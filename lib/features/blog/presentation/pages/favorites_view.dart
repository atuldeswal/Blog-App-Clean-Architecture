part of 'blog_page.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(BlogFetchFavorites());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BlogBloc, BlogState>(
      listener: (context, state) {
        if (state is BlogFailure) {
          showSnackBar(context, state.error);
        }
      },
      builder: (context, state) {
        if (state is BlogLoading) {
          return const Center(child: Loader());
        }
        if (state is BlogFavoritesDisplaySuccess) {
          if (state.favoriteBlogs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 72,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No favorite blogs yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Like some blogs to see them here',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            itemCount: state.favoriteBlogs.length,
            itemBuilder: (context, index) {
              final blog = state.favoriteBlogs[index];
              // final isFavorite = state.favoriteBlogIds.contains(blog.id);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: BlogCard(
                  blog: blog,
                  color:
                      index % 2 == 0
                          ? AppPalette.gradient1
                          : AppPalette.gradient2,
                  // isFavoritesView: true,
                ),
              );
            },
          );
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.favorite_border,
                size: 72,
                color: Colors.grey.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              const Text(
                'No favorite blogs yet',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Like some blogs to see them here',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        );
      },
    );
  }
}
