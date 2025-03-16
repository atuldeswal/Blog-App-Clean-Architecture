part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

final class ProfileFetchUserProfile extends ProfileEvent {}

final class ProfileFetchUserBlogs extends ProfileEvent {}

final class ProfileLogOut extends ProfileEvent {}

final class ProfileDeleteUserAccount extends ProfileEvent {}

final class ProfileUpdateUserProfile extends ProfileEvent {
  final User user;
  final File? profileImage;

  ProfileUpdateUserProfile({required this.user, this.profileImage});
}

final class ProfileFollowUser extends ProfileEvent {
  final String followingId;

  ProfileFollowUser({required this.followingId});
}

final class ProfileUnfollowUser extends ProfileEvent {
  final String followingId;

  ProfileUnfollowUser({required this.followingId});
}

final class ProfileCheckFollowing extends ProfileEvent {
  final String followerId;
  final String followingId;

  ProfileCheckFollowing({required this.followerId, required this.followingId});
}
