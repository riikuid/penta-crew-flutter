import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

/// Visual variants from the prototype. Colours come from the theme, so this
/// widget only picks the Material button class and the size.
enum AppButtonVariant {
  /// Ink fill, white text — the one primary action per screen.
  primary,

  /// Blush fill, ink text — secondary actions ("Create account", "Edit").
  secondary,

  /// White fill, hairline border — neutral actions ("Cancel", "Try again").
  outlined,

  /// Transparent fill, 1 px ink border, ink text — C5 "Withdraw application".
  outlinedInk,

  /// White fill, hairline border, error-red text — E1 "Sign out".
  danger,

  /// No fill — inline links ("Forgot password?").
  ghost,
}

enum AppButtonSize {
  /// 56 — full-width actions in the thumb zone.
  large(AppSize.control, 16, 20),

  /// 52 — E1 "Sign out", 15 px label.
  tall(52, 15, 18),

  /// 48 — inline actions that sit next to content.
  medium(AppSize.controlMedium, 16, 20),

  /// 44 — E2 "Change photo" and inline links, 14 px label.
  small(44, 14, 16);

  const AppButtonSize(this.height, this.fontSize, this.iconSize);
  final double height;
  final double fontSize;
  final double iconSize;
}

/// Pill button with a built-in busy state: while [loading] is true it ignores
/// taps (keeping its enabled colours) and swaps the label for a spinner in the label's colour,
/// so the button keeps its width and the layout does not jump.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.large,
    this.loading = false,
    this.icon,
    this.expand = true,
    this.padding,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool loading;
  final IconData? icon;

  /// Fill the available width (the prototype's default for form actions).
  /// Set false for inline buttons that should hug their label.
  final bool expand;

  /// Overrides the theme's horizontal padding (e.g. zero for a flush link).
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    // A non-null callback keeps the enabled colours; taps are ignored below.
    final callback = loading ? _ignore : onPressed;
    final child = _Label(
      label: label,
      icon: icon,
      loading: loading,
      size: size,
    );
    final sizeStyle = ButtonStyle(
      minimumSize: WidgetStatePropertyAll(
        Size(expand ? double.infinity : 64, size.height),
      ),
      maximumSize: WidgetStatePropertyAll(Size(double.infinity, size.height)),
      // 44 is the minimum hit height; do not let Material pad it back to 48.
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: padding == null ? null : WidgetStatePropertyAll(padding),
    );

    return IgnorePointer(
      ignoring: loading,
      child: _button(context, callback, child, sizeStyle),
    );
  }

  static void _ignore() {}

  Widget _button(
    BuildContext context,
    VoidCallback? callback,
    Widget child,
    ButtonStyle sizeStyle,
  ) {
    return switch (variant) {
      AppButtonVariant.primary => FilledButton(
        onPressed: callback,
        style: sizeStyle,
        child: child,
      ),
      AppButtonVariant.secondary => FilledButton.tonal(
        onPressed: callback,
        style: sizeStyle,
        child: child,
      ),
      AppButtonVariant.outlined => OutlinedButton(
        onPressed: callback,
        style: sizeStyle,
        child: child,
      ),
      AppButtonVariant.outlinedInk => OutlinedButton(
        onPressed: callback,
        style: sizeStyle.copyWith(
          backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
          side: WidgetStateProperty.resolveWith(
            (states) => BorderSide(
              color: states.contains(WidgetState.disabled)
                  ? context.tokens.line
                  : context.tokens.ink,
            ),
          ),
        ),
        child: child,
      ),
      AppButtonVariant.danger => OutlinedButton(
        onPressed: callback,
        style: sizeStyle.copyWith(
          foregroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.disabled)
                ? context.tokens.muted
                : context.tokens.error,
          ),
        ),
        child: child,
      ),
      AppButtonVariant.ghost => TextButton(
        onPressed: callback,
        style: sizeStyle,
        child: child,
      ),
    };
  }
}

class _Label extends StatelessWidget {
  const _Label({
    required this.label,
    required this.icon,
    required this.loading,
    required this.size,
  });

  final String label;
  final IconData? icon;
  final bool loading;
  final AppButtonSize size;

  @override
  Widget build(BuildContext context) {
    // Keep the label in the tree (invisible) so the button keeps its width.
    final text = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: size.iconSize),
          const SizedBox(width: 8),
        ],
        Text(label, style: TextStyle(fontSize: size.fontSize)),
      ],
    );

    if (!loading) return text;

    // The button sets IconTheme to its foreground colour; the spinner
    // follows it so it reads on ink, blush and white alike.
    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(opacity: 0, child: text),
        SizedBox.square(
          dimension: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: IconTheme.of(context).color,
          ),
        ),
      ],
    );
  }
}
