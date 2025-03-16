import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetUserProfile implements UseCase<User, NoParams>{
  final BlogRepository repository;

  GetUserProfile(this.repository);
  
  @override
  Future<Either<Failure, User>> call(NoParams params) {
    return repository.getUserProfile();
  }
}