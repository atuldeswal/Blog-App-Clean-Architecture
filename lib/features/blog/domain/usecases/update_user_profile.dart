import 'dart:io';

import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateUserProfile implements UseCase<void, UpdateUserProfileParama> {
  BlogRepository repository;

  UpdateUserProfile(this.repository);
  @override
  Future<Either<Failure, void>> call(UpdateUserProfileParama params) {
    return repository.updateUserProfile(
      user: params.user,
      profileImage: params.profileImage,
    );
  }
}

class UpdateUserProfileParama {
  final User user;
  final File? profileImage;

  const UpdateUserProfileParama({required this.user, this.profileImage});
}
