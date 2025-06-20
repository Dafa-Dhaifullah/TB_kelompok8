import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tb_mobile/providers/news_provider.dart';
import 'package:tb_mobile/utils/time_helper.dart';

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
              return Container(
                color: Colors.white,
                margin: const EdgeInsets.only(right: 5),
                padding: const EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (news.featuredImageUrl != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4), // Radius hanya untuk gambar
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
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatTimeAgo(news.updatedAt),
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
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
        return Column(
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
          return Padding(
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
                ),
                const SizedBox(height: 4),

                // Summary
                Text(
                  news.summary ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
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