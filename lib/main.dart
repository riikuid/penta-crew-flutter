import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'app.dart';
import 'core/di/locator.dart';
import 'core/logging/app_logger.dart';
import 'core/push/push_service.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupLocator();
  Bloc.observer = AppBlocObserver(sl<Talker>());

  // A missing/invalid native push config (google-services.json, APNs) must
  // never block startup — push just stays off and the error is logged.
  try {
    await sl<PushService>().init();
  } catch (e, st) {
    sl<Talker>().handle(e, st, 'PushService.init failed; push disabled');
  }

  // Start verifying the stored session; SplashScreen waits for the outcome.
  sl<AuthCubit>().checkSession();

  runApp(const App());
}
