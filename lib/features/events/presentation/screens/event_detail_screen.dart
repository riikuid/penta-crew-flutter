import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../core/utils/app_dates.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/eyebrow.dart';
import '../../../../core/widgets/progress_timeline.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../core/widgets/status_pill.dart';
import '../../../../core/widgets/tag_chip.dart';
import '../../events_routes.dart';
import '../../models/application.dart';
import '../../models/cannot_apply_reason.dart';
import '../../models/event_detail.dart';
import '../../models/event_position.dart';
import '../cubit/event_detail_cubit.dart';
import '../cubit/event_detail_state.dart';
import '../event_detail_view.dart';
import '../event_formats.dart';
import '../widgets/apply_sheet.dart';
import '../widgets/withdraw_sheet.dart';

/// Event detail, root-level (no pill nav): back circle + `{branch} branch`
/// header, then one of the six layouts C3 / C5 / C7 / C8 / C9 derived from
/// the `EventDetail` (`EventDetailViewX.view`). Apply opens the C4 sheet,
/// withdraw the C6 sheet; outcomes arrive as toasts via the cubit's notice.
///
/// Expects an `EventDetailCubit` above it (provided by the route).
class EventDetailScreen extends StatelessWidget {
  const EventDetailScreen({super.key, this.now});

  /// Reference time for "3 days left"; defaults to `DateTime.now()`.
  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EventDetailCubit, EventDetailState>(
      listenWhen: (previous, next) =>
          next is EventDetailLoaded &&
          next.notice != null &&
          !(previous is EventDetailLoaded &&
              identical(previous.notice, next.notice)),
      listener: (_, state) => _showNotice((state as EventDetailLoaded).notice!),
      builder: (context, state) => switch (state) {
        EventDetailInitial() ||
        EventDetailLoading() => const _Frame(body: _DetailSkeleton()),
        EventDetailError(:final message) => _Frame(
          body: ErrorView(
            message: message,
            onRetry: context.read<EventDetailCubit>().retry,
          ),
        ),
        EventDetailLoaded(:final detail, :final busy) => _Loaded(
          detail: detail,
          busy: busy,
          now: now ?? DateTime.now(),
        ),
      },
    );
  }

  void _showNotice(EventDetailNotice notice) => switch (notice) {
    ApplicationSent(:final roleName, :final eventTitle) => AppToast.success(
      'Application sent',
      description: 'Applied as $roleName for $eventTitle.',
    ),
    ApplicationWithdrawn(:final reapplyUntil) => AppToast.success(
      'Application withdrawn',
      description:
          'You can apply again until '
          '${EventFormats.deadlineStamp(reapplyUntil)}.',
    ),
    ActionFailed(:final message) => AppToast.error(message),
  };
}

/// Scaffold + header shared by every state; [bottom] is the fixed action
/// bar (C3 / C5 / C9) or nothing (C7 / C8).
class _Frame extends StatelessWidget {
  const _Frame({required this.body, this.branchName, this.bottom});

  final Widget body;
  final String? branchName;
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Header(branchName: branchName),
            Expanded(child: body),
            ?bottom,
          ],
        ),
      ),
    );
  }
}

/// 44 px white back circle on the left, `JAKARTA BRANCH` eyebrow on the
/// right (prototype C3 :712-715).
class _Header extends StatelessWidget {
  const _Header({required this.branchName});

  final String? branchName;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Material(
            color: tokens.surface,
            shape: CircleBorder(side: BorderSide(color: tokens.line)),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => _back(context),
              child: SizedBox.square(
                dimension: AppSize.tab,
                child: Icon(Icons.arrow_back, size: 20, color: tokens.ink),
              ),
            ),
          ),
          if (branchName != null) Eyebrow('$branchName branch'),
        ],
      ),
    );
  }

  void _back(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      // Deep link / push notification: nothing underneath, go to the tab.
      context.go(EventsRoutes.root);
    }
  }
}

/// Shapes of the C3 page while the detail loads: headline line, the blush
/// date hero, the deadline card, the positions card.
class _DetailSkeleton extends StatelessWidget {
  const _DetailSkeleton();

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        const Skeleton(width: 300, height: 36),
        const SizedBox(height: 8),
        const Skeleton(width: 190, height: 36),
        const SizedBox(height: 20),
        Skeleton.card(height: 260, color: tokens.accent.withValues(alpha: 0.7)),
        const SizedBox(height: 20),
        Skeleton(
          height: 72,
          radius: AppRadius.note,
          color: tokens.surface,
          borderColor: tokens.line,
        ),
        const SizedBox(height: 20),
        Skeleton(
          height: 200,
          radius: AppRadius.card,
          color: tokens.surface,
          borderColor: tokens.line,
        ),
      ],
    );
  }
}

