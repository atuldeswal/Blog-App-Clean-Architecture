// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  final String id;
  final String email;
  final String name;
  final String profileImage;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.profileImage,
  });

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? profileImage,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}
