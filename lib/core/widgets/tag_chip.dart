import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

/// Fill treatments for a [TagChip].
enum TagChipTone {
  /// Scaffold-grey fill, ink text — position chips on event cards (`Crew`).
  sunken,

  /// Blush fill, ink text — the position you applied for (`as Crew`).
  accent,

  /// White fill, hairline border, ink text — role tags on the profile.
  outlined,
}

/// Natural-case pill for roles, positions and dates (`Crew`, `as Crew`,
/// `Usher`, `MON 05 OCT`). Unlike `StatusPill` it never uppercases its label,
/// so it is the chip for anything that is not a status.
///
/// Heights from the prototype: 26 (12/500 — dense rows), 30 (card position
/// chips) and 32 (profile role tags), the latter two at 13/500; anything
/// under 30 takes the 12 px text. Pass [style] to override the text entirely
/// (the compact card's 28 px eyebrow-style date pill).
class TagChip extends StatelessWidget {
  const TagChip({
    super.key,
    required this.label,
    this.tone = TagChipTone.sunken,
    this.height = 30,
    this.style,
  });

  final String label;
  final TagChipTone tone;
  final double height;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final (Color background, Color? border) = switch (tone) {
      TagChipTone.sunken => (tokens.background, null),
      TagChipTone.accent => (tokens.accent, null),
      TagChipTone.outlined => (tokens.surface, tokens.line),
    };
    final textStyle =
        style ??
        Theme.of(context).textTheme.labelMedium?.copyWith(
          fontSize: height < 30 ? 12 : 13,
          fontWeight: FontWeight.w500,
          color: tokens.ink,
        );

    return Container(
      height: height,
      padding: EdgeInsets.symmetric(horizontal: height < 30 ? 10 : 12),
      alignment: Alignment.center,
      decoration: ShapeDecoration(
        color: background,
        shape: StadiumBorder(
          side: border == null ? BorderSide.none : BorderSide(color: border),
        ),
      ),
      child: Text(label, style: textStyle),
    );
  }
}
