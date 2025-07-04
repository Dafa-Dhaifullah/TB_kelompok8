import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tb_mobile/providers/news_provider.dart';
import 'package:tb_mobile/utils/time_helper.dart';


// Halaman Detail Berita
class NewsDetailPage extends StatelessWidget {
  final dynamic news;

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
              news.title ?? 'No Title',
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
                  formatTimeAgo(news.updatedAt),
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
                  news.featuredImageUrl,
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
            
            // Tags atau kategori (jika ada)
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

class TopStoriesCarousel extends StatefulWidget {
  final List<dynamic> newsList;

  const TopStoriesCarousel({super.key, required this.newsList});

  @override
  State<TopStoriesCarousel> createState() => _TopStoriesCarouselState();
}

class _TopStoriesCarouselState extends State<TopStoriesCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> topNews = widget.newsList
      ..sort((a, b) => (b.viewCount ?? 0).compareTo(a.viewCount ?? 0));
    final List<dynamic> top5 = topNews.take(5).toList();

    return Column(
      children: [
        SizedBox(
          height: 250,
          child: PageView.builder(
            controller: _pageController,
            itemCount: top5.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              final news = top5[index];
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
                  color: Colors.white,
                  margin: const EdgeInsets.only(right: 5),
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (news.featuredImageUrl != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(
                            news.featuredImageUrl,
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      const SizedBox(height: 8),
                      Text(
                        news.title ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formatTimeAgo(news.updatedAt),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(top5.length, (index) {
            return Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index ? Colors.blue : Colors.grey[300],
              ),
            );
          }),
        ),
      ],
    );
  }
}

class HighlightsList extends StatelessWidget {
  final List<dynamic> newsList;

  const HighlightsList({super.key, required this.newsList});

  @override
  Widget build(BuildContext context) {
    final sortedList = List.from(newsList)
    ..sort((a, b) =>
        (b.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0))
          .compareTo(a.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0)));

    final latest3 = sortedList.take(3).toList();

    return Column(
      children: latest3.map((news) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewsDetailPage(news: news),
              ),
            );
          },
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kiri: Judul dan waktu
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          news.title ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formatTimeAgo(news.updatedAt),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Kanan: Gambar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      news.featuredImageUrl ?? '',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(color: Colors.grey),
              const SizedBox(height: 12),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class TrendingList extends StatefulWidget {
  final List<dynamic> newsList;

  const TrendingList({super.key, required this.newsList});

  @override
  State<TrendingList> createState() => _TrendingListState();
}

class _TrendingListState extends State<TrendingList> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final trendingNews = List.from(widget.newsList)
      ..sort((a, b) {
        final countA = a.viewCount ?? 0;
        final countB = b.viewCount ?? 0;
        if (countA != countB) return countB.compareTo(countA);
        return (b.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0))
          .compareTo(a.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0));
      });

    final displayList = _showAll ? trendingNews : trendingNews.take(2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...displayList.map((news) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsDetailPage(news: news),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gambar Horizontal
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      news.featuredImageUrl ?? '',
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 180,
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Judul
                  Text(
                    news.title ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Summary
                  Text(
                    news.summary ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Time ago
                  Text(
                    formatTimeAgo(news.updatedAt),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Garis abu-abu
                  const Divider(color: Colors.grey),
                ],
              ),
            ),
          );
        }).toList(),

        // Tombol See All
        if (!_showAll && trendingNews.length > 2)
          Center(
            child: TextButton(
              onPressed: () {
                setState(() {
                  _showAll = true;
                });
              },
              child: const Text("See All News"),
            ),
          ),
      ],
    );
  }
}


class ForYouPage extends StatefulWidget {
  const ForYouPage({super.key});

  @override
  State<ForYouPage> createState() => _ForYouPageState();
}

class _ForYouPageState extends State<ForYouPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<NewsProvider>(context, listen: false).fetchNews());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            DateFormat('EEEE, MMMM d').format(DateTime.now()),
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),

          // --- Top Stories ---
          _sectionHeader("Top Stories"),
          const SizedBox(height: 12),

          Consumer<NewsProvider>(
            builder: (context, newsProvider, _) {
              if (newsProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              final newsList = newsProvider.newsList;

              if (newsList.isEmpty) {
                return const Text("Tidak ada berita tersedia.");
              }

              return TopStoriesCarousel(newsList: newsList);
            },
          ),

          const SizedBox(height: 24),

          // --- Highlights ---
          _sectionHeader("Highlights"),
          const SizedBox(height: 12),
          Consumer<NewsProvider>(
            builder: (context, newsProvider, _) {
              final newsList = newsProvider.newsList;
              if (newsProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (newsList.isEmpty) {
                return const Text("Tidak ada berita highlights.");
              }
              return HighlightsList(newsList: newsList);
            },
          ),


          const SizedBox(height: 24),

          // --- Trending ---
          Container(
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: Colors.blue,
                  width: 4.0,
                ),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: _sectionHeader("🔥 Trending"),
          ),
          const SizedBox(height: 12),
          Consumer<NewsProvider>(
            builder: (context, newsProvider, _) {
              final newsList = newsProvider.newsList;
              if (newsProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (newsList.isEmpty) {
                return const Text("Tidak ada berita trending.");
              }
              return TrendingList(newsList: newsList);
            },
          ),
        ],
      ),
    );
  }


  Widget _sectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}