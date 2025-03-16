import 'dart:io';

import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:blog_app/features/blog/data/models/follow_count_model.dart';
import 'package:blog_app/features/blog/data/models/user_profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDataSource {
  Future<BlogModel> uploadBlog(BlogModel blog);
  Future<String> uploadBlogImage({
    required File image,
    required BlogModel blog,
  });
  Future<String> uploadProfileImage({
    required File profileImage,
    required UserProfileModel user,
  });
  Future<void> updateBlog({
    required String blogId,
    required String title,
    required String content,
    required List<String> topics,
    String? imageUrl,
  });
  Future<void> updateUserProfile({
    required UserProfileModel user,
    File? profileImageFile,
  });
  Future<String> updateBlogImage({required File image, required String blogId});
  Future<String> updateProfileImage({
    required File image,
    required String userId,
  });
  Future<List<BlogModel>> getAllBlogs();
  Future<List<BlogModel>> getUserBlogs();
  Future<void> deleteBlog(String blogId);
  Future<void> logout();
  Future<BlogModel> getNextBlog(String currentBlogId);
  Future<void> toggleFavorite(String blogId, bool isFavorite);
  Future<List<BlogModel>> getFavoriteBlogs();
  Future<List<String>> getFavoriteBlogIds();
  Future<void> deleteUserAccount();
  Future<UserProfileModel> getUserProfile();

  Future<void> followUser(String followingId);
  Future<void> unfollowUser(String followingId);
  Future<bool> isFollowing(String userId, String followingId);
  Future<FollowCountModel> getFollowCount(String userId);
}

