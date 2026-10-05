import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/env.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/state_views.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

/// A1. Waits for `AuthCubit.checkSession()` (started in `main.dart`) and then
/// goes to `?from=` or home. Guards take over from there (home → login if
/// signed out).
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, this.from});

  final String? from;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // The session may already be resolved before this listener is attached.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _maybeLeave(context.read<AuthCubit>().state);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) => _maybeLeave(state),
      builder: (context, state) {
        return Scaffold(
          body: switch (state) {
            AuthUnavailable(:final message) => ErrorView(
              message: message,
              onRetry: () => context.read<AuthCubit>().checkSession(),
            ),
            _ => const _Brand(),
          },
        );
      },
    );
  }

  void _maybeLeave(AuthState state) {
    if (state is AuthUnknown || state is AuthUnavailable) return;
    context.go(widget.from ?? AppRoutes.home);
  }
}

/// Centred wordmark over the "Freelance event crew" eyebrow (A1). There is no
/// logo asset in the repo yet, so the app name stands in for the 168 px image.
class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(Env.appName, style: tokens.display, textAlign: TextAlign.center),
          const SizedBox(height: 28),
          Text(
            'Freelance event crew'.toUpperCase(),
            // A1 tracks wider than the other eyebrows: 0.08em × 11px.
            style: tokens.eyebrow.copyWith(letterSpacing: 0.88),
          ),
        ],
      ),
    );
  }
}
