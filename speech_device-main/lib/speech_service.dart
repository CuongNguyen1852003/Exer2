import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isInitialized = false;
  bool _isListening = false;

  Future<bool> initialize() async {
    if (!_isInitialized) {
      try {
        _isInitialized = await _speech.initialize(
          onError: (error) => print('Speech recognition error: $error'),
          onStatus: (status) => print('Speech recognition status: $status'),
        );
        print('Speech recognition initialized: $_isInitialized');
      } catch (e) {
        print('Error initializing speech recognition: $e');
        _isInitialized = false;
      }
    }
    return _isInitialized;
  }

  Future<bool> requestPermissions() async {
    try {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.microphone,
        Permission.storage,
      ].request();

      bool allGranted = true;
      statuses.forEach((permission, status) {
        print('Permission $permission status: $status');
        if (!status.isGranted) {
          allGranted = false;
        }
      });

      return allGranted;
    } catch (e) {
      print('Error requesting permissions: $e');
      return false;
    }
  }

  Future<void> startListening({
    required Function(String text) onResult,
  }) async {
    if (!_isInitialized) {
      bool initialized = await initialize();
      if (!initialized) {
        throw Exception('Speech recognition not initialized');
      }
    }

    if (!_isListening) {
      try {
        _isListening = await _speech.listen(
          onResult: (result) {
            print('Speech recognition result: ${result.recognizedWords}');
            if (result.finalResult) {
              onResult(result.recognizedWords);
            }
          },
          listenFor: const Duration(seconds: 30),
          pauseFor: const Duration(seconds: 5),
          partialResults: true,
          cancelOnError: true,
        );
        print('Started listening: $_isListening');
      } catch (e) {
        print('Error starting speech recognition: $e');
        _isListening = false;
        throw e;
      }
    }
  }

  Future<void> stopListening() async {
    if (_isListening) {
      try {
        await _speech.stop();
        _isListening = false;
        print('Stopped listening');
      } catch (e) {
        print('Error stopping speech recognition: $e');
        throw e;
      }
    }
  }

  bool get isListening => _isListening;
} 