import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../config/env.dart';

/// Single Talker instance. Also drives `TalkerDioLogger` and [AppBlocObserver].
Talker buildTalker() => TalkerFlutter.init(
  settings: TalkerSettings(
    enabled: Env.enableLogging,
    useConsoleLogs: Env.enableLogging,
  ),
);

/// Logs cubit errors (and, outside prod, state transitions) through Talker.
class AppBlocObserver extends BlocObserver {
  const AppBlocObserver(this._talker);

  final Talker _talker;

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    if (!Env.isProd) {
      _talker.debug(
        '${bloc.runtimeType}: ${change.currentState.runtimeType} → ${change.nextState.runtimeType}',
      );
    }
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    _talker.handle(error, stackTrace, '${bloc.runtimeType} error');
    super.onError(bloc, error, stackTrace);
  }
}
