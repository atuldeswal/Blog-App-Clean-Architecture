import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/usecases/get_next_blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_navigation_state.dart';

class BlogNavigationCubit extends Cubit<BlogNavigationState> {
  final GetNextBlog getNextBlog;
  BlogNavigationCubit({required this.getNextBlog}) : super(BlogNavigationInitial());

  Future<void> navigateToNextBlog(String currentBlogId) async {
    emit(BlogNavigationLoading());

    final result = await getNextBlog(currentBlogId);

    result.fold(
      (failure) => emit(BlogNavigationFailure(message: failure.message)),
      (nextBlog) => emit(BlogNavigationSuccess(nextBlog: nextBlog)),
    );
  }
}
