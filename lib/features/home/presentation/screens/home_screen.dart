import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../core/utils/app_dates.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/eyebrow.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../../core/widgets/status_pill.dart';
import '../../../auth/models/user.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../events/events_routes.dart';
import '../../../events/models/application.dart';
import '../../../events/models/event.dart';
import '../../../events/presentation/widgets/event_card.dart';
import '../../../notifications/notifications_routes.dart';
import '../../../schedule/schedule_routes.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../cubit/section.dart';

/// Home tab (prototype B1 loaded, B2 loading, B3 empty). Each block reads its
/// own `Section` of [HomeState] (D-05), so a slow or failing request only
/// affects that block; greeting and roles come from `AuthCubit`.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.now});

  /// Injected by tests so "in N days" and deadline chips are deterministic;
  /// `null` means the wall clock at build time.
  final DateTime? now;

  static const double _horizontalPadding = 20;
  static const double _blockGap = 24;

  @override
  Widget build(BuildContext context) {
    final now = this.now ?? DateTime.now();
    final user = context.select((AuthCubit cubit) => cubit.user);
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      body: BlocListener<HomeCubit, HomeState>(
        // A failed refresh keeps the data on screen; only the message surfaces.
        listenWhen: (_, next) => next.refreshError != null,
        listener: (_, state) => AppToast.error(state.refreshError!),
        child: SafeArea(
          bottom: false,
          child: RefreshIndicator(
            onRefresh: context.read<HomeCubit>().refresh,
            child: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) => ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.only(top: 12, bottom: bottom),
                children: [
                  _inset(_buildHeader(context, state)),
                  const SizedBox(height: _blockGap),
                  _inset(_buildGreeting(context, state, user, now)),
                  const SizedBox(height: _blockGap),
                  _inset(_buildNextShift(context, state, user, now)),
                  const SizedBox(height: _blockGap),
                  _inset(_buildCounters(context, state)),
                  const SizedBox(height: _blockGap),
                  _buildOpenEvents(context, state, now),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _inset(Widget child) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
    child: child,
  );

  Widget _buildHeader(BuildContext context, HomeState state) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const _LogoMark(),
      if (state.isInitialLoading)
        const Skeleton.circle()
      else
        _BellButton(onTap: () => context.push(NotificationsRoutes.root)),
    ],
  );

  Widget _buildGreeting(
    BuildContext context,
    HomeState state,
    User? user,
    DateTime now,
  ) {
    final tokens = context.tokens;
    if (state.isInitialLoading) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Skeleton.line(width: 130),
          SizedBox(height: 12),
          Skeleton(width: 300, height: 36),
          SizedBox(height: 12),
          Skeleton(width: 190, height: 36),
        ],
      );
    }

    final firstName = user?.name.trim().split(RegExp(r'\s+')).first ?? '';
    final headline = _headline(state, now);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Greetings, $firstName!',
          style: Theme.of(context).textTheme.bodyLarge
              ?.copyWith(fontSize: 17, color: tokens.muted),
        ),
        const SizedBox(height: 8),
        switch (state.nextShift) {
          SectionLoading() => const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Skeleton(width: 300, height: 36),
              SizedBox(height: 12),
              Skeleton(width: 190, height: 36),
            ],
          ),
          _ when headline != null => Text(headline, style: tokens.display),
          _ => const SizedBox.shrink(),
        },
      ],
    );
  }

  /// B1 headline for the next shift, B3 variants when there is none, and no
  /// headline at all while that section is in error (the inline error says
  /// what happened).
  String? _headline(HomeState state, DateTime now) {
    final nextShift = state.nextShift;
    if (nextShift is! SectionLoaded<Application?>) return null;

    final event = nextShift.data?.event;
    if (event == null) {
      final openEvents = state.openEvents;
      final noOpenEvents =
          openEvents is SectionLoaded<List<Event>> && openEvents.data.isEmpty;
      return noOpenEvents
          ? "You're verified and ready."
          : 'Nothing scheduled yet.';
    }

    return switch (AppDates.daysUntil(event.date, now: now)) {
      <= 0 => 'Your next shift is today.',
      1 => 'Your next shift is tomorrow.',
      final days => 'Your next shift is in $days days.',
    };
  }

  Widget _buildNextShift(
    BuildContext context,
    HomeState state,
    User? user,
    DateTime now,
  ) {
    final tokens = context.tokens;
    return switch (state.nextShift) {
      SectionLoading() => Skeleton.card(height: 290, color: tokens.accent),
      SectionError(:final message) => _SectionError(
        message: message,
        onRetry: () => _retry(context, HomeSection.nextShift),
      ),
      SectionLoaded(:final data) =>
        data?.event == null
            ? _RolesCard(user: user)
            : _NextShiftCard(
                application: data!,
                onInspect: () =>
                    context.push(EventsRoutes.detail(data.event!.id)),
              ),
    };
  }

  Widget _buildCounters(BuildContext context, HomeState state) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        flex: 5,
        child: _buildCounter(
          context,
          section: state.waitingCount,
          homeSection: HomeSection.waitingCount,
          eyebrow: 'Waiting',
          value: _twoDigits,
          sub: (_) => 'applications pending',
          showArrow: true,
          onTap: () => context.go(EventsRoutes.root),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        flex: 4,
        child: _buildCounter(
          context,
          section: state.worked,
          homeSection: HomeSection.worked,
          eyebrow: 'Worked',
          value: (summary) => _twoDigits(summary.workedCount),
          sub: (summary) => summary.workedSince == null
              ? 'no events yet'
              : 'since ${AppDates.monthYear(summary.workedSince!)}',
          showArrow: false,
          onTap: () => context.go(ScheduleRoutes.root),
        ),
      ),
    ],
  );

  Widget _buildCounter<T>(
    BuildContext context, {
    required Section<T> section,
    required HomeSection homeSection,
    required String eyebrow,
    required String Function(T data) value,
    required String Function(T data) sub,
    required bool showArrow,
    required VoidCallback onTap,
  }) {
    final tokens = context.tokens;
    return switch (section) {
      SectionLoading() => Skeleton(
        height: 132,
        radius: AppRadius.card,
        color: tokens.surface,
        borderColor: tokens.line,
      ),
      SectionError(:final message) => _SectionError(
        message: message,
        onRetry: () => _retry(context, homeSection),
      ),
      SectionLoaded(:final data) => _CounterCard(
        eyebrow: eyebrow,
        value: value(data),
        sub: sub(data),
        showArrow: showArrow,
        onTap: onTap,
      ),
    };
  }

  Widget _buildOpenEvents(BuildContext context, HomeState state, DateTime now) {
    final tokens = context.tokens;
    final body = switch (state.openEvents) {
      SectionLoading() => const _Carousel(
        children: [_CompactCardSkeleton(), _CompactCardSkeleton()],
      ),
      SectionError(:final message) => _inset(
        _SectionError(
          message: message,
          onRetry: () => _retry(context, HomeSection.openEvents),
        ),
      ),
      SectionLoaded(:final data) when data.isEmpty => _inset(
        const _OpenEventsEmptyCard(),
      ),
      SectionLoaded(:final data) => _Carousel(
        children: [
          for (final event in data)
            EventCard.compact(
              event: event,
              now: now,
              onTap: () => context.push(EventsRoutes.detail(event.id)),
            ),
        ],
      ),
    };

    // B2 has no section header yet; B3 replaces the whole section with the
    // blush empty block.
    final headerless = switch (state.openEvents) {
      SectionLoading() => true,
      SectionLoaded(:final data) => data.isEmpty,
      SectionError() => false,
    };
    if (headerless) return body;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _inset(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: Text(
                  'Open for you',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => context.go(EventsRoutes.root),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'View list',
                    style: Theme.of(context).textTheme.labelLarge
                        ?.copyWith(color: tokens.ink),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        body,
      ],
    );
  }

  void _retry(BuildContext context, HomeSection section) =>
      context.read<HomeCubit>().retry(section);

  static String _twoDigits(int value) => value.toString().padLeft(2, '0');
}

