import 'package:flutter/material.dart';

/// The crew-app palette — exactly the seven flat colours used by the
/// prototype ("editorial light"). No gradients, no derived tints.
///
/// Prefer reading colours through `context.tokens` (see `app_tokens.dart`);
/// these constants exist so the theme and the tokens share one source.
abstract final class AppColors {
  /// Primary text, primary buttons, active nav/tab, "Selected" pills.
  static const Color ink = Color(0xFF221F1F);

  /// Secondary text, eyebrow labels, inactive icons.
  static const Color muted = Color(0xFF6F6B69);

  /// Cards, inputs, the floating nav.
  static const Color surface = Color(0xFFFFFFFF);

  /// Scaffold background.
  static const Color background = Color(0xFFF7F7F6);

  /// Hairline borders, skeletons, disabled buttons, segmented-tab track.
  static const Color line = Color(0xFFE4E4E3);

  /// Blush accent: secondary buttons, "Waiting" pills, highlight cards,
  /// avatar circles.
  static const Color accent = Color(0xFFE9DDD8);

  /// Form errors and "Not approved" only — never used for "Not selected".
  static const Color error = Color(0xFFB3261E);
}
