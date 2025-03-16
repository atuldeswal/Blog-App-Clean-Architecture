import 'package:blog_app/core/theme/app_palette.dart';
import 'package:blog_app/features/auth/presentation/pages/login_page.dart';
import 'package:blog_app/features/blog/presentation/bloc/profile/profile_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomPopupMenuButton extends StatelessWidget {
  const CustomPopupMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert_outlined),
      onSelected: (value) {
        if (value == "Logout") {
          context.read<ProfileBloc>().add(ProfileLogOut());
          Navigator.pushAndRemoveUntil(
            context,
            LoginPage.route(),
            (Route<dynamic> route) => false,
          );
        } else {
          Navigator.push(context, Settings.route());
        }
      },
      itemBuilder:
          (BuildContext context) => [
            PopupMenuItem(
              value: "Settings",
              child: Row(
                children: [
                  Icon(Icons.settings, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Settings', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            PopupMenuItem(
              value: "Logout",
              child: Row(
                children: [
                  Icon(Icons.logout, color: AppPalette.errorColor),
                  SizedBox(width: 8),
                  Text('Logout', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ],
    );
  }
}
