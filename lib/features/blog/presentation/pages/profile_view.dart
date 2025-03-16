part of 'blog_page.dart';

class ProfileView extends StatelessWidget {
  static route() => MaterialPageRoute(builder: (context) => ProfileView());
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileFailure) {
          showSnackBar(context, state.error);
        }
      },
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Center(child: Loader());
        }

        if (state is ProfileDisplaySuccess) {
          final user = state.user;
          final userBlogs = state.blogs;
          final followerCount = state.followCount.followers;
          final followingCount = state.followCount.following;
          const defaultImageUrl = 'https://t3.ftcdn.net/jpg/02/43/12/34/360_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50.0, // Inner circle size
                        backgroundImage: NetworkImage(
                          user.profileImage.isNotEmpty ? user.profileImage : defaultImageUrl,
                        ),
                        backgroundColor: Colors.transparent,
                      ),

                      const SizedBox(height: 16),
                      Text(
                        user.name.isNotEmpty ? user.name : 'Unknown User',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildStatItem('${userBlogs.length}', 'Posts'),
                          Container(
                            height: 30,
                            width: 1,
                            color: Colors.grey[300],
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                          _buildStatItem(followerCount.toString(), 'Followers'),
                          Container(
                            height: 30,
                            width: 1,
                            color: Colors.grey[300],
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                          _buildStatItem(followingCount.toString(), 'Following'),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => Navigator.push(context, EditProfilePage.route(user)),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                          backgroundColor: AppPalette.gradient2,
                        ),
                        child: const Text(
                          'Edit Profile',
                          style: TextStyle(
                            color: AppPalette.whiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                const Text(
                  'My Posts',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // User's blog posts
                userBlogs.isEmpty
                    ? _buildNoPostsWidget()
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: userBlogs.length,
                        itemBuilder: (context, index) {
                          final blog = userBlogs[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: BlogCard(
                              blog: blog,
                              color: index % 2 == 0
                                  ? AppPalette.gradient1
                                  : AppPalette.gradient2,
                            ),
                          );
                        },
                      ),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildNoPostsWidget() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Icon(
            Icons.article_outlined,
            size: 60,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No posts yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
