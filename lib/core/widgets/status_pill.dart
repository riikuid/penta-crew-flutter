import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

/// Fill/outline treatments a pill can have. The prototype never uses green
/// for positive states: "Selected"/"Verified" are solid ink, "Waiting" is
/// blush, negatives are hairline-outlined in muted, and only "Not approved"
/// (admin rejection) borrows the error red.
enum PillTone {
  /// Ink fill, white text.
  ink,

  /// Blush fill, ink text.
  accent,

  /// White fill, ink text — used on top of blush/ink cards.
  surface,

  /// Scaffold-grey fill — "Completed" in History.
  sunken,

  /// Hairline border, muted text — "Not selected", deadline chips.
  outlined,

  /// Error border and text — "Not approved".
  outlinedError,
}

/// 28px (or 26px when [small]) uppercase pill with an optional 14/12px icon.
///
/// Prefer the named constructors for domain states so copy and icon stay
/// consistent across Events, Schedule and Profile; use the default
/// constructor for one-off chips (deadline, position, role).
class StatusPill extends StatelessWidget {
  const StatusPill({
    super.key,
    required this.label,
    this.icon,
    this.tone = PillTone.outlined,
    this.small = false,
  });

  /// Application accepted / crew confirmed; also the profile "Verified" badge.
  const StatusPill.selected({super.key, this.small = false})
    : label = 'Selected',
      icon = Icons.check,
      tone = PillTone.ink;

  const StatusPill.verified({super.key, this.small = false})
    : label = 'Verified',
      icon = Icons.check,
      tone = PillTone.ink;

  /// Application submitted, selection still open. Pass [onAccent] when the
  /// pill sits on a blush card so it flips to a white fill.
  const StatusPill.waiting({
    super.key,
    this.label = 'Waiting for selection',
    this.small = false,
    bool onAccent = false,
  }) : icon = Icons.schedule,
       tone = onAccent ? PillTone.surface : PillTone.accent;

  const StatusPill.notSelected({super.key, this.small = false})
    : label = 'Not selected',
      icon = Icons.close,
      tone = PillTone.outlined;

  const StatusPill.notApproved({super.key, this.small = false})
    : label = 'Not approved',
      icon = Icons.close,
      tone = PillTone.outlinedError;

  const StatusPill.completed({super.key, this.small = false})
    : label = 'Completed',
      icon = Icons.check,
      tone = PillTone.sunken;

  final String label;
  final IconData? icon;
  final PillTone tone;

  /// 26px high, 10px text, 12px icon — list rows and dense cards.
  final bool small;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final (Color? background, Color? border, Color foreground) = switch (tone) {
      PillTone.ink => (tokens.ink, null, tokens.surface),
      PillTone.accent => (tokens.accent, null, tokens.ink),
      PillTone.surface => (tokens.surface, null, tokens.ink),
      PillTone.sunken => (tokens.background, null, tokens.ink),
      PillTone.outlined => (null, tokens.line, tokens.muted),
      PillTone.outlinedError => (null, tokens.error, tokens.error),
    };
    final style = (small ? tokens.eyebrowSmall : tokens.eyebrow).copyWith(
      color: foreground,
    );

    return Container(
      height: small ? 26 : 28,
      padding: EdgeInsets.symmetric(horizontal: small ? 10 : 12),
      decoration: ShapeDecoration(
        color: background,
        shape: StadiumBorder(
          side: border == null ? BorderSide.none : BorderSide(color: border),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: small ? 12 : 14, color: foreground),
            const SizedBox(width: 6),
          ],
          Text(label.toUpperCase(), style: style),
        ],
      ),
    );
  }
}
