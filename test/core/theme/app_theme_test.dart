import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:penta_crew/core/theme/app_colors.dart';
import 'package:penta_crew/core/theme/app_theme.dart';
import 'package:penta_crew/core/theme/app_tokens.dart';

void main() {
  final theme = AppTheme.light();

  test('maps the seven-colour palette onto the ColorScheme', () {
    final s = theme.colorScheme;
    expect(s.primary, AppColors.ink);
    expect(s.onPrimary, AppColors.surface);
    expect(s.secondaryContainer, AppColors.accent); // FilledButton.tonal
    expect(s.onSurfaceVariant, AppColors.muted);
    expect(s.outline, AppColors.line);
    expect(s.error, AppColors.error);
    expect(s.surfaceTint, Colors.transparent);
    expect(theme.scaffoldBackgroundColor, AppColors.background);
  });

  test('registers AppTokens with the editorial styles', () {
    final tokens = theme.extension<AppTokens>();
    expect(tokens, isNotNull);
    expect(tokens!.display.fontSize, 40);
    expect(tokens.display.letterSpacing, closeTo(-1.2, 1e-9)); // -0.03em
    expect(tokens.eyebrow.fontSize, 11);
    expect(tokens.eyebrow.fontWeight, FontWeight.w600);
    expect(tokens.eyebrow.color, AppColors.muted);
  });

  test('text scale follows the prototype', () {
    final t = theme.textTheme;
    expect(t.displayMedium?.fontSize, 40);
    expect(t.headlineMedium?.fontSize, 28);
    expect(t.bodyLarge?.fontSize, 16);
    expect(t.labelSmall?.fontSize, 11);
    expect(t.bodyLarge?.fontFamily, contains('Inter'));
  });

  test('inputs are 56 high with a 20px radius', () {
    final d = theme.inputDecorationTheme;
    expect(d.constraints?.minHeight, AppSize.control);
    final border = d.enabledBorder as OutlineInputBorder;
    expect(border.borderRadius.topLeft.x, AppRadius.input);
    expect(border.borderSide.color, AppColors.line);
    final focused = d.focusedBorder as OutlineInputBorder;
    expect(focused.borderSide.color, AppColors.ink);
    final error = d.errorBorder as OutlineInputBorder;
    expect(error.borderSide.width, 1.5);
  });

  test('filled buttons share the disabled look but keep scheme fills', () {
    final style = theme.filledButtonTheme.style!;
    expect(
      style.minimumSize?.resolve({})?.height,
      AppSize.control,
    );
    expect(style.shape?.resolve({}), isA<StadiumBorder>());
    expect(
      style.backgroundColor?.resolve({WidgetState.disabled}),
      AppColors.line,
    );
    // Enabled fill is left to the scheme so FilledButton and
    // FilledButton.tonal can differ (ink vs blush).
    expect(style.backgroundColor?.resolve({}), isNull);
  });

  testWidgets('context.tokens resolves under the app theme', (tester) async {
    late AppTokens tokens;
    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: Builder(
          builder: (context) {
            tokens = context.tokens;
            return const SizedBox();
          },
        ),
      ),
    );
    expect(tokens.accent, AppColors.accent);
  });
}
