import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:goodfellow/common/widgets/loaders/loaders.dart';
import 'package:goodfellow/features/authentication/screens/login/login.dart';
import 'package:goodfellow/utils/constants/api_constants.dart';
import 'package:goodfellow/utils/helpers/network_manager.dart';
import 'package:goodfellow/utils/http/http_client.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  final hidePassword = true.obs;
  final email = TextEditingController();
  final isLoading = false.obs;
  final password = TextEditingController();
  final emailError = false.obs;
  final passwordError = false.obs;
  final isFormValid = false.obs;
  final fullnameError = false.obs;
  final phoneError = false.obs;
  final addressError = false.obs;

  final phone = TextEditingController();

  final address = TextEditingController();

  final fullname = TextEditingController();

  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  final deviceStorage = GetStorage();

  Future<void> signup() async {
    try {
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) return;
      if (!signupFormKey.currentState!.validate()) return;

      isLoading.value = true;
      emailError.value = false;
      passwordError.value = false;

      final body = {
        "fullname": fullname.text.trim(),
        "email": email.text.trim(),
        "password": password.text,
        "role": "customer",
        "address": address.text.trim(),
      };

      var res = await APPHttpHelper.post(
        APIConstants.publicUrl,
        APIConstants.registerendpoint,
        "",
        body,
      );

      // print(res);
      if (res['status'] == "success") {
        // Show success message
        APPLoaders.successSnackBar(
          title: "Success",
          message:
              res["message"] ?? "Your account has been created successfully",
        );

        // Navigate to home screen
        Get.offAll(
          transition: Transition.rightToLeft,
          duration: const Duration(milliseconds: 500),
          () => const LoginScreen(),
        );
        return;
      } else if (res['error'] != null) {
        if (res["code"] == "401") {
          emailError.value = true;
          passwordError.value = true;
          fullnameError.value = true;
          phoneError.value = true;
          addressError.value = true;
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
