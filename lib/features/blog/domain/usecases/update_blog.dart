import 'dart:io';

import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateBlog implements UseCase<void, UpdateBlogParams> {
  BlogRepository blogRepository;
  UpdateBlog(this.blogRepository);
  @override
  Future<Either<Failure, void>> call(UpdateBlogParams params) async {
    return await blogRepository.updateBlog(
      blogId: params.blogId,
      title: params.title,
      content: params.content,
      topics: params.topics,
      image: params.image,
    );
  }
}

class UpdateBlogParams {
  final String blogId;
  final String title;
  final String content;
  final List<String> topics;
  final File? image;

  UpdateBlogParams({
    required this.blogId,
    required this.title,
    required this.content,
    required this.topics,
    this.image,
  });
}
