import 'dart:typed_data';

import 'package:ch_vote/services/fingertprint_service.dart';
import 'package:flutter/material.dart';


class FingerprintScannerPage extends StatefulWidget {
  const FingerprintScannerPage({super.key});

  @override
  FingerprintScannerPageState createState() => FingerprintScannerPageState();
}

class FingerprintScannerPageState extends State<FingerprintScannerPage> {
  final FingerprintService _fingerprintService = FingerprintService();
  bool _isSensorInitialized = false;
  bool _isDeviceOpened = false;
  Uint8List? _fingerprintImage;
  String _statusMessage = '';
  
  @override
  void initState() {
    super.initState();
    _initializeSensor();
  }
  
  Future<void> _initializeSensor() async {
    try {
      final initialized = await _fingerprintService.initFingerprintSensor();
      setState(() {
        _isSensorInitialized = initialized;
        _statusMessage = initialized ? 'Sensor initialized' : 'Failed to initialize sensor';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error initializing sensor: $e';
      });
    }
  }
  
  Future<void> _openDevice() async {
    if (!_isSensorInitialized) {
      setState(() {
        _statusMessage = 'Sensor not initialized';
      });
      return;
    }
    
    try {
      final result = await _fingerprintService.openDevice();
      final deviceOpened = result != null && result >= 0;
      setState(() {
        _isDeviceOpened = deviceOpened;
        _statusMessage = deviceOpened ? 'Device opened' : 'Failed to open device: $result';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error opening device: $e';
      });
    }
  }
  
  Future<void> _closeDevice() async {
    if (!_isDeviceOpened) {
      setState(() {
        _statusMessage = 'Device not opened';
      });
      return;
    }
    
    try {
      final closed = await _fingerprintService.closeDevice();
      setState(() {
        _isDeviceOpened = !closed;
        _statusMessage = closed ? 'Device closed' : 'Failed to close device';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error closing device: $e';
      });
    }
  }
  
  Future<void> _scanFingerprint() async {
    if (!_isDeviceOpened) {
      setState(() {
        _statusMessage = 'Device not opened';
      });
      return;
    }
    
    setState(() {
      _statusMessage = 'Scanning for fingerprint...';
    });
    
    try {
      // Set a reasonable timeout (e.g., 10 seconds) and accept score (e.g., 60)
      final image = await _fingerprintService.getImage(acceptScore: 60, timeout: 10000);
      setState(() {
        _fingerprintImage = image;
        _statusMessage = image != null ? 'Fingerprint captured' : 'Failed to capture fingerprint';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error scanning fingerprint: $e';
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fingerprint Scanner'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Status: $_statusMessage',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (_fingerprintImage != null) ...[
              Text(
                'Fingerprint Image (${_fingerprintImage!.length} bytes):',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: Center(
                  child: Text('Raw image data available (${_fingerprintImage!.length} bytes)'),
                ),
              ),
              const SizedBox(height: 20),
            ],
            ElevatedButton(
              onPressed: _isSensorInitialized && !_isDeviceOpened ? _openDevice : null,
              child: const Text('Open Device'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _isDeviceOpened ? _scanFingerprint : null,
              child: const Text('Scan Fingerprint'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _isDeviceOpened ? _closeDevice : null,
              child: const Text('Close Device'),
            ),
          ],
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    if (_isDeviceOpened) {
      _fingerprintService.closeDevice();
    }
    super.dispose();
  }
}