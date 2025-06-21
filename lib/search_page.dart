import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tb_mobile/model/news_items_model.dart';
import 'package:tb_mobile/search_result_page.dart';

Future<List<NewsItem>> fetchAllNews() async {
  final response = await http.get(Uri.parse('https://your-api.com/berita'));
  if (response.statusCode == 200) {
    final List jsonData = json.decode(response.body);
    return jsonData.map((item) => NewsItem.fromJson(item)).toList();
  } else {
    throw Exception('Gagal ambil data berita');
  }
}

List<NewsItem> filterNews(String query, List<NewsItem> NewsList) {
  final q = query.toLowerCase();
  return NewsList.where((news) {
    return news.title.toLowerCase().contains(q) ||
           (news.summary ?? '').toLowerCase().contains(q) ||
           news.content.toLowerCase().contains(q) ||
           news.authorName.toLowerCase().contains(q) ||
           (news.category ?? '').toLowerCase().contains(q);
  }).toList();
}



class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchHistory = [];

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }

  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _searchHistory = prefs.getStringList('search_history') ?? [];
    });
  }

  Future<void> _saveSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('search_history', _searchHistory);
  }

  void _submitSearch(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _searchHistory.remove(query); // hapus duplikat
      _searchHistory.insert(0, query); // tambahkan di paling atas
      if (_searchHistory.length > 3) _searchHistory = _searchHistory.sublist(0, 3);
    });
    _saveSearchHistory();

    try {
      final allNews = await fetchAllNews();
      final results = filterNews(query, allNews);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SearchResultPage(
            query: query,
            newsResults: results,
          ),
        ),
      );
    } catch (e) {
      print('Error saat pencarian: $e');
    }

  }

  void _deleteHistory(String keyword) {
    setState(() {
      _searchHistory.remove(keyword);
    });
    _saveSearchHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          onSubmitted: _submitSearch,
          decoration: InputDecoration(
            hintText: 'Search',
            border: InputBorder.none,
          ),
        ),
      ),
      body: _searchHistory.isEmpty
          ? Center(child: Text("No search history yet"))
          : ListView.builder(
              itemCount: _searchHistory.length,
              itemBuilder: (context, index) {
                String keyword = _searchHistory[index];
                return ListTile(
                  leading: Icon(Icons.history),
                  title: Text(keyword),
                  trailing: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => _deleteHistory(keyword),
                        ),
                  onTap: () => _submitSearch(keyword),
                );
              },
            ),
    );
  }
}
