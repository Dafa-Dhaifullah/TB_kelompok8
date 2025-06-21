import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:tb_mobile/providers/auth_provider.dart';
import 'package:tb_mobile/providers/news_provider.dart';
import 'package:tb_mobile/signin_screen.dart';
import 'package:tb_mobile/create_news.dart';
import 'package:tb_mobile/read_news.dart';
import 'package:tb_mobile/model/news.dart';

// News Detail Page untuk Author (mengadaptasi dari NewsDetailPage)
class AuthorNewsDetailPage extends StatelessWidget {
  final News news;
  final bool isAuthor;

  const AuthorNewsDetailPage({
    super.key, 
    required this.news,
    this.isAuthor = true,
  });

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
          if (isAuthor) ...[
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.black),
              onPressed: () {
                // Navigate to edit news screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Edit functionality coming soon')),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                // Show delete confirmation
                _showDeleteConfirmation(context);
              },
            ),
          ],
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share functionality coming soon')),
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
            // Status badge (jika author)
            if (isAuthor) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Published', // Atau status lainnya
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
            
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
            
            // Waktu dan info lainnya
            Row(
              children: [
                Text(
                  DateFormat('MMM d, yyyy').format(news.updatedAt),
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
            
            // Content
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
            
            // Category
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

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Article'),
          content: const Text('Are you sure you want to delete this article?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Implement delete functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Delete functionality coming soon')),
                );
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}

// Author News Card (mengadaptasi dari RegularNewsCard)
class AuthorNewsCard extends StatelessWidget {
  final News news;

  const AuthorNewsCard({
    super.key,
    required this.news,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("Slug yang dikirim: ${news.slug}");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AuthorNewsDetailPage(
              news: news,
              isAuthor: true,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
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
                  // Status badge (untuk author)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Published',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  
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
                  
                  const SizedBox(height: 4),
                  
                  // Summary
                  if (news.summary != null && news.summary!.isNotEmpty)
                    Text(
                      news.summary!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  
                  const SizedBox(height: 6),
                  
                  // Date and views
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 12, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('MMM d').format(news.updatedAt),
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
              child: SizedBox(
                width: 80,
                height: 80,
                child: news.featuredImageUrl != null
                    ? Image.network(
                        news.featuredImageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                            size: 30,
                          ),
                        ),
                      )
                    : Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.image,
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

// Author Page (mengintegrasikan semua komponen)
class AuthorPage extends StatefulWidget {
  const AuthorPage({super.key});

  @override
  State<AuthorPage> createState() => _AuthorPageState();
}

class _AuthorPageState extends State<AuthorPage> {
  int _currentPage = 1;
  final int _limit = 10;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.isAuthenticated) {
        _loadAuthorNews();
      }
    });
  }

  void _loadAuthorNews() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);
    
    if (authProvider.token != null) {
      newsProvider.getAuthorNews(
        authProvider.token!, 
        page: _currentPage, 
        limit: _limit,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (!authProvider.isAuthenticated) {
          return const SignInScreen();
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Profile Section
                _buildProfileSection(authProvider),
                
                const SizedBox(height: 20),
                
                // Divider
                const Divider(color: Colors.grey),
                
                const SizedBox(height: 16),
                
                // Your News Section
                _buildNewsSection(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileSection(AuthProvider authProvider) {
    final user = authProvider.user!;
    
    return Column(
      children: [
        // Avatar
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey[300],
          backgroundImage: user.avatarUrl != null 
              ? NetworkImage(user.avatarUrl!) 
              : null,
          child: user.avatarUrl == null 
              ? Icon(Icons.person, size: 50, color: Colors.grey[600])
              : null,
        ),
        
        const SizedBox(height: 16),
        
        // Full Name
        Text(
          user.fullName,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Email
        Text(
          user.email,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Bio
        if (user.bio != null)
          Text(
            user.bio!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
      ],
    );
  }

  Widget _buildNewsSection() {
    return Column(
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Your News',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateNewsScreen(),
                  ),
                ).then((_) => _loadAuthorNews());
              },
              icon: const Icon(Icons.edit),
              tooltip: 'Create News',
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // News List
        Consumer<NewsProvider>(
          builder: (context, newsProvider, _) {
            if (newsProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (newsProvider.error != null) {
              return Center(
                child: Column(
                  children: [
                    Text(
                      'Error: ${newsProvider.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _loadAuthorNews,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final newsList = newsProvider.authorNews;

            if (newsList.isEmpty) {
              return Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.article_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No news articles yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Create your first article to get started',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreateNewsScreen(),
                          ),
                        ).then((_) => _loadAuthorNews());
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Create Article'),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                // News Cards
                ...newsList.map((news) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: AuthorNewsCard(news: news),
                  );
                }).toList(),
                
                // Load more button jika diperlukan
                if (newsList.length >= _limit)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _currentPage++;
                        });
                        _loadAuthorNews();
                      },
                      child: const Text('Load More'),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}