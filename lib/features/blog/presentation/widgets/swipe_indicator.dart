import 'package:blog_app/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

enum SwipeDirection { up, down }

class SwipeIndicator extends StatelessWidget {
  final SwipeDirection direction;
  const SwipeIndicator({super.key, this.direction = SwipeDirection.up});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(
            direction == SwipeDirection.up
                ? Icons.keyboard_arrow_up
                : null,
            color: AppPalette.greyColor,
          ),
          Text(
            direction == SwipeDirection.up
                ? 'Swipe up for next article'
                : '',
            style: TextStyle(color: AppPalette.greyColor, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
