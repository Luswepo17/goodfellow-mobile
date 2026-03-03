import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:goodfellow/common/widgets/error/systemerror.dart';
import 'package:goodfellow/common/widgets/loaders/loaders.dart';
import 'package:goodfellow/features/authentication/models/resetPassword.dart';
import 'package:goodfellow/features/authentication/screens/login/login.dart';
import 'package:goodfellow/utils/constants/api_constants.dart';
import 'package:goodfellow/utils/constants/image_strings.dart';
import 'package:goodfellow/utils/helpers/network_manager.dart';
import 'package:goodfellow/utils/http/http_client.dart';
import 'package:goodfellow/utils/popups/full_screen_loader.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class ResetPasswordController extends GetxController {
  static ResetPasswordController get instance => Get.find();

  final hidePassword = true.obs;
  final hideConfirmPassword = true.obs;
  final hideCurrentPassword = true.obs;
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final currentPassword = TextEditingController();
  GlobalKey<FormState> resetPasswordFormKey = GlobalKey<FormState>();

  final deviceStorage = GetStorage();
  Future<void> resetPassword() async {
    try {
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) return;

      if (!resetPasswordFormKey.currentState!.validate()) return;
      if (password.text.trim() != confirmPassword.text.trim()) {
        APPLoaders.errorSnackBar(
          title: "Oh snap!",
          message: "Passwords do not match",
        );
        return;
      } else {
        APPFullScreenLoader.openLoadingDialog(
          "Your information is being processed.",
          APPImages.loader,
        );
        ResetPasswordModule resetPasswordModule = ResetPasswordModule(
          newPassword: password.text.trim(),
          oldPassword: currentPassword.text.trim(),
        );
        String token = deviceStorage.read("token");
        var res = await APPHttpHelper.post(
          APIConstants.publicUrl,
          // APIConstants.modesendpoint,"".,
          "",
          token,
          resetPasswordModule,
        );
        final data = res['msgList'] as Map;
        String k = "";
        for (final name in data.keys) {
          // final value = data[name];
          k = k + name;
        }
        if (res["status"] == "Timeout") {
          APPLoaders.errorSnackBar(
            title: "Oh snap!",
            message: "Something went wrong",
          );
          APPFullScreenLoader.stopLoader();
          Get.offAll(() => const SystemError());
        } else if (res["status"] == "FAIL") {
          APPLoaders.errorSnackBar(title: "Password Change Error!", message: k);
          APPFullScreenLoader.stopLoader();
          Get.offAll(() => const SystemError());
        } else if (res["status"] == "SUCCESS") {
          deviceStorage.write("isLoggedIn", false);
          deviceStorage.write("token", "");
          APPLoaders.successSnackBar(
            title: "Password reset",
            message: res["message"],
          );
          APPFullScreenLoader.stopLoader();
          Get.offAll(() => const LoginScreen());
        }
      }
    } catch (exception, stackTrace) {
      await Sentry.captureException(exception, stackTrace: stackTrace);
      APPFullScreenLoader.stopLoader();
      APPLoaders.errorSnackBar(
        title: "Oh snap!",
        message: exception.toString().substring(11),
      );
    }
  }
}
