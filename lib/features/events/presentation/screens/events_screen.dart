import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/eyebrow.dart';
import '../../../../core/widgets/segmented_tabs.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../events_routes.dart';
import '../cubit/open_events_cubit.dart';
import '../cubit/open_events_state.dart';
import '../cubit/tracked_cubit.dart';
import '../cubit/tracked_state.dart';
import '../event_formats.dart';
import '../widgets/event_card.dart';
import '../widgets/tracked_card.dart';

/// The two tabs of the Events root (prototype C1 / C2 / C10).
enum EventsTab {
  open,
  tracked;

  /// `EventsRoutes.tabParam` value → tab; anything else is `null`.
  static EventsTab? fromName(String? name) => switch (name) {
    'open' => EventsTab.open,
    'tracked' => EventsTab.tracked,
    _ => null,
  };
}

/// Events tab root: eyebrow + `Events` headline, search (Open only),
/// `Open 03 | Tracked 04` segmented tabs, then the active list. Both lists
/// stay mounted in an [IndexedStack] so switching keeps scroll position and
/// data; the cubits are provided by the route builder.
///
/// Expects `OpenEventsCubit`, `TrackedCubit` and `AuthCubit` above it.
class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key, this.initialTab});

  /// Tab to show; `null` keeps whatever is selected. Changing it on an
  /// already-mounted screen (`context.go(EventsRoutes.open)`) switches tabs.
  final EventsTab? initialTab;

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  static const _debounce = Duration(milliseconds: 400);
  static const _loadMoreThreshold = 300.0;

  final _searchController = TextEditingController();
  final _openScroll = ScrollController();
  final _trackedScroll = ScrollController();
  Timer? _debounceTimer;
  late EventsTab _tab = widget.initialTab ?? EventsTab.open;

  OpenEventsCubit get _openCubit => context.read<OpenEventsCubit>();
  TrackedCubit get _trackedCubit => context.read<TrackedCubit>();

  @override
  void initState() {
    super.initState();
    _openScroll.addListener(_onOpenScroll);
    _trackedScroll.addListener(_onTrackedScroll);
    // Rebuild for the clear button only.
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void didUpdateWidget(EventsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    final tab = widget.initialTab;
    if (tab != null && tab != oldWidget.initialTab && tab != _tab) {
      setState(() => _tab = tab);
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _openScroll
      ..removeListener(_onOpenScroll)
      ..dispose();
    _trackedScroll
      ..removeListener(_onTrackedScroll)
      ..dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final branchName =
        context.select((AuthCubit cubit) => cubit.user?.branch?.name) ?? '';
    final openState = context.watch<OpenEventsCubit>().state;
    final trackedState = context.watch<TrackedCubit>().state;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildEyebrow(openState, trackedState, branchName),
                  const SizedBox(height: 6),
                  Text('Events', style: context.tokens.display),
                  const SizedBox(height: 18),
                  if (_tab == EventsTab.open) ...[
                    _SearchField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      onSubmitted: _submitSearch,
                      onClear: _clearSearch,
                    ),
                    const SizedBox(height: 18),
                  ],
                  SegmentedTabs(
                    labels: const ['Open', 'Tracked'],
                    counts: [_count(openState), _count(trackedState)],
                    index: _tab.index,
                    onChanged: (index) =>
                        setState(() => _tab = EventsTab.values[index]),
                  ),
                ],
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: _tab.index,
                children: [
                  _OpenList(scrollController: _openScroll, onOpen: _openDetail),
                  _TrackedList(
                    scrollController: _trackedScroll,
                    onOpen: _openDetail,
                    onBrowse: () => setState(() => _tab = EventsTab.open),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// `3 open · Jakarta` (C1) / `4 applications` (C2); a skeleton pill while
  /// the tab's first page is in flight, a neutral label when it failed.
  Widget _buildEyebrow(
    OpenEventsState openState,
    TrackedState trackedState,
    String branchName,
  ) {
    final text = switch (_tab) {
      EventsTab.open => switch (openState) {
        OpenEventsLoaded(:final total) => EventFormats.openHeader(
          total,
          branchName,
        ),
        OpenEventsError() => branchName,
        _ => null,
      },
      EventsTab.tracked => switch (trackedState) {
        TrackedLoaded(:final total) => EventFormats.applications(total),
        TrackedError() => 'Applications',
        _ => null,
      },
    };
    if (text == null) {
      return const SizedBox(
        height: 16,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Skeleton.line(width: 130),
        ),
      );
    }
    return SizedBox(height: 16, child: Eyebrow(text));
  }

  /// `03` after the tab label once the total is known and non-zero (C10
  /// shows no count on an empty tab).
  String? _count(Object state) {
    final total = switch (state) {
      OpenEventsLoaded(:final total) => total,
      TrackedLoaded(:final total) => total,
      _ => 0,
    };
    return total > 0 ? EventFormats.twoDigits(total) : null;
  }

  void _onOpenScroll() {
    if (!_openScroll.hasClients) return;
    if (_openScroll.position.extentAfter < _loadMoreThreshold) {
      _openCubit.loadMore();
    }
  }

  void _onTrackedScroll() {
    if (!_trackedScroll.hasClients) return;
    if (_trackedScroll.position.extentAfter < _loadMoreThreshold) {
      _trackedCubit.loadMore();
    }
  }

  void _onSearchChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounce, () => _submitSearch(value));
  }

  void _submitSearch(String value) {
    _debounceTimer?.cancel();
    _openCubit.fetch(search: value);
  }

  void _clearSearch() {
    _searchController.clear();
    _submitSearch('');
  }

  /// Detail can apply / withdraw, which changes both tabs — refresh them
  /// silently once it pops (plan §4 T6: no event bus).
  Future<void> _openDetail(int eventId) async {
    await context.push(EventsRoutes.detail(eventId));
    if (!mounted) return;
    _openCubit.refresh();
    _trackedCubit.refresh();
  }
}

