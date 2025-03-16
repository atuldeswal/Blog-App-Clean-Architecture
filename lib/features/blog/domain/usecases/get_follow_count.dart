import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/follow_count.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetFollowCount implements UseCase<FollowCount, GetFollowCountParams> {
  final BlogRepository blogRepository;

  GetFollowCount(this.blogRepository);

  @override
  Future<Either<Failure, FollowCount>> call(GetFollowCountParams params) async {
    return await blogRepository.getFollowCount(userId: params.userId);
  }
}

class GetFollowCountParams {
  final String userId;
  GetFollowCountParams({required this.userId});
}
