import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/eyebrow.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../../core/widgets/state_views.dart';
import '../../models/app_notification.dart';
import '../cubit/notifications_cubit.dart';
import '../cubit/notifications_state.dart';
import '../notification_formats.dart';

/// N1 Notifications, root-level (no pill nav, copy-table N1): back circle,
/// `{n} unread` / `All caught up` eyebrow, `Notifications` headline with the
/// `Mark all read` link, then the list grouped `Today` / `Earlier` with one
/// card per notification (unread = ink dot). Pull to refresh, infinite
/// scroll; C10-style empty card; error card with retry.
///
/// Tapping a row marks it read (optimistic). Navigation by type is added by
/// the next unit of TASK-019.
///
/// Expects a `NotificationsCubit` above it (provided by the route).
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key, this.now});

  /// Reference time for `2 h ago` and the `Today` split; defaults to
  /// `DateTime.now()`.
  final DateTime? now;

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  static const _loadMoreThreshold = 300.0;

  final _scrollController = ScrollController();

  NotificationsCubit get _cubit => context.read<NotificationsCubit>();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationsCubit, NotificationsState>(
      // Error while data is on screen → toast only, list stays.
      listenWhen: (_, next) =>
          next is NotificationsError && next.data.isNotEmpty,
      listener: (_, state) =>
          AppToast.error((state as NotificationsError).message),
      buildWhen: (_, next) => next is! NotificationsError || next.data.isEmpty,
      builder: (context, state) {
        final unreadCount = switch (state) {
          NotificationsLoaded(:final unreadCount) => unreadCount,
          _ => 0,
        };
        return Scaffold(
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _Header(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildEyebrow(state),
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(
                              'Notifications',
                              style: context.tokens.display,
                            ),
                          ),
                          if (unreadCount > 0)
                            _MarkAllReadLink(onTap: _cubit.markAllRead),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(child: _buildBody(state)),
              ],
            ),
          ),
        );
      },
    );
  }

  /// `3 unread` / `All caught up`; a skeleton pill while the first page is
  /// in flight, nothing when it failed.
  Widget _buildEyebrow(NotificationsState state) {
    return SizedBox(
      height: 16,
      child: switch (state) {
        NotificationsLoaded(:final unreadCount) => Eyebrow(
          unreadCount == 0 ? 'All caught up' : '$unreadCount unread',
        ),
        NotificationsError() => const SizedBox.shrink(),
        _ => const Align(
          alignment: Alignment.centerLeft,
          child: Skeleton.line(width: 110),
        ),
      },
    );
  }

  Widget _buildBody(NotificationsState state) => switch (state) {
    NotificationsInitial() || NotificationsLoading() => const _ListSkeleton(),
    NotificationsError(:final message) => ErrorView(
      message: message,
      onRetry: _cubit.load,
    ),
    NotificationsLoaded(:final data) when data.isEmpty => _Refreshable(
      onRefresh: _cubit.refresh,
      child: const EmptyView(
        icon: Icons.notifications_none_outlined,
        title: 'No notifications yet.',
        message: 'Selection results and new events for your roles will show up here.',
      ),
    ),
    NotificationsLoaded(:final data, :final isLoadingMore) => _buildList(
      data,
      isLoadingMore: isLoadingMore,
    ),
  };

  Widget _buildList(List<AppNotification> data, {required bool isLoadingMore}) {
    final now = widget.now ?? DateTime.now();
    final groups = NotificationFormats.group(data, now: now);
    final rows = <_Row>[
      if (groups.today.isNotEmpty) ...[
        const _HeaderRow('Today'),
        for (final notification in groups.today) _ItemRow(notification),
      ],
      if (groups.earlier.isNotEmpty) ...[
        const _HeaderRow('Earlier'),
        for (final notification in groups.earlier) _ItemRow(notification),
      ],
      if (isLoadingMore) const _LoadingRow(),
    ];

    return RefreshIndicator(
      onRefresh: _cubit.refresh,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: _listPadding(context),
        itemCount: rows.length,
        itemBuilder: (context, index) => switch (rows[index]) {
          _HeaderRow(:final label) => Padding(
            padding: EdgeInsets.only(top: index == 0 ? 0 : 14, bottom: 12),
            child: Eyebrow(label),
          ),
          _ItemRow(:final notification) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _NotificationCard(
              notification: notification,
              now: now,
              onTap: () => _cubit.markRead(notification.id),
            ),
          ),
          _LoadingRow() => const _LoadingMoreRow(),
        },
      ),
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.extentAfter < _loadMoreThreshold) {
      _cubit.loadMore();
    }
  }
}

/// One entry of the flattened, grouped list.
sealed class _Row {
  const _Row();
}

class _HeaderRow extends _Row {
  const _HeaderRow(this.label);

  final String label;
}

class _ItemRow extends _Row {
  const _ItemRow(this.notification);

  final AppNotification notification;
}

class _LoadingRow extends _Row {
  const _LoadingRow();
}

/// 44 px white back circle on the left (same header as the event detail).
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Material(
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
      ),
    );
  }

  void _back(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      // Deep link / push notification: nothing underneath, go Home.
      context.go(AppRoutes.home);
    }
  }
}

/// `Mark all read` — 14/500 ink text link next to the headline.
class _MarkAllReadLink extends StatelessWidget {
  const _MarkAllReadLink({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    behavior: HitTestBehavior.opaque,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 0, 8),
      child: Text(
        'Mark all read',
        style: Theme.of(context).textTheme.labelLarge,
      ),
    ),
  );
}

/// One notification: 32-radius card, 17/500 title, muted body, relative
/// time; an 8 px ink dot on the right while unread.
class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.notification,
    required this.now,
    required this.onTap,
  });

  final AppNotification notification;
  final DateTime now;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final text = Theme.of(context).textTheme;

    return AppCard(
      padding: const EdgeInsets.all(20),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: text.titleMedium?.copyWith(
                    fontSize: 17,
                    letterSpacing: -0.17,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notification.body,
                  style: text.bodySmall?.copyWith(color: tokens.muted),
                ),
                const SizedBox(height: 8),
                Text(
                  NotificationFormats.relativeTime(
                    notification.createdAt,
                    now: now,
                  ),
                  style: tokens.caption,
                ),
              ],
            ),
          ),
          if (!notification.isRead) ...[
            const SizedBox(width: 12),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: _UnreadDot(color: tokens.ink),
            ),
          ],
        ],
      ),
    );
  }
}

class _UnreadDot extends StatelessWidget {
  const _UnreadDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: 8,
    height: 8,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}

/// Three card-shaped placeholders (white fill, hairline border) under a
/// group-header pill.
class _ListSkeleton extends StatelessWidget {
  const _ListSkeleton();

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: _listPadding(context),
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Skeleton.line(width: 48, height: 12),
          ),
        ),
        for (var index = 0; index < 3; index++)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Skeleton(
              height: 112,
              radius: AppRadius.card,
              color: tokens.surface,
              borderColor: tokens.line,
            ),
          ),
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

/// 20 px sides, 18 px below the headline, bottom safe area plus gutter.
EdgeInsets _listPadding(BuildContext context) =>
    EdgeInsets.fromLTRB(20, 18, 20, MediaQuery.paddingOf(context).bottom + 24);
