import 'package:go_router/go_router.dart';

import '../../core/router/app_routes.dart';
import '../../core/router/route_guard.dart';
import 'presentation/screens/verification_data_screen.dart';
import 'presentation/screens/verification_screen.dart';

abstract final class VerificationRoutes {
  static const root = AppRoutes.verification;
  static const data = '/verification/data';
}

/// Root-level pages (no pill nav). A verified user opening `/verification`
/// is sent home; `/verification/data` ("View my data", A6) stays readable.
final List<RouteBase> verificationRoutes = [
  GoRoute(
    path: VerificationRoutes.root,
    parentNavigatorKey: rootNavigatorKey,
    redirect: unverifiedOnly(),
    builder: (context, state) => const VerificationScreen(),
  ),
  GoRoute(
    path: VerificationRoutes.data,
    parentNavigatorKey: rootNavigatorKey,
    redirect: guard(requireVerified: false),
    builder: (context, state) => const VerificationDataScreen(),
  ),
];
