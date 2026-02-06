import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceService {
  final SpeechToText _speech = SpeechToText();
  final TextEditingController controller;
  bool _isListening = false;

  VoiceService({required this.controller});

  // 🎙️ Start Listening
  Future<bool> startListening() async {
    if (_isListening) return false;

    try {
      bool available = await _speech.initialize(
        onStatus: (status) => print('Voice Status: $status'),
        onError: (error) => print('Voice Error: $error'),
      );

      if (available) {
        _isListening = true;
        await _speech.listen(
          onResult: (result) {
            controller.text = result.recognizedWords;
          },
          listenFor: Duration(seconds: 30),
          pauseFor: Duration(seconds: 3),
          localeId: 'en_US',
        );
        return true;
      }
      return false;
    } catch (e) {
      print('Voice init error: $e');
      return false;
    }
  }

  // 🛑 Stop Listening
  Future<void> stopListening() async {
    if (_isListening) {
      await _speech.stop();
      _isListening = false;
    }
  }

  // 🔄 Toggle (Start/Stop)
  Future<bool> toggleListening() async {
    if (_isListening) {
      await stopListening();
      return false;
    } else {
      return await startListening();
    }
  }

  bool get isListening => _isListening;
}
