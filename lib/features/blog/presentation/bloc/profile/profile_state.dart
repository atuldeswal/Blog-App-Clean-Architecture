part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileDisplaySuccess extends ProfileState {
  final User user;
  final List<Blog> blogs;
  final FollowCount followCount;
  ProfileDisplaySuccess({
    required this.user,
    required this.blogs,
    required this.followCount,
  });
}

final class ProfileFailure extends ProfileState {
  final String error;
  ProfileFailure(this.error);
}

final class ProfileLoading extends ProfileState {}

final class ProfileLogoutSuccess extends ProfileState {}

final class ProfileDeleteUserAccountSuccess extends ProfileState {}

final class ProfileUpdateSuccess extends ProfileState {}

final class ProfileUserProfileSuccess extends ProfileState {
  final User user;
  ProfileUserProfileSuccess(this.user);
}

final class ProfileFollowSuccess extends ProfileState {}

final class ProfileUnfollowSuccess extends ProfileState {}

final class ProfileIsFollowingFetched extends ProfileState {
  final bool isFollowing;
  ProfileIsFollowingFetched({required this.isFollowing});
}
