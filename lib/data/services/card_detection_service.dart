import 'dart:async';

import 'package:flutter/services.dart';

class CardDetectionService {
  static const MethodChannel _channel = MethodChannel(
    'com.example.goodfellow/card',
  );

  // Declare a callback function type
  static Function(String)? onCardDetectedCallback;

  static Timer? _debounceTimer;
  static String? _lastDetectedCard;

  static void _initialize() {
    _channel.setMethodCallHandler(_handleMethod);
  }

  // Initialize the service
  static void start() {
    _initialize();
  }

  static Future<void> startCardDetection() async {
    await _channel.invokeMethod('startCardDetection');
  }

  static Future<void> stopCardDetection() async {
    await _channel.invokeMethod('stopCardDetection');
  }

  // Handle card detection results from the native side
  static Future<void> _handleMethod(MethodCall call) async {
    if (call.method == 'onCardDetected') {
      String cardNumber = call.arguments;
      // print("Flutter: Card detected - $cardNumber");

      // Debounce logic
      if (_lastDetectedCard != cardNumber) {
        _lastDetectedCard = cardNumber;

        // Cancel previous timer if it exists
        _debounceTimer?.cancel();
        // Set a new timer
        _debounceTimer = Timer(const Duration(seconds: 2), () {
          // Call the callback only after the debounce period
          if (onCardDetectedCallback != null) {
            //print("Flutter: Calling onCardDetectedCallback");
            onCardDetectedCallback!(cardNumber);
          } else {
            //  print("Flutter: No callback registered for onCardDetected");
          }
        });
      } else {
        // print("Flutter: Duplicate card detected, ignoring.");
      }
    } else {
      // print("Flutter: Unknown method ${call.method} called on MethodChannel");
    }
  }

  // Register the callback function
  static void setOnCardDetectedCallback(Function(String) callback) {
    onCardDetectedCallback = callback;
    // print(
    //     "Flutter: Callback set for onCardDetected"); // Log when callback is set
  }
}
