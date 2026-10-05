import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../core/utils/app_dates.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/eyebrow.dart';
import '../../../../core/widgets/segmented_tabs.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../core/widgets/status_pill.dart';
import '../../../../core/widgets/tag_chip.dart';
import '../../../events/events_routes.dart';
import '../../../events/models/application.dart';
import '../../../events/models/event.dart';
import '../../models/history_summary.dart';
import '../../models/month_group.dart';
import '../cubit/history_cubit.dart';
import '../cubit/history_state.dart';
import '../cubit/upcoming_cubit.dart';
import '../cubit/upcoming_state.dart';

/// Prototype D screens use a 20 px gutter (the pill nav's inset), not the
/// 24 px form padding.
const double _gutter = 20;

/// Vertical rhythm of the D screens: 18 between every block.
const double _gap = 18;

/// Schedule tab: D1 Upcoming (grouped by month, first item "Next"), D2
/// History (worked counter + dense rows), D3 empty. Expects an
/// [UpcomingCubit] and a [HistoryCubit] above it (see `schedule_routes.dart`);
/// both stay alive while the segmented tabs switch.
class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key, this.clock = DateTime.now});

  /// Injected so "Next · in 8 days" is testable.
  final DateTime Function() clock;

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  static const _tabs = ['Upcoming', 'History'];

  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final header = _PageHeader(
      labels: _tabs,
      index: _tabIndex,
      onChanged: _onTabChanged,
    );
    return Scaffold(
      body: _tabIndex == 0
          ? _UpcomingTab(header: header, now: widget.clock())
          : _HistoryTab(header: header),
    );
  }

  void _onTabChanged(int index) => setState(() => _tabIndex = index);
}

/// Eyebrow + headline + segmented tabs; scrolls with each tab's list.
class _PageHeader extends StatelessWidget {
  const _PageHeader({
    required this.labels,
    required this.index,
    required this.onChanged,
  });

  final List<String> labels;
  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Eyebrow('Confirmed shifts'),
        const SizedBox(height: 6),
        Text('Schedule', style: tokens.display),
        const SizedBox(height: _gap),
        SegmentedTabs(labels: labels, index: index, onChanged: onChanged),
      ],
    );
  }
}

/// Pull-to-refresh scroll view shared by both tabs: the page header, then
/// the tab's own slivers, then clearance for the pill nav (the shell adds the
/// nav's footprint to `MediaQuery.padding.bottom`).
class _TabScrollView extends StatelessWidget {
  const _TabScrollView({
    required this.controller,
    required this.onRefresh,
    required this.header,
    required this.slivers,
  });

  final ScrollController controller;
  final Future<void> Function() onRefresh;
  final Widget header;
  final List<Widget> slivers;

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.paddingOf(context);
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: CustomScrollView(
        controller: controller,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(_gutter, padding.top + 16, _gutter, 0),
            sliver: SliverToBoxAdapter(child: header),
          ),
          ...slivers,
          SliverPadding(padding: EdgeInsets.only(bottom: padding.bottom + 24)),
        ],
      ),
    );
  }
}

/// Tabs scroll their list body; load more when the end comes within reach.
const double _loadMoreThreshold = 300;

// ── Upcoming (D1 / D3) ──────────────────────────────────────────────────────

class _UpcomingTab extends StatefulWidget {
  const _UpcomingTab({required this.header, required this.now});

  final Widget header;
  final DateTime now;

  @override
  State<_UpcomingTab> createState() => _UpcomingTabState();
}

class _UpcomingTabState extends State<_UpcomingTab> {
  final _scroll = ScrollController();

