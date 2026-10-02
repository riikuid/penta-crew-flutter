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

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final RouterRefresh _refresh;
  late final router = buildAppRouter(refreshListenable: _refresh);

  @override
  void initState() {
    super.initState();
    // Guards re-run on every AuthCubit emission (login, logout, 401).
    _refresh = RouterRefresh([sl<AuthCubit>().stream]);
  }

  @override
  void dispose() {
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
        listenWhen: (_, next) =>
            next is Unauthenticated && next.sessionExpired,
        listener: (_, _) => AppToast.warning(AppMessages.sessionExpired),
        child: ToastificationWrapper(
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
