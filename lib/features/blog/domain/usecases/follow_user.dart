import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class FollowUser implements UseCase<void, FollowUserParams>{
  BlogRepository blogRepository;
  FollowUser(this.blogRepository);

  @override
  Future<Either<Failure, void>> call(FollowUserParams params) async {
    return await blogRepository.followUser(followingId: params.follwoingId);
  }
}

class FollowUserParams {
  final String follwoingId;

  FollowUserParams(this.follwoingId);
}