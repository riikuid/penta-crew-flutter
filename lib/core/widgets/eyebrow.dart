import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

/// Uppercase 11/600 section label — the most used text style in the
/// prototype ("CREW ACCOUNT", "NEXT SHIFT", field labels).
///
/// Uppercasing happens here, not in the token, because `TextStyle` cannot
/// transform case and callers should pass natural-case copy.
class Eyebrow extends StatelessWidget {
  const Eyebrow(
    this.text, {
    super.key,
    this.color,
    this.small = false,
    this.textAlign,
  });

  final String text;

  /// Defaults to muted. Pass `tokens.ink` on accent backgrounds, or
  /// `tokens.surface` on ink.
  final Color? color;

  /// 10px variant used inside small pills and dense rows.
  final bool small;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final base = small ? tokens.eyebrowSmall : tokens.eyebrow;
    return Text(
      text.toUpperCase(),
      textAlign: textAlign,
      style: color == null ? base : base.copyWith(color: color),
    );
  }
}
