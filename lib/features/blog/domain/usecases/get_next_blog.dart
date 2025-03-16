import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetNextBlog implements UseCase<Blog, String> {
  final BlogRepository blogRepository;
  GetNextBlog(this.blogRepository);

  @override
  Future<Either<Failure, Blog>> call(String currentBlogId) async {
    return await blogRepository.getNextBlog(currentBlogId);
  }
}
