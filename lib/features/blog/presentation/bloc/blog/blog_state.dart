part of 'blog_bloc.dart';

@immutable
sealed class BlogState {}

final class BlogInitial extends BlogState {}

final class BlogUploadSuccess extends BlogState {}

final class BlogUpdateSuccess extends BlogState {}

final class BlogDisplaySuccess extends BlogState {
  final List<Blog> blogs;
  final List<String> favoriteBlogIds;
  BlogDisplaySuccess(this.blogs, {this.favoriteBlogIds = const []});
}

final class BlogFavoritesDisplaySuccess extends BlogState {
  final List<Blog> favoriteBlogs;
  final List<String> favoriteBlogIds;
  BlogFavoritesDisplaySuccess(this.favoriteBlogs) : favoriteBlogIds = favoriteBlogs.map((blog) => blog.id).toList();
}

final class BlogFavoriteToggleSuccess extends BlogState {}

final class BlogFailure extends BlogState {
  final String error;
  BlogFailure(this.error);
}

final class BlogDeleteSuccess extends BlogState {}

final class BlogLoading extends BlogState {}
