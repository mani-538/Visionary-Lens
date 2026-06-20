import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/vision_provider.dart';
import '../../core/constants.dart';
import 'result_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<VisionProvider>().fetchHistory());
  }

  @override
  Widget build(BuildContext context) {
    final vision = context.watch<VisionProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("Scan History", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: vision.isLoading
          ? const Center(child: CircularProgressIndicator())
          : vision.history.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history_rounded, size: 80, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      const Text("No scans yet", style: TextStyle(fontSize: 18, color: Colors.grey)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: vision.history.length,
                  itemBuilder: (context, index) {
                    final item = vision.history[index];
                    final date = DateTime.parse(item['created_at']);
                    final formattedDate = DateFormat('MMM dd, yyyy • hh:mm a').format(date);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ResultScreen(
                                imagePath: item['image_path'],
                                aiResponse: {
                                  'analysis': item['analysis_result'],
                                  'confidence': (item['confidence'] ?? 0) / 100.0,
                                },
                                isLocalPath: false,
                              ),
                            ),
                          );
                        },
                        contentPadding: const EdgeInsets.all(12),
                        leading: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey.shade200,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: item['image_path'].startsWith('app/') 
                              // Fallback if it's a server path we can't easily reach yet or display
                              ? const Icon(Icons.image)
                              : Image.file(File(item['image_path']), fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.image)),
                          ),
                        ),
                        title: Text(
                          item['analysis_result'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(formattedDate),
                        trailing: const Icon(Icons.chevron_right),
                      ),
                    );
                  },
                ),
    );
  }
}
