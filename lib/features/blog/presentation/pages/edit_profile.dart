import 'dart:io';

import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/core/theme/app_palette.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/blog/presentation/bloc/profile/profile_bloc.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  final User user;

  const EditProfilePage({super.key, required this.user});

  static Route route(User user) =>
      MaterialPageRoute(builder: (context) => EditProfilePage(user: user));

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.name;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _saveProfile() {
    final trimmedName = _nameController.text.trim();

    if (trimmedName.isEmpty) {
      showSnackBar(context, 'Name cannot be empty');
      return;
    }

    final updatedUser = widget.user.copyWith(name: trimmedName);

    context.read<ProfileBloc>().add(
      ProfileUpdateUserProfile(user: updatedUser, profileImage: _selectedImage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoading) {
            showLoadingDialog(context);
          } else if (state is ProfileUpdateSuccess) {
            dismissLoadingDialog(context);
            context.read<ProfileBloc>().add(ProfileFetchUserBlogs());
            Navigator.pop(context); // Go back to profile screen
          } else if (state is ProfileFailure) {
            dismissLoadingDialog(context);
            showSnackBar(context, state.error);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: DottedBorder(
                        borderType: BorderType.Circle,
                        color: AppPalette.borderColor,
                        strokeWidth: 2,
                        dashPattern: [6, 3],
                        radius: Radius.circular(50),
                        child: CircleAvatar(
                          radius: 50,

                          backgroundColor: AppPalette.backgroundColor,
                          backgroundImage:
                              _selectedImage != null
                                  ? FileImage(_selectedImage!) as ImageProvider
                                  : (widget.user.profileImage.isNotEmpty
                                      ? NetworkImage(widget.user.profileImage)
                                      : null),
                          child:
                              (_selectedImage == null &&
                                      widget.user.profileImage.isEmpty)
                                  ? Text(
                                    widget.user.name.isNotEmpty
                                        ? widget.user.name[0]
                                        : '?',
                                    style: const TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  )
                                  : null,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor: AppPalette.gradient2,
                        child: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          onPressed: _pickImage,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppPalette.gradient1, AppPalette.gradient2],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                  borderRadius: BorderRadius.circular(7),
                ),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(345, 55),
                    shadowColor: AppPalette.transparentColor,
                    backgroundColor: AppPalette.transparentColor,
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showLoadingDialog(BuildContext context) {
  if (ModalRoute.of(context)?.isCurrent != true) return;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(child: CircularProgressIndicator()),
  );
}

void dismissLoadingDialog(BuildContext context) {
  if (Navigator.canPop(context)) {
    Navigator.pop(context);
  }
}
