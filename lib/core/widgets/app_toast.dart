import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

import '../theme/app_colors.dart';
import '../theme/app_tokens.dart';

/// Context-free toasts (usable from cubit listeners and from `app.dart`).
/// Requires `ToastificationWrapper` above `MaterialApp` — see `app.dart`.
///
/// Rendered as the prototype's C5 toast card (`screens.html` :820-823):
/// white, hairline border, radius 24, soft shadow, a 36 px ink circle with the
/// status icon, then a 15/500 [title] and an optional 13 muted [description].
/// Only the icon changes per kind; error swaps the circle to the error red.
abstract final class AppToast {
  /// Pass to `ToastificationWrapper`. The overlay list absorbs every tap over
  /// its bounds, so it starts below the 44 px back-circle header of root-level
  /// pages (C5/C6/E3) instead of covering it.
  static final config = ToastificationConfig(
    marginBuilder: (_, _) => const EdgeInsets.only(top: 104),
  );

  static void success(String title, {String? description}) =>
      _show(title, description, Icons.check);

  static void error(String title, {String? description}) =>
      _show(title, description, Icons.close, circleColor: AppColors.error);

  static void info(String title, {String? description}) =>
      _show(title, description, Icons.info_outline);

  static void warning(String title, {String? description}) =>
      _show(title, description, Icons.priority_high);

  static void _show(
    String title,
    String? description,
    IconData icon, {
    Color circleColor = AppColors.ink,
  }) {
    toastification.showCustom(
      alignment: Alignment.topCenter,
      autoCloseDuration: const Duration(seconds: 3),
      builder: (context, item) => _ToastCard(
        title: title,
        description: description,
        icon: icon,
        circleColor: circleColor,
        onTap: () => toastification.dismiss(item),
      ),
    );
  }
}

/// The overlay sits above `MaterialApp`, so there is no theme to read —
/// colours and type come straight from [AppColors] / [AppTokens.light].
class _ToastCard extends StatelessWidget {
  const _ToastCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.circleColor,
    required this.onTap,
  });

  final String title;
  final String? description;
  final IconData icon;
  final Color circleColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.light();
    final titleStyle = GoogleFonts.inter(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      height: 1.3,
      color: tokens.ink,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: tokens.surface,
          borderRadius: BorderRadius.circular(AppRadius.note),
          border: Border.all(color: tokens.line),
          boxShadow: [
            BoxShadow(
              color: tokens.ink.withValues(alpha: 0.12),
              blurRadius: 32,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          borderRadius: BorderRadius.circular(AppRadius.note),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: circleColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 16, color: tokens.surface),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(title, style: titleStyle),
                        if (description != null) ...[
                          const SizedBox(height: 2),
                          Text(description!, style: tokens.caption),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
