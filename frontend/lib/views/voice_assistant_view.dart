import 'package:flutter/material.dart';
import 'package:visionary_lens/services/voice_assistant_service.dart';

class VoiceAssistantView extends StatefulWidget {
  const VoiceAssistantView({super.key});

  @override
  State<VoiceAssistantView> createState() => _VoiceAssistantViewState();
}

class _VoiceAssistantViewState extends State<VoiceAssistantView> {
  final VoiceAssistantService _voiceService = VoiceAssistantService();
  String _lastWords = "TAP TO SPEAK";
  bool _isListening = false;

  void _startListening() {
    _voiceService.listen((result) {
      setState(() {
        _lastWords = result;
      });
      // Process command after a short delay or specialized check
    });
    setState(() => _isListening = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.mic, size: 120, color: Colors.blue),
            const SizedBox(height: 50),
            Text(
              _lastWords,
              style: const TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 80),
            SizedBox(
              width: 300,
              height: 300,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: _isListening ? Colors.red : Colors.blue,
                ),
                onPressed: _startListening,
                child: Text(
                  _isListening ? "LISTENING" : "START",
                  style: const TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
