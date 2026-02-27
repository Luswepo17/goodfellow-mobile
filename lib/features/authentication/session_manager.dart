import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:async';

class SessionManager {
  final GetStorage storage = GetStorage();
  Timer? _sessionTimer;
  Duration sessionDuration = const Duration(minutes: 1);
  VoidCallback onSessionTimeout;

  SessionManager({required this.onSessionTimeout});

  void startSession() {
    _resetTimer();
  }

  void _resetTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = Timer(sessionDuration, () {
      _sessionExpired();
    });
  }

  void _sessionExpired() {
    storage.remove("token");
    storage.write("isLoggedIn", false);
    onSessionTimeout();
  }

  void resetTimerOnActivity() {
    _resetTimer();
  }

  void endSession() {
    _sessionTimer?.cancel();
  }
}
