// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:goodfellow/features/authentication/session_manager.dart';

// class AuthenticationWrapper extends StatefulWidget {
//   final Widget loginPage;
//   final Widget homePage;

//   const AuthenticationWrapper(
//       {super.key, required this.loginPage, required this.homePage});

//   @override
//   State<AuthenticationWrapper> createState() => _AuthenticationWrapperState();
// }

// class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
//   final storage = GetStorage();
//   bool _isAuthenticated = false;
//   late SessionManager sessionManager;

//   @override
//   void initState() {
//     super.initState();
//     sessionManager = SessionManager(onSessionTimeout: _handleSesssionTimeout);

//     _checkAuthStatus();
//   }

//   Future<void> _checkAuthStatus() async {
//     final token = storage.read("token");
//     final isLoggedIn = storage.read("isLoggedIn") ?? false;
//     setState(() {
//       _isAuthenticated = token != null && token.isNotEmpty && isLoggedIn;
//     });

//     if (_isAuthenticated) {
//       sessionManager.startSession();
//     }
//   }

//   Future<bool> isAuthenticated() async {
//     final token = await getAuthToken();
//     return token != null && token.isNotEmpty;
//   }

//   // Get saved token
//   Future<String?> getAuthToken() async {
//     // ignore: await_only_futures
//     return await storage.read("token");
//   }

//   void _handleSesssionTimeout() {
//     Get.offAll(() => widget.loginPage);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//         onTap: sessionManager.resetTimerOnActivity,
//         onPanUpdate: (details) => sessionManager.resetTimerOnActivity(),
//         child: _isAuthenticated ? widget.homePage : widget.loginPage);
//   }

//   @override
//   void dispose() {
//     sessionManager.endSession();
//     super.dispose();
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:goodfellow/features/authentication/controllers/updates/update_controller.dart';
import 'package:goodfellow/features/authentication/screens/updates/update_screen.dart';

class AuthenticationWrapper extends StatefulWidget {
  final Widget loginPage;
  final Widget homePage;

  const AuthenticationWrapper({
    super.key,
    required this.loginPage,
    required this.homePage,
  });

  @override
  State<AuthenticationWrapper> createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  final storage = GetStorage();
  final setupStorage = GetStorage("setup");
  bool _isAuthenticated = false;
  bool _isCheckingUpdate = true;
  final UpdateController updateController = Get.put(UpdateController());

  @override
  void initState() {
    super.initState();
    _checkForForcedUpdate();
  }

  Future<void> _checkForForcedUpdate() async {
    // Check for forced update first
    await updateController.checkForUpdate();

    // Read from storage
    final updateAvailable =
        setupStorage.read("updateAvailable") ??
        storage.read("updateAvailable") ??
        false;
    final forcedUpdate = setupStorage.read("forcedUpdate") ?? false;

    setState(() {
      _isCheckingUpdate = false;
    });

    // If forced update is available, block access to app
    if (updateAvailable && forcedUpdate) {
      // Navigate to update screen immediately
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAll(() => const UpdateScreen());
      });
      return;
    }

    // Otherwise, proceed with normal auth check
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final token = storage.read("token");
    final isLoggedIn = storage.read("isLoggedIn") ?? false;
    setState(() {
      _isAuthenticated = token != null && token.isNotEmpty && isLoggedIn;
    });
  }

  Future<bool> isAuthenticated() async {
    final token = await getAuthToken();
    return token != null && token.isNotEmpty;
  }

  // Get saved token
  Future<String?> getAuthToken() async {
    // ignore: await_only_futures
    return await storage.read("token");
  }

  @override
  Widget build(BuildContext context) {
    // Show loading while checking for updates
    if (_isCheckingUpdate) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Check if update is available and forced
    final updateAvailable =
        setupStorage.read("updateAvailable") ??
        storage.read("updateAvailable") ??
        false;
    final forcedUpdate = setupStorage.read("forcedUpdate") ?? false;

    if (updateAvailable && forcedUpdate) {
      return const UpdateScreen();
    }

    return _isAuthenticated ? widget.homePage : widget.loginPage;
  }
}
