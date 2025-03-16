import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeleteUserAccount implements UseCase<void, NoParams>{
  BlogRepository blogRepository;
  DeleteUserAccount(this.blogRepository);
  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await blogRepository.deleteUserAccount();
  }
}