import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:penta_crew/core/theme/app_theme.dart';
import 'package:penta_crew/features/profile/presentation/widgets/confirm_sheet.dart';

void main() {
  testWidgets('ConfirmSheet opened from a nested navigator covers the nav', (
    tester,
  ) async {
    bool? result;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Stack(
          children: [
            Navigator(
              onGenerateRoute: (_) => MaterialPageRoute<void>(
                builder: (context) => Center(
                  child: TextButton(
                    onPressed: () async => result = await ConfirmSheet.show(
                      context,
                      title: 'Sign out?',
                      body: 'body',
                      confirmLabel: 'Sign out',
                      cancelLabel: 'Stay signed in',
                    ),
                    child: const Text('open'),
                  ),
                ),
              ),
            ),
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SizedBox(height: 80, child: Text('NAV')),
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Sign out?'), findsOneWidget);
    expect(find.text('NAV').hitTestable(), findsNothing);

    await tester.tap(find.text('Stay signed in'));
    await tester.pumpAndSettle();

    expect(result, isFalse);
    expect(find.text('open'), findsOneWidget);
  });
}
