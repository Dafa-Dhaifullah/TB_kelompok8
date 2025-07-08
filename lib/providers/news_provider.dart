import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:tb_mobile/model/news.dart';
import 'dart:convert';
import 'package:tb_mobile/model/news_items_model.dart';
import 'package:tb_mobile/services/api_service.dart';


class NewsProvider with ChangeNotifier {
  final String baseUrl = 'http://45.149.187.204:3000/api';

  List<NewsItem> _newsList = [];

  List<NewsItem> get newsList => _newsList;
  
  bool _isLoading = false;
  List<News> get authorNews => _authorNews;
  List<News> get publicNews => _publicNews;
  News? get selectedNews => _selectedNews;
  String? get error => _error;

  // Get author's news
  Future<void> getAuthorNews(String token, {int page = 1, int limit = 10}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.getAuthorNews(token, page: page, limit: limit);
      if (response.success) {
        if (page == 1) {
          _authorNews = response.data!;
        } else {
          _authorNews.addAll(response.data!);
        }
      } else {
        _error = response.message;
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Get public news
  Future<void> getPublicNews() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.getPublicNews();
      if (response.success) {
        _publicNews = response.data!;
      } else {
        _error = response.message;
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Get news by slug
  Future<void> getNewsBySlug(String slug) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.getNewsBySlug(slug);
      if (response.success) {
        _selectedNews = response.data!;
      } else {
        _error = response.message;
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Create news
  Future<bool> createNews(News news, String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.createNews(news, token);
      if (response.success) {
        _authorNews.insert(0, response.data!);
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

  // Update news
  // Future<bool> updateNews(String id, News news, String token) async {
  //   _isLoading = true;
  //   _error = null;
  //   notifyListeners();

  //   try {
  //     final response = await ApiService.updateNews(id, news, token);
  //     if (response.success) {
  //       final index = _authorNews.indexWhere((n) => n.id == id);
  //       if (index != -1) {
  //         _authorNews[index] = response.data!;
  //       }
  //       _isLoading = false;
  //       notifyListeners();
  //       return true;
  //     } else {
  //       _error = response.message;
  //       _isLoading = false;
  //       notifyListeners();
  //       return false;
  //     }
  //   } catch (e) {
  //     _error = e.toString();
  //     _isLoading = false;
  //     notifyListeners();
  //     return false;
  //   }
  // }

  // Delete news
  // Future<bool> deleteNews(String id, String token) async {
  //   _isLoading = true;
  //   _error = null;
  //   notifyListeners();

  //   try {
  //     final response = await ApiService.deleteNews(id, token);
  //     if (response.success) {
  //       _authorNews.removeWhere((news) => news.id == id);
  //       _isLoading = false;
  //       notifyListeners();
  //       return true;
  //     } else {
  //       _error = response.message;
  //       _isLoading = false;
  //       notifyListeners();
  //       return false;
  //     }
  //   } catch (e) {
  //     _error = e.toString();
  //     _isLoading = false;
  //     notifyListeners();
  //     return false;
  //   }
  // }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearSelectedNews() {
    _selectedNews = null;
    notifyListeners();
  }
  Future<bool> updateNews(
    String token,
    String newsId,
    {
      required String title,
      String? summary,
      String? content,
      String? category,
      String? imageUrl,
    }
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/author/news/$newsId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'title': title,
          'summary': summary,
          'content': content,
          'category': category,
          'featured_image_url': imageUrl,
        }),
      );

      if (response.statusCode == 200) {
        // Refresh author news setelah update
        await getAuthorNews(token);
      } else {
        throw Exception('Failed to update news');
      }
    } catch (e) {
      throw Exception('Error updating news: $e');
    }
    return false;
  }

  Future<bool> deleteNews(String token, String newsId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/author/news/$newsId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Remove from local list
        _authorNews.removeWhere((news) => news.id == newsId);
        notifyListeners();
      } else {
        throw Exception('Failed to delete news');
      }
    } catch (e) {
      throw Exception('Error deleting news: $e');
    }

    return false;
  }
}
