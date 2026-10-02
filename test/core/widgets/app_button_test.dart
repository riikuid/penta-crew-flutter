import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:penta_crew/core/theme/app_colors.dart';
import 'package:penta_crew/core/theme/app_tokens.dart';
import 'package:penta_crew/core/widgets/app_button.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('primary is a 56px FilledButton that fires onPressed', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpApp(
      AppButton(label: 'Sign in', onPressed: () => taps++),
    );

    expect(find.byType(FilledButton), findsOneWidget);
    expect(tester.getSize(find.byType(FilledButton)).height, AppSize.control);

    await tester.tap(find.text('Sign in'));
    expect(taps, 1);
  });

  testWidgets('loading disables the button, hides the label, shows a spinner', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpApp(
      AppButton(label: 'Sign in', loading: true, onPressed: () => taps++),
    );

    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(button.onPressed, isNull);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    // Label stays in the tree (invisible) so the width does not jump.
    expect(find.text('Sign in'), findsOneWidget);
    expect(
      tester.widget<Opacity>(find.byType(Opacity)).opacity,
      0,
    );

    await tester.tap(find.byType(FilledButton), warnIfMissed: false);
    expect(taps, 0);
  });

  testWidgets('variants pick the right Material button', (tester) async {
    await tester.pumpApp(
      const Column(
        children: [
          AppButton(
            label: 'secondary',
            onPressed: _noop,
            variant: AppButtonVariant.secondary,
          ),
          AppButton(
            label: 'outlined',
            onPressed: _noop,
            variant: AppButtonVariant.outlined,
          ),
          AppButton(
            label: 'danger',
            onPressed: _noop,
            variant: AppButtonVariant.danger,
          ),
          AppButton(
            label: 'ghost',
            onPressed: _noop,
            variant: AppButtonVariant.ghost,
            size: AppButtonSize.medium,
          ),
        ],
      ),
    );

    expect(find.byType(FilledButton), findsOneWidget); // tonal
    expect(find.byType(OutlinedButton), findsNWidgets(2));
    expect(find.byType(TextButton), findsOneWidget);
    expect(
      tester.getSize(find.byType(TextButton)).height,
      AppSize.controlMedium,
    );

    final dangerText = tester.widget<Text>(find.text('danger'));
    final dangerStyle = DefaultTextStyle.of(
      tester.element(find.text('danger')),
    ).style;
    expect(dangerText.data, 'danger');
    expect(dangerStyle.color, AppColors.error);
  });
}

void _noop() {}
