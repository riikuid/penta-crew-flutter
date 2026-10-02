import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

class FloatingPillNavItem {
  const FloatingPillNavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

/// The floating bottom navigation from the prototype: a white pill with a
/// hairline border and soft shadow; the active item expands into an ink pill
/// showing icon + label, inactive items are icon-only 52×52 targets.
///
/// This draws only the bar. The shell positions it (20px from the sides,
/// above the home indicator) and owns [index].
class FloatingPillNav extends StatelessWidget {
  const FloatingPillNav({
    super.key,
    required this.items,
    required this.index,
    required this.onChanged,
  }) : assert(items.length >= 2, 'FloatingPillNav needs at least two items');

  final List<FloatingPillNavItem> items;
  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: ShapeDecoration(
        color: tokens.surface,
        shape: StadiumBorder(side: BorderSide(color: tokens.line)),
        shadows: [
          BoxShadow(
            color: tokens.ink.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var i = 0; i < items.length; i++)
            _NavItem(
              item: items[i],
              selected: i == index,
              onTap: i == index ? null : () => onChanged(i),
            ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final FloatingPillNavItem item;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final labelStyle = Theme.of(context).textTheme.labelLarge;

    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      inMutuallyExclusiveGroup: true,
      child: Material(
        color: selected ? tokens.ink : Colors.transparent,
        shape: const StadiumBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            alignment: Alignment.centerLeft,
            child: SizedBox(
              height: AppSize.row,
              child: Padding(
                padding: selected
                    ? const EdgeInsets.only(left: 16, right: 20)
                    : const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.icon,
                      size: 20,
                      color: selected ? tokens.surface : tokens.muted,
                    ),
                    if (selected) ...[
                      const SizedBox(width: 8),
                      Text(
                        item.label,
                        style: labelStyle?.copyWith(color: tokens.surface),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
