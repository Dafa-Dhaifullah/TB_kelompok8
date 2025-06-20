import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tb_mobile/model/news_items_model.dart';
import 'package:tb_mobile/providers/news_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class HeadlinesPage extends StatefulWidget {
  const HeadlinesPage({super.key});

  @override
  _HeadlinesPageState createState() => _HeadlinesPageState();
}

class _HeadlinesPageState extends State<HeadlinesPage> {
  String selectedCategory = '';
  
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<NewsProvider>(context, listen: false);
    provider.fetchNews(); // pastikan ini hanya dipanggil sekali
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (context, provider, child) {
        final allNews = provider.newsList;
        final categories = allNews
            .map((news) => news.category)
            .toSet()
            .toList();

        final filteredNews = selectedCategory.isEmpty
            ? allNews
            : allNews.where((n) => n.category == selectedCategory).toList();

        return Scaffold(
          appBar: AppBar(title: Text('Headlines')),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔸 Category Selector
              Container(
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    final isSelected = cat == selectedCategory;
                    return GestureDetector(
                      onTap: () => setState(() => selectedCategory = cat ?? ''),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.grey[300] : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          cat ?? '',
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Divider(),
              // 🔹 News List
              Expanded(
                child: ListView.separated(
                  itemCount: filteredNews.length,
                  separatorBuilder: (_, __) => Divider(color: Colors.grey),
                  itemBuilder: (context, index) {
                    final news = filteredNews[index];

                    if (index < 3) {
                      return TopNewsCard(news: news); // 3 berita pertama
                    } else {
                      return RegularNewsCard(news: news); // sisanya
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class TopNewsCard extends StatelessWidget {
  final NewsItem news;
  const TopNewsCard({required this.news});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(news.featuredImageUrl ?? 'assets/images/icons8-no-image-100.png', width: double.infinity, height: 180, fit: BoxFit.cover),
          SizedBox(height: 8),
          Text(news.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text(news.summary ?? '', style: TextStyle(color: Colors.grey[700])),
          SizedBox(height: 4),
          Text(timeago.format(news.updatedAt), style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}

class RegularNewsCard extends StatelessWidget {
  final NewsItem news;
  const RegularNewsCard({required this.news});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(news.title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                SizedBox(height: 4),
                Text(timeago.format(news.updatedAt), style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          SizedBox(width: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(news.featuredImageUrl ?? 'assets/images/icons8-no-image-100.png', width: 80, height: 80, fit: BoxFit.cover),
          ),
        ],
      ),
    );
  }
}
