import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class AccessibilityWrapper extends StatelessWidget {
  final Widget child;
  final FlutterTts _tts = FlutterTts();

  AccessibilityWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        _tts.speak("Ask My Notes. Feature pending.");
      },
      onTertiaryTapUp: (details) {
        // Mocking 3-finger tap with tertiary tap for dev env
        _tts.speak("Repeating last content.");
      },
      child: child,
    );
  }
}
