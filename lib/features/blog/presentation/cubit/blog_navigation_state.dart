part of 'blog_navigation_cubit.dart';

@immutable
sealed class BlogNavigationState {}

final class BlogNavigationInitial extends BlogNavigationState {}

final class BlogNavigationLoading extends BlogNavigationState {}

final class BlogNavigationSuccess extends BlogNavigationState {
  final Blog nextBlog;

  BlogNavigationSuccess({required this.nextBlog});
}

class BlogNavigationFailure extends BlogNavigationState {
  final String message;

  BlogNavigationFailure({required this.message});
}
