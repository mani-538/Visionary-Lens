import 'package:flutter/material.dart';
import 'package:visionary_lens/services/api_service.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  bool _isLoading = false;
  final ApiService _apiService = ApiService();

  bool get isAuthenticated => _token != null;
  bool get isLoading => _isLoading;
  String? get token => _token;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final res = await _apiService.login(email, password);
      if (res['access_token'] != null) {
        _token = res['access_token'];
      }
    } catch (e) {
      debugPrint("Login error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    _token = null;
    notifyListeners();
  }
}
