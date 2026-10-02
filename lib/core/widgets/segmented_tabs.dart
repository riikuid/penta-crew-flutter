import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

/// Two-or-more way pill switch on a hairline-grey track (Open / Tracked,
/// Upcoming / History). Purely presentational: the parent owns [index].
class SegmentedTabs extends StatelessWidget {
  const SegmentedTabs({
    super.key,
    required this.labels,
    required this.index,
    required this.onChanged,
  }) : assert(labels.length >= 2, 'SegmentedTabs needs at least two labels');

  final List<String> labels;
  final int index;
  final ValueChanged<int> onChanged;

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
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: Semantics(
                button: true,
                selected: i == index,
                inMutuallyExclusiveGroup: true,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: i == index ? null : () => onChanged(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOut,
                    height: AppSize.tab,
                    alignment: Alignment.center,
                    decoration: ShapeDecoration(
                      color: i == index ? tokens.ink : Colors.transparent,
                      shape: const StadiumBorder(),
                    ),
                    child: Text(
                      labels[i],
                      style: labelStyle?.copyWith(
                        color: i == index ? tokens.surface : tokens.ink,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
