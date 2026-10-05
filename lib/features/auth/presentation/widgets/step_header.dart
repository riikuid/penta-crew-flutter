import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import 'circle_back_button.dart';

/// A4/A5 header: circle back button, one 4 px progress pill per step (gap 6,
/// completed and current pills are ink) and the `01 / 02` counter.
class StepHeader extends StatelessWidget {
  const StepHeader({
    super.key,
    required this.step,
    required this.total,
    required this.onBack,
  });

  /// 1-based current step.
  final int step;
  final int total;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Row(
      children: [
        CircleBackButton(onPressed: onBack),
        const SizedBox(width: 16),
        Expanded(
          child: Row(
            children: [
              for (var index = 1; index <= total; index++) ...[
                if (index > 1) const SizedBox(width: 6),
                Expanded(
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: index <= step ? tokens.ink : tokens.line,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 16),
        // Digits only, so the eyebrow style applies without uppercasing.
        Text('${_pad(step)} / ${_pad(total)}', style: tokens.eyebrow),
      ],
    );
  }

  static String _pad(int value) => value.toString().padLeft(2, '0');
}
