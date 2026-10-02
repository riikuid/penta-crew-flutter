import 'package:flutter/widgets.dart';

/// Paths the core router needs to know. Features declare their own paths in
/// `<feature>_routes.dart`.
abstract final class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String forbidden = '/forbidden';

  /// Where authenticated-but-unverified users live (D-01).
  static const String verification = '/verification';

  /// Query key used to send the user back where they were heading after the
  /// session resolves / after login.
  static const String fromParam = 'from';
}

/// Root navigator — for dialogs/toasts triggered outside a widget context.
final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
