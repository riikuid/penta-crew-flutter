import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/locator.dart';
import '../../../../core/theme/app_tokens.dart';
import '../cubit/unread_count_cubit.dart';

/// Overlays a small ink dot on the top-right of [child] while there are
/// unread notifications (copy table B1: "unread dot when `unread_count > 0`").
///
/// Reads the app-scoped [UnreadCountCubit] from `sl` — the list cubit keeps
/// it in sync locally; this widget refetches it when it first shows and on
/// every app resume, so a push received in the background is reflected.
class UnreadDot extends StatefulWidget {
  const UnreadDot({required this.child, super.key});

  /// Accessibility label of the dot; also what tests look for.
  static const semanticsLabel = 'Unread notifications';

  final Widget child;

  @override
  State<UnreadDot> createState() => _UnreadDotState();
}

class _UnreadDotState extends State<UnreadDot> with WidgetsBindingObserver {
  late final UnreadCountCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<UnreadCountCubit>();
    WidgetsBinding.instance.addObserver(this);
    _cubit.fetch();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _cubit.fetch();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UnreadCountCubit, int>(
      bloc: _cubit,
      builder: (context, count) => Stack(
        clipBehavior: Clip.none,
        children: [
          widget.child,
          if (count > 0) const Positioned(top: 2, right: 2, child: _Dot()),
        ],
      ),
    );
  }
}

/// 8 px ink dot with a 2 px surface ring so it reads over the hairline border.
class _Dot extends StatelessWidget {
  const _Dot();

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Semantics(
      label: UnreadDot.semanticsLabel,
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: tokens.ink,
          shape: BoxShape.circle,
          border: Border.all(color: tokens.surface, width: 2),
        ),
      ),
    );
  }
}
