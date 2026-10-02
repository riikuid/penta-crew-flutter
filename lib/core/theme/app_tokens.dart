import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Design tokens that do not map onto Material's `ColorScheme`/`TextTheme`
/// semantics: the raw palette by name and the editorial text styles the
/// prototype uses outside of Material widgets (eyebrows, numerals, counters).
///
/// Read it with `context.tokens`. Anything that *does* map onto Material
/// (body text, titles, button colours) lives in `ThemeData` so stock widgets
/// pick it up automatically.
@immutable
class AppTokens extends ThemeExtension<AppTokens> {
  const AppTokens({
    required this.ink,
    required this.muted,
    required this.surface,
    required this.background,
    required this.line,
    required this.accent,
    required this.error,
    required this.display,
    required this.displayLarge,
    required this.numeral,
    required this.counter,
    required this.eyebrow,
    required this.eyebrowSmall,
    required this.caption,
    required this.captionSmall,
  });

  // ── Colours ────────────────────────────────────────────────────────────
  final Color ink;
  final Color muted;
  final Color surface;
  final Color background;
  final Color line;
  final Color accent;
  final Color error;

  // ── Editorial text ─────────────────────────────────────────────────────
  /// 40/500, -0.03em — screen headlines ("Welcome back.").
  final TextStyle display;

  /// 44/500 — the larger headline variant (Home greeting).
  final TextStyle displayLarge;

  /// 44/400, -0.04em — the day number in a date block ("05").
  final TextStyle numeral;

  /// 80/500, -0.05em — big counters ("06 events worked").
  final TextStyle counter;

  /// 11/600, +0.06em, muted — section labels. Render UPPERCASE (see
  /// `Eyebrow`); `TextStyle` cannot transform case.
  final TextStyle eyebrow;

  /// 10/600 variant used inside small pills.
  final TextStyle eyebrowSmall;

  /// 13/400 muted.
  final TextStyle caption;

  /// 12/400 muted.
  final TextStyle captionSmall;

  static AppTokens light() {
    TextStyle inter({
      required double size,
      required FontWeight weight,
      double? height,
      double tracking = 0,
      Color color = AppColors.ink,
    }) => GoogleFonts.inter(
      fontSize: size,
      fontWeight: weight,
      height: height,
      // Prototype specifies tracking in em; Flutter wants logical pixels.
      letterSpacing: tracking * size,
      color: color,
    );

    return AppTokens(
      ink: AppColors.ink,
      muted: AppColors.muted,
      surface: AppColors.surface,
      background: AppColors.background,
      line: AppColors.line,
      accent: AppColors.accent,
      error: AppColors.error,
      display: inter(
        size: 40,
        weight: FontWeight.w500,
        height: 1.04,
        tracking: -0.03,
      ),
      displayLarge: inter(
        size: 44,
        weight: FontWeight.w500,
        height: 1.04,
        tracking: -0.03,
      ),
      numeral: inter(
        size: 44,
        weight: FontWeight.w400,
        height: 1,
        tracking: -0.04,
      ),
      counter: inter(
        size: 80,
        weight: FontWeight.w500,
        height: 0.85,
        tracking: -0.05,
      ),
      eyebrow: inter(
        size: 11,
        weight: FontWeight.w600,
        tracking: 0.06,
        color: AppColors.muted,
      ),
      eyebrowSmall: inter(
        size: 10,
        weight: FontWeight.w600,
        tracking: 0.06,
        color: AppColors.muted,
      ),
      caption: inter(
        size: 13,
        weight: FontWeight.w400,
        height: 1.4,
        color: AppColors.muted,
      ),
      captionSmall: inter(
        size: 12,
        weight: FontWeight.w400,
        height: 1.4,
        color: AppColors.muted,
      ),
    );
  }

  @override
  AppTokens copyWith({
    Color? ink,
    Color? muted,
    Color? surface,
    Color? background,
    Color? line,
    Color? accent,
    Color? error,
    TextStyle? display,
    TextStyle? displayLarge,
    TextStyle? numeral,
    TextStyle? counter,
    TextStyle? eyebrow,
    TextStyle? eyebrowSmall,
    TextStyle? caption,
    TextStyle? captionSmall,
  }) {
    return AppTokens(
      ink: ink ?? this.ink,
      muted: muted ?? this.muted,
      surface: surface ?? this.surface,
      background: background ?? this.background,
      line: line ?? this.line,
      accent: accent ?? this.accent,
      error: error ?? this.error,
      display: display ?? this.display,
      displayLarge: displayLarge ?? this.displayLarge,
      numeral: numeral ?? this.numeral,
      counter: counter ?? this.counter,
      eyebrow: eyebrow ?? this.eyebrow,
      eyebrowSmall: eyebrowSmall ?? this.eyebrowSmall,
      caption: caption ?? this.caption,
      captionSmall: captionSmall ?? this.captionSmall,
    );
  }

  @override
  AppTokens lerp(AppTokens? other, double t) {
    if (other == null) return this;
    return AppTokens(
      ink: Color.lerp(ink, other.ink, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      background: Color.lerp(background, other.background, t)!,
      line: Color.lerp(line, other.line, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      error: Color.lerp(error, other.error, t)!,
      display: TextStyle.lerp(display, other.display, t)!,
      displayLarge: TextStyle.lerp(displayLarge, other.displayLarge, t)!,
      numeral: TextStyle.lerp(numeral, other.numeral, t)!,
      counter: TextStyle.lerp(counter, other.counter, t)!,
      eyebrow: TextStyle.lerp(eyebrow, other.eyebrow, t)!,
      eyebrowSmall: TextStyle.lerp(eyebrowSmall, other.eyebrowSmall, t)!,
      caption: TextStyle.lerp(caption, other.caption, t)!,
      captionSmall: TextStyle.lerp(captionSmall, other.captionSmall, t)!,
    );
  }
}

extension AppTokensX on BuildContext {
  /// The crew-app tokens. Throws if the app theme was not built with
  /// `AppTheme.light()` — that is a wiring bug, not a runtime condition.
  AppTokens get tokens => Theme.of(this).extension<AppTokens>()!;
}

/// Corner radii. Everything is either a pill or one of these four.
abstract final class AppRadius {
  /// Buttons, chips, pills, nav, segmented tabs.
  static const double pill = 9999;

  /// Text inputs and select rows.
  static const double input = 20;

  /// Inline notes / callouts.
  static const double note = 24;

  /// Standard cards and dialogs.
  static const double card = 32;

  /// Hero cards, empty-state cards, bottom sheets.
  static const double cardLarge = 40;
}

/// Fixed control dimensions.
abstract final class AppSize {
  /// Primary buttons and text inputs.
  static const double control = 56;

  /// Inline / secondary buttons.
  static const double controlMedium = 48;

  /// Floating-nav active item, list rows.
  static const double row = 52;

  /// Segmented tab item, icon buttons.
  static const double tab = 44;

  /// Horizontal screen padding.
  static const double pagePadding = 24;
}
