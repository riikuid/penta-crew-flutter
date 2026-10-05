import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:penta_crew/core/network/result.dart';
import 'package:penta_crew/core/session/session_events.dart';
import 'package:penta_crew/core/session/session_storage.dart';
import 'package:penta_crew/core/theme/app_theme.dart';
import 'package:penta_crew/core/usecase/usecase.dart';
import 'package:penta_crew/features/auth/models/branch.dart';
import 'package:penta_crew/features/auth/models/crew_role.dart';
import 'package:penta_crew/features/auth/models/user.dart';
import 'package:penta_crew/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:penta_crew/features/auth/usecases/get_me.dart';
import 'package:penta_crew/features/auth/usecases/logout.dart';
import 'package:toastification/toastification.dart';

class MockGetMe extends Mock implements GetMe {}

class MockLogout extends Mock implements Logout {}

/// Mirrors the mock backend's personas (`mock_data.dart`) closely enough for
/// the copy assertions: approved (E1), pending (A6) and rejected (A7).
const jakarta = Branch(id: 1, name: 'Jakarta');

final approvedUser = User(
  id: 1,
  name: 'Rina Anggraini',
  email: 'rina.anggraini@email.com',
  phone: '+62 812 3456 7890',
  dateOfBirth: DateTime(2000, 3, 14),
  gender: Gender.female,
  address: 'Jl. Tebet Raya 21, Tebet, Jakarta Selatan',
  branch: jakarta,
  roles: const [CrewRole(id: 1, name: 'Crew'), CrewRole(id: 2, name: 'Event Manager')],
  verificationStatus: VerificationStatus.approved,
  submittedAt: DateTime(2026, 6, 20, 9, 40),
  reviewedAt: DateTime(2026, 6, 22),
  memberSince: DateTime(2026, 6, 20),
);

final pendingUser = approvedUser.copyWith(
  roles: const [],
  verificationStatus: VerificationStatus.pending,
  submittedAt: DateTime(2026, 9, 25, 9, 40),
  reviewedAt: null,
);

final rejectedUser = pendingUser.copyWith(
  verificationStatus: VerificationStatus.rejected,
  verificationNote:
      "We couldn't reach your phone number and your date of birth doesn't "
      'match your ID. Please check both.',
  reviewedAt: DateTime(2026, 9, 26),
);

/// A real `AuthCubit` (so `updateUser` / `logout` behave) over mocked
/// usecases, already signed in as [user].
class AuthHarness {
  AuthHarness(User user) {
    registerFallbackValue(const NoParams());
    when(() => logout(any())).thenAnswer((_) async => const Result.success(null));
    cubit = AuthCubit(
      getMe: getMe,
      logout: logout,
      storage: storage,
      events: events,
    )..setAuthenticated(user);
  }

  final getMe = MockGetMe();
  final logout = MockLogout();
  final events = SessionEvents();
  final storage = InMemorySessionStorage();
  late final AuthCubit cubit;

  Future<void> dispose() async {
    await cubit.close();
    events.dispose();
  }
}

/// Phone-width, tall viewport so lazily built lists render every row.
void useTallViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(430, 2200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

/// Pumps [home] at `/` inside a `GoRouter` whose other routes render their
/// own path, so navigation can be asserted with `find.text(path)`.
/// [extraRoutes] are mounted as-is (e.g. to provide a cubit on a page).
Future<GoRouter> pumpRouted(
  WidgetTester tester, {
  required Widget home,
  required AuthCubit auth,
  List<String> stubPaths = const [],
  List<RouteBase> extraRoutes = const [],
}) async {
  useTallViewport(tester);
  final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => home),
      for (final path in stubPaths)
        GoRoute(
          path: path,
          builder: (context, state) =>
              Scaffold(body: Text(state.uri.toString())),
        ),
      ...extraRoutes,
    ],
  );
  await tester.pumpWidget(
    BlocProvider.value(
      value: auth,
      child: ToastificationWrapper(
        child: MaterialApp.router(theme: AppTheme.light(), routerConfig: router),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return router;
}
