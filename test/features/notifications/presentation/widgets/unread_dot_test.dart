import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:penta_crew/core/di/locator.dart';
import 'package:penta_crew/core/theme/app_theme.dart';
import 'package:penta_crew/features/notifications/presentation/cubit/unread_count_cubit.dart';
import 'package:penta_crew/features/notifications/presentation/widgets/unread_dot.dart';

class _MockUnreadCountCubit extends MockCubit<int>
    implements UnreadCountCubit {}

void main() {
  late _MockUnreadCountCubit cubit;

  setUp(() {
    cubit = _MockUnreadCountCubit();
    when(() => cubit.fetch()).thenAnswer((_) async {});
    sl.registerSingleton<UnreadCountCubit>(cubit);
  });

  tearDown(() async => sl.reset());

  const child = SizedBox(key: Key('bell'), width: 44, height: 44);
  final dot = find.byWidgetPredicate(
    (widget) =>
        widget is Semantics &&
        widget.properties.label == UnreadDot.semanticsLabel,
  );

  Future<void> pumpDot(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const Center(child: UnreadDot(child: child)),
      ),
    );
  }

  testWidgets('hides the dot at zero', (tester) async {
    when(() => cubit.state).thenReturn(0);
    await pumpDot(tester);

    expect(find.byKey(const Key('bell')), findsOneWidget);
    expect(dot, findsNothing);
  });

  testWidgets('shows the dot over the child when unread', (tester) async {
    when(() => cubit.state).thenReturn(3);
    await pumpDot(tester);

    expect(dot, findsOneWidget);
    final childRect = tester.getRect(find.byKey(const Key('bell')));
    final dotRect = tester.getRect(dot);
    expect(dotRect.top, childRect.top + 2);
    expect(dotRect.right, childRect.right - 2);
  });

  testWidgets('follows the count as it changes', (tester) async {
    final counts = StreamController<int>(sync: true);
    addTearDown(counts.close);
    whenListen(cubit, counts.stream, initialState: 0);
    await pumpDot(tester);
    expect(dot, findsNothing);

    counts.add(2);
    await tester.pump();
    expect(dot, findsOneWidget);

    counts.add(0);
    await tester.pump();
    expect(dot, findsNothing);
  });

  testWidgets('fetches on init and on app resume', (tester) async {
    when(() => cubit.state).thenReturn(0);
    await pumpDot(tester);
    verify(() => cubit.fetch()).called(1);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pump();
    verifyNever(() => cubit.fetch());

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    verify(() => cubit.fetch()).called(1);
  });

  testWidgets('stops observing after dispose', (tester) async {
    when(() => cubit.state).thenReturn(0);
    await pumpDot(tester);
    verify(() => cubit.fetch()).called(1);

    await tester.pumpWidget(const SizedBox());
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    verifyNever(() => cubit.fetch());
  });
}
