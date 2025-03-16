
import 'package:blog_app/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final String? label;

  const FollowButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: label != null ? 16 : 0,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: backgroundColor ?? AppPalette.primary,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white),
              if (label != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    label!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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