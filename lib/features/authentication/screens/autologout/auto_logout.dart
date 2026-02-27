import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:goodfellow/features/authentication/controllers/sign_in/sign_in_controller.dart';
import 'package:goodfellow/features/authentication/screens/login/login.dart';
import 'package:workmanager/workmanager.dart';

class AutoLogout extends StatefulWidget {
  const AutoLogout({super.key, required this.child});
  final Widget child;

  @override
  State<AutoLogout> createState() => _AutoLogoutState();
}

class _AutoLogoutState extends State<AutoLogout> with WidgetsBindingObserver {
  Timer? _inactivityTimer;
  final Duration _timeout = const Duration(minutes: 5);

  void _resetTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(_timeout, _logoutUser);
  }

  void _logoutUser() {
    final deviceStorage = GetStorage();
    final signinController = SigninController.instance;

    deviceStorage.erase();
    signinController.email.clear();
    signinController.password.clear();
    signinController.isLoading.value = false;
    Workmanager().cancelAll();
    // Display a snackbar or any success message here
    Get.offAll(() => const LoginScreen());
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _resetTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _inactivityTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _inactivityTimer?.cancel();
    } else if (state == AppLifecycleState.resumed) {
      _resetTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _resetTimer,
      onPanDown: (_) => _resetTimer(),
      child: widget.child,
    );
  }
}
