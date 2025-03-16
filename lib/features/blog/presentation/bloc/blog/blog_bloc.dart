import 'dart:io';

import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/usecases/delete_blog.dart';
import 'package:blog_app/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog_app/features/blog/domain/usecases/get_favorite_blogs.dart';
import 'package:blog_app/features/blog/domain/usecases/toggle_favorite.dart';
import 'package:blog_app/features/blog/domain/usecases/update_blog.dart';
import 'package:blog_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:blog_app/features/blog/presentation/bloc/profile/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;
  final DeleteBlog _deleteBlog;
  final UpdateBlog _updateBlog;
  final ToggleFavorite _toggleFavorite;
  final GetFavoriteBlogs _getFavoriteBlogs;
  BlogBloc({
    required UploadBlog uploadBlog,
    required GetAllBlogs getAllBlogs,
    required DeleteBlog deleteBlog,
    required UpdateBlog updateBlog,
    required ToggleFavorite toggleFavorite,
    required GetFavoriteBlogs getFavoriteBlogs,
  }) : _uploadBlog = uploadBlog,
       _getAllBlogs = getAllBlogs,
       _deleteBlog = deleteBlog,
       _updateBlog = updateBlog,
       _toggleFavorite = toggleFavorite,
       _getFavoriteBlogs = getFavoriteBlogs,
       super(BlogInitial()) {
    // Remove this line as it's causing all events to immediately emit Loading state
    // on<BlogEvent>((event, emit) => emit(BlogLoading()));

    on<BlogUpload>(_onBlogUpload);
    on<BlogFetchAllBlogs>(_onFetchAllBlogs);
    on<BlogDelete>(_onDeleteBlog);
    on<BlogUpdate>(_onBlogUpdate);
    on<BlogToggleFavorite>(_onToggleFavorite);
    on<BlogFetchFavorites>(_onFetchFavoriteBlogs);
  }

  void _onBlogUpload(BlogUpload event, Emitter<BlogState> emit) async {
    emit(BlogLoading()); // Add loading state here instead
    final res = await _uploadBlog(
      UploadBlogParams(
        posterId: event.posterId,
        title: event.title,
        content: event.content,
        image: event.image,
        topics: event.topics,
      ),
    );

    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogUploadSuccess()),
    );
  }

  void _onFetchAllBlogs(
    BlogFetchAllBlogs event,
    Emitter<BlogState> emit,
  ) async {
  emit(BlogLoading());

  final allBlogsRes = await _getAllBlogs(NoParams());
  final favoriteBlogsRes = await _getFavoriteBlogs(NoParams());

  allBlogsRes.fold(
    (l) => emit(BlogFailure(l.message)),
    (allBlogs) {
      List<String> favoriteBlogIds = [];

      // Fetch favorite IDs from favoriteBlogsRes
      favoriteBlogsRes.fold(
        (l) => {}, 
        (favoriteBlogs) => favoriteBlogIds =
            favoriteBlogs.map((blog) => blog.id).toList(),
      );

      emit(BlogDisplaySuccess(allBlogs, favoriteBlogIds: favoriteBlogIds));
    },
  );
}

  void _onDeleteBlog(BlogDelete event, Emitter<BlogState> emit) async {
    emit(BlogLoading()); // Add loading state here instead
    final res = await _deleteBlog(BlogDeleteParams(event.blogId));

    res.fold((l) => emit(BlogFailure(l.message)), (r) {
      emit(BlogDeleteSuccess());
      add(BlogFetchAllBlogs());
      BlocProvider.of<ProfileBloc>(event.context).add(ProfileFetchUserBlogs());
    });
  }

  void _onBlogUpdate(BlogUpdate event, Emitter<BlogState> emit) async {
    emit(BlogLoading()); // Add loading state here instead
    final res = await _updateBlog(
      UpdateBlogParams(
        blogId: event.blogId,
        title: event.updatedTitle,
        content: event.updatedContent,
        topics: event.updatedTopics,
        image: event.updatedImage,
      ),
    );
    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogUpdateSuccess()),
    );
  }

  void _onToggleFavorite(
    BlogToggleFavorite event,
    Emitter<BlogState> emit,
  ) async {
    // Don't emit loading for toggle favorite - this allows the animation to work
    // and prevents unnecessary UI flicker
    final res = await _toggleFavorite(
      ToggleFavoriteParams(blogId: event.blogId, isFavorite: event.isFavorite),
    );

    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) {
        List<String> updatedFavoriteIds = [];

        if (state is BlogDisplaySuccess) {
          updatedFavoriteIds = List.from((state as BlogDisplaySuccess).favoriteBlogIds);
        } else if (state is BlogFavoritesDisplaySuccess) {
          updatedFavoriteIds = List.from((state as BlogFavoritesDisplaySuccess).favoriteBlogIds);
        }

        if (event.isFavorite) {
          if (!updatedFavoriteIds.contains(event.blogId)) {
            updatedFavoriteIds.add(event.blogId);
          }
        } else {
          updatedFavoriteIds.remove(event.blogId);
        }

        emit(BlogFavoriteToggleSuccess());

        if (state is BlogDisplaySuccess) {
          final blogs = (state as BlogDisplaySuccess).blogs;
          emit(BlogDisplaySuccess(blogs, favoriteBlogIds: updatedFavoriteIds));
        }

        add(BlogFetchAllBlogs());
        add(BlogFetchFavorites());
      },
    );
  }

  void _onFetchFavoriteBlogs(
    BlogFetchFavorites event,
    Emitter<BlogState> emit,
  ) async {
    emit(BlogLoading()); // Add loading state here instead
    final res = await _getFavoriteBlogs(NoParams());

    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) {
        final favorites = r;

        if (state is BlogDisplaySuccess) {
          final blogs = (state as BlogDisplaySuccess).blogs;
          final favoriteBlogIds = favorites.map((blog) => blog.id).toList();
          emit(BlogDisplaySuccess(blogs, favoriteBlogIds: favoriteBlogIds));
        }
        emit(BlogFavoritesDisplaySuccess(favorites));
      },
    );
  }
}