  UpcomingCubit get _cubit => context.read<UpcomingCubit>();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpcomingCubit, UpcomingState>(
      // Error while data is on screen → toast only, list stays.
      listenWhen: (_, next) => next is UpcomingError && next.groups.isNotEmpty,
      listener: (_, state) => AppToast.error((state as UpcomingError).message),
      // That same transient error is restored to `loaded` right after,
      // so skip rebuilding for it.
      buildWhen: (_, next) => next is! UpcomingError || next.groups.isEmpty,
      builder: (context, state) => _TabScrollView(
        controller: _scroll,
        onRefresh: _cubit.refresh,
        header: widget.header,
        slivers: [
          switch (state) {
            UpcomingInitial() ||
            UpcomingLoading() => _bodySliver(const _UpcomingSkeleton()),
            UpcomingError(:final message) => SliverToBoxAdapter(
              child: ErrorView(message: message, onRetry: _cubit.retry),
            ),
            UpcomingLoaded(:final groups) when groups.isEmpty =>
              SliverToBoxAdapter(child: _buildEmpty(context)),
            UpcomingLoaded(:final groups, :final isLoadingMore) => _bodySliver(
              _buildGroups(context, groups, state.next, isLoadingMore),
            ),
          },
        ],
      ),
    );
  }

  Widget _bodySliver(Widget child) => SliverPadding(
    padding: const EdgeInsets.fromLTRB(_gutter, _gap, _gutter, 0),
    sliver: SliverToBoxAdapter(child: child),
  );

  Widget _buildGroups(
    BuildContext context,
    List<MonthGroup> groups,
    Application? next,
    bool isLoadingMore,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final group in groups) ...[
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: _gap),
            child: Eyebrow(group.label),
          ),
          for (final application in group.items) ...[
            _UpcomingRow(
              application: application,
              isNext: application.id == next?.id,
              now: widget.now,
              onTap: () => _openDetail(context, application),
            ),
            const SizedBox(height: _gap),
          ],
        ],
        if (isLoadingMore) const _UpcomingRowSkeleton(),
      ],
    );
  }

  Widget _buildEmpty(BuildContext context) => EmptyView(
    icon: Icons.event_available_outlined,
    title: 'No confirmed events.',
    message:
        "Events you're selected for will appear here. "
        'Pending applications stay in Events › Tracked.',
    action: AppButton(
      label: 'Browse events',
      onPressed: () => context.go(EventsRoutes.root),
      variant: AppButtonVariant.secondary,
      size: AppButtonSize.medium,
      expand: false,
    ),
  );

  void _onScroll() {
    if (!_scroll.hasClients) return;
    if (_scroll.position.extentAfter < _loadMoreThreshold) _cubit.loadMore();
  }

  void _openDetail(BuildContext context, Application application) {
    final event = application.event;
    if (event != null) context.push(EventsRoutes.detail(event.id));
  }
}

/// D1 row: 52-wide date rail, then the shift card — blush with a
/// `Next · in 8 days` eyebrow for the first item, white with `Confirmed`
/// for the rest.
class _UpcomingRow extends StatelessWidget {
  const _UpcomingRow({
    required this.application,
    required this.isNext,
    required this.now,
    required this.onTap,
  });

  final Application application;
  final bool isNext;
  final DateTime now;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Grouping already dropped applications without an event.
    final event = application.event!;
    final tokens = context.tokens;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 52, child: _buildDateRail(event, tokens)),
        const SizedBox(width: 16),
        Expanded(
          child: AppCard(
            tone: isNext ? AppCardTone.accent : AppCardTone.surface,
            padding: const EdgeInsets.all(20),
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Eyebrow(
                      isNext ? _nextLabel(event.date) : 'Confirmed',
                      small: true,
                      color: isNext ? tokens.ink : null,
                    ),
                    Icon(Icons.arrow_outward, size: 16, color: tokens.ink),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  event.title,
                  style: textTheme.titleMedium?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.18,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${event.timeRange} · ${event.venueName}',
                  style: tokens.caption,
                ),
                const SizedBox(height: 10),
                TagChip(
                  label: 'as ${application.position.role.name}',
                  height: 26,
                  // White on the blush card, scaffold-grey on white cards.
                  tone: isNext ? TagChipTone.outlined : TagChipTone.sunken,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateRail(Event event, AppTokens tokens) => Padding(
    padding: const EdgeInsets.only(top: 18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppDates.dayNumber(event.date),
          style: tokens.numeral.copyWith(
            fontSize: 36,
            fontWeight: FontWeight.w500,
            height: 0.9,
            letterSpacing: -0.04 * 36,
          ),
        ),
        const SizedBox(height: 4),
        Eyebrow(AppDates.weekday(event.date)),
      ],
    ),
  );

  String _nextLabel(DateTime date) {
    final days = AppDates.daysUntil(date, now: now);
    return switch (days) {
      0 => 'Next · today',
      1 => 'Next · tomorrow',
      _ => 'Next · in $days days',
    };
  }
}

/// Month eyebrow + two card-shaped rows while page 1 loads.
class _UpcomingSkeleton extends StatelessWidget {
  const _UpcomingSkeleton();

  @override
  Widget build(BuildContext context) => const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.only(top: 8, bottom: _gap),
        child: Skeleton.line(width: 150, height: 11),
      ),
      _UpcomingRowSkeleton(),
      SizedBox(height: _gap),
      _UpcomingRowSkeleton(),
    ],
  );
}

class _UpcomingRowSkeleton extends StatelessWidget {
  const _UpcomingRowSkeleton();

  @override
  Widget build(BuildContext context) => const Row(
    children: [
      SizedBox(
        width: 52,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: _gap),
            Skeleton(width: 40, height: 32),
            SizedBox(height: 6),
            Skeleton.line(width: 28, height: 10),
          ],
        ),
      ),
      SizedBox(width: 16),
      Expanded(child: Skeleton(height: 164, radius: AppRadius.card)),
    ],
  );
}

