// background_tasks.dart
import 'dart:convert';
import 'package:workmanager/workmanager.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:goodfellow/utils/constants/api_constants.dart';
import 'package:goodfellow/utils/http/http_client.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      final response = await http.get(Uri.parse('http://ip-api.com/json'));
      String latitude = "", longitude = "";

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        longitude = data['lon']?.toString() ?? "";
        latitude = data['lat']?.toString() ?? "";
      }

      final locationData = {
        "latitude": latitude,
        "longitude": longitude,
        "timestamp": DateTime.now().toIso8601String(),
        "accuracy": "low",
      };

      if (task == "sendLocationNow" || task == "sendLocation") {
        final deviceStorage = GetStorage();
        final packageInfo = await PackageInfo.fromPlatform();

        await APPHttpHelper.postMaster(
          APIConstants.pinglocationendpoint,
          "",
          locationData,
        );

        final updateData = {
          "posdevice_id": deviceStorage.read("posdevice_id") ?? "",
          "app_version": packageInfo.version,
          "timestamp": DateTime.now().toIso8601String(),
          "accuracy": "low",
        };

        await APPHttpHelper.postMaster(
          APIConstants.checkupdateendpoint,
          "",
          updateData,
        );
      }
    } catch (e) {
      print("Background task error: $e");
    }

    return Future.value(true);
  });
}
