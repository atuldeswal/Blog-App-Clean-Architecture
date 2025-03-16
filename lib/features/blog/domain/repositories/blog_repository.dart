import 'dart:io';

import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/entities/follow_count.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class BlogRepository {
  Future<Either<Failure, User>> getUserProfile();

  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  });

  Future<Either<Failure, List<Blog>>> getAllBlogs();

  Future<Either<Failure, List<Blog>>> getUserBlogs();

  Future<Either<Failure, void>> deleteBlog({required String blogId});

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, void>> updateBlog({
    required String blogId,
    required String title,
    required String content,
    required List<String> topics,
    File? image,
  });

  Future<Either<Failure, void>> updateUserProfile({
    required User user,
    File? profileImage,
  });

  Future<Either<Failure, Blog>> getNextBlog(String currentBlogId);

  Future<Either<Failure, List<Blog>>> getFavoriteBlogs();

  Future<Either<Failure, void>> toggleFavorite({
    required String blogId,
    required bool isFavorite,
  });

  Future<Either<Failure, List<String>>> getFavoriteBlogIds();

  Future<Either<Failure, void>> deleteUserAccount();

  Future<Either<Failure, void>> followUser({
    required String followingId,
  });

  Future<Either<Failure, void>> unfollowUser({
    required String followingId,
  });

  Future<Either<Failure, bool>> isFollowing({
    required String followerId,
    required String followingId,
  });

  Future<Either<Failure, FollowCount>> getFollowCount({required String userId});
}
