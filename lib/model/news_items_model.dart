class NewsItem {
  final String id;
  final String title;
  final String slug;
  final String? summary;
  final String content;
  final String? featuredImageUrl;
  final String? category;
  final List<String>? tags;
  final DateTime publishedAt;
  final int viewCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String authorName;
  final String? authorBio;
  final String? authorAvatar;

  NewsItem({
    required this.id,
    required this.title,
    required this.slug,
    this.summary,
    required this.content,
    this.featuredImageUrl,
    this.category,
    this.tags,
    required this.publishedAt,
    required this.viewCount,
    required this.createdAt,
    required this.updatedAt,
    required this.authorName,
    this.authorBio,
    this.authorAvatar,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      id: json['id'],
      title: json['title'],
      slug: json['slug'],
      summary: json['summary'],
      content: json['content'],
      featuredImageUrl: json['featured_image_url'],
      category: json['category'],
      tags: List<String>.from(json['tags']),
      publishedAt: DateTime.parse(json['published_at']),
      viewCount: json['view_count'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      authorName: json['author_name'],
      authorBio: json['author_bio'],
      authorAvatar: json['author_avatar'],
    );
  }
}
