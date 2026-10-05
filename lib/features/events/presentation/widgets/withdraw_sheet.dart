import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/app_button.dart';
import '../event_formats.dart';
import 'sheet_scaffold.dart';

/// C6 "Withdraw · confirm" bottom sheet. Resolves `true` when the user
/// confirms, `false` / `null` otherwise (D-04: re-applying is allowed until
/// the deadline, which the body says).
class WithdrawSheet extends StatelessWidget {
  const WithdrawSheet({super.key, required this.closesAt});

  final DateTime closesAt;

  static Future<bool?> show(
    BuildContext context, {
    required DateTime closesAt,
  }) => showModalBottomSheet<bool>(
    context: context,
    builder: (_) => WithdrawSheet(closesAt: closesAt),
  );

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final text = Theme.of(context).textTheme;

    return SheetScaffold(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Withdraw application?', style: text.headlineMedium),
            const SizedBox(height: 10),
            Text(
              'You can apply again until '
              '${EventFormats.deadlineStamp(closesAt)}.',
              style: text.bodyMedium?.copyWith(
                fontSize: 15,
                color: tokens.muted,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppButton(
              label: 'Withdraw',
              onPressed: () => Navigator.of(context).pop(true),
            ),
            const SizedBox(height: 6),
            AppButton(
              label: 'Keep application',
              variant: AppButtonVariant.ghost,
              size: AppButtonSize.medium,
              onPressed: () => Navigator.of(context).pop(false),
            ),
          ],
        ),
      ],
    );
  }
}
