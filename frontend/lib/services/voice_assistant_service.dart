import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

class VoiceAssistantService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _tts = FlutterTts();

  Future<void> speak(String text) async {
    await _tts.speak(text);
  }

  Future<void> listen(Function(String) onResult) async {
    bool available = await _speech.initialize();
    if (available) {
      _speech.listen(onResult: (val) => onResult(val.recognizedWords));
    } else {
      speak("Voice recognition is not available at the moment.");
    }
  }

  void stop() {
    _speech.stop();
  }

  String processCommand(String command) {
    String cmd = command.toLowerCase();
    if (cmd.contains("scan")) return "SCAN";
    if (cmd.contains("library")) return "LIBRARY";
    if (cmd.contains("study")) return "STUDY";
    if (cmd.contains("help")) return "HELP";
    if (cmd.contains("logout")) return "LOGOUT";
    return "UNKNOWN";
  }
}