/// 52 px pill search box (prototype C1 :633): search icon, borderless input.
class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final text = Theme.of(context).textTheme;

    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: ShapeDecoration(
        color: tokens.surface,
        shape: StadiumBorder(side: BorderSide(color: tokens.line)),
      ),
      child: Row(
        children: [
          Icon(Icons.search, size: 18, color: tokens.muted),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.search,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              style: text.bodyMedium,
              decoration: InputDecoration(
                isCollapsed: true,
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                hintText: 'Search events or venues',
                hintStyle: text.bodyMedium?.copyWith(color: tokens.muted),
              ),
            ),
          ),
          if (controller.text.isNotEmpty)
            GestureDetector(
              onTap: onClear,
              behavior: HitTestBehavior.opaque,
              child: Icon(Icons.close, size: 18, color: tokens.muted),
            ),
        ],
      ),
    );
  }
}

/// C1 list: skeleton cards → `EventCard` list sorted as returned, pull to
/// refresh, infinite scroll; C10 empty card; error card with retry.
class _OpenList extends StatelessWidget {
  const _OpenList({required this.scrollController, required this.onOpen});

  final ScrollController scrollController;
  final ValueChanged<int> onOpen;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OpenEventsCubit>();
    final now = DateTime.now();

    return BlocConsumer<OpenEventsCubit, OpenEventsState>(
      // Error while data is on screen → toast only, list stays.
      listenWhen: (_, next) => next is OpenEventsError && next.data.isNotEmpty,
      listener: (_, state) =>
          AppToast.error((state as OpenEventsError).message),
      buildWhen: (_, next) => next is! OpenEventsError || next.data.isEmpty,
      builder: (context, state) => switch (state) {
        OpenEventsInitial() || OpenEventsLoading() => const _ListSkeleton(
          cardHeight: 212,
          radius: AppRadius.cardLarge,
        ),
        OpenEventsError(:final message) => ErrorView(
          message: message,
          onRetry: cubit.retry,
        ),
        OpenEventsLoaded(:final data) when data.isEmpty => _Refreshable(
          onRefresh: cubit.refresh,
          child: const EmptyView(
            icon: Icons.explore_outlined,
            title: 'No open events right now.',
            message: "New events for your roles will show up here. You'll also get a notification.",
          ),
        ),
        OpenEventsLoaded(:final data, :final isLoadingMore) => RefreshIndicator(
          onRefresh: cubit.refresh,
          child: ListView.separated(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: _listPadding(context),
            itemCount: data.length + (isLoadingMore ? 1 : 0),
            separatorBuilder: (_, _) => const SizedBox(height: 18),
            itemBuilder: (context, index) {
              if (index >= data.length) return const _LoadingMoreRow();
              final event = data[index];
              return EventCard(
                event: event,
                now: now,
                onTap: () => onOpen(event.id),
              );
            },
          ),
        ),
      },
    );
  }
}