/// 36 px mark in the header. The brand asset is not in the repo yet; this
/// keeps the prototype's footprint so the layout does not shift when it lands.
class _LogoMark extends StatelessWidget {
  const _LogoMark();

  @override
  Widget build(BuildContext context) => Container(
    width: 36,
    height: 36,
    decoration: BoxDecoration(
      color: context.tokens.ink,
      shape: BoxShape.circle,
    ),
  );
}

/// 44 px white circle with a hairline border and a 20 px bell (B1 `:509`).
/// The unread badge arrives with Notifications (T9).
class _BellButton extends StatelessWidget {
  const _BellButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Material(
      color: tokens.surface,
      shape: CircleBorder(side: BorderSide(color: tokens.line)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            Icons.notifications_outlined,
            size: 20,
            color: tokens.ink,
          ),
        ),
      ),
    );
  }
}

/// B1 hero: blush 40-radius card with the selected pill, role eyebrow, the
/// 88 px day numeral with stacked month/weekday, title, meta and `Inspect`.
class _NextShiftCard extends StatelessWidget {
  const _NextShiftCard({required this.application, required this.onInspect});

  final Application application;
  final VoidCallback onInspect;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final text = Theme.of(context).textTheme;
    final event = application.event!;
    final stackedStyle = tokens.eyebrow.copyWith(
      fontSize: 12,
      letterSpacing: 0.72,
      color: tokens.ink,
    );

