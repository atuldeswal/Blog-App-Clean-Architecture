import 'dart:io';

import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/core/constants/constants.dart';
import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/network/connection_checker.dart';
// import 'package:blog_app/features/blog/data/datasources/blog_local_data_source.dart';
import 'package:blog_app/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:blog_app/features/blog/data/models/user_profile_model.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/entities/follow_count.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;
  // final BlogLocalDataSource blogLocalDataSource;
  final ConnectionChecker connectionChecker;
  BlogRepositoryImpl(
    this.blogRemoteDataSource,
    // this.blogLocalDataSource,
    this.connectionChecker,
  );

  @override
  Future<Either<Failure, User>> getUserProfile() async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }

      final userProfileModel = await blogRemoteDataSource.getUserProfile();
      return right(userProfileModel);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateBlog({
    required String blogId,
    required String title,
    required String content,
    required List<String> topics,
    File? image,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }

      if (image != null) {
        final imageUrl = await blogRemoteDataSource.updateBlogImage(
          image: image,
          blogId: blogId,
        );
        return right(
          await blogRemoteDataSource.updateBlog(
            blogId: blogId,
            title: title,
            content: content,
            topics: topics,
            imageUrl: imageUrl,
          ),
        );
      }

      return right(
        await blogRemoteDataSource.updateBlog(
          blogId: blogId,
          title: title,
          content: content,
          topics: topics,
        ),
      );
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }
      BlogModel blogModel = BlogModel(
        id: const Uuid().v1(),
        posterId: posterId,
        title: title,
        content: content,
        imageUrl: '',
        topics: topics,
        updatedAt: DateTime.now(),
        isFavorite: false,
      );

      final imageUrl = await blogRemoteDataSource.uploadBlogImage(
        image: image,
        blog: blogModel,
      );

      blogModel = blogModel.copyWith(imageUrl: imageUrl);

      final uploadedBlog = await blogRemoteDataSource.uploadBlog(blogModel);
      return right(uploadedBlog);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs() async {
    try {
      // if (!await (connectionChecker.isConnected)) {
      //   final blogs = blogLocalDataSource.loadBlogs();
      //   return right(blogs);
      // }
      final blogs = await blogRemoteDataSource.getAllBlogs();
      // blogLocalDataSource.uploadLocalBlogs(blogs: blogs);

      return right(blogs);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getUserBlogs() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }
      final userBlogs = await blogRemoteDataSource.getUserBlogs();

      return right(userBlogs);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      return right(blogRemoteDataSource.logout());
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBlog({required String blogId}) async {
    try {
      return right(blogRemoteDataSource.deleteBlog(blogId));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Blog>> getNextBlog(String currentBlogId) async {
    try {
      final blogModel = await blogRemoteDataSource.getNextBlog(currentBlogId);
      return right(blogModel);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getFavoriteBlogs() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }

      final favoriteBlogs = await blogRemoteDataSource.getFavoriteBlogs();
      return right(favoriteBlogs);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> toggleFavorite({
    required String blogId,
    required bool isFavorite,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }

      await blogRemoteDataSource.toggleFavorite(blogId, isFavorite);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getFavoriteBlogIds() async {
    try {
      final favoriteBlogIds = await blogRemoteDataSource.getFavoriteBlogIds();

      return right(favoriteBlogIds);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUserAccount() async {
    try {
      return right(blogRemoteDataSource.deleteUserAccount());
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserProfile({
    required User user,
    File? profileImage,
  }) async {
    try {
      final userProfileModel = UserProfileModel(
        id: user.id,
        email: user.email,
        name: user.name,
        profileImage: user.profileImage,
      );

      await blogRemoteDataSource.updateUserProfile(
        user: userProfileModel,
        profileImageFile: profileImage,
      );

      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> followUser({
    required String followingId,
  }) async {
    try {
      return right(blogRemoteDataSource.followUser(followingId));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, FollowCount>> getFollowCount({required String userId}) async {
  try {
    final followCount = await blogRemoteDataSource.getFollowCount(userId);
    return right(followCount);
  } on ServerException catch (e) {
    return left(Failure(e.message));
  }
}


  @override
  Future<Either<Failure, bool>> isFollowing({
    required String followerId,
    required String followingId,
  }) async {
    try {
      final isFollowing = await blogRemoteDataSource.isFollowing(followerId, followingId);

      return right(isFollowing);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> unfollowUser({
    required String followingId,
  }) async {
    try {
      return right(blogRemoteDataSource.unfollowUser(followingId));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
