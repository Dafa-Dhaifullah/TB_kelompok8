import 'package:flutter/material.dart';
import 'package:tb_mobile/model/news_items_model.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cached_network_image/cached_network_image.dart';

class SearchResultPage extends StatelessWidget {
  final String query;
  final List<NewsItem> newsResults;

  const SearchResultPage({
    Key? key,
    required this.query,
    required this.newsResults,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Results for \"$query\""),
      ),
      body: ListView.separated(
        itemCount: newsResults.length,
        separatorBuilder: (_, __) => Divider(color: Colors.grey[300]),
        itemBuilder: (context, index) {
          final news = newsResults[index];
          return InkWell(
            onTap: () {
              // TODO: Buka halaman detail berita
              // Navigator.push(context, MaterialPageRoute(builder: (_) => NewsDetailPage(news)));
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  // Left: Title & Summary
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          news.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          news.summary ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          timeago.format(news.updatedAt),
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Right: Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: news.featuredImageUrl ?? 'assets/images/icons8-no-image-100.png',
                      width: 100,
                      height: 80,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        width: 100,
                        height: 80,
                        color: Colors.grey[200],
                      ),
                      errorWidget: (_, __, ___) => Icon(Icons.image_not_supported),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
