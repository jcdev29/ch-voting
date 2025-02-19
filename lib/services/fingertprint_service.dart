// fingerprint_service.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FingerprintService {
  static const MethodChannel _channel = MethodChannel('com.example.ch_vote/fingerprint');
  
  // Initialize the fingerprint sensor
  Future<bool> initFingerprintSensor() async {
    try {
      final bool result = await _channel.invokeMethod('initFingerprintSensor');
      return result;
    } on PlatformException catch (e) {
      debugPrint('Error initializing fingerprint sensor: ${e.message}');
      return false;
    }
  }
  
  // Open the fingerprint device
  Future<int?> openDevice() async {
    try {
      final int result = await _channel.invokeMethod('openDevice');
      return result;
    } on PlatformException catch (e) {
      debugPrint('Error opening device: ${e.message}');
      return null;
    }
  }
  
  // Close the fingerprint device
  Future<bool> closeDevice() async {
    try {
      final bool result = await _channel.invokeMethod('closeDevice');
      return result;
    } on PlatformException catch (e) {
      debugPrint('Error closing device: ${e.message}');
      return false;
    }
  }
  
  // Check if the device is opened
  Future<bool> isDeviceOpened() async {
    try {
      final bool result = await _channel.invokeMethod('isDeviceOpened');
      return result;
    } on PlatformException catch (e) {
      debugPrint('Error checking if device is opened: ${e.message}');
      return false;
    }
  }
  
  // Get a fingerprint image
  Future<Uint8List?> getImage({int acceptScore = 0, int timeout = 0}) async {
    try {
      final Uint8List result = await _channel.invokeMethod('getImage', {
        'acceptScore': acceptScore,
        'timeout': timeout,
      });
      return result;
    } on PlatformException catch (e) {
      debugPrint('Error getting fingerprint image: ${e.message}');
      return null;
    }
  }
  
  // Add more methods as needed to support other fingerprint operations
}