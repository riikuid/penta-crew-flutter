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
    this.color,
    this.borderColor,
  });

  /// One line of text: pill-shaped, 16px high.
  const Skeleton.line({super.key, this.width, this.height = 16, this.color})
    : radius = AppRadius.pill,
      borderColor = null;

  /// Avatar / icon circle.
  const Skeleton.circle({super.key, double size = 44, this.color})
    : width = size,
      height = size,
      radius = AppRadius.pill,
      borderColor = null;

  /// Whole-card placeholder with the large card radius. B2 uses a blush
  /// hero (`color: tokens.accent`) and white counters with a hairline border
  /// (`color: tokens.surface, borderColor: tokens.line`).
  const Skeleton.card({
    super.key,
    this.width,
    required this.height,
    this.color,
    this.borderColor,
  }) : radius = AppRadius.cardLarge;

  final double? width;
  final double height;
  final double radius;

  /// Fill; defaults to the hairline grey (`tokens.line`).
  final Color? color;

  /// Optional 1 px border; none by default.
  final Color? borderColor;

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
    final color = widget.color ?? context.tokens.line;
    final borderColor = widget.borderColor;
    return ExcludeSemantics(
      child: FadeTransition(
        opacity: _opacity,
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(widget.radius),
            border: borderColor == null ? null : Border.all(color: borderColor),
          ),
        ),
      ),
    );
  }
}
