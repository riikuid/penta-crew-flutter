import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_tokens.dart';

/// Material theme for the crew app, derived from the seven-colour palette in
/// [AppColors] and the Inter type scale of the prototype.
///
/// Light only (D-12): the prototype defines no dark direction. Stock Material
/// widgets (TextField, FilledButton, Card, …) are themed here so screens can
/// use them directly; anything editorial goes through `context.tokens`.
abstract final class AppTheme {
  static ThemeData light() {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.ink,
      onPrimary: AppColors.surface,
      primaryContainer: AppColors.ink,
      onPrimaryContainer: AppColors.surface,
      secondary: AppColors.muted,
      onSecondary: AppColors.surface,
      // FilledButton.tonal → blush secondary button.
      secondaryContainer: AppColors.accent,
      onSecondaryContainer: AppColors.ink,
      tertiary: AppColors.muted,
      onTertiary: AppColors.surface,
      tertiaryContainer: AppColors.background,
      onTertiaryContainer: AppColors.ink,
      error: AppColors.error,
      onError: AppColors.surface,
      errorContainer: AppColors.surface,
      onErrorContainer: AppColors.error,
      surface: AppColors.surface,
      onSurface: AppColors.ink,
      onSurfaceVariant: AppColors.muted,
      surfaceDim: AppColors.line,
      surfaceBright: AppColors.surface,
      surfaceContainerLowest: AppColors.surface,
      surfaceContainerLow: AppColors.background,
      surfaceContainer: AppColors.background,
      surfaceContainerHigh: AppColors.line,
      surfaceContainerHighest: AppColors.line,
      outline: AppColors.line,
      outlineVariant: AppColors.line,
      shadow: AppColors.ink,
      scrim: AppColors.ink,
      inverseSurface: AppColors.ink,
      onInverseSurface: AppColors.surface,
      inversePrimary: AppColors.accent,
      // Flat design: never tint elevated surfaces.
      surfaceTint: Colors.transparent,
    );

    final textTheme = _textTheme();
    final buttonText = GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      canvasColor: AppColors.background,
      textTheme: textTheme,
      extensions: [AppTokens.light()],
      visualDensity: VisualDensity.standard,
      splashFactory: InkRipple.splashFactory,

      // ── Inputs: 56 high, radius 20, hairline border that turns ink on
      //    focus and error-red (1.5) on error. Labels are drawn by
      //    `LabeledField`, so no floating label here.
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        constraints: const BoxConstraints(minHeight: AppSize.control),
        hintStyle: textTheme.bodyLarge?.copyWith(color: AppColors.muted),
        errorStyle: textTheme.bodySmall?.copyWith(color: AppColors.error),
        errorMaxLines: 2,
        border: _inputBorder(AppColors.line),
        enabledBorder: _inputBorder(AppColors.line),
        focusedBorder: _inputBorder(AppColors.ink),
        errorBorder: _inputBorder(AppColors.error, width: 1.5),
        focusedErrorBorder: _inputBorder(AppColors.error, width: 1.5),
        disabledBorder: _inputBorder(AppColors.line),
        suffixIconColor: AppColors.muted,
        prefixIconColor: AppColors.muted,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.ink,
        selectionColor: AppColors.accent,
        selectionHandleColor: AppColors.ink,
      ),

      // ── Buttons: pills, 56 high. Enabled colours come from the scheme
      //    (FilledButton = ink, FilledButton.tonal = blush); only the
      //    disabled look is overridden so both variants share it.
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, AppSize.control),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          shape: const StadiumBorder(),
          textStyle: buttonText,
          iconSize: 20,
          elevation: 0,
          disabledBackgroundColor: AppColors.line,
          disabledForegroundColor: AppColors.muted,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, AppSize.control),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          shape: const StadiumBorder(),
          textStyle: buttonText,
          iconSize: 20,
          foregroundColor: AppColors.ink,
          backgroundColor: AppColors.surface,
          side: const BorderSide(color: AppColors.line),
          disabledForegroundColor: AppColors.muted,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(0, AppSize.tab),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          shape: const StadiumBorder(),
          textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500),
          foregroundColor: AppColors.ink,
          disabledForegroundColor: AppColors.muted,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size.square(AppSize.tab),
          foregroundColor: AppColors.ink,
          disabledForegroundColor: AppColors.muted,
        ),
      ),

      // ── Surfaces
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.ink,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: const CardThemeData(
        color: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.card)),
          side: BorderSide(color: AppColors.line),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.line,
        thickness: 1,
        space: 1,
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.zero,
        minTileHeight: 60,
        iconColor: AppColors.muted,
        textColor: AppColors.ink,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: AppColors.surface,
        modalBarrierColor: Color(0x66221F1F),
        showDragHandle: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.cardLarge),
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.card)),
        ),
        titleTextStyle: textTheme.headlineSmall,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.muted,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.ink,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.surface,
        ),
        behavior: SnackBarBehavior.floating,
        shape: const StadiumBorder(),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.ink,
        linearTrackColor: AppColors.line,
        circularTrackColor: Colors.transparent,
      ),
    );
  }

  static OutlineInputBorder _inputBorder(Color color, {double width = 1}) =>
      OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.input)),
        borderSide: BorderSide(color: color, width: width),
      );

  /// Inter scale as used by the prototype. Tracking is given in em there;
  /// Flutter wants logical pixels, hence `tracking * size`.
  static TextTheme _textTheme() {
    TextStyle s(
      double size,
      FontWeight weight, {
      double height = 1.3,
      double tracking = 0,
      Color color = AppColors.ink,
    }) => TextStyle(
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: tracking * size,
      color: color,
    );

    final base = TextTheme(
      // Editorial headlines.
      displayLarge: s(44, FontWeight.w500, height: 1.04, tracking: -0.03),
      displayMedium: s(40, FontWeight.w500, height: 1.04, tracking: -0.03),
      displaySmall: s(36, FontWeight.w500, height: 1.04, tracking: -0.03),
      // Section / card headlines.
      headlineLarge: s(32, FontWeight.w500, height: 1.1, tracking: -0.02),
      headlineMedium: s(28, FontWeight.w500, height: 1.1, tracking: -0.02),
      headlineSmall: s(22, FontWeight.w500, height: 1.2, tracking: -0.02),
      // Titles (app bar, card title, list row title).
      titleLarge: s(20, FontWeight.w500, height: 1.2, tracking: -0.02),
      titleMedium: s(18, FontWeight.w500, height: 1.25, tracking: -0.01),
      titleSmall: s(16, FontWeight.w500, height: 1.3),
      // Body.
      bodyLarge: s(16, FontWeight.w400, height: 1.5),
      bodyMedium: s(15, FontWeight.w400, height: 1.5),
      bodySmall: s(14, FontWeight.w400, height: 1.5),
      // Labels: UI chrome, chips, eyebrows (uppercase applied by `Eyebrow`).
      labelLarge: s(14, FontWeight.w500, height: 1.2),
      labelMedium: s(13, FontWeight.w500, height: 1.2),
      labelSmall: s(
        11,
        FontWeight.w600,
        height: 1.2,
        tracking: 0.06,
        color: AppColors.muted,
      ),
    );

    return GoogleFonts.interTextTheme(base);
  }
}
