import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SimpleSlideAnimation extends HookWidget {
  const SimpleSlideAnimation({
    Key? key,
    required this.initialOffset,
    required this.child,
    this.curve,
  }) : super(key: key);

  final Offset initialOffset;
  final Widget child;
  final Curve? curve;

  @override
  Widget build(BuildContext context) {
    final _animationController = useAnimationController(
      duration: const Duration(milliseconds: 500),
    );

    final _slideAnimation = useAnimation(
      Tween<double>(begin: 1, end: 0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: curve ?? Curves.easeInOutBack,
        ),
      ),
    );

    _animationController.forward();

    return Transform.translate(
      offset: initialOffset * _slideAnimation,
      child: child,
    );
  }
}