/// Picks the layout for a loaded detail and owns the apply / withdraw
/// interactions.
class _Loaded extends StatelessWidget {
  const _Loaded({required this.detail, required this.busy, required this.now});

  final EventDetail detail;
  final bool busy;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final view = detail.view;
    final application = detail.myApplication;

    return _Frame(
      branchName: detail.branch?.name,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: switch (view) {
          EventDetailView.open => _buildOpen(context),
          EventDetailView.applied => _buildWaiting(context, application!),
          EventDetailView.closedWaiting => _buildWaiting(context, application!),
          EventDetailView.selected => _buildSelected(context, application!),
          EventDetailView.notSelected => _buildNotSelected(
            context,
            application!,
          ),
        },
      ),
      bottom: switch (view) {
        EventDetailView.open when !detail.isClosed => _ActionBar(
          button: AppButton(
            label: 'Apply',
            loading: busy,
            onPressed: detail.canApply ? () => _onApply(context) : null,
          ),
          footnote: _applyFootnote(detail.cannotApplyReason),
        ),
        EventDetailView.applied => _ActionBar(
          button: AppButton(
            label: 'Withdraw application',
            variant: AppButtonVariant.outlinedInk,
            loading: busy,
            onPressed: () => _onWithdraw(context, application!),
          ),
        ),
        EventDetailView.notSelected => _ActionBar(
          button: AppButton(
            label: 'Browse open events',
            variant: AppButtonVariant.secondary,
            onPressed: () => context.go(EventsRoutes.open),
          ),
        ),
        _ => null,
      },
    );
  }

  // ── C3 ──────────────────────────────────────────────────────────────────

  List<Widget> _buildOpen(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return [
      Text(detail.title, style: text.displaySmall),
      const SizedBox(height: 20),
      _DateHero(detail: detail),
      const SizedBox(height: 20),
      _DeadlineCard(detail: detail, now: now),
      const SizedBox(height: 20),
      _Section(
        title: 'Positions',
        child: _PositionsCard(positions: detail.positions),
      ),
      if (detail.requirements.isNotEmpty || detail.description != null) ...[
        const SizedBox(height: 20),
        _Section(
          title: 'Requirements',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (detail.requirements.isNotEmpty)
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final requirement in detail.requirements)
                      TagChip(
                        label: requirement,
                        tone: TagChipTone.outlined,
                        height: 32,
                      ),
                  ],
                ),
              if (detail.description != null) ...[
                if (detail.requirements.isNotEmpty) const SizedBox(height: 12),
                Text(
                  detail.description!,
                  style: text.bodyMedium?.copyWith(
                    height: 1.55,
                    color: context.tokens.muted,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    ];
  }

  /// Under the Apply button: the neutral line, or why Apply is disabled.
  String _applyFootnote(CannotApplyReason? reason) => switch (reason) {
    null => "Can't make it? You don't need to do anything.",
    CannotApplyReason.dateConflict => "You're already booked on this date.",
    CannotApplyReason.noMatchingRole =>
      'None of these positions match your roles.',
    CannotApplyReason.notVerified =>
      'Your profile needs to be approved before you can apply.',
    CannotApplyReason.alreadyApplied => "You've already applied to this event.",
    CannotApplyReason.closed =>
      "Applications closed. This can't be changed now.",
    CannotApplyReason.unknown => "You can't apply to this event.",
  };

  Future<void> _onApply(BuildContext context) async {
    final cubit = context.read<EventDetailCubit>();
    final positionId = await ApplySheet.show(context, detail: detail);
    if (positionId == null) return;
    await cubit.apply(positionId);
  }

  // ── C5 / C7 ─────────────────────────────────────────────────────────────

  List<Widget> _buildWaiting(BuildContext context, Application application) {
    final text = Theme.of(context).textTheme;
    final closed = detail.isClosed;
    return [
      Text(detail.title, style: text.displaySmall),
      const SizedBox(height: 20),
      _StatusCard(
        tone: closed ? AppCardTone.surface : AppCardTone.accent,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: StatusPill.waiting(onAccent: !closed),
          ),
          const SizedBox(height: 16),
          Text(
            'Applied as ${application.appliedPosition.role.name}',
            style: text.titleLarge,
          ),
          const SizedBox(height: 16),
          ProgressTimeline.bar(
            steps: [
              TimelineStep(
                label: EventFormats.appliedStamp(application.appliedAt),
                state: TimelineStepState.done,
              ),
              TimelineStep(
                label: closed
                    ? EventFormats.closed(application.closesAt)
                    : EventFormats.closes(application.closesAt),
                state: closed
                    ? TimelineStepState.done
                    : TimelineStepState.upcoming,
              ),
              const TimelineStep(
                label: 'Result',
                state: TimelineStepState.upcoming,
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (closed)
            const _LockNote()
          else
            Text(
              "You'll get a notification when the admin picks the crew.",
              style: text.bodySmall,
            ),
        ],
      ),
      const SizedBox(height: 20),
      _InfoRows(detail: detail, timeLine: _timeWithHours()),
    ];
  }

  Future<void> _onWithdraw(
    BuildContext context,
    Application application,
  ) async {
    final cubit = context.read<EventDetailCubit>();
    final confirmed = await WithdrawSheet.show(
      context,
      closesAt: application.closesAt,
    );
    if (confirmed != true) return;
    await cubit.withdraw();
  }

  // ── C8 ──────────────────────────────────────────────────────────────────

  List<Widget> _buildSelected(BuildContext context, Application application) {
    final tokens = context.tokens;
    final text = Theme.of(context).textTheme;
    final roleName = application.position.role.name;
    final briefing = detail.briefingTime;
    return [
      AppCard(
        tone: AppCardTone.accent,
        radius: AppRadius.cardLarge,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const StatusPill.selected(),
            const SizedBox(height: 16),
            Text("You're on the crew.", style: text.displaySmall),
            const SizedBox(height: 16),
            Text(
              'Confirmed as $roleName for ${detail.title}. '
              "It's now in your schedule.",
              style: text.bodyMedium,
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      AppCard(
        padding: const EdgeInsets.all(20),
        child: _InfoRows(
          detail: detail,
          timeLine:
              '${detail.timeRange}'
              '${briefing == null ? '' : ' · BRIEFING $briefing'}',
          timeStyle: tokens.eyebrow.copyWith(
            fontWeight: FontWeight.w500,
            letterSpacing: 0,
          ),
        ),
      ),
      if (detail.adminNote != null) ...[
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Eyebrow('Notes from admin'),
              const SizedBox(height: 10),
              Text(
                detail.adminNote!,
                style: text.bodyMedium?.copyWith(height: 1.55),
              ),
            ],
          ),
        ),
      ],
    ];
  }

  // ── C9 ──────────────────────────────────────────────────────────────────

  List<Widget> _buildNotSelected(
    BuildContext context,
    Application application,
  ) {
    final text = Theme.of(context).textTheme;
    return [
      Text(detail.title, style: text.displaySmall),
      const SizedBox(height: 20),
      _StatusCard(
        tone: AppCardTone.surface,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: StatusPill.notSelected(),
          ),
          const SizedBox(height: 14),
          Text(
            'All positions for this event have been filled. Thanks for '
            'applying as ${application.appliedPosition.role.name}.',
            style: text.bodyLarge,
          ),
        ],
      ),
      const SizedBox(height: 20),
      _InfoRows(detail: detail, timeLine: detail.timeRange),
    ];
  }

  /// `14:00–20:00 · 6 hours`, or just the range when hours are unknown.
  String _timeWithHours() {
    final hours = detail.durationHours;
    if (hours == null) return detail.timeRange;
    return '${detail.timeRange} · ${EventFormats.hours(hours)}';
  }
}

