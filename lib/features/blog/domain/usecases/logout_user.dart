import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class LogoutUser implements UseCase<void, NoParams>{
  final BlogRepository blogRepository;
  LogoutUser(this.blogRepository);
  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await blogRepository.logout();
  }
}