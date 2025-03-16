import 'dart:io';

import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/entities/follow_count.dart';
import 'package:blog_app/features/blog/domain/usecases/delete_user_account.dart';
import 'package:blog_app/features/blog/domain/usecases/follow_user.dart';
import 'package:blog_app/features/blog/domain/usecases/ger_user_profile.dart';
import 'package:blog_app/features/blog/domain/usecases/get_follow_count.dart';
import 'package:blog_app/features/blog/domain/usecases/get_user_blogs.dart';
import 'package:blog_app/features/blog/domain/usecases/is_following.dart';
import 'package:blog_app/features/blog/domain/usecases/logout_user.dart';
import 'package:blog_app/features/blog/domain/usecases/unfollow_user.dart';
import 'package:blog_app/features/blog/domain/usecases/update_user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfile _getUserProfile;
  final GetUserBlogs _getUserBlogs;
  final LogoutUser _logoutUser;
  final DeleteUserAccount _deleteUserAccount;
  final UpdateUserProfile _updateUserProfile;
  final FollowUser _followUser;
  final UnfollowUser _unfollowUser;
  final IsFollowing _isFollowing;
  final GetFollowCount _getFollowCount;
  ProfileBloc({
    required GetUserProfile getUserProfile,
    required GetUserBlogs getUserBlogs,
    required LogoutUser logoutUser,
    required DeleteUserAccount deleteUserAccound,
    required UpdateUserProfile updateUserProfile,
    required FollowUser followUser,
    required UnfollowUser unfollowUser,
    required IsFollowing isFollowing,
    required GetFollowCount getFollowCount,
  }) : _getUserProfile = getUserProfile,
       _getUserBlogs = getUserBlogs,
       _logoutUser = logoutUser,
       _deleteUserAccount = deleteUserAccound,
       _updateUserProfile = updateUserProfile,
       _followUser = followUser,
       _unfollowUser = unfollowUser,
       _isFollowing = isFollowing,
       _getFollowCount = getFollowCount,
       super(ProfileInitial()) {
    on<ProfileEvent>((event, emit) => emit(ProfileLoading()));
    on<ProfileFetchUserProfile>(_onFetchUserProfile);
    on<ProfileFetchUserBlogs>(_onFetchUserBlogs);
    on<ProfileLogOut>(_onProfileLogOut);
    on<ProfileDeleteUserAccount>(_onProfileDeleteUserAccount);
    on<ProfileUpdateUserProfile>(_onUpdateUserProfile);
    on<ProfileFollowUser>(_onFollowUser);
    on<ProfileUnfollowUser>(_onUnfollowUser);
    on<ProfileCheckFollowing>(_onCheckFollowing);
  }

  void _onFetchUserProfile(
    ProfileFetchUserProfile event,
    Emitter<ProfileState> emit,
  ) async {
    final userRes = await _getUserProfile(NoParams());

    userRes.fold(
      (failure) => emit(ProfileFailure(failure.message)),
      (user) => emit(ProfileUserProfileSuccess(user)),
    );
  }

  void _onFetchUserBlogs(
    ProfileFetchUserBlogs event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    // Fetch user profile
    final userRes = await _getUserProfile(NoParams());
    final user = userRes.fold(
      (failure) => throw Exception("User not found"),
      (user) => user,
    );

    // Fetch user blogs
    final blogRes = await _getUserBlogs(NoParams());
    final blogs = blogRes.fold(
      (failure) => <Blog>[], // Explicitly define the empty list as List<Blog>
      (blogs) => blogs,
    );

    // Fetch follow count
    final followCountRes = await _getFollowCount(
      GetFollowCountParams(userId: user.id),
    );
    final followCount = followCountRes.fold(
      (failure) => FollowCount(followers: 0, following: 0),
      (count) => count,
    );

    // Emit success state
    emit(
      ProfileDisplaySuccess(user: user, blogs: blogs, followCount: followCount),
    );
  }

  void _onProfileLogOut(ProfileLogOut event, Emitter<ProfileState> emit) async {
    final res = await _logoutUser(NoParams());

    res.fold(
      (l) => emit(ProfileFailure(l.message)),
      (r) => emit(ProfileLogoutSuccess()),
    );
  }

  void _onProfileDeleteUserAccount(
    ProfileDeleteUserAccount event,
    Emitter<ProfileState> emit,
  ) async {
    final res = await _deleteUserAccount(NoParams());

    res.fold(
      (l) => emit(ProfileFailure(l.message)),
      (r) => emit(ProfileDeleteUserAccountSuccess()),
    );
  }

  void _onUpdateUserProfile(
    ProfileUpdateUserProfile event,
    Emitter<ProfileState> emit,
  ) async {
    final res = await _updateUserProfile(
      UpdateUserProfileParama(
        user: event.user,
        profileImage: event.profileImage,
      ),
    );

    res.fold(
      (l) => emit(ProfileFailure(l.message)),
      (r) => emit(ProfileUpdateSuccess()),
    );
  }

  void _onFollowUser(
    ProfileFollowUser event,
    Emitter<ProfileState> emit,
  ) async {
    final res = await _followUser(FollowUserParams(event.followingId));

    res.fold(
      (failure) => emit(ProfileFailure(failure.message)),
      (success) => emit(ProfileFollowSuccess()),
    );
  }

  void _onUnfollowUser(
    ProfileUnfollowUser event,
    Emitter<ProfileState> emit,
  ) async {
    final res = await _unfollowUser(UnfollowUserParams(event.followingId));

    res.fold(
      (failure) => emit(ProfileFailure(failure.message)),
      (success) => emit(ProfileUnfollowSuccess()),
    );
  }

  void _onCheckFollowing(
    ProfileCheckFollowing event,
    Emitter<ProfileState> emit,
  ) async {
    final res = await _isFollowing(
      IsFollowingParams(
        followerId: event.followerId,
        followingId: event.followingId,
      ),
    );

    res.fold(
      (failure) => emit(ProfileFailure(failure.message)),
      (isFollowing) =>
          emit(ProfileIsFollowingFetched(isFollowing: isFollowing)),
    );
  }
}
