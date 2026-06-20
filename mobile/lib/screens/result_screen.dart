import 'package:flutter/material.dart';
import 'dart:io';
import '../core/tts_helper.dart';

class ResultScreen extends StatelessWidget {
  final String imagePath;
  final Map<String, dynamic> aiResponse;
  final bool isLocalPath;

  const ResultScreen({
    super.key,
    required this.imagePath,
    required this.aiResponse,
    this.isLocalPath = true,
  });

  @override
  Widget build(BuildContext context) {
    final analysisText = aiResponse['analysis'] ?? "No analysis returned.";
    final confidence = (aiResponse['confidence'] ?? 0.0) as double;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "AI Analysis Result",
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up_rounded),
            onPressed: () => TtsHelper.speak(analysisText),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Display Image Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: isLocalPath && File(imagePath).existsSync()
                    ? Image.file(
                        File(imagePath),
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: 250,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.image, size: 80, color: Colors.grey),
                      ),
              ),
              const SizedBox(height: 24),
              // AI Result Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, spreadRadius: 2),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.check_circle_rounded, color: Colors.green, size: 28),
                        const SizedBox(width: 8),
                        const Text(
                          "Analysis Complete",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),
                    const Text(
                      "Detected Info:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      analysisText,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFF1E293B),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.analytics_rounded, color: Colors.blue, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            "Confidence: ${(confidence * 100).toStringAsFixed(1)}%",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Done Button
              SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    TtsHelper.stop();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  icon: const Icon(Icons.home_outlined, color: Colors.white),
                  label: const Text(
                    "Back to Dashboard",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
