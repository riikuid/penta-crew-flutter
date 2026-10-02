import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:penta_crew/core/theme/app_theme.dart';

extension PumpApp on WidgetTester {
  /// Pumps [child] inside a `MaterialApp` built with the real app theme so
  /// widgets can read `context.tokens`.
  Future<void> pumpApp(Widget child) => pumpWidget(
    MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(body: Center(child: child)),
    ),
  );
}
