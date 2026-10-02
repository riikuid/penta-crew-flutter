import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

enum AppCardTone {
  /// White with a hairline border — the default content card.
  surface,

  /// Blush fill, no border — "next shift" / highlight cards.
  accent,

  /// Ink fill, white text — the inverse hero card.
  ink,

  /// Scaffold-grey fill — quiet grouping (positions list, notes).
  sunken,
}

/// Flat, large-radius card. No elevation anywhere in this design — depth is
/// expressed with fill colour and the hairline border only.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.tone = AppCardTone.surface,
    this.radius = AppRadius.card,
    this.padding = const EdgeInsets.all(24),
    this.onTap,
  });

  final Widget child;
  final AppCardTone tone;

  /// `AppRadius.card` (32) for list cards, `AppRadius.cardLarge` (40) for
  /// hero and empty-state cards.
  final double radius;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final (Color background, Color? border, Color foreground) = switch (tone) {
      AppCardTone.surface => (tokens.surface, tokens.line, tokens.ink),
      AppCardTone.accent => (tokens.accent, null, tokens.ink),
      AppCardTone.ink => (tokens.ink, null, tokens.surface),
      AppCardTone.sunken => (tokens.background, null, tokens.ink),
    };
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
      side: border == null ? BorderSide.none : BorderSide(color: border),
    );

    // Ink cards invert text and icon defaults for their whole subtree.
    final body = DefaultTextStyle.merge(
      style: TextStyle(color: foreground),
      child: IconTheme.merge(
        data: IconThemeData(color: foreground),
        child: Padding(padding: padding, child: child),
      ),
    );

    return Material(
      color: background,
      shape: shape,
      clipBehavior: Clip.antiAlias,
      child: onTap == null ? body : InkWell(onTap: onTap, child: body),
    );
  }
}
