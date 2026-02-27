import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:goodfellow/common/widgets/loaders/loaders.dart';
import 'package:goodfellow/features/Home/screens/home/home.dart';
import 'package:goodfellow/features/authentication/models/authModel.dart';
import 'package:goodfellow/features/authentication/screens/setup/setup.dart';
import 'package:goodfellow/main.dart';
import 'package:goodfellow/utils/constants/api_constants.dart';
import 'package:goodfellow/utils/helpers/network_manager.dart';
import 'package:goodfellow/utils/http/http_client.dart';
import 'package:workmanager/workmanager.dart';

class SigninController extends GetxController {
  static SigninController get instance => Get.find();

  final hidePassword = true.obs;
  final email = TextEditingController();
  final isLoading = false.obs;
  final password = TextEditingController();
  final emailError = false.obs;
  final passwordError = false.obs;
  final isFormValid = false.obs;

  GlobalKey<FormState> signinFormKey = GlobalKey<FormState>();

  final deviceStorage = GetStorage();

  Future<void> signin() async {
    try {
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) return;
      if (!signinFormKey.currentState!.validate()) return;

      isLoading.value = true;
      emailError.value = false;
      passwordError.value = false;

      LoginModule loginModule = LoginModule(
        email: email.text.trim(),
        password: password.text.trim(),
        portal: "customer",
      );

      print("Login Module ${loginModule.portal}");

      var res = await APPHttpHelper.post(
        APIConstants.publicUrl,
        APIConstants.loginendpoint,
        "",
        loginModule,
      );

      print("Response: ${res}");
      if (res['status'] == "success") {
        //  Store user data
        final data = res["data"];

        deviceStorage.write("token", data?['token'] ?? "");
        deviceStorage.write("isLoggedIn", true);
        deviceStorage.write("fullname", res['data']?['fullname'] ?? "");
        deviceStorage.write("role", res['data']?['role'] ?? "");
        deviceStorage.write(
          "account_status",
          res['data']?['accountStatus'] ?? "",
        );

        deviceStorage.write("user_id", res['data']?['user_id'] ?? "");
        deviceStorage.write("email", res['data']?['email'] ?? "");
        deviceStorage.write(
          "first_time_login",
          res['data']?['first_time_login'] ?? false,
        );

        deviceStorage.write(
          "kyc_profile_id",
          res["data"]?["kyc_profile_id"] ?? "",
        );

        // await Workmanager().cancelAll();

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

        bool firstLogin = deviceStorage.read("first_time_login");

        // Show success message
        APPLoaders.successSnackBar(
          title: "Login Successful",
          message: res["message"] ?? "Welcome back!",
        );

        // Navigate to home screen
        Get.offAll(
          transition: Transition.rightToLeft,
          duration: const Duration(milliseconds: 500),
          () => firstLogin ? const SetupScreen() : const HomeScreen(),
        );
        return;
      } else if (res['error'] != null) {
        if (res["code"] == "401") {
          emailError.value = true;
          passwordError.value = true;
          isLoading.value = false;
          throw Exception(res["error"]);
        } else if (res["code"] == "403") {
          isLoading.value = false;
          throw Exception(res["message"]);
        } else {
          isLoading.value = false;
          throw Exception(res["error"]);
        }
      }
    } catch (exception) {
      isLoading.value = false;
      //  APPFullScreenLoader.stopLoader();
      APPLoaders.errorSnackBar(
        title: "Oh snap!",
        message: exception.toString().substring(11),
      );
    }
  }
}
