import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

import 'core/config/app_messages.dart';
import 'core/config/env.dart';
import 'core/di/locator.dart';
import 'core/router/app_router.dart';
import 'core/router/router_refresh.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/app_toast.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/cubit/auth_state.dart';
import 'features/notifications/push_notification_listener.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final RouterRefresh _refresh;
  late final router = buildAppRouter(refreshListenable: _refresh);
  late final PushNotificationListener _pushListener;

  @override
  void initState() {
    super.initState();
    // Guards re-run when the session they read changes (login, logout, 401).
    _refresh = RouterRefresh(sl<AuthCubit>().stream, sl<AuthCubit>());
    // Tapped pushes navigate on this router once the session has resolved.
    _pushListener = PushNotificationListener(
      pushService: sl(),
      session: sl(),
      sessionChanges: sl<AuthCubit>().stream,
      router: router,
      updateDeviceToken: sl(),
      talker: sl(),
    )..start();
  }

  @override
  void dispose() {
    _pushListener.dispose();
    router.dispose();
    _refresh.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Only truly app-wide cubits live here. Page cubits are provided per route.
        BlocProvider.value(value: sl<AuthCubit>()),
      ],
      child: BlocListener<AuthCubit, AuthState>(
        listenWhen: (_, next) => next is Unauthenticated && next.sessionExpired,
        listener: (_, _) => AppToast.warning(AppMessages.sessionExpired),
        child: ToastificationWrapper(
          config: AppToast.config,
          child: MaterialApp.router(
            title: Env.appName,
            debugShowCheckedModeBanner: !Env.isProd,
            // Light only — the prototype has no dark direction (D-12).
            theme: AppTheme.light(),
            themeMode: ThemeMode.light,
            routerConfig: router,
          ),
        ),
      ),
    );
  }
}
