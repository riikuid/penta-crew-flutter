import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

/// Two-or-more way pill switch on a hairline-grey track (Open / Tracked,
/// Upcoming / History). Purely presentational: the parent owns [index].
///
/// Pass [counts] to show the C1/C2 counter after each label (`Open 03`):
/// 11 px, 8 px gap, the label colour at 70 % on the active tab and muted on
/// the others. A `null` entry leaves that tab without a count.
class SegmentedTabs extends StatelessWidget {
  const SegmentedTabs({
    super.key,
    required this.labels,
    required this.index,
    required this.onChanged,
    this.counts,
  }) : assert(labels.length >= 2, 'SegmentedTabs needs at least two labels'),
       assert(
         counts == null || counts.length == labels.length,
         'SegmentedTabs counts must line up with labels',
       );

  final List<String> labels;
  final int index;
  final ValueChanged<int> onChanged;

  /// One entry per label, already formatted (`'03'`), or `null` for none.
  final List<String?>? counts;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final labelStyle = Theme.of(context).textTheme.labelLarge;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: ShapeDecoration(
        color: tokens.line,
        shape: const StadiumBorder(),
      ),
      child: Row(
        children: [
          for (var tabIndex = 0; tabIndex < labels.length; tabIndex++)
            Expanded(
              child: _Tab(
                label: labels[tabIndex],
                count: counts?[tabIndex],
                selected: tabIndex == index,
                onTap: tabIndex == index ? null : () => onChanged(tabIndex),
                labelStyle: labelStyle,
              ),
            ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
    required this.labelStyle,
  });

  final String label;
  final String? count;
  final bool selected;
  final VoidCallback? onTap;
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final foreground = selected ? tokens.surface : tokens.ink;

    return Semantics(
      button: true,
      selected: selected,
      inMutuallyExclusiveGroup: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          height: AppSize.tab,
          alignment: Alignment.center,
          decoration: ShapeDecoration(
            color: selected ? tokens.ink : Colors.transparent,
            shape: const StadiumBorder(),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, style: labelStyle?.copyWith(color: foreground)),
              if (count != null) ...[
                const SizedBox(width: 8),
                Text(
                  count!,
                  style: labelStyle?.copyWith(
                    fontSize: 11,
                    color: selected
                        ? foreground.withValues(alpha: 0.7)
                        : tokens.muted,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