/// Fixed bottom bar (prototype :750): hairline top border, page background,
/// the one action and an optional 13 px centred footnote.
class _ActionBar extends StatelessWidget {
  const _ActionBar({required this.button, this.footnote});

  final Widget button;
  final String? footnote;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: BoxDecoration(
        color: tokens.background,
        border: Border(top: BorderSide(color: tokens.line)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          button,
          if (footnote != null) ...[
            const SizedBox(height: 8),
            Text(footnote!, style: tokens.caption, textAlign: TextAlign.center),
          ],
        ],
      ),
    );
  }
}

/// C3 blush hero: 80 px day numeral, `OCT 2026` / `MONDAY`, then the time
/// and venue rows under a soft divider.
class _DateHero extends StatelessWidget {
  const _DateHero({required this.detail});

  final EventDetail detail;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final text = Theme.of(context).textTheme;
    final hours = detail.durationHours;
    final timeLine = hours == null
        ? detail.timeRange
        : '${detail.timeRange} · ${EventFormats.hours(hours)}';
    final smallCaps = tokens.eyebrow.copyWith(fontSize: 12, color: tokens.ink);

    return AppCard(
      tone: AppCardTone.accent,
      radius: AppRadius.cardLarge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(AppDates.dayNumber(detail.date), style: tokens.counter),
              const SizedBox(width: 14),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      EventFormats.monthYear(detail.date).toUpperCase(),
                      style: smallCaps,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      EventFormats.weekdayLong(detail.date).toUpperCase(),
                      style: smallCaps.copyWith(color: tokens.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.only(top: 16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: tokens.ink.withValues(alpha: 0.12)),
              ),
            ),
            child: Column(
              children: [
                _IconRow(
                  icon: Icons.schedule,
                  iconColor: tokens.ink,
                  primary: Text(timeLine, style: text.bodyMedium),
                ),
                const SizedBox(height: 12),
                _IconRow(
                  icon: Icons.place_outlined,
                  iconColor: tokens.ink,
                  primary: Text(detail.venueName, style: text.bodyMedium),
                  secondary: detail.venueAddress,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// `Apply by Mon, 28 Sep · 18:00` + `3 DAYS LEFT` (prototype :728-731).
class _DeadlineCard extends StatelessWidget {
  const _DeadlineCard({required this.detail, required this.now});

  final EventDetail detail;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final text = Theme.of(context).textTheme;
    final sub = detail.isClosed
        ? EventFormats.closed(detail.applyDeadline)
        : EventFormats.daysLeft(detail.applyDeadline, now: now);

    return AppCard(
      radius: AppRadius.note,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: tokens.ink,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.hourglass_empty, size: 18, color: tokens.surface),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Apply by ${EventFormats.deadlineStamp(detail.applyDeadline)}',
                  style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 2),
                Eyebrow(sub),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// `Positions` / `Requirements` heading (20/500) + content.
class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 12),
      child,
    ],
  );
}

