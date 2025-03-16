import 'package:blog_app/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

class FloatingButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final String? lable;

  const FloatingButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.lable,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      shape: const CircleBorder(),
      backgroundColor: AppPalette.primary,
      child: Icon(icon, size: 28, color: Colors.white),
    );
  }
}
