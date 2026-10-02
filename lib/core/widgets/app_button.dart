import 'package:flutter/material.dart';

/// Primary action button with a built-in busy state (disables itself and
/// shows a spinner while [loading] is true).
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.outlined = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final bool outlined;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final child = loading
        ? const SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: 8)],
              Text(label),
            ],
          );

    final callback = loading ? null : onPressed;

    return outlined
        ? OutlinedButton(onPressed: callback, child: child)
        : FilledButton(onPressed: callback, child: child);
  }
}
