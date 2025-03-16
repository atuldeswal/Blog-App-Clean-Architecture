import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/theme/app_palette.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/bloc/profile/profile_bloc.dart';
import 'package:blog_app/features/blog/presentation/cubit/blog_navigation_cubit.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_update_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_content.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_transition_animation.dart';
import 'package:blog_app/features/blog/presentation/widgets/floating_button.dart';
import 'package:blog_app/features/blog/presentation/widgets/follow_button.dart';
import 'package:blog_app/features/blog/presentation/widgets/swipe_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogViewerPage extends StatefulWidget {
  static Route route(Blog blog) =>
      MaterialPageRoute(builder: (context) => BlogViewerPage(blog: blog));
  final Blog blog;
  const BlogViewerPage({super.key, required this.blog});

  @override
  State<BlogViewerPage> createState() => _BlogViewerPageState();
}

class _BlogViewerPageState extends State<BlogViewerPage>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  bool _isAtTop = true;
  bool _isAtBottom = false;
  bool _isTransitioning = false;
  TransitionDirection _transitionDirection = TransitionDirection.up;

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _initializeAnimations();
    _setupScrollListeners();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkFollowStatus();
    });
  }

  void _checkFollowStatus() {
    final userState = context.read<AppUserCubit>().state;
    if (userState is AppUserLoggedIn &&
        userState.user.id != widget.blog.posterId) {
      context.read<ProfileBloc>().add(
        ProfileCheckFollowing(
          followerId: userState.user.id,
          followingId: widget.blog.posterId,
        ),
      );
    }
  }

  void _refreshFollowStatus() {
    final userState = context.read<AppUserCubit>().state;
    if (userState is AppUserLoggedIn &&
        userState.user.id != widget.blog.posterId) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          context.read<ProfileBloc>().add(
            ProfileCheckFollowing(
              followerId: userState.user.id,
              followingId: widget.blog.posterId,
            ),
          );
        }
      });
    }
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (_transitionDirection == TransitionDirection.down) {
          _navigateToHomePage();
        } else {
          _navigateToNextPage();
        }
      }
    });

    final userState = context.read<AppUserCubit>().state;
    if (userState is AppUserLoggedIn &&
        userState.user.id != widget.blog.posterId) {
      context.read<ProfileBloc>().add(
        ProfileCheckFollowing(
          followerId: userState.user.id,
          followingId: widget.blog.posterId,
        ),
      );
    }
  }

  void _setupScrollListeners() {
    _scrollController.addListener(_scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkIfScrollable();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _checkIfScrollable() {
    if (_scrollController.position.maxScrollExtent == 0) {
      setState(() {
        _isAtBottom = true;
      });
    }
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _isAtBottom = true;
        _isAtTop = false;
      });
    } else if (_scrollController.offset <= 0) {
      setState(() {
        _isAtTop = true;
        _isAtBottom = false;
      });
    } else {
      setState(() {
        _isAtBottom = false;
        _isAtTop = false;
      });
    }
  }

  void _handleVerticalSwipe(DragUpdateDetails details) {
    if (_isAtBottom && details.delta.dy < -15 && !_isTransitioning) {
      _startTransitionAnimation(direction: TransitionDirection.up);
    }

    if (_isAtTop && details.delta.dy > 15 && !_isTransitioning) {
      _startTransitionAnimation(direction: TransitionDirection.down);
    }
  }

  void _handleVerticalSwipeEnd(DragEndDetails details) {
    if (_isAtBottom &&
        details.velocity.pixelsPerSecond.dy < -200 &&
        !_isTransitioning) {
      _startTransitionAnimation(direction: TransitionDirection.up);
    }

    if (_isAtTop &&
        details.velocity.pixelsPerSecond.dy > 200 &&
        !_isTransitioning) {
      _startTransitionAnimation(direction: TransitionDirection.down);
    }
  }

  void _navigateToHomePage() {
    // showSnackBar(context, 'Returning to Home Page');
    Navigator.of(
      context,
    ).pushAndRemoveUntil(BlogPage.route(), (Route<dynamic> route) => false);

    _animationController.reset();
    setState(() {
      _isTransitioning = false;
    });
  }

  void _startTransitionAnimation({required TransitionDirection direction}) {
    setState(() {
      _isTransitioning = true;
      _transitionDirection = direction;
    });

    if (direction == TransitionDirection.up) {
      context.read<BlogNavigationCubit>().navigateToNextBlog(widget.blog.id);
    }

    _animationController.forward();
  }

  void _navigateToNextPage() {
    final state = context.read<BlogNavigationCubit>().state;

    if (state is BlogNavigationSuccess) {
      Navigator.of(context).push(BlogViewerPage.route(state.nextBlog));
    } else if (state is BlogNavigationFailure) {
      showSnackBar(context, 'No new blogs! Returning to Home Page');
      Navigator.of(
        context,
      ).pushAndRemoveUntil(BlogPage.route(), (Route<dynamic> route) => false);
    }

    _animationController.reset();
    setState(() {
      _isTransitioning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userState = context.watch<AppUserCubit>().state;
    final String? currentUserId =
        userState is AppUserLoggedIn ? userState.user.id : null;

    return BlogTransitionAnimation(
      animation: _animation,
      direction: _transitionDirection,
      child: GestureDetector(
        onVerticalDragUpdate: _handleVerticalSwipe,
        onVerticalDragEnd: _handleVerticalSwipeEnd,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              if (widget.blog.posterId == currentUserId)
                IconButton(
                  icon: Icon(Icons.delete, color: AppPalette.errorColor),
                  onPressed: () => _confirmDelete(context, widget.blog.id),
                ),
            ],
          ),
          body: Stack(
            children: [
              BlogContent(
                blog: widget.blog,
                scrollController: _scrollController,
              ),
              if (_isAtBottom && !_isTransitioning)
                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: SwipeIndicator(),
                ),

              if (_isAtTop && !_isTransitioning)
                Positioned(
                  top: -8,
                  left: 0,
                  right: 0,
                  child: SwipeIndicator(direction: SwipeDirection.down),
                ),
              BlocListener<BlogNavigationCubit, BlogNavigationState>(
                listener: (context, state) {
                  if (state is BlogNavigationFailure) {
                    showSnackBar(context, 'No new blogs!');

                    _animationController.reverse();
                    setState(() {
                      _isTransitioning = false;
                    });
                  }
                },
                child: Container(),
              ),
              if (widget.blog.posterId == currentUserId)
                Positioned(
                  right: 20,
                  bottom: 70,
                  child: FloatingButton(
                    icon: Icons.edit,
                    onPressed:
                        () => Navigator.push(
                          context,
                          BlogUpdatePage.route(widget.blog),
                        ),
                  ),
                ),
              BlocConsumer<ProfileBloc, ProfileState>(
                listenWhen:
                    (previous, current) =>
                        current is ProfileFollowSuccess ||
                        current is ProfileUnfollowSuccess ||
                        current is ProfileFailure,
                listener: (context, state) {
                  if (state is ProfileFailure) {
                    showSnackBar(context, state.error);
                  }
                },
                builder: (context, profileState) {
                  // Only show follow button if the current user is not the blog poster
                  final bool isCurrentUserTheAuthor =
                      widget.blog.posterId == currentUserId;
                  if (isCurrentUserTheAuthor || currentUserId == null) {
                    return const SizedBox();
                  }

                  // Determine follow status based on state
                  bool isFollowing = false;
                  if (profileState is ProfileIsFollowingFetched) {
                    isFollowing = profileState.isFollowing;
                  } else if (profileState is ProfileFollowSuccess) {
                    isFollowing = true;
                  } else if (profileState is ProfileUnfollowSuccess) {
                    isFollowing = false;
                  }

                  return Positioned(
                    top: 75,
                    right: 20,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (
                        Widget child,
                        Animation<double> animation,
                      ) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: FollowButton(
                        key: ValueKey<bool>(
                          isFollowing,
                        ), // Key helps AnimatedSwitcher identify this as a different widget
                        backgroundColor:
                            isFollowing ? Colors.grey : AppPalette.primary,
                        icon:
                            isFollowing
                                ? Icons.person_remove
                                : Icons.person_add,
                        label: isFollowing ? 'Unfollow' : 'Follow',
                        onPressed: () {
                          if (isFollowing) {
                            context.read<ProfileBloc>().add(
                              ProfileUnfollowUser(
                                followingId: widget.blog.posterId,
                              ),
                            );
                            context.read<ProfileBloc>().add(
                              ProfileFetchUserBlogs(),
                            );
                          } else {
                            context.read<ProfileBloc>().add(
                              ProfileFollowUser(
                                followingId: widget.blog.posterId,
                              ),
                            );
                            context.read<ProfileBloc>().add(
                              ProfileFetchUserBlogs(),
                            );
                          }

                          _refreshFollowStatus();

                          // Check following status after action
                          context.read<ProfileBloc>().add(
                            ProfileCheckFollowing(
                              followerId: currentUserId,
                              followingId: widget.blog.posterId,
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String blogId) {
    showDialog(
      context: context,
      builder:
          (context) => BlocListener<BlogBloc, BlogState>(
            listener: (context, state) {
              if (state is BlogDeleteSuccess) {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to home
              } else if (state is BlogFailure) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
            child: AlertDialog(
              title: const Text("Delete Blog"),
              content: const Text("Are you sure you want to delete this blog?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    context.read<BlogBloc>().add(
                      BlogDelete(blogId: blogId, context: context),
                    );
                  },
                  child: const Text(
                    "Delete",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
