part of 'blog_bloc.dart';

@immutable
sealed class BlogEvent {}

final class BlogUpload extends BlogEvent {
  final String posterId;
  final String title;
  final String content;
  final File image;
  final List<String> topics;

  BlogUpload({
    required this.posterId,
    required this.title,
    required this.content,
    required this.image,
    required this.topics,
  });
}

final class BlogFetchAllBlogs extends BlogEvent {}

final class BlogDelete extends BlogEvent {
  final String blogId;
  final BuildContext context;

  BlogDelete({required this.blogId, required this.context});
}

final class BlogUpdate extends BlogEvent {
  final String blogId;
  final String updatedTitle;
  final String updatedContent;
  final List<String> updatedTopics;
  final File? updatedImage;

  BlogUpdate({
    required this.blogId,
    required this.updatedTitle,
    required this.updatedContent,
    required this.updatedTopics,
    this.updatedImage,
  });
}

final class BlogToggleFavorite extends BlogEvent {
  final String blogId;
  final bool isFavorite;

  BlogToggleFavorite({
    required this.blogId,
    required this.isFavorite,
  });
}

final class BlogFetchFavorites extends BlogEvent {}
