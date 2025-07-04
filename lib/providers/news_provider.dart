import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:tb_mobile/model/news.dart';
import 'dart:convert';
import 'package:tb_mobile/model/news_items_model.dart';
import 'package:tb_mobile/services/api_service.dart';


class NewsProvider with ChangeNotifier {
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
  Future<bool> updateNews(String id, News news, String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.updateNews(id, news, token);
      if (response.success) {
        final index = _authorNews.indexWhere((n) => n.id == id);
        if (index != -1) {
          _authorNews[index] = response.data!;
        }
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

  // Delete news
  Future<bool> deleteNews(String id, String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.deleteNews(id, token);
      if (response.success) {
        _authorNews.removeWhere((news) => news.id == id);
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

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearSelectedNews() {
    _selectedNews = null;
    notifyListeners();
  }
}
