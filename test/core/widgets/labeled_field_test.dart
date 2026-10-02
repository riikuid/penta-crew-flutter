import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:penta_crew/core/theme/app_tokens.dart';
import 'package:penta_crew/core/widgets/labeled_field.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('renders an uppercase eyebrow label above a 56px input', (
    tester,
  ) async {
    await tester.pumpApp(
      const Padding(
        padding: EdgeInsets.all(24),
        child: AppTextField(label: 'Email', hint: 'name@email.com'),
      ),
    );

    expect(find.text('EMAIL'), findsOneWidget);
    expect(find.text('name@email.com'), findsOneWidget);
    expect(
      tester.getSize(find.byType(TextFormField)).height,
      AppSize.control,
    );
  });

  testWidgets('shows server errorText and validator errors the same way', (
    tester,
  ) async {
    final formKey = GlobalKey<FormState>();
    await tester.pumpApp(
      Form(
        key: formKey,
        child: Column(
          children: [
            const AppTextField(label: 'Email', errorText: 'Already taken'),
            AppTextField(
              label: 'Password',
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),
          ],
        ),
      ),
    );

    expect(find.text('Already taken'), findsOneWidget);
    expect(find.text('Required'), findsNothing);

    formKey.currentState!.validate();
    await tester.pump();
    expect(find.text('Required'), findsOneWidget);
  });

  testWidgets('obscureText adds an eye toggle', (tester) async {
    await tester.pumpApp(
      const AppTextField(label: 'Password', obscureText: true),
    );

    EditableText editable() =>
        tester.widget<EditableText>(find.byType(EditableText));

    expect(editable().obscureText, isTrue);
    await tester.tap(find.byIcon(Icons.visibility_outlined));
    await tester.pump();
    expect(editable().obscureText, isFalse);
    expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
  });

  testWidgets('picker field shows placeholder, value and error', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpApp(
      Column(
        children: [
          AppPickerField(
            label: 'Branch',
            placeholder: 'Select branch',
            onTap: () => taps++,
          ),
          const AppPickerField(
            label: 'Gender',
            value: 'Female',
            errorText: 'Pick one',
            onTap: null,
          ),
        ],
      ),
    );

    expect(find.text('BRANCH'), findsOneWidget);
    expect(find.text('Select branch'), findsOneWidget);
    expect(find.text('Female'), findsOneWidget);
    expect(find.text('Pick one'), findsOneWidget);

    await tester.tap(find.text('Select branch'));
    expect(taps, 1);
  });
}
