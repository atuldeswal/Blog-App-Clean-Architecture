import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_palette.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/auth/presentation/pages/login_page.dart';
import 'package:blog_app/features/blog/presentation/bloc/profile/profile_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/about_page.dart';
import 'package:blog_app/features/blog/presentation/pages/edit_profile.dart';
import 'package:blog_app/features/blog/presentation/pages/help_and_support.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Settings extends StatelessWidget {
  static route() => MaterialPageRoute(builder: (context) => Settings());
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileDeleteUserAccountSuccess) {
            showSnackBar(context, 'Account deleted successfully!');
            Navigator.pushAndRemoveUntil(
              context,
              LoginPage.route(),
              (route) => false,
            );
          } else if (state is ProfileFailure) {
            showSnackBar(context, state.error);
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: Loader());
          }

          if (state is ProfileDisplaySuccess) {
            final user = state.user; // Get user from state

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSettingsItem(
                  icon: Icons.person_outline,
                  title: 'Edit Profile',
                  onTap:
                      () =>
                          Navigator.push(context, EditProfilePage.route(user)),
                ),
                _buildSettingsItem(
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  onTap: () {
                    // TODO: Navigate to notifications settings
                  },
                ),
                _buildSettingsItem(
                  icon: Icons.lock_outline,
                  title: 'Privacy & Security',
                  onTap: () {
                    // TODO: Navigate to privacy settings
                  },
                ),
                _buildSettingsItem(
                  icon: Icons.palette_outlined,
                  title: 'Theme',
                  onTap: () {
                    // TODO: Toggle theme
                  },
                ),
                _buildSettingsItem(
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  onTap: () => Navigator.push(context, HelpSupportPage.route()),
                ),
                _buildSettingsItem(
                  icon: Icons.info_outline,
                  title: 'About',
                  onTap: () => Navigator.push(context, AboutPage.route()),
                ),
                const Divider(height: 40),
                _buildSettingsItem(
                  icon: Icons.delete,
                  title: 'Delete Account',
                  onTap: () => _confirmDeleteAccount(context),
                  color: Colors.redAccent,
                ),
              ],
            );
          }

          return const SizedBox(); // If state is neither loading nor success
        },
      ),
    );
  }

  void _confirmDeleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<ProfileBloc>().add(ProfileDeleteUserAccount());
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: AppPalette.errorColor),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.white,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppPalette.gradient2, size: 28),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 18,
        color: Colors.grey,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
