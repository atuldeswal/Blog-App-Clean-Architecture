import 'package:blog_app/features/blog/domain/entities/blog.dart';

class BlogModel extends Blog {
  BlogModel({
    required super.id,
    required super.posterId,
    required super.title,
    required super.content,
    required super.imageUrl,
    required super.topics,
    required super.updatedAt,
    bool? isFavorite,
    super.posterName,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'poster_id': posterId,
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'topics': topics,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory BlogModel.fromJson(Map<String, dynamic> map) {
    try {
      return BlogModel(
        id: map['id'] as String? ?? 'unknown_id',
        posterId: map['poster_id'] as String? ?? 'unknown_poster',
        title: map['title'] as String? ?? 'Untitled',
        content: map['content'] as String? ?? 'No content available',
        imageUrl: map['image_url'] as String? ?? '',
        topics: List<String>.from(map['topics'] ?? []),
        updatedAt:
            map['updated_at'] == null
                ? DateTime.now()
                : DateTime.parse(map['updated_at']),
        isFavorite: map['is_favorite'] ?? false,
        posterName: map['profiles']?['name'] as String?,
      );
    } catch (e) {
      throw FormatException('Error parsing BlogModel: $e');
    }
  }

  BlogModel copyWith({
    String? id,
    String? posterId,
    String? title,
    String? content,
    String? imageUrl,
    List<String>? topics,
    DateTime? updatedAt,
    String? posterName,
    bool? isFavorite,
  }) {
    return BlogModel(
      id: id ?? this.id,
      posterId: posterId ?? this.posterId,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      topics: topics ?? this.topics,
      updatedAt: updatedAt ?? this.updatedAt,
      posterName: posterName ?? this.posterName,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
