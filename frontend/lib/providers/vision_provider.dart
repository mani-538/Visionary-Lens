import 'package:flutter/material.dart';
import 'package:visionary_lens/services/api_service.dart';

class VisionProvider with ChangeNotifier {
  bool _isProcessing = false;
  String _guidanceMessage = "Initializing Camera...";
  String _extractedText = "";
  final ApiService _apiService = ApiService();

  bool get isProcessing => _isProcessing;
  String get guidanceMessage => _guidanceMessage;
  String get extractedText => _extractedText;

  void updateGuidance(String message) {
    _guidanceMessage = message;
    notifyListeners();
  }

  Future<void> processImage(String token, String imagePath) async {
    _isProcessing = true;
    updateGuidance("Processing document. Please wait...");
    
    try {
      final uploadRes = await _apiService.uploadDocument(token, imagePath);
      if (uploadRes['id'] != null) {
        int docId = uploadRes['id'];
        final ocrRes = await _apiService.extractOCR(token, docId);
        _extractedText = ocrRes['extracted_text'] ?? "";
        updateGuidance("Text extracted successfully.");
      }
    } catch (e) {
      updateGuidance("Error processing image: $e");
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }
}
