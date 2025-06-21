class News {
  final String id;
  final String title;
  final String slug;
  final String? summary;
  final String content;
  final String? featuredImageUrl;
  final String authorId;
  final String? category;
  final List<String>? tags;
  final bool isPublished;
  final DateTime? publishedAt;
  final int viewCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? authorName; // Only available in public API
  final String? authorBio;  // Only available in public API
  final String? authorAvatar; // Only available in public API

  News({
    required this.id,
    required this.title,
    required this.slug,
    this.summary,
    required this.content,
    this.featuredImageUrl,
    required this.authorId,
    this.category,
    this.tags,
    required this.isPublished,
    this.publishedAt,
    required this.viewCount,
    required this.createdAt,
    required this.updatedAt,
    this.authorName,
    this.authorBio,
    this.authorAvatar,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'],
      title: json['title'],
      slug: json['slug'],
      summary: json['summary'],
      content: json['content'],
      featuredImageUrl: json['featured_image_url'],
      authorId: json['author_id'],
      category: json['category'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      isPublished: json['is_published'],
      publishedAt: json['published_at'] != null 
          ? DateTime.parse(json['published_at']) 
          : null,
      viewCount: json['view_count'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      authorName: json['author_name'],
      authorBio: json['author_bio'],
      authorAvatar: json['author_avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'summary': summary,
      'content': content,
      'featured_image_url': featuredImageUrl,
      'author_id': authorId,
      'category': category,
      'tags': tags,
      'is_published': isPublished,
      'published_at': publishedAt?.toIso8601String(),
      'view_count': viewCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // For creating/updating news
  Map<String, dynamic> toCreateJson() {
    return {
      'title': title,
      'summary': summary,
      'content': content,
      'featured_image_url': featuredImageUrl,
      'category': category,
      'tags': tags,
      'is_published': isPublished,
    };
  }

  News copyWith({
    String? id,
    String? title,
    String? slug,
    String? summary,
    String? content,
    String? featuredImageUrl,
    String? authorId,
    String? category,
    List<String>? tags,
    bool? isPublished,
    DateTime? publishedAt,
    int? viewCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? authorName,
    String? authorBio,
    String? authorAvatar,
  }) {
    return News(
      id: id ?? this.id,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      summary: summary ?? this.summary,
      content: content ?? this.content,
      featuredImageUrl: featuredImageUrl ?? this.featuredImageUrl,
      authorId: authorId ?? this.authorId,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      isPublished: isPublished ?? this.isPublished,
      publishedAt: publishedAt ?? this.publishedAt,
      viewCount: viewCount ?? this.viewCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      authorName: authorName ?? this.authorName,
      authorBio: authorBio ?? this.authorBio,
      authorAvatar: authorAvatar ?? this.authorAvatar,
    );
  }
}