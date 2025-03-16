import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class IsFollowing implements UseCase<bool, IsFollowingParams> {
  final BlogRepository blogRepository;

  IsFollowing(this.blogRepository);

  @override
  Future<Either<Failure, bool>> call(IsFollowingParams params) async {
    return await blogRepository.isFollowing(
      followerId: params.followerId,
      followingId: params.followingId,
    );
  }
}

class IsFollowingParams {
  final String followerId;
  final String followingId;

  IsFollowingParams({
    required this.followerId,
    required this.followingId,
  });
}