/// White card listing every position; rows that do not match the user's
/// roles are muted with a lock (prototype :734-738).
class _PositionsCard extends StatelessWidget {
  const _PositionsCard({required this.positions});

  final List<EventPosition> positions;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Column(
        children: [
          for (final (index, position) in positions.indexed)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: index == positions.length - 1
                  ? null
                  : BoxDecoration(
                      border: Border(bottom: BorderSide(color: tokens.line)),
                    ),
              child: _PositionRow(position: position),
            ),
        ],
      ),
    );
  }
}

class _PositionRow extends StatelessWidget {
  const _PositionRow({required this.position});

  final EventPosition position;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final text = Theme.of(context).textTheme;
    final matches = position.matchesMyRole;
    final foreground = matches ? tokens.ink : tokens.muted;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (!matches) ...[
                    Icon(Icons.lock_outline, size: 14, color: foreground),
                    const SizedBox(width: 6),
                  ],
                  Flexible(
                    child: Text(
                      position.role.name,
                      style: text.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: foreground,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                matches ? 'Matches your role' : 'Not one of your roles',
                style: tokens.caption,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          EventFormats.needed(position.needed).toUpperCase(),
          style: tokens.eyebrow.copyWith(
            fontSize: 12,
            letterSpacing: 0,
            color: foreground,
          ),
        ),
      ],
    );
  }
}

/// C5/C7/C9 status card: 40-radius, blush (C5) or white with a border.
class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.tone, required this.children});

  final AppCardTone tone;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => AppCard(
    tone: tone,
    radius: AppRadius.cardLarge,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    ),
  );
}

/// C7: `Applications closed. This can't be changed now.` on the page grey.
class _LockNote extends StatelessWidget {
  const _LockNote();

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: tokens.background,
        borderRadius: BorderRadius.circular(AppRadius.input),
      ),
      child: Row(
        children: [
          Icon(Icons.lock_outline, size: 16, color: tokens.muted),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "Applications closed. This can't be changed now.",
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: tokens.muted),
            ),
          ),
        ],
      ),
    );
  }
}

/// Date + venue rows with muted icons (C5/C7/C8/C9).
class _InfoRows extends StatelessWidget {
  const _InfoRows({
    required this.detail,
    required this.timeLine,
    this.timeStyle,
  });

  final EventDetail detail;

  /// Second line under the date: `14:00–20:00 · 6 hours` or the C8
  /// `14:00–20:00 · BRIEFING 13:00`.
  final String timeLine;
  final TextStyle? timeStyle;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          _IconRow(
            icon: Icons.calendar_today_outlined,
            iconColor: tokens.muted,
            primary: Text(AppDates.long(detail.date), style: text.bodyMedium),
            secondary: timeLine,
            secondaryStyle: timeStyle,
          ),
          const SizedBox(height: 14),
          _IconRow(
            icon: Icons.place_outlined,
            iconColor: tokens.muted,
            primary: Text(detail.venueName, style: text.bodyMedium),
            secondary: detail.venueAddress,
          ),
        ],
      ),
    );
  }
}

/// 18 px icon, 12 px gap, a primary line and an optional 13 px muted line.
class _IconRow extends StatelessWidget {
  const _IconRow({
    required this.icon,
    required this.iconColor,
    required this.primary,
    this.secondary,
    this.secondaryStyle,
  });

  final IconData icon;
  final Color iconColor;
  final Widget primary;
  final String? secondary;
  final TextStyle? secondaryStyle;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              primary,
              if (secondary != null) ...[
                const SizedBox(height: 2),
                Text(secondary!, style: secondaryStyle ?? tokens.caption),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
