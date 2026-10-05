import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:penta_crew/core/router/app_routes.dart';
import 'package:penta_crew/core/theme/app_theme.dart';
import 'package:penta_crew/core/widgets/labeled_field.dart';
import 'package:penta_crew/features/auth/auth_routes.dart';
import 'package:toastification/toastification.dart';

/// Path the screen under test is mounted at.
const authScreenPath = '/under-test';

/// Pumps [screen] as the first page of a small `GoRouter` whose other routes
/// are stubs rendering `stub:<uri>`, so `context.go` / `context.push` from
/// the screen can be asserted through `router.state`. Real theme, plus the
/// toast overlay `AppToast` needs.
Future<GoRouter> pumpAuthScreen(WidgetTester tester, Widget screen) async {
  final router = GoRouter(
    initialLocation: authScreenPath,
    routes: [
      GoRoute(path: authScreenPath, builder: (_, _) => screen),
      for (final path in const [
        AppRoutes.home,
        AppRoutes.login,
        AppRoutes.verification,
        AuthRoutes.register,
        AuthRoutes.forgotPassword,
        AuthRoutes.checkEmail,
      ])
        GoRoute(path: path, builder: _stubPage),
    ],
  );
  addTearDown(router.dispose);

  await tester.pumpWidget(
    ToastificationWrapper(
      child: MaterialApp.router(theme: AppTheme.light(), routerConfig: router),
    ),
  );
  await tester.pump();
  return router;
}

Widget _stubPage(BuildContext context, GoRouterState state) =>
    Scaffold(body: Text('stub:${state.uri}'));

/// toastification inserts the card a frame later and animates it in.
Future<void> showToastFrames(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

/// Lets the 3 s auto-close timers finish so the test ends without pending
/// timers.
Future<void> settleToasts(WidgetTester tester) async {
  await tester.pump(const Duration(seconds: 4));
  await tester.pumpAndSettle();
}

/// The `AppTextField` whose eyebrow reads [label] (rendered uppercase).
Finder appField(String label) =>
    find.widgetWithText(AppTextField, label.toUpperCase());

/// The `TextFormField` under the eyebrow [label] (rendered uppercase).
Finder fieldLabeled(String label) => find.descendant(
  of: find.ancestor(
    of: find.text(label.toUpperCase()),
    matching: find.byType(Column),
  ).first,
  matching: find.byType(TextFormField),
);
