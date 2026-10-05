import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';

/// E3 live checklist: white card (radius 24, padding 18 20), one 14 px row
/// per rule with a 22 px circle — ink with a check when the rule passes,
/// 2 px hairline ring otherwise. Rules are the contract's password policy
/// (§2: min 8 chars, one digit) plus the confirmation match.
class PasswordRulesCard extends StatelessWidget {
  const PasswordRulesCard({
    super.key,
    required this.hasMinLength,
    required this.hasNumber,
    required this.matches,
  });

  final bool hasMinLength;
  final bool hasNumber;
  final bool matches;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(AppRadius.note),
        border: Border.all(color: tokens.line),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _RuleRow(label: 'At least 8 characters', passed: hasMinLength),
            const SizedBox(height: 12),
            _RuleRow(label: 'Contains a number', passed: hasNumber),
            const SizedBox(height: 12),
            _RuleRow(label: 'Both new passwords match', passed: matches),
          ],
        ),
      ),
    );
  }
}

class _RuleRow extends StatelessWidget {
  const _RuleRow({required this.label, required this.passed});

  final String label;
  final bool passed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Row(
      children: [
        SizedBox.square(
          dimension: 22,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: passed ? tokens.ink : null,
              border: passed ? null : Border.all(color: tokens.line, width: 2),
            ),
            child: passed
                ? Icon(Icons.check, size: 12, color: tokens.surface)
                : null,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodySmall),
        ),
      ],
    );
  }
}
