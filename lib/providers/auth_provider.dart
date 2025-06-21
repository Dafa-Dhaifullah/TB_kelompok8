import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tb_mobile/model/user.dart';
import '../model/login_response.dart';
import '../model/api_response.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  String? _token;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _token != null && _user != null;

  AuthProvider() {
    _loadTokenFromStorage();
  }

  Future<void> _loadTokenFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    if (_token != null) {
      await getCurrentUser();
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.login(email, password);
      if (response.success) {
        _token = response.data!.token;
        _user = response.data!.author;
        
        // Save token to storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);
        
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response.message;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> getCurrentUser() async {
    if (_token == null) return;

    try {
      final response = await ApiService.getCurrentUser(_token!);
      if (response.success) {
        _user = response.data!;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _user = null;
    _token = null;
    _error = null;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}