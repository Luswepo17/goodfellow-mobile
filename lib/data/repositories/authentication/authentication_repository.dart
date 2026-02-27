import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:goodfellow/features/Home/screens/home/home.dart';
import 'package:goodfellow/features/authentication/screens/login/login.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final deviceStorage = GetStorage();

  @override
  void onReady() {
    screenRedirect();
    FlutterNativeSplash.remove();
  }

  screenRedirect() async {
    deviceStorage.writeIfNull("isLoggedIn", false);
    deviceStorage.writeIfNull("firstSetup", true);
    deviceStorage.writeIfNull("token", "");
    deviceStorage.writeIfNull("radius", 5);
    deviceStorage.read("firstSetup") == true
        ? Get.offAll(() => {})
        : deviceStorage.read("isLoggedIn") == false &&
              deviceStorage.read("token") == ""
        ? Get.offAll(() => const LoginScreen())
        : Get.offAll(() => const HomeScreen());
  }
}
