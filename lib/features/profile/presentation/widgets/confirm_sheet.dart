import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/app_button.dart';

/// Destructive confirmation as a bottom sheet (prototype C6; §2.7): 40×4
/// handle, 28 px title, 15 px muted body, then a 56 primary and a 48 ghost
/// button. Padding `12 24 36`, 22 px between blocks.
///
/// Resolves to `true` when the primary action is chosen, `false` otherwise
/// (ghost button, scrim tap, swipe down).
class ConfirmSheet extends StatelessWidget {
  const ConfirmSheet({
    super.key,
    required this.title,
    required this.body,
    required this.confirmLabel,
    required this.cancelLabel,
  });

  final String title;
  final String body;
  final String confirmLabel;
  final String cancelLabel;

  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String body,
    required String confirmLabel,
    required String cancelLabel,
  }) async {
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      builder: (context) => ConfirmSheet(
        title: title,
        body: body,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
      ),
    );
    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(24, 12, 24, 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: tokens.line,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
          ),
          const SizedBox(height: 22),
          Text(title, style: textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(body, style: textTheme.bodyMedium?.copyWith(color: tokens.muted)),
          const SizedBox(height: 22),
          AppButton(
            label: confirmLabel,
            onPressed: () => Navigator.of(context).pop(true),
          ),
          const SizedBox(height: 6),
          AppButton(
            label: cancelLabel,
            variant: AppButtonVariant.ghost,
            size: AppButtonSize.medium,
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ],
      ),
    );
  }
}

/// The sign-out confirmation shared by E1 and A6/A7.
Future<bool> confirmSignOut(BuildContext context) => ConfirmSheet.show(
  context,
  title: 'Sign out?',
  body: "You'll need your email and password to sign back in.",
  confirmLabel: 'Sign out',
  cancelLabel: 'Stay signed in',
);
