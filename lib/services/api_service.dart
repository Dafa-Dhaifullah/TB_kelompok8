import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tb_mobile/model/api_response.dart';
import 'package:tb_mobile/model/login_response.dart';
import 'package:tb_mobile/model/news.dart';
import 'package:tb_mobile/model/user.dart';


class ApiService {
  static const String baseUrl = 'http://45.149.187.204:3000'; // Ganti dengan URL API Anda
  
  static const Duration timeoutDuration = Duration(seconds: 30);

  static Map<String, String> _getHeaders({String? token}) {
    final headers = {
      'Content-Type': 'application/json',
    };
    
    if (token != null) {
      headers['Authorization'] = 'Bearer $token'; // atau sesuai format yang dibutuhkan API Anda
    }
    
    return headers;
  }

  // AUTH ENDPOINTS

  static Future<ApiResponse<LoginResponse>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: _getHeaders(),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(timeoutDuration);

      final jsonResponse = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return ApiResponse<LoginResponse>(
          status: jsonResponse['status'],
          success: jsonResponse['body']['success'],
          data: LoginResponse.fromJson(jsonResponse['body']['data']),
          message: jsonResponse['body']['message'],
        );
      } else {
        return ApiResponse<LoginResponse>(
          status: jsonResponse['status'] ?? response.statusCode,
          success: false,
          message: jsonResponse['body']['message'] ?? 'Login failed',
        );
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<ApiResponse<User>> getCurrentUser(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/auth/me'),
        headers: _getHeaders(token: token),
      ).timeout(timeoutDuration);

      final jsonResponse = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return ApiResponse<User>(
          status: jsonResponse['status'],
          success: jsonResponse['body']['success'],
          data: User.fromJson(jsonResponse['body']['data']),
          message: jsonResponse['body']['message'],
        );
      } else {
        return ApiResponse<User>(
          status: jsonResponse['status'] ?? response.statusCode,
          success: false,
          message: jsonResponse['body']['message'] ?? 'Failed to get user data',
        );
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // AUTHOR NEWS ENDPOINTS

  static Future<ApiResponse<List<News>>> getAuthorNews(String token, {int page = 1, int limit = 10}) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/api/author/news'),
      headers: _getHeaders(token: token),
    ).timeout(timeoutDuration);

      final jsonResponse = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        final List<dynamic> newsData = jsonResponse['body']['data'];
        final List<News> newsList = newsData.map((json) => News.fromJson(json)).toList();
        
        return ApiResponse<List<News>>(
          status: jsonResponse['status'],
          success: jsonResponse['body']['success'],
          data: newsList,
          message: jsonResponse['body']['message'],
        );
      } else {
        return ApiResponse<List<News>>(
          status: jsonResponse['status'] ?? response.statusCode,
          success: false,
          message: jsonResponse['body']['message'] ?? 'Failed to get author news',
        );
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<ApiResponse<News>> createNews(News news, String token) async {
    try { 

      final response = await http.post(
        Uri.parse('$baseUrl/api/author/news'),
        headers: _getHeaders(token: token),
        body: jsonEncode(news.toCreateJson()),
      ).timeout(timeoutDuration);

      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return ApiResponse<News>(
          status: jsonResponse['status'],
          success: jsonResponse['body']['success'],
          data: News.fromJson(jsonResponse['body']['data']),
          message: jsonResponse['body']['message'],
        );
      } else {
        return ApiResponse<News>(
          status: jsonResponse['status'] ?? response.statusCode,
          success: false,
          message: jsonResponse['body']['message'] ?? 'Failed to create news',
        );
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<ApiResponse<News>> updateNews(String id, News news, String token) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/author/news/$id'),
        headers: _getHeaders(token: token),
        body: jsonEncode(news.toCreateJson()),
      ).timeout(timeoutDuration);

      final jsonResponse = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return ApiResponse<News>(
          status: jsonResponse['status'],
          success: jsonResponse['body']['success'],
          data: News.fromJson(jsonResponse['body']['data']),
          message: jsonResponse['body']['message'],
        );
      } else {
        return ApiResponse<News>(
          status: jsonResponse['status'] ?? response.statusCode,
          success: false,
          message: jsonResponse['body']['message'] ?? 'Failed to update news',
        );
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<ApiResponse<void>> deleteNews(String id, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/author/news/$id'),
        headers: _getHeaders(token: token),
      ).timeout(timeoutDuration);

      final jsonResponse = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return ApiResponse<void>(
          status: jsonResponse['status'],
          success: jsonResponse['body']['success'],
          message: jsonResponse['body']['message'],
        );
      } else {
        return ApiResponse<void>(
          status: jsonResponse['status'] ?? response.statusCode,
          success: false,
          message: jsonResponse['body']['message'] ?? 'Failed to delete news',
        );
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // PUBLIC NEWS ENDPOINTS

  static Future<ApiResponse<List<News>>> getPublicNews() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/news'),
        headers: _getHeaders(),
      ).timeout(timeoutDuration);

      final jsonResponse = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        final List<dynamic> newsData = jsonResponse['body']['data'];
        final List<News> newsList = newsData.map((json) => News.fromJson(json)).toList();
        
        return ApiResponse<List<News>>(
          status: jsonResponse['status'],
          success: jsonResponse['body']['success'],
          data: newsList,
          message: jsonResponse['body']['message'],
        );
      } else {
        return ApiResponse<List<News>>(
          status: jsonResponse['status'] ?? response.statusCode,
          success: false,
          message: jsonResponse['body']['message'] ?? 'Failed to get public news',
        );
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<ApiResponse<News>> getNewsBySlug(String slug) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/news/$slug'),
        headers: _getHeaders(),
      ).timeout(timeoutDuration);

      final jsonResponse = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return ApiResponse<News>(
          status: jsonResponse['status'],
          success: jsonResponse['body']['success'],
          data: News.fromJson(jsonResponse['body']['data']),
          message: jsonResponse['body']['message'],
        );
      } else {
        return ApiResponse<News>(
          status: jsonResponse['status'] ?? response.statusCode,
          success: false,
          message: jsonResponse['body']['message'] ?? 'Failed to get news',
        );
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}