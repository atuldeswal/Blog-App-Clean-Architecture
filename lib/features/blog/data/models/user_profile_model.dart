import 'package:blog_app/core/common/entities/user.dart';

class UserProfileModel extends User {
  UserProfileModel({
    required super.id,
    required super.email,
    required super.name,
    required super.profileImage,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> map) {
    return UserProfileModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      profileImage: map['profile_image'] ?? '',
    );
  }

  @override
  UserProfileModel copyWith({
    String? id,
    String? email,
    String? name,
    String? profileImage,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}
