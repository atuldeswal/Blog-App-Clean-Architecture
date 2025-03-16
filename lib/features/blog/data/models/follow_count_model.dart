import 'package:blog_app/features/blog/domain/entities/follow_count.dart';

class FollowCountModel extends FollowCount {
  FollowCountModel({required super.followers, required super.following});

  factory FollowCountModel.fromMap(Map<String, dynamic> map) {
    return FollowCountModel(
      followers: map['followers'] ?? 0,
      following: map['following'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'followers': followers,
      'following': following,
    };
  }
}
