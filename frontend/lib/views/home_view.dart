import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:visionary_lens/views/camera_view.dart';
import 'package:visionary_lens/views/library_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final FlutterTts _tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _speak("Welcome to Visionary Lens. Main Menu. You have four main options: Scan, Library, Study, and Help.");
  }

  Future<void> _speak(String text) async {
    await _tts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("VISIONARY LENS"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _speak("Logging out"),
          )
        ],
      ),
      body: GridView.count(
        crossAxisCount: 1,
        padding: const EdgeInsets.all(16.0),
        childAspectRatio: 2.5,
        mainAxisSpacing: 20,
        children: [
          _buildMenuButton(
            context,
            "SCAN DOCUMENT",
            Icons.camera_alt,
            Colors.orange,
            "Scanning mode activated. Point your camera at the text.",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CameraView())),
          ),
          _buildMenuButton(
            context,
            "LIBRARY & NOTES",
            Icons.folder,
            Colors.blue,
            "Opening your saved documents and notes.",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LibraryView())),
          ),
          _buildMenuButton(
            context,
            "STUDY ASSISTANT",
            Icons.school,
            Colors.green,
            "Study Assistant. Access flashcards and quizzes."
          ),
          _buildMenuButton(
            context,
            "SETTINGS & HELP",
            Icons.settings,
            Colors.grey,
            "Opening settings and voice help."
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        height: 100,
        color: Colors.deepPurple,
        child: Center(
          child: TextButton.icon(
            onPressed: () => _speak("Voice Assistant listening. Say a command."),
            icon: const Icon(Icons.mic, size: 40, color: Colors.white),
            label: const Text("ASK VISIONARY LENS", style: TextStyle(color: Colors.white, fontSize: 20)),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String title, IconData icon, Color color, String voiceMsg, {VoidCallback? onTap}) {
    return InkWell(
      onTap: () {
        _speak(voiceMsg);
        if (onTap != null) onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          border: Border.all(color: color, width: 3),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(width: 20),
            Text(
              title,
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
