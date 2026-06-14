import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class AudioReaderView extends StatefulWidget {
  final String text;
  final String title;

  const AudioReaderView({super.key, required this.text, required this.title});

  @override
  State<AudioReaderView> createState() => _AudioReaderViewState();
}

class _AudioReaderViewState extends State<AudioReaderView> {
  final FlutterTts _tts = FlutterTts();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _play();
  }

  Future<void> _play() async {
    setState(() => _isPlaying = true);
    await _tts.speak(widget.text);
    setState(() => _isPlaying = false);
  }

  Future<void> _pause() async {
    await _tts.stop();
    setState(() => _isPlaying = false);
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Text(
                widget.text,
                style: const TextStyle(fontSize: 22, color: Colors.white),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.deepPurple,
            height: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildControlButton(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  _isPlaying ? "PAUSE" : "PLAY",
                  () => _isPlaying ? _pause() : _play()
                ),
                _buildControlButton(
                  Icons.replay,
                  "REPEAT",
                  () => _play()
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(IconData icon, String label, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 50, color: Colors.white),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
