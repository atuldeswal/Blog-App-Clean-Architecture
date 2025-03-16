import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class UnfollowUser implements UseCase<void, UnfollowUserParams> {
  final BlogRepository blogRepository;

  UnfollowUser(this.blogRepository);

  @override
  Future<Either<Failure, void>> call(UnfollowUserParams params) async {
    return await blogRepository.unfollowUser(followingId: params.followingId);
  }
}

class UnfollowUserParams {
  final String followingId;

  UnfollowUserParams(this.followingId);
}
