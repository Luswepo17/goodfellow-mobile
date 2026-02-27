import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:goodfellow/common/widgets/loaders/loaders.dart';
import 'package:goodfellow/features/authentication/screens/kyc/kyc.dart';
// import 'package:goodfellow/main.dart';
import 'package:goodfellow/utils/constants/api_constants.dart';
import 'package:goodfellow/utils/helpers/network_manager.dart';
import 'package:goodfellow/utils/http/http_client.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
// import 'package:workmanager/workmanager.dart';

class SetupController extends GetxController {
  static SetupController get instance => Get.find();

  GlobalKey<FormState> setupFormKey = GlobalKey<FormState>();
  final deviceStorage = GetStorage();
  final imei = TextEditingController();
  final serialNumber = TextEditingController();
  final paymentPlan = TextEditingController();
  final downPayment = TextEditingController();
  final priceController = TextEditingController();

  final selectedPhoneTypeId = "".obs;
  final selectedPrice = "".obs;

  final isLoading = false.obs;

  @override
  void onClose() {
    imei.dispose();
    serialNumber.dispose();
    paymentPlan.dispose();
    downPayment.dispose();
    super.onClose();
  }

  Future setup() async {
    final isConnected = await NetworkManager.instance.isConnected();
    // print("Network connected: $isConnected");
    if (!isConnected) {
      APPLoaders.errorSnackBar(
        title: "No Connection",
        message: "Please check your internet connection.",
      );
      return;
    }

    if (!setupFormKey.currentState!.validate()) {
      // print("Form validation failed");
      APPLoaders.errorSnackBar(
        title: "Invalid Input",
        message: "Please enter a valid email address.",
      );
      return;
    }

    try {
      isLoading.value = true;

      final locationData = await _getLocationSafely();
      final body = {
        "serial_number": serialNumber.text.trim(),
        "imei": imei.text,
        "latitude": locationData["latitude"]!,
        "longitude": locationData["longitude"]!,
        "phone_type_id": selectedPhoneTypeId.value,
        "payment_plan": paymentPlan.text,
        "down_payment": downPayment.text,
        "user_id": deviceStorage.read("user_id") ?? "",
      };

      final token = deviceStorage.read("token") ?? "";

      // print(
      // "Sending HTTP request to ${APIConstants.deviceregistrationendpoint}");
      final res = await APPHttpHelper.post(
        APIConstants.customerUrl,
        APIConstants.deviceregistrationendpoint,
        token,
        body,
      );

      print("HTTP response: $res");

      if (res["status"] == "success") {
        final phoneId = res["phone_id"];
        deviceStorage.write("first_time_login", false);
        deviceStorage.write("phone_id", phoneId);
        deviceStorage.write('last_latitude', locationData["latitude"] ?? "0.0");
        deviceStorage.write(
          'last_longitude',
          locationData["longitude"] ?? "0.0",
        );
        "0.0";

        // await Workmanager().registerPeriodicTask(
        //   "1",
        //   pingLocation,
        //   inputData: {},
        //   frequency: const Duration(minutes: 15),
        // );

        // await Workmanager().registerPeriodicTask(
        //   "2",
        //   checkVersion,
        //   inputData: {},
        //   frequency: const Duration(days: 1),
        // );
        // await Workmanager().registerPeriodicTask(
        //   "3",
        //   heartBeat,
        //   frequency: const Duration(minutes: 15),
        // );

        APPLoaders.successSnackBar(
          title: "Success",
          message: "Device registered successfully!",
        );

        Get.offAll(
          transition: Transition.leftToRight,
          duration: const Duration(milliseconds: 300),
          () => const KYCScreen(),
        );
      } else if (res["status"] == "error") {
        isLoading.value = false;
        // print("HTTP request failed: ${res["message"]}");
        APPLoaders.errorSnackBar(
          title: "Registration Failed",
          message: res["message"] ?? "Unknown error occurred.",
        );
      } else {
        isLoading.value = false;
        // print("HTTP request failed: ${res["message"]}");
        APPLoaders.errorSnackBar(
          title: "Registration Failed",
          message: res["error"] ?? "Unknown error occurred.",
        );
      }
    } catch (exception, stackTrace) {
      isLoading.value = false;
      // print("Exception in setup: $exception");
      await Sentry.captureException(exception, stackTrace: stackTrace);
      APPLoaders.errorSnackBar(
        title: "Oh snap!",
        message: exception.toString(),
      );
    }
  }

  Future<Map<String, String>> _getLocationSafely() async {
    try {
      print("Getting location...");
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        forceAndroidLocationManager: true,
      );
      print("Location retrieved: ${position.latitude}, ${position.longitude}");

      return {
        "latitude": position.latitude.toString(),
        "longitude": position.longitude.toString(),
      };
    } catch (e, stackTrace) {
      print("Location error: $e");
      // await Sentry.captureException(e, stackTrace: stackTrace);
      APPLoaders.warningSnackBar(
        title: "Location Unavailable",
        message: "Using stored coordinates: $e",
      );
      return {};
    }
  }
}
