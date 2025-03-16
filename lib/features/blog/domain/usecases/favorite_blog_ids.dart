import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class FavoriteBlogIds implements UseCase {
  BlogRepository blogRepository;

  FavoriteBlogIds(this.blogRepository);
  @override
  Future<Either<Failure, dynamic>> call(params) async {
    return await blogRepository.getFavoriteBlogIds();
  }
}