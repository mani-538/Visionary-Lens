import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:visionary_lens/providers/vision_provider.dart';
import 'package:visionary_lens/providers/auth_provider.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  final FlutterTts _tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _controller = CameraController(_cameras![0], ResolutionPreset.high);
      await _controller!.initialize();
      if (!mounted) return;
      setState(() {});
      _speak("Camera Ready. Hold the document in front of you.");
    }
  }

  Future<void> _speak(String text) async {
    await _tts.speak(text);
  }

  Future<void> _captureAndProcess() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      final image = await _controller!.takePicture();
      _speak("Image captured accurately. Processing now.");
      
      final vision = Provider.of<VisionProvider>(context, listen: false);
      final auth = Provider.of<AuthProvider>(context, listen: false);
      
      if (auth.token != null) {
        await vision.processImage(auth.token!, image.path);
        _speak(vision.guidanceMessage);
      }
    } catch (e) {
      _speak("Error capturing image.");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (_controller != null && _controller!.value.isInitialized)
            Center(child: CameraPreview(_controller!))
          else
            const Center(child: CircularProgressIndicator()),
          
          // Guidance Overlay
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 50),
              padding: const EdgeInsets.all(20),
              color: Colors.black54,
              child: Consumer<VisionProvider>(
                builder: (context, vision, _) => Text(
                  vision.guidanceMessage,
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          
          // Tap to Capture (Full Screen)
          GestureDetector(
            onDoubleTap: _captureAndProcess,
            child: Container(
              color: Colors.transparent,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}
