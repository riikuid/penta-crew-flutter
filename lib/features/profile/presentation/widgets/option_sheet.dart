import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';

/// Single-choice picker as a bottom sheet (E2 Gender / Branch): handle,
/// 28 px title, then one 56 px row per option with a check on the selected
/// one. Resolves to the tapped option, or `null` when dismissed.
class OptionSheet<T> extends StatelessWidget {
  const OptionSheet({
    super.key,
    required this.title,
    required this.options,
    required this.label,
    this.selected,
  });

  final String title;
  final List<T> options;
  final String Function(T option) label;
  final T? selected;

  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required List<T> options,
    required String Function(T option) label,
    T? selected,
  }) => showModalBottomSheet<T>(
    context: context,
    builder: (context) => OptionSheet<T>(
      title: title,
      options: options,
      label: label,
      selected: selected,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(24, 12, 24, 24),
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
          const SizedBox(height: 14),
          for (final option in options)
            InkWell(
              onTap: () => Navigator.of(context).pop(option),
              borderRadius: BorderRadius.circular(AppRadius.input),
              child: SizedBox(
                height: AppSize.control,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(label(option), style: textTheme.bodyLarge),
                    ),
                    if (option == selected)
                      Icon(Icons.check, size: 20, color: tokens.ink),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
