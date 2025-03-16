import 'package:blog_app/core/theme/app_palette.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_update_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopupMenuBlogButton extends StatelessWidget {
  final Blog blog;
  const PopupMenuBlogButton({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert_outlined),
      itemBuilder:
          (context) => [
            PopupMenuItem(
              value: "Edit",
              child: Row(
                children: [
                  Icon(Icons.edit, color: Colors.white),
                  SizedBox(width: 8),
                  Text("Edit", style: TextStyle(color: Colors.white)),
                ],
              ),
              onTap: () => Navigator.push(context, BlogUpdatePage.route(blog)),
            ),
            PopupMenuItem(
              value: "Delete",
              child: Row(
                children: [
                  Icon(Icons.delete, color: AppPalette.errorColor),
                  SizedBox(width: 8),
                  Text("Delete", style: TextStyle(color: Colors.white)),
                ],
              ),
              onTap: () => _confirmDelete(context, blog.id),
            ),
          ],
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