/// C2 list: intro line, then a `TrackedCard` per application; empty card
/// with a "Browse open events" action that switches to the Open tab.
class _TrackedList extends StatelessWidget {
  const _TrackedList({
    required this.scrollController,
    required this.onOpen,
    required this.onBrowse,
  });

  final ScrollController scrollController;
  final ValueChanged<int> onOpen;
  final VoidCallback onBrowse;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TrackedCubit>();

    return BlocConsumer<TrackedCubit, TrackedState>(
      listenWhen: (_, next) => next is TrackedError && next.data.isNotEmpty,
      listener: (_, state) => AppToast.error((state as TrackedError).message),
      buildWhen: (_, next) => next is! TrackedError || next.data.isEmpty,
      builder: (context, state) => switch (state) {
        TrackedInitial() || TrackedLoading() => const _ListSkeleton(
          cardHeight: 150,
          radius: AppRadius.card,
          intro: _TrackedIntro(),
        ),
        TrackedError(:final message) => ErrorView(
          message: message,
          onRetry: cubit.retry,
        ),
        TrackedLoaded(:final data) when data.isEmpty => _Refreshable(
          onRefresh: cubit.refresh,
          child: EmptyView(
            icon: Icons.explore_outlined,
            title: "You haven't applied to any events.",
            message:
                'Applications you send will appear here with their status.',
            action: AppButton(
              label: 'Browse open events',
              onPressed: onBrowse,
              variant: AppButtonVariant.secondary,
              size: AppButtonSize.medium,
              expand: false,
            ),
          ),
        ),
        TrackedLoaded(:final data, :final isLoadingMore) => RefreshIndicator(
          onRefresh: cubit.refresh,
          child: ListView.separated(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: _listPadding(context),
            // Item 0 is the intro line.
            itemCount: 1 + data.length + (isLoadingMore ? 1 : 0),
            separatorBuilder: (_, index) =>
                SizedBox(height: index == 0 ? 18 : 14),
            itemBuilder: (context, index) {
              if (index == 0) return const _TrackedIntro();
              if (index > data.length) return const _LoadingMoreRow();
              final application = data[index - 1];
              final event = application.event;
              return TrackedCard(
                application: application,
                onTap: event == null ? null : () => onOpen(event.id),
              );
            },
          ),
        ),
      },
    );
  }
}

class _TrackedIntro extends StatelessWidget {
  const _TrackedIntro();

  @override
  Widget build(BuildContext context) => Text(
    'Monitor your applications and selection results.',
    style: Theme.of(context).textTheme.bodyMedium
        ?.copyWith(fontSize: 15, color: context.tokens.muted),
  );
}

/// Three card-shaped placeholders (B2 shape: white fill, hairline border).
class _ListSkeleton extends StatelessWidget {
  const _ListSkeleton({
    required this.cardHeight,
    required this.radius,
    this.intro,
  });

  final double cardHeight;
  final double radius;
  final Widget? intro;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: _listPadding(context),
      children: [
        if (intro != null) ...[intro!, const SizedBox(height: 18)],
        for (var index = 0; index < 3; index++) ...[
          if (index > 0) const SizedBox(height: 18),
          Skeleton(
            height: cardHeight,
            radius: radius,
            color: tokens.surface,
            borderColor: tokens.line,
          ),
        ],
      ],
    );
  }
}

class _LoadingMoreRow extends StatelessWidget {
  const _LoadingMoreRow();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(vertical: 16),
    child: Center(child: CircularProgressIndicator.adaptive()),
  );
}

/// Makes a non-scrollable child (empty view) pull-to-refreshable.
class _Refreshable extends StatelessWidget {
  const _Refreshable({required this.onRefresh, required this.child});

  final Future<void> Function() onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(height: constraints.maxHeight, child: child),
        ),
      ),
    );
  }
}

/// 20 px sides, 18 px below the tabs, and the shell's nav clearance (it is
/// handed down as bottom `MediaQuery.padding`) plus the page gutter.
EdgeInsets _listPadding(BuildContext context) =>
    EdgeInsets.fromLTRB(20, 18, 20, MediaQuery.paddingOf(context).bottom + 24);