class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final SupabaseClient supabaseClient;
  BlogRemoteDataSourceImpl(this.supabaseClient);
  @override
  Future<BlogModel> uploadBlog(BlogModel blog) async {
    try {
      final blogData =
          await supabaseClient.from('blogs').insert(blog.toJson()).select();

      return BlogModel.fromJson(blogData.first);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadBlogImage({
    required File image,
    required BlogModel blog,
  }) async {
    try {
      await supabaseClient.storage.from('blog_images').upload(blog.id, image);
      return supabaseClient.storage.from('blog_images').getPublicUrl(blog.id);
    } on StorageException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadProfileImage({
    required File profileImage,
    required UserProfileModel user,
  }) async {
    try {
      await supabaseClient.storage
          .from('profile-images')
          .upload(user.id, profileImage);
      return supabaseClient.storage
          .from('profile-images')
          .getPublicUrl(user.id);
    } on StorageException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BlogModel>> getAllBlogs() async {
    try {
      final blogs = await supabaseClient
          .from('blogs')
          .select('*, profiles (name)');
      return blogs
          .map(
            (blog) => BlogModel.fromJson(
              blog,
            ).copyWith(posterName: blog['profiles']['name']),
          )
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BlogModel>> getUserBlogs() async {
    try {
      final user = supabaseClient.auth.currentUser;

      if (user == null) {
        return [];
      }

      final res = await supabaseClient
          .from('blogs')
          .select('*')
          .eq('poster_id', user.id);

      return res.map((blog) => BlogModel.fromJson(blog)).toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await supabaseClient.auth.signOut();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteBlog(String blogId) async {
    try {
      final blog =
          await supabaseClient
              .from('blogs')
              .select('image_url')
              .eq('id', blogId)
              .single();
      final imageUrl = blog['image_url'].toString();
      final imagePath = imageUrl.split('/').last.toString();
      await supabaseClient.storage.from('blog_images').remove([imagePath]);
      await supabaseClient.from('blogs').delete().eq('id', blogId);
    } on StorageException catch (e) {
      throw ServerException(e.message);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateBlog({
    required String blogId,
    required String title,
    required String content,
    required List<String> topics,
    String? imageUrl,
  }) async {
    try {
      if (imageUrl != null) {
        await supabaseClient
            .from('blogs')
            .update({
              'title': title,
              'content': content,
              'image_url': imageUrl,
              'topics': topics,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('id', blogId);
      } else {
        await supabaseClient
            .from('blogs')
            .update({
              'title': title,
              'content': content,
              'topics': topics,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('id', blogId);
      }
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateUserProfile({
    required UserProfileModel user,
    File? profileImageFile,
  }) async {
    try {
      String? newProfileImageUrl;

      if (profileImageFile != null) {
        newProfileImageUrl = await updateProfileImage(
          image: profileImageFile,
          userId: user.id,
        );
      }

      await supabaseClient
          .from('profiles')
          .update({
            'name': user.name,
            if (newProfileImageUrl != null && newProfileImageUrl.isNotEmpty)
              'profile_image': newProfileImageUrl,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', user.id);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> updateBlogImage({
    required File image,
    required String blogId,
  }) async {
    try {
      final blog =
          await supabaseClient
              .from('blogs')
              .select('image_url')
              .eq('id', blogId)
              .single();
      final imageUrl = blog['image_url'].toString();
      final imagePath = imageUrl.split('/').last.toString();

      await supabaseClient.storage.from('blog_images').remove([imagePath]);

      await supabaseClient.storage.from('blog_images').upload(blogId, image);

      final newImageUrl = supabaseClient.storage
          .from('blog_images')
          .getPublicUrl(blogId);

      await supabaseClient
          .from('blogs')
          .update({'image_url': newImageUrl})
          .eq('id', blogId);

      return newImageUrl;
    } on StorageException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> updateProfileImage({
    required File image,
    required String userId,
  }) async {
    try {
      final user =
          await supabaseClient
              .from('profiles')
              .select('profile_image')
              .eq('id', userId)
              .single();

      final profileImageUrl = user['profile_image'].toString();

      if (profileImageUrl.isNotEmpty) {
        final profileImagePath = profileImageUrl.split('/').last.toString();
        await supabaseClient.storage.from('profile-images').remove([
          profileImagePath,
        ]);
      }

      await supabaseClient.storage.from('profile-images').upload(userId, image);

      final newProfileImageUrl = supabaseClient.storage
          .from('profile-images')
          .getPublicUrl(userId);

      await supabaseClient
          .from('profiles')
          .update({'profile_image': newProfileImageUrl})
          .eq('id', userId);

      return newProfileImageUrl;
    } on StorageException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<BlogModel> getNextBlog(String currentBlogId) async {
    try {
      final currentBlog =
          await supabaseClient
              .from('blogs')
              .select('updated_at')
              .eq('id', currentBlogId)
              .single();

      if (currentBlog['updated_at'] == null) {
        throw ServerException('Blog not found or missing updated_at field');
      }

      final updatedAt = currentBlog['updated_at'];

      final nextBlog =
          await supabaseClient
              .from('blogs')
              .select('*, profiles(name)')
              .gt('updated_at', updatedAt)
              .order('updated_at', ascending: true)
              .limit(1)
              .maybeSingle();

      if (nextBlog == null) {
        throw ServerException('No next blog found');
      }

      print('Next blog fetched: $nextBlog');

      return BlogModel.fromJson(nextBlog);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BlogModel>> getFavoriteBlogs() async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) {
        throw ServerException('User not Authernticated');
      }

      final favoriteBlogs = await supabaseClient
          .from('favorites')
          .select('blog_id')
          .eq('user_id', user.id);

      final blogIds =
          favoriteBlogs.map((favorite) => favorite['blog_id']).toList();

      if (blogIds.isEmpty) {
        return [];
      }

      final blogs = await supabaseClient
          .from('blogs')
          .select('*, profiles (name)')
          .filter('id', 'in', blogIds);

      return blogs
          .map(
            (blog) => BlogModel.fromJson(
              blog,
            ).copyWith(posterName: blog['profiles']['name'], isFavorite: true),
          )
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> toggleFavorite(String blogId, bool isFavorite) async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) throw ServerException('User not authenticated');

      if (isFavorite) {
        await supabaseClient.from('favorites').insert({
          'user_id': user.id,
          'blog_id': blogId,
        });
      } else {
        await supabaseClient
            .from('favorites')
            .delete()
            .eq('user_id', user.id)
            .eq('blog_id', blogId);
      }
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<String>> getFavoriteBlogIds() async {
    try {
      final userId = supabaseClient.auth.currentUser!.id;
      final res = await supabaseClient
          .from('favorites')
          .select('blog_id')
          .eq('user_id', userId);

      return (res as List).map((item) => item['blog_id'] as String).toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteUserAccount() async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) {
        throw ServerException('User not authenticated');
      }

      final userId = user.id;

      final blogs = await supabaseClient
          .from('blogs')
          .select('id, image_url')
          .eq('poster_id', userId);
      for (final blog in blogs) {
        final blogId = blog['id'];
        final imageUrl = blog['image_url']?.toString();

        if (imageUrl != null && imageUrl.isNotEmpty) {
          final imagePath = imageUrl.split('/').last;
          await supabaseClient.storage.from('blog_images').remove([imagePath]);
        }

        await supabaseClient.from('blogs').delete().eq('id', blogId);
      }

      await supabaseClient.from('favorites').delete().eq('user_id', userId);

      await supabaseClient.from('profiles').delete().eq('id', userId);

      return await supabaseClient.auth.admin.deleteUser(userId);
    } on StorageException catch (e) {
      throw ServerException('Storage error: ${e.message}');
    } on PostgrestException catch (e) {
      throw ServerException('Database error: ${e.message}');
    } on AuthException catch (e) {
      throw ServerException('Auth error: ${e.message}');
    } catch (e) {
      throw ServerException('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<UserProfileModel> getUserProfile() async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) {
        throw ServerException('No authenticated user found.');
      }

      final response =
          await supabaseClient
              .from('profiles')
              .select()
              .eq('id', user.id)
              .single();

      return UserProfileModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> followUser(String followingId) async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) throw ServerException('User not logged in');

    try {
      await supabaseClient.from('follows').insert({
        'follower_id': userId,
        'following_id': followingId,
      });
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<FollowCountModel> getFollowCount(String userId) async {
    try {
      final followers = await supabaseClient
          .from('follows')
          .select('id')
          .eq('following_id', userId);

      final following = await supabaseClient
          .from('follows')
          .select('id')
          .eq('follower_id', userId);

      return FollowCountModel(
        followers: followers.length,
        following: following.length,
      );
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> isFollowing(String userId, String followingId) async {
    try {
      final response =
          await supabaseClient
              .from('follows')
              .select()
              .eq('follower_id', userId)
              .eq('following_id', followingId)
              .maybeSingle();

      return response != null;
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> unfollowUser(String followingId) async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) throw ServerException('User not logged in');

    try {
      await supabaseClient.from('follows').delete().match({
        'follower_id': userId,
        'following_id': followingId,
      });
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
