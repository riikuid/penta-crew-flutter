import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/eyebrow.dart';

/// Eyebrow + editorial headline + muted body, stacked with 12 px gaps — the
/// opening block of every auth screen (A2 "Welcome back.", Forgot, Reset).
class AuthIntro extends StatelessWidget {
  const AuthIntro({
    super.key,
    required this.headline,
    required this.body,
    this.eyebrow = 'Crew account',
    this.headlineStyle,
    this.bodyStyle,
  });

  final String headline;
  final String body;
  final String eyebrow;

  /// Defaults to `tokens.display` (40). A2 passes `displayLarge` (44).
  final TextStyle? headlineStyle;

  /// Defaults to 16 muted (A2). A4/A5 pass 15.
  final TextStyle? bodyStyle;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Eyebrow(eyebrow),
        const SizedBox(height: 12),
        Text(headline, style: headlineStyle ?? tokens.display),
        const SizedBox(height: 12),
        Text(
          body,
          style: bodyStyle ?? textTheme.bodyLarge?.copyWith(color: tokens.muted),
        ),
      ],
    );
  }
}
