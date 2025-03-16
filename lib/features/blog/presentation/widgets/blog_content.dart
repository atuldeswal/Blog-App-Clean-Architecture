import 'package:blog_app/core/theme/app_palette.dart';
import 'package:blog_app/core/utils/calculate_reading_time.dart';
import 'package:blog_app/core/utils/format_date.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:flutter/material.dart';

class BlogContent extends StatelessWidget {
  final Blog blog;
  final ScrollController scrollController;
  const BlogContent({
    super.key,
    required this.blog,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                blog.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'By ${blog.posterName}',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '${formatDateBydMMMYYYY(blog.updatedAt)} . ${calculateReadingTime(blog.content)} min',
                style: const TextStyle(
                  color: AppPalette.greyColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  '${blog.imageUrl}?timestamp=${DateTime.now().millisecondsSinceEpoch}',
                ),
              ),
              const SizedBox(height: 20),
              Text(
                blog.content,
                style: const TextStyle(fontSize: 16, height: 2),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
