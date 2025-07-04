import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tb_mobile/model/news.dart';
import '../providers/auth_provider.dart';
import '../providers/news_provider.dart';

class CreateNewsScreen extends StatefulWidget {
  const CreateNewsScreen({super.key});

  @override
  State<CreateNewsScreen> createState() => _CreateNewsScreenState();
}

class _CreateNewsScreenState extends State<CreateNewsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _summaryController = TextEditingController();
  final _contentController = TextEditingController();
  final _featuredImageUrlController = TextEditingController();
  final _categoryController = TextEditingController();
  final _tagsController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _summaryController.dispose();
    _contentController.dispose();
    _featuredImageUrlController.dispose();
    _categoryController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create News',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              _buildTextField(
                controller: _titleController,
                label: 'Title',
                hint: 'Enter news title',
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Summary
              _buildTextField(
                controller: _summaryController,
                label: 'Summary',
                hint: 'Enter brief summary',
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Summary is required';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Content
              _buildTextField(
                controller: _contentController,
                label: 'Content',
                hint: 'Write your news content here...',
                maxLines: 8,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Content is required';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Featured Image URL
              _buildTextField(
                controller: _featuredImageUrlController,
                label: 'Featured Image URL',
                hint: 'https://example.com/image.jpg',
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Featured image URL is required';
                  }
                  if (!Uri.tryParse(value)!.isAbsolute) {
                    return 'Please enter a valid URL';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Category
              _buildTextField(
                controller: _categoryController,
                label: 'Category',
                hint: 'e.g., Politics, Sports, Technology',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Category is required';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Tags
              _buildTextField(
                controller: _tagsController,
                label: 'Tags',
                hint: 'Enter tags separated by commas (e.g., news, politics, update)',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Tags are required';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 32),
              
              // Publish Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _publishNews,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Publish',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blue),
            ),
          ),
        ),
      ],
    );
  }

  void _publishNews() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);

    // Parse tags
    final tagsList = _tagsController.text
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList();

    // Create news object
    final news = News(
      id: '', // Will be set by API
      title: _titleController.text.trim(),
      slug: '', // Will be generated by API
      summary: _summaryController.text.trim(),
      content: _contentController.text.trim(),
      featuredImageUrl: _featuredImageUrlController.text.trim(),
      authorId: authProvider.user!.id,
      category: _categoryController.text.trim(),
      tags: tagsList,
      isPublished: true, // Always true as per requirement
      viewCount: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final success = await newsProvider.createNews(news, authProvider.token!);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('News published successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Auto kembali ke author page
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to publish news: ${newsProvider.error}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}