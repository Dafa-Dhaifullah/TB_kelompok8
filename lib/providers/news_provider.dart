import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tb_mobile/model/news_items_model.dart';

class NewsProvider with ChangeNotifier {
  List<NewsItem> _newsList = [];

  List<NewsItem> get newsList => _newsList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchNews() async {
    if (_newsList.isNotEmpty) return; // hanya fetch 1x

    _isLoading = true;
    notifyListeners();

    final response = await http.get(Uri.parse('http://45.149.187.204:3000/api/news'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _newsList = (data['body']['data'] as List)
          .map((item) => NewsItem.fromJson(item))
          .toList();
    } else {
      throw Exception('Gagal mengambil berita');
    }

    _isLoading = false;
    notifyListeners();
  }
}
