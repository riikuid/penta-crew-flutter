import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

/// Loading placeholder in the prototype's style: hairline-grey block that
/// pulses gently. Compose several inside a section while its request is in
/// flight (D-05: each Home section clears its own skeleton independently).
///
/// The pulse is driven per widget; a skeleton screen has a handful of these,
/// which is well within budget and keeps the API dependency-free.
class Skeleton extends StatefulWidget {
  /// Free-form block, 12px radius by default (headline placeholders).
  const Skeleton({
    super.key,
    this.width,
    this.height = 16,
    this.radius = 12,
  });

  /// One line of text: pill-shaped, 16px high.
  const Skeleton.line({super.key, this.width, this.height = 16})
    : radius = AppRadius.pill;

  /// Avatar / icon circle.
  const Skeleton.circle({super.key, double size = 44})
    : width = size,
      height = size,
      radius = AppRadius.pill;

  /// Whole-card placeholder with the large card radius.
  const Skeleton.card({super.key, this.width, required this.height})
    : radius = AppRadius.cardLarge;

  final double? width;
  final double height;
  final double radius;

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat(reverse: true);

  late final Animation<double> _opacity = Tween(
    begin: 0.45,
    end: 0.85,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.tokens.line;
    return ExcludeSemantics(
      child: FadeTransition(
        opacity: _opacity,
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(widget.radius),
          ),
        ),
      ),
    );
  }
}
