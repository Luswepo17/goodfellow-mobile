import 'dart:async';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:goodfellow/utils/constants/api_constants.dart';
import 'package:goodfellow/utils/http/http_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

enum DownloadState { idle, downloading, completed, error, installing }

class UpdateController extends GetxController {
  final isUpdateAvailable = false.obs;
  final isForcedUpdate = false.obs;
  final downloadUrl = "".obs;
  final releaseNotes = "".obs;
  final deviceStorage = GetStorage();
  final downloadProgress = 0.0.obs;
  final downloadState = DownloadState.idle.obs;
  final errorMessage = "".obs;

  @override
  void onInit() {
    super.onInit();
    checkForUpdate();
    // Initialize isUpdateAvailable from GetStorage
    isUpdateAvailable.value = deviceStorage.read("updateAvailable") ?? false;

    // Optionally, listen for changes to updateAvailable in GetStorage
    deviceStorage.listenKey("updateAvailable", (value) {
      isUpdateAvailable.value = value ?? false;
    });

    _readFromStorage();
  }

  void _readFromStorage() {
    final storage = GetStorage("pos");
    final setupStorage = GetStorage("setup");
    isUpdateAvailable.value =
        setupStorage.read("updateAvailable") ??
        storage.read("updateAvailable") ??
        false;
    isForcedUpdate.value = setupStorage.read("forcedUpdate") ?? false;
    downloadUrl.value =
        setupStorage.read("downloadUrl") ?? storage.read("downloadUrl") ?? "";
    releaseNotes.value =
        setupStorage.read("releaseNotes") ?? storage.read("releaseNotes") ?? "";
  }

  Future<void> checkForUpdate() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final updateData = {
        "posdevice_id": deviceStorage.read("posdevice_id") ?? "",
        "app_version": packageInfo.version,
        "build_number": packageInfo.buildNumber,
      };

      final updateCheck = await APPHttpHelper.postMaster(
        APIConstants.checkupdateendpoint,
        "",
        updateData,
      );

      if (updateCheck["status"] == "success") {
        final updateAvailable =
            updateCheck["data"]?["update_available"] == true;
        final forcedUpdate = updateCheck["data"]?["forced_update"] == true;
        isUpdateAvailable.value = updateAvailable;
        isForcedUpdate.value = forcedUpdate;

        // Write to both storages for consistency
        final setupStorage = GetStorage("setup");
        final downloadUrlValue = updateCheck["data"]?["download_url"] ?? "";
        final releaseNotesValue = updateCheck["data"]?["release_notes"] ?? "";

        await deviceStorage.write("updateAvailable", updateAvailable);
        await deviceStorage.write("forcedUpdate", forcedUpdate);
        await deviceStorage.write("downloadUrl", downloadUrlValue);
        await deviceStorage.write("releaseNotes", releaseNotesValue);

        // Also write to setup storage for background tasks
        await setupStorage.write("updateAvailable", updateAvailable);
        await setupStorage.write("forcedUpdate", forcedUpdate);
        await setupStorage.write("downloadUrl", downloadUrlValue);
        await setupStorage.write("releaseNotes", releaseNotesValue);
      }
    } catch (e) {
      debugPrint("Update check error: $e");
    }
  }

  Future<void> downloadAndInstallApk() async {
    final setupStorage = GetStorage("setup");
    final url =
        setupStorage.read("downloadUrl") ??
        deviceStorage.read("downloadUrl") ??
        "";

    if (url.isEmpty) {
      errorMessage.value = "Download URL not available";
      downloadState.value = DownloadState.error;
      return;
    }

    final dir = await getExternalStorageDirectory();
    final filePath = '${dir!.path}/update.apk';

    Dio dio = Dio();
    downloadState.value = DownloadState.downloading;
    downloadProgress.value = 0.0;
    errorMessage.value = "";

    try {
      await dio.download(
        url,
        filePath,
        onReceiveProgress: (recieved, total) {
          if (total != -1) {
            double progress = recieved / total * 100;
            downloadProgress.value = progress;
            debugPrint("Download progress: ${progress.toStringAsFixed(0)}%");
          }
        },
      );

      downloadState.value = DownloadState.completed;
      downloadProgress.value = 100.0;

      // Proceed with installation
      downloadState.value = DownloadState.installing;
      await _installApk(filePath);
    } catch (e) {
      debugPrint("Download failed: $e");
      errorMessage.value = "Download failed: ${e.toString()}";
      downloadState.value = DownloadState.error;
      if (Get.context != null) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(content: Text("Update failed: ${e.toString()}")),
        );
      }
    }
  }

  Future<void> _installApk(String filePath) async {
    try {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      final packageInfo = await PackageInfo.fromPlatform();

      if (deviceInfo.version.sdkInt >= 26) {
        final hasPermission = await _hasInstallPermission();
        if (!hasPermission) {
          // Request permission
          final intent = AndroidIntent(
            action: 'android.settings.MANAGE_UNKNOWN_APP_SOURCES',
            data: 'package:${packageInfo.packageName}',
            flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
          );
          await intent.launch();

          // Wait for user to return and check permission again
          await Future.delayed(const Duration(seconds: 2));
          if (await _hasInstallPermission()) {
            // Permission granted, proceed with installation
            OpenFile.open(filePath);
          } else {
            // Permission still not granted, show error
            errorMessage.value =
                "Install permission denied. Please enable 'Install unknown apps' in settings.";
            downloadState.value = DownloadState.error;
            if (Get.context != null) {
              ScaffoldMessenger.of(Get.context!).showSnackBar(
                const SnackBar(
                  content: Text("Permission denied. Cannot install update."),
                ),
              );
            }
            return;
          }
        } else {
          OpenFile.open(filePath);
        }
      } else {
        OpenFile.open(filePath);
      }
    } catch (e) {
      debugPrint("Installation failed: $e");
      errorMessage.value = "Installation failed: ${e.toString()}";
      downloadState.value = DownloadState.error;
    }
  }

  void startDownload() {
    if (downloadState.value == DownloadState.downloading) {
      return; // Already downloading
    }
    downloadAndInstallApk();
  }

  void _openInstaller(String filePath) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      const SnackBar(content: Text("Download complete! Opening installer...")),
    );
    OpenFile.open(filePath);
  }

  Future<bool> _hasInstallPermission() async {
    if (await Permission.requestInstallPackages.isGranted) {
      return true;
    }
    return false;
  }
}
