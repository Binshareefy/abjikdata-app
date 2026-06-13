import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _loading = false;
  String? _error;
  bool _isLoggedIn = false;

  User? get user => _user;
  bool get loading => _loading;
  String? get error => _error;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionId = prefs.getString('session_id');
    if (sessionId != null) {
      ApiService.setSessionId(sessionId);
      _isLoggedIn = true;
      await fetchProfile();
    }
  }

  Future<bool> login(String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final res = await ApiService.login(email, password);
      if (res['status'] == 'success') {
        final sessionId = res['session_id'] ?? res['data']?['session_id'];
        if (sessionId != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('session_id', sessionId);
          ApiService.setSessionId(sessionId);
        }
        _user = User.fromJson(res['data'] ?? res);
        _isLoggedIn = true;
        _loading = false;
        notifyListeners();
        return true;
      } else {
        _error = res['message'] ?? 'Login failed';
        _loading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Connection error. Please try again.';
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(Map<String, dynamic> data) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final res = await ApiService.register(data);
      if (res['status'] == 'success') {
        final sessionId = res['session_id'] ?? res['data']?['session_id'];
        if (sessionId != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('session_id', sessionId);
          ApiService.setSessionId(sessionId);
        }
        _user = User.fromJson(res['data'] ?? res);
        _isLoggedIn = true;
        _loading = false;
        notifyListeners();
        return true;
      } else {
        _error = res['message'] ?? 'Registration failed';
        _loading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Connection error. Please try again.';
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchProfile() async {
    try {
      final res = await ApiService.getProfile();
      if (res['status'] == 'success') {
        _user = User.fromJson(res['data'] ?? res);
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('session_id');
    ApiService.setSessionId(null);
    _user = null;
    _isLoggedIn = false;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
