import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:visionary_lens/views/audio_reader_view.dart';

class LibraryView extends StatefulWidget {
  const LibraryView({super.key});

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
  final FlutterTts _tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _tts.speak("Library Screen. Select a document to read.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MY DOCUMENTS")),
      body: ListView.builder(
        itemCount: 3, // Mock data count
        itemBuilder: (context, index) {
          String docTitle = "Document ${index + 1}";
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(15),
              title: Text(docTitle, style: const TextStyle(fontSize: 22, color: Colors.white)),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blue),
              onTap: () {
                _tts.speak("Reading $docTitle");
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) => AudioReaderView(
                    title: docTitle,
                    text: "This is the extracted text content for $docTitle. It contains academic notes that the student can listen to using the audio reader feature.",
                  )
                ));
              },
            ),
          );
        },
      ),
    );
  }
}
