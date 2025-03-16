import 'dart:io';

import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/constants/constants.dart';
import 'package:blog_app/core/theme/app_palette.dart';
import 'package:blog_app/core/utils/pick_image.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogUpdatePage extends StatefulWidget {
  static route(Blog blog) =>
      MaterialPageRoute(builder: (context) => BlogUpdatePage(blog: blog));
  final Blog blog;
  const BlogUpdatePage({super.key, required this.blog});

  @override
  State<BlogUpdatePage> createState() => _BlogUpdatePageState();
}

class _BlogUpdatePageState extends State<BlogUpdatePage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<String> selectedTopics = [];
  File? image;

  @override
  void initState() {
    titleController.text = widget.blog.title;
    contentController.text = widget.blog.content;
    selectedTopics = List.from(widget.blog.topics);
    super.initState();
  }

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  void updateBlog(blogId) {
    if (formKey.currentState!.validate() && selectedTopics.isNotEmpty) {
      context.read<BlogBloc>().add(
        BlogUpdate(
          blogId: blogId,
          updatedTitle: titleController.text.trim(),
          updatedContent: contentController.text.trim(),
          updatedTopics: selectedTopics,
          updatedImage: image,
        ),
      );
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final blog = widget.blog;
    final blogId = blog.id;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: () {
              updateBlog(blogId);
            },
            icon: Icon(Icons.done_rounded),
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.error);
          } else if (state is BlogUpdateSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              BlogPage.route(),
              (route) => false,
            );
            showSnackBar(context, 'Blog updated successfully.');
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    image != null
                        ? GestureDetector(
                          onTap: selectImage,
                          child: SizedBox(
                            height: 150,
                            width: double.infinity,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(image!, fit: BoxFit.cover),
                            ),
                          ),
                        )
                        : GestureDetector(
                          onTap: () {
                            selectImage();
                          },
                          child: DottedBorder(
                            color: AppPalette.borderColor,
                            dashPattern: [10, 4],
                            radius: Radius.circular(10),
                            borderType: BorderType.RRect,
                            strokeCap: StrokeCap.round,
                            child: SizedBox(
                              height: 150,
                              width: double.infinity,
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.folder_open, size: 40),
                                  SizedBox(height: 15),
                                  Text(
                                    'Select your image',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            Constants.topics
                                .map(
                                  (e) => Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        if (selectedTopics.contains(e)) {
                                          selectedTopics.remove(e);
                                        } else {
                                          selectedTopics.add(e);
                                        }
                                        setState(() {});
                                      },
                                      child: Chip(
                                        label: Text(e),
                                        color:
                                            selectedTopics.contains(e)
                                                ? WidgetStatePropertyAll(
                                                  AppPalette.gradient1,
                                                )
                                                : null,
                                        side:
                                            selectedTopics.contains(e)
                                                ? null
                                                : BorderSide(
                                                  color: AppPalette.borderColor,
                                                ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    BlogEditor(
                      controller: titleController,
                      hintText: 'Blog Title',
                    ),
                    const SizedBox(height: 10),
                    BlogEditor(
                      controller: contentController,
                      hintText: 'Blog Content',
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
