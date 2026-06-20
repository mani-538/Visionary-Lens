import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../core/constants.dart';

class VisionProvider with ChangeNotifier {
  List<dynamic> _history = [];
  bool _isLoading = false;

  List<dynamic> get history => _history;
  bool get isLoading => _isLoading;

  Future<void> fetchHistory() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse("${ApiConstants.baseUrl}${ApiConstants.historyPath}"),
      );

      if (response.statusCode == 200) {
        _history = jsonDecode(response.body);
      }
    } catch (e) {
      debugPrint("Fetch history error: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<Map<String, dynamic>?> analyzeImage(String imagePath) async {
    _isLoading = true;
    notifyListeners();

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${ApiConstants.baseUrl}${ApiConstants.visionPath}"),
      );
      
      request.files.add(
        await http.MultipartFile.fromPath('file', imagePath),
      );

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        _isLoading = false;
        notifyListeners();
        // Refresh history after new scan
        fetchHistory();
        return result;
      }
    } catch (e) {
      debugPrint("Analyze error: $e");
    }

    _isLoading = false;
    notifyListeners();
    return null;
  }
}