    return AppCard(
      tone: AppCardTone.accent,
      radius: AppRadius.cardLarge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const StatusPill.selected(),
              Eyebrow(
                'As ${application.position.role.name}',
                color: tokens.ink,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                AppDates.dayNumber(event.date),
                style: tokens.counter.copyWith(
                  fontSize: 88,
                  letterSpacing: -4.4,
                ),
              ),
              const SizedBox(width: 14),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppDates.month(event.date), style: stackedStyle),
                    const SizedBox(height: 4),
                    Text(
                      AppDates.weekday(event.date),
                      style: stackedStyle.copyWith(color: tokens.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(event.title, style: text.headlineSmall),
          const SizedBox(height: 6),
          Text(
            '${event.timeRange} · ${event.venueName}'.toUpperCase(),
            style: _metaStyle(tokens),
          ),
          const SizedBox(height: 18),
          Align(
            alignment: Alignment.centerRight,
            child: _InspectButton(onPressed: onInspect),
          ),
        ],
      ),
    );
  }
}

/// `Inspect ↗` — 44 px ink pill, 14/500, trailing 16 px arrow (B1 `:530`).
/// `AppButton` has neither a 44 size nor a trailing icon, hence the local
/// `FilledButton`.
class _InspectButton extends StatelessWidget {
  const _InspectButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => FilledButton(
    onPressed: onPressed,
    style: FilledButton.styleFrom(
      minimumSize: const Size(0, 44),
      maximumSize: const Size(double.infinity, 44),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      textStyle: Theme.of(context).textTheme.labelLarge,
    ),
    child: const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Inspect'),
        SizedBox(width: 8),
        Icon(Icons.arrow_outward, size: 16),
      ],
    ),
  );
}

/// B3 roles card: 40 px ink circle with a check, `Roles assigned`, and the
/// user's roles and branch as an uppercase meta line.
class _RolesCard extends StatelessWidget {
  const _RolesCard({required this.user});

  final User? user;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final parts = [
      ...?user?.roles.map((role) => role.name),
      ?user?.branch?.name,
    ];

    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: tokens.ink,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check, size: 18, color: tokens.surface),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Roles assigned',
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w500, height: 1.3),
                ),
                const SizedBox(height: 4),
                Text(
                  parts.join(' · ').toUpperCase(),
                  style: _metaStyle(tokens),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// White 32-radius counter (B1 `:534-543`): eyebrow (+ optional arrow),
/// 44/400 numeral, 13 px muted sub-copy.
class _CounterCard extends StatelessWidget {
  const _CounterCard({
    required this.eyebrow,
    required this.value,
    required this.sub,
    required this.showArrow,
    required this.onTap,
  });

  final String eyebrow;
  final String value;
  final String sub;
  final bool showArrow;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return AppCard(
      padding: const EdgeInsets.all(20),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Eyebrow(eyebrow),
              if (showArrow)
                Icon(Icons.arrow_outward, size: 16, color: tokens.ink),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: tokens.numeral),
          const SizedBox(height: 8),
          Text(sub, style: tokens.caption),
        ],
      ),
    );
  }
}

/// Horizontal strip that bleeds to the screen edges with 20 px end padding
/// (prototype `margin:0 -20px; padding:0 20px`). Cards share the tallest
/// card's height.
class _Carousel extends StatelessWidget {
  const _Carousel({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.symmetric(
      horizontal: HomeScreen._horizontalPadding,
    ),
    child: IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var index = 0; index < children.length; index++) ...[
            if (index > 0) const SizedBox(width: 12),
            children[index],
          ],
        ],
      ),
    ),
  );
}

class _CompactCardSkeleton extends StatelessWidget {
  const _CompactCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Skeleton(
      width: EventCard.compactWidth,
      height: 190,
      radius: AppRadius.card,
      color: tokens.surface,
      borderColor: tokens.line,
    );
  }
}

/// B3 `:606-610`: blush 40-radius block that replaces the carousel.
class _OpenEventsEmptyCard extends StatelessWidget {
  const _OpenEventsEmptyCard();

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final text = Theme.of(context).textTheme;
    return AppCard(
      tone: AppCardTone.accent,
      radius: AppRadius.cardLarge,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Eyebrow('Open for you · 00', color: tokens.ink),
          const SizedBox(height: 14),
          Text('No open events yet.', style: text.headlineMedium),
          const SizedBox(height: 14),
          Text(
            'When an admin publishes an event that matches your roles, it '
            "shows up here and you'll get a notification.",
            style: text.bodyMedium,
          ),
        ],
      ),
    );
  }
}

/// Compact inline error for one section: the server message as-is and a
/// retry that re-fires only that section (D-05).
class _SectionError extends StatelessWidget {
  const _SectionError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return AppCard(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.error_outline, size: 18, color: tokens.muted),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: tokens.caption.copyWith(color: tokens.ink),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          TextButton(
            onPressed: onRetry,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
            ),
            child: const Text('Try again'),
          ),
        ],
      ),
    );
  }
}

/// 11/500, +0.04em, muted — the hero meta line and the roles line
/// (`:526`, `:604`). Callers pass uppercase copy.
TextStyle _metaStyle(AppTokens tokens) => tokens.eyebrow.copyWith(
  fontWeight: FontWeight.w500,
  letterSpacing: 0.44,
  color: tokens.muted,
);
