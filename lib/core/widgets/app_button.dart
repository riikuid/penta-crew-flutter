import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

/// Visual variants from the prototype. Colours come from the theme, so this
/// widget only picks the Material button class and the size.
enum AppButtonVariant {
  /// Ink fill, white text — the one primary action per screen.
  primary,

  /// Blush fill, ink text — secondary actions ("Create account", "Edit").
  secondary,

  /// White fill, hairline border — neutral actions ("Sign out", "Cancel").
  outlined,

  /// White fill, hairline border, error-red text — "Withdraw application".
  danger,

  /// No fill — inline links ("Forgot password?").
  ghost,
}

enum AppButtonSize {
  /// 56 — full-width actions in the thumb zone.
  large(AppSize.control),

  /// 48 — inline actions that sit next to content.
  medium(AppSize.controlMedium);

  const AppButtonSize(this.height);
  final double height;
}

/// Pill button with a built-in busy state: while [loading] is true it
/// disables itself and swaps the label for a spinner in the label's colour,
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

  @override
  Widget build(BuildContext context) {
    final callback = loading ? null : onPressed;
    final child = _Label(label: label, icon: icon, loading: loading);
    final sizeStyle = ButtonStyle(
      minimumSize: WidgetStatePropertyAll(
        Size(expand ? double.infinity : 64, size.height),
      ),
      maximumSize: WidgetStatePropertyAll(
        Size(double.infinity, size.height),
      ),
    );

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
  const _Label({required this.label, required this.icon, required this.loading});

  final String label;
  final IconData? icon;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    // Keep the label in the tree (invisible) so the button keeps its width.
    final text = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[Icon(icon), const SizedBox(width: 8)],
        Text(label),
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
