import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:goodfellow/app.dart';
import 'package:goodfellow/bindings/general_bindings.dart';
import 'package:goodfellow/common/widgets/loaders/loaders.dart';
// import 'package:goodfellow/features/authentication/screens/autologout/auto_logout.dart';
import 'package:goodfellow/utils/constants/api_constants.dart';
import 'package:goodfellow/utils/http/http_client.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:workmanager/workmanager.dart';

const pingLocation = "pingLocation";
const checkVersion = "checkUpdate";
const heartBeat = "heartBeat";

//  ✅ This must be a top-level function
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await GetStorage.init();

    final deviceStorageSetup = GetStorage("setup");
    // final deviceStorage = GetStorage();
    switch (task) {
      case pingLocation:
        try {
          Map<String, String> getFallbackLocation() {
            final storedLat = deviceStorageSetup.read('last_latitude') ?? "0.0";
            final storedLng =
                deviceStorageSetup.read('last_longitude') ?? "0.0";
            // print("Using fallback location: $storedLat, $storedLng");
            return {"latitude": storedLat, "longitude": storedLng};
          }

          Future<Map<String, String>> getLocationSafely() async {
            try {
              // print("Getting location...");
              final position = await Geolocator.getCurrentPosition(
                // ignore: deprecated_member_use
                desiredAccuracy: LocationAccuracy.low,
                // ignore: deprecated_member_use
                forceAndroidLocationManager: true,
              );
              // print(
              //     "Location retrieved: ${position.latitude}, ${position.longitude}");

              return {
                "latitude": position.latitude.toString(),
                "longitude": position.longitude.toString(),
              };
            } catch (e, stackTrace) {
              // print("Location error: $e");
              await Sentry.captureException(e, stackTrace: stackTrace);
              APPLoaders.warningSnackBar(
                title: "Location Unavailable",
                message: "Using stored coordinates: $e",
              );
              return getFallbackLocation();
            }
          }

          final locationInfo = await getLocationSafely();
          // print(
          //     "Location retrieved: ${position.latitude}, ${position.longitude}");

          final locationData = {
            'posdevice_id': deviceStorageSetup.read('posdevice_id') ?? '',
            'latitude': locationInfo["latitude"]!,
            'longitude': locationInfo["longitude"]!,
            'timestamp': DateTime.now().toIso8601String(),
            'accuracy': "low",
            'region': '', // Optional: add reverse geocoding if needed
            'ip_address': '', // Remove if not needed anymore
            'city': '', // Optional: add reverse geocoding if needed
          };

          await APPHttpHelper.postMaster(
            APIConstants.pinglocationendpoint,
            '',
            locationData,
          );
        } catch (exception, stackTrace) {
          await Sentry.captureException(exception, stackTrace: stackTrace);
        }
        break;

      case checkVersion:
        try {
          // print("check version");
          final packageInfo = await PackageInfo.fromPlatform();
          final updateData = {
            'posdevice_id': deviceStorageSetup.read('posdevice_id') ?? '',
            'app_version': packageInfo.version,
            'build_number': packageInfo.buildNumber,
          };

          final updateCheck = await APPHttpHelper.postMaster(
            APIConstants.checkupdateendpoint,
            '',
            updateData,
          );

          if (updateCheck['status'] == 'success') {
            final updateAvailable =
                updateCheck['data']?['update_available'] == true;
            final forcedUpdate = updateCheck['data']?['forced_update'] == true;
            await deviceStorageSetup.write('updateAvailable', updateAvailable);
            await deviceStorageSetup.write('forcedUpdate', forcedUpdate);
            await deviceStorageSetup.write(
              'downloadUrl',
              updateCheck['data']?['download_url'] ?? '',
            );
            await deviceStorageSetup.write(
              'releaseNotes',
              updateCheck['data']?['release_notes'] ?? '',
            );
          } else {
            debugPrint('Update check failed: ${updateCheck['message']}');
          }
        } catch (exception, stackTrace) {
          await Sentry.captureException(exception, stackTrace: stackTrace);
        }
        break;

      case heartBeat:
        try {
          print("heartbeat called");
          final updateData = {
            'device_id': deviceStorageSetup.read('posdevice_id') ?? '',
            'timestamp': DateTime.now().toIso8601String(),
          };

          await APPHttpHelper.postMaster(
            APIConstants.heartbeatendpoint,
            '',
            updateData,
          );
        } catch (exception, stackTrace) {
          await Sentry.captureException(exception, stackTrace: stackTrace);
        }
        break;
      default:
    }

    return true;
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

  GeneralBindings().dependencies();
  await GetStorage.init();
  // await GetStorage.init('setup');
  // await GetStorage.init('receipt_logs');

  _handleLocationPermission();

  //   await SentryFlutter.init((options) {
  //     options.dsn = options.dsn =
  //         'https://c6422f992250fbeca6981b0dd0944ca0@o4509478949683201.ingest.de.sentry.io/4509479021314128';
  //     // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
  //     // We recommend adjusting this value in production.
  //     options.tracesSampleRate = 1.0;
  //     // options.release = 'mmp_izb_pos@2.0.0+1';
  //     // options.environment = 'staging';
  //     // options.autoSessionTrackingInterval = const Duration(milliseconds: 60000);
  //   }, appRunner: () => runApp(const MyApp()));
  // }
  runApp(const MyApp());
}

Future<bool> _handleLocationPermission() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    APPLoaders.errorSnackBar(
      title: "Location",
      message: 'Location services are disabled. Please enable the services',
    );
    return false;
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      APPLoaders.errorSnackBar(
        title: "Location",
        message: 'Location permissions are denied',
      );
      return false;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    APPLoaders.errorSnackBar(
      title: "Location",
      message:
          'Location permissions are permanently denied, we cannot request permissions.',
    );

    return false;
  }
  return true;
}