// ── History (D2) ────────────────────────────────────────────────────────────

class _HistoryTab extends StatefulWidget {
  const _HistoryTab({required this.header});

  final Widget header;

  @override
  State<_HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<_HistoryTab> {
  final _scroll = ScrollController();

  HistoryCubit get _cubit => context.read<HistoryCubit>();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HistoryCubit, HistoryState>(
      listenWhen: (_, next) => next is HistoryError && next.items.isNotEmpty,
      listener: (_, state) => AppToast.error((state as HistoryError).message),
      buildWhen: (_, next) => next is! HistoryError || next.items.isEmpty,
      builder: (context, state) => _TabScrollView(
        controller: _scroll,
        onRefresh: _cubit.refresh,
        header: widget.header,
        slivers: [
          switch (state) {
            HistoryInitial() ||
            HistoryLoading() => _bodySliver(const _HistorySkeleton()),
            HistoryError(:final message) => SliverToBoxAdapter(
              child: ErrorView(message: message, onRetry: _cubit.retry),
            ),
            HistoryLoaded(:final items) when items.isEmpty =>
              const SliverToBoxAdapter(
                child: EmptyView(
                  icon: Icons.event_available_outlined,
                  title: 'No history yet.',
                  message:
                      'Completed shifts and past applications will appear '
                      'here.',
                ),
              ),
            HistoryLoaded(:final items, :final summary, :final isLoadingMore) =>
              _bodySliver(_buildLoaded(context, items, summary, isLoadingMore)),
          },
        ],
      ),
    );
  }

  Widget _bodySliver(Widget child) => SliverPadding(
    padding: const EdgeInsets.fromLTRB(_gutter, _gap, _gutter, 0),
    sliver: SliverToBoxAdapter(child: child),
  );

  Widget _buildLoaded(
    BuildContext context,
    List<Application> items,
    HistorySummary summary,
    bool isLoadingMore,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _WorkedCounter(summary: summary),
        const SizedBox(height: _gap),
        AppCard(
          padding: const EdgeInsets.symmetric(horizontal: _gutter, vertical: 4),
          child: Column(
            children: [
              for (final (index, application) in items.indexed) ...[
                if (index > 0) const Divider(),
                _HistoryRow(
                  application: application,
                  onTap: () => _openDetail(context, application),
                ),
              ],
              if (isLoadingMore) ...[
                const Divider(),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Skeleton.line(width: 180),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;
    if (_scroll.position.extentAfter < _loadMoreThreshold) _cubit.loadMore();
  }

  void _openDetail(BuildContext context, Application application) {
    final event = application.event;
    if (event != null) context.push(EventsRoutes.detail(event.id));
  }
}

/// `06` as an editorial numeral, then `events worked` ⏎ `since Jul 2026`
/// (just `events worked` when nothing was worked yet).
class _WorkedCounter extends StatelessWidget {
  const _WorkedCounter({required this.summary});

  final HistorySummary summary;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final since = summary.workedSince;
    final caption = summary.workedCount == 0 || since == null
        ? 'events worked'
        : 'events worked\nsince ${AppDates.monthYear(since)}';

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            summary.workedCount.toString().padLeft(2, '0'),
            style: tokens.counter.copyWith(
              fontSize: 64,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.05 * 64,
            ),
          ),
          const SizedBox(width: 14),
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(
              caption,
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: tokens.muted, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

/// Dense D2 row: 15/500 title, `SUN 20 SEP · CREW` meta, status pill.
class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.application, required this.onTap});

  final Application application;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final textTheme = Theme.of(context).textTheme;
    final event = application.event;
    final meta = [
      if (event != null) AppDates.dayStamp(event.date),
      application.position.role.name.toUpperCase(),
    ].join(' · ');

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event?.title ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    meta,
                    style: textTheme.labelMedium?.copyWith(
                      fontSize: 11,
                      letterSpacing: 0.04 * 11,
                      color: tokens.muted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // D-07: `selected` in History means the date has passed.
            if (application.isSelected)
              const StatusPill.completed(small: true)
            else
              const StatusPill.notSelected(small: true),
          ],
        ),
      ),
    );
  }
}

/// Counter + one grouped card while page 1 loads.
class _HistorySkeleton extends StatelessWidget {
  const _HistorySkeleton();

  @override
  Widget build(BuildContext context) => const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.fromLTRB(4, 8, 4, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Skeleton(width: 84, height: 54),
            SizedBox(width: 14),
            Skeleton.line(width: 120),
          ],
        ),
      ),
      SizedBox(height: _gap),
      Skeleton(height: 296, radius: AppRadius.card),
    ],
  );
}
