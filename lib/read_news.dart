import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/news_provider.dart';
import '../providers/auth_provider.dart';
import '../edit_news.dart';
import '../model/news.dart';

class ReadNewsScreen extends StatefulWidget {
  final String slug;
  final bool isAuthor;

  const ReadNewsScreen({
    super.key,
    required this.slug,
    this.isAuthor = false,
  });

  @override
  State<ReadNewsScreen> createState() => _ReadNewsScreenState();
}

class _ReadNewsScreenState extends State<ReadNewsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NewsProvider>(context, listen: false)
          .getNewsBySlug(widget.slug);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (context, newsProvider, _) {
        if (newsProvider.isLoading) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Loading...'),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (newsProvider.error != null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Error'),
            ),
            body: Center(
              child: Text(
                'Error: ${newsProvider.error}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        final news = newsProvider.selectedNews;
        if (news == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Not Found'),
            ),
            body: const Center(
              child: Text('News not found'),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: _buildAppBar(news),
          body: _buildBody(news),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(News news) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        news.title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      actions: widget.isAuthor ? [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditNewsScreen(news: news),
              ),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _showDeleteConfirmation(news),
        ),
      ] : null,
    );
  }

  Widget _buildBody(News news) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Featured Image
          if (news.featuredImageUrl != null)
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(news.featuredImageUrl!),
                  fit: BoxFit.cover,
                ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  news.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Updated At
                Text(
                  DateFormat('MMMM d, yyyy').format(news.updatedAt),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Content
                Text(
                  news.content,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.black87,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Author Info
                if (news.authorName != null)
                  _buildAuthorInfo(news),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthorInfo(News news) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author Avatar
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey[300],
            backgroundImage: news.authorAvatar != null 
                ? NetworkImage(news.authorAvatar!) 
                : null,
            child: news.authorAvatar == null 
                ? Icon(Icons.person, color: Colors.grey[600])
                : null,
          ),
          
          const SizedBox(width: 12),
          
          // Author Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  news.authorName!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                
                if (news.authorBio != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    news.authorBio!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(News news) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete News'),
          content: const Text('Are you sure you want to delete this news article? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteNews(news);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteNews(News news) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);

    if (authProvider.token != null) {
      final success = await newsProvider.deleteNews(news.id, authProvider.token!);
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('News deleted successfully')),
        );
        Navigator.pop(context);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete news: ${newsProvider.error}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}