import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tb_mobile/model/news_items_model.dart';
import 'package:tb_mobile/providers/news_provider.dart';
import 'package:timeago/timeago.dart' as timeago;


// Halaman Detail Berita (sama seperti sebelumnya)
class NewsDetailPage extends StatelessWidget {
  final NewsItem news;

  const NewsDetailPage({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: () {
              // Implementasi share functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share functionality coming soon')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border, color: Colors.black),
            onPressed: () {
              // Implementasi bookmark functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bookmark functionality coming soon')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul
            Text(
              news.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 12),
            
            // Waktu dan view count
            Row(
              children: [
                Text(
                  timeago.format(news.updatedAt),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                if (news.viewCount != null) ...[
                  const SizedBox(width: 16),
                  Icon(Icons.visibility, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    '${news.viewCount} views',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 20),
            
            // Gambar utama
            if (news.featuredImageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  news.featuredImageUrl!,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 250,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.broken_image, size: 50),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            
            // Summary
            if (news.summary != null && news.summary!.isNotEmpty) ...[
              Text(
                news.summary!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
            ],
            
            // Content (jika ada)
            if (news.content != null && news.content!.isNotEmpty) ...[
              Text(
                news.content!,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.black87,
                ),
              ),
            ] else ...[
              // Jika tidak ada content, tampilkan placeholder
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Full article content would be displayed here. This is a placeholder for the complete news article content.',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.black54,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
            
            const SizedBox(height: 30),
            
            // Tags atau kategori
            if (news.category != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  news.category!,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

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
        final categories = <String>[''] + allNews // Add empty string for "All" option
            .map((news) => news.category)
            .where((category) => category != null)
            .cast<String>()
            .toSet()
            .toList();

        final filteredNews = selectedCategory.isEmpty
            ? allNews
            : allNews.where((n) => n.category == selectedCategory).toList();

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(title: Text('Headlines')),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔸 Category Selector
              SizedBox(height: 10),
              Container(
                height: 35,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    final isSelected = cat == selectedCategory;
                    return GestureDetector(
                      onTap: () => setState(() => selectedCategory = cat ?? ''),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue : Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          cat?.isEmpty == true ? 'All' : (cat ?? ''),
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 5),
              // 🔹 News List
              Expanded(
  child: filteredNews.isEmpty
      ? const Center(
          child: Text(
            'No news available',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        )
      : RefreshIndicator(
          onRefresh: () async {
            final provider = Provider.of<NewsProvider>(context, listen: false);
            await provider.fetchNews();
          },
          child: ListView.separated(
            itemCount: filteredNews.length,
            separatorBuilder: (_, __) => Divider(color: Colors.grey[300]),
            itemBuilder: (context, index) {
              final news = filteredNews[index];

              if (index < 3) {
                return TopNewsCard(news: news);
              } else {
                return RegularNewsCard(news: news);
              }
            },
          ),
        ),
)

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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetailPage(news: news),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Featured Image
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              child: Image.network(
                news.featuredImageUrl ?? '',
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: double.infinity,
                  height: 180,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  ),
                ),
              ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category badge
                  if (news.category != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        news.category!,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  
                  const SizedBox(height: 8),
                  
                  // Title
                  Text(
                    news.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Summary
                  if (news.summary != null && news.summary!.isNotEmpty)
                    Text(
                      news.summary!,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  
                  const SizedBox(height: 8),
                  
                  // Time and view count
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        timeago.format(news.updatedAt),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      if (news.viewCount != null) ...[
                        const SizedBox(width: 16),
                        Icon(Icons.visibility, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          '${news.viewCount}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RegularNewsCard extends StatelessWidget {
  final NewsItem news;
  const RegularNewsCard({required this.news});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetailPage(news: news),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category badge (smaller for regular cards)
                  if (news.category != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        news.category!,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],
                  
                  // Title
                  Text(
                    news.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 6),
                  
                  // Time and view count
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 12, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        timeago.format(news.updatedAt),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                      ),
                      if (news.viewCount != null) ...[
                        const SizedBox(width: 12),
                        Icon(Icons.visibility, size: 12, color: Colors.grey),
                        const SizedBox(width: 2),
                        Text(
                          '${news.viewCount}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                news.featuredImageUrl ?? '',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.broken_image,
                    color: Colors.grey,
                    size: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

