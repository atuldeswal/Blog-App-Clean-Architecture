import 'package:flutter/material.dart';

enum TransitionDirection { up, down }

class BlogTransitionAnimation extends StatelessWidget {
  final Widget child;
  final Animation<double> animation;
  final TransitionDirection direction;

  const BlogTransitionAnimation({
    super.key,
    required this.child,
    required this.animation,
    this.direction = TransitionDirection.up,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final offset =
            direction == TransitionDirection.up
                ? Offset(0, -animation.value)
                : Offset(0, animation.value);

        final opacity = 1.0 - animation.value.abs().clamp(0.0, 1.0);

        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: offset * MediaQuery.of(context).size.height * 0.5,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
