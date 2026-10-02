import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../core/utils/app_dates.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/status_pill.dart';
import '../../models/event.dart';

/// An open event as the prototype draws it:
///
/// - [EventCard] (C1 list): 40-radius card, `MON 05 OCT` eyebrow + deadline
///   chip (blush + clock when urgent, outlined otherwise), 22/500 title,
///   `time · venue`, then a hairline divider with position chips and an ink
///   arrow button. Only positions matching the user's roles are listed.
/// - [EventCard.compact] (B1 carousel): 250 px wide, 32-radius, date in a
///   grey pill, 18/500 title, `time · venue`, blush deadline chip.
class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.event,
    required this.now,
    this.onTap,
  }) : _compact = false;

  const EventCard.compact({
    super.key,
    required this.event,
    required this.now,
    this.onTap,
  }) : _compact = true;

  final Event event;

  /// Injected so deadline copy is testable and consistent across a list.
  final DateTime now;
  final VoidCallback? onTap;
  final bool _compact;

  static const double compactWidth = 250;

  @override
  Widget build(BuildContext context) => _compact
      ? _Compact(event: event, now: now, onTap: onTap)
      : _List(event: event, now: now, onTap: onTap);
}

class _List extends StatelessWidget {
  const _List({required this.event, required this.now, this.onTap});

  final Event event;
  final DateTime now;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final text = Theme.of(context).textTheme;
    final deadline = AppDates.deadline(event.applyDeadline, now: now);

    return AppCard(
      radius: AppRadius.cardLarge,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppDates.dayStamp(event.date),
                style: tokens.eyebrow.copyWith(color: tokens.ink),
              ),
              if (event.isUrgent)
                StatusPill(
                  label: deadline,
                  icon: Icons.schedule,
                  tone: PillTone.accent,
                  small: true,
                )
              else
                StatusPill(
                  label: deadline,
                  tone: PillTone.outlined,
                  small: true,
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            event.title,
            style: text.titleLarge?.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              height: 1.2,
              letterSpacing: -0.44,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${event.timeRange} · ${event.venueName}',
            style: text.bodyMedium?.copyWith(color: tokens.muted),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.only(top: 14),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: tokens.line)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final p in event.matchingPositions)
                        _PositionChip(label: p.role.name),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: tokens.ink,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_outward,
                    size: 18,
                    color: tokens.surface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Compact extends StatelessWidget {
  const _Compact({required this.event, required this.now, this.onTap});

  final Event event;
  final DateTime now;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final text = Theme.of(context).textTheme;

    return SizedBox(
      width: EventCard.compactWidth,
      child: AppCard(
        padding: const EdgeInsets.all(20),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _PositionChip(
                  label: AppDates.dayStamp(event.date),
                  style: tokens.eyebrow.copyWith(
                    color: tokens.ink,
                    letterSpacing: 0.44,
                  ),
                  height: 28,
                ),
                Icon(Icons.arrow_outward, size: 18, color: tokens.ink),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              event.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: text.titleMedium?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.18,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${event.timeRange} · ${event.venueName}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: tokens.caption.copyWith(color: tokens.muted),
            ),
            const SizedBox(height: 14),
            StatusPill(
              label: AppDates.deadline(event.applyDeadline, now: now),
              icon: Icons.schedule,
              tone: PillTone.accent,
              small: true,
            ),
          ],
        ),
      ),
    );
  }
}

/// 30 px scaffold-grey pill (`Crew`, `Event Manager`); also the date pill on
/// the compact card.
class _PositionChip extends StatelessWidget {
  const _PositionChip({required this.label, this.style, this.height = 30});

  final String label;
  final TextStyle? style;
  final double height;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: tokens.background,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style:
            style ??
            Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: tokens.ink,
            ),
      ),
    );
  }
}
