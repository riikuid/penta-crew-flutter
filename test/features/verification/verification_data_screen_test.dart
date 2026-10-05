import 'package:flutter_test/flutter_test.dart';
import 'package:penta_crew/features/profile/presentation/widgets/circle_back_button.dart';
import 'package:penta_crew/features/verification/presentation/screens/verification_data_screen.dart';

import '../profile/profile_test_harness.dart';

void main() {
  late AuthHarness auth;

  tearDown(() => auth.dispose());

  testWidgets('shows the read-only profile rows for the pending user', (tester) async {
    auth = AuthHarness(pendingUser);
    await pumpRouted(tester, home: const VerificationDataScreen(), auth: auth.cubit);

    expect(find.byType(CircleBackButton), findsOneWidget);
    expect(find.text('CREW ACCOUNT'), findsOneWidget);
    expect(find.text('My data'), findsOneWidget);
    expect(
      find.text(
        'This is what the admin will review. You can edit it if changes are '
        'requested.',
      ),
      findsOneWidget,
    );
    expect(find.text('FULL NAME'), findsOneWidget);
    expect(find.text('Rina Anggraini'), findsOneWidget);
    expect(find.text('EMAIL'), findsOneWidget);
    expect(find.text('rina.anggraini@email.com'), findsOneWidget);
    expect(find.text('BRANCH'), findsOneWidget);
    expect(find.text('Jakarta'), findsOneWidget);
    expect(find.text('PHONE'), findsOneWidget);
    expect(find.text('+62 812 3456 7890'), findsOneWidget);
    expect(find.text('DATE OF BIRTH'), findsOneWidget);
    expect(find.text('14 March 2000 · Female'), findsOneWidget);
    expect(find.text('HOME ADDRESS'), findsOneWidget);
    expect(find.text('Jl. Tebet Raya 21, Tebet, Jakarta Selatan'), findsOneWidget);
    // No roles while pending, no actions anywhere.
    expect(find.text('Edit profile'), findsNothing);
    expect(find.text('Sign out'), findsNothing);
  });
}
