import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class ToggleFavorite implements UseCase<void, ToggleFavoriteParams> {
  final BlogRepository blogRepository;

  ToggleFavorite(this.blogRepository);
  @override
  Future<Either<Failure, void>> call(ToggleFavoriteParams params) async {
    return await blogRepository.toggleFavorite(
      blogId: params.blogId,
      isFavorite: params.isFavorite,
    );
  }
}

class ToggleFavoriteParams {
  final String blogId;
  final bool isFavorite;

  ToggleFavoriteParams({required this.blogId, required this.isFavorite});
}
