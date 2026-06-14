import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://YOUR_BACKEND_IP:8000";

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> uploadDocument(String token, String filePath) async {
    var request = http.MultipartRequest('POST', Uri.parse("$baseUrl/documents/upload"));
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath('file', filePath));
    
    var res = await request.send();
    final response = await http.Response.fromStream(res);
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> extractOCR(String token, int documentId) async {
    final response = await http.post(
      Uri.parse("$baseUrl/ocr/extract"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode({"document_id": document_id}),
    );
    return jsonDecode(response.body);
  }

  // Add other methods for AI summarize, ask, labels etc.
}
