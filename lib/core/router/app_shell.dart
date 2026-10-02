import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/events/events_routes.dart';
import '../../features/home/home_routes.dart';
import '../../features/profile/profile_routes.dart';
import '../../features/schedule/schedule_routes.dart';
import '../widgets/floating_pill_nav.dart';
import 'route_guard.dart';

/// The four-tab shell (D-13 §2.5). Only the tab roots live here; every other
/// page is a root-level route and shows without the pill nav.
///
/// Like `app_router.dart` and `locator.dart`, this file is allowed to import
/// from `features/`.
final StatefulShellRoute appShellRoute = StatefulShellRoute.indexedStack(
  redirect: guard(),
  builder: (context, state, navigationShell) =>
      AppShell(navigationShell: navigationShell),
  branches: [
    StatefulShellBranch(routes: [homeTabRoute]),
    StatefulShellBranch(routes: [eventsTabRoute]),
    StatefulShellBranch(routes: [scheduleTabRoute]),
    StatefulShellBranch(routes: [profileTabRoute]),
  ],
);

/// Scaffold that overlays [FloatingPillNav] on the active tab, 20 px from the
/// sides and above the home indicator (prototype: `left/right 20, bottom 30`).
///
/// The tab content receives extra bottom `MediaQuery.padding` equal to the
/// nav's footprint, so a `SafeArea` or a `ListView` with default padding never
/// ends up hidden behind the pill.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _items = [
    FloatingPillNavItem(icon: Icons.home_outlined, label: 'Home'),
    FloatingPillNavItem(icon: Icons.explore_outlined, label: 'Events'),
    FloatingPillNavItem(icon: Icons.event_available_outlined, label: 'Schedule'),
    FloatingPillNavItem(icon: Icons.account_circle_outlined, label: 'Profile'),
  ];

  /// 52 px items + 6 px padding on both sides.
  static const double navHeight = 64;
  static const double sideInset = 20;
  static const double bottomInset = 30;

  void _onTap(int index) => navigationShell.goBranch(
    index,
    // Tapping the active tab again pops it back to its root.
    initialLocation: index == navigationShell.currentIndex,
  );

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final bottom = math.max(bottomInset, media.padding.bottom + 8);
    final clearance = bottom + navHeight;

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          MediaQuery(
            data: media.copyWith(
              padding: media.padding.copyWith(bottom: clearance),
              viewPadding: media.viewPadding.copyWith(bottom: clearance),
            ),
            child: navigationShell,
          ),
          Positioned(
            left: sideInset,
            right: sideInset,
            bottom: bottom,
            child: FloatingPillNav(
              items: _items,
              index: navigationShell.currentIndex,
              onChanged: _onTap,
            ),
          ),
        ],
      ),
    );
  }
}
