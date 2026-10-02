import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';

/// Placeholder for B1–B3; the real Home arrives with TASK-018. Keeps a sign
/// out action so the shell/guard loop can be exercised on a simulator.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final user = context.select(
      (AuthCubit c) => switch (c.state) {
        Authenticated(:final user) => user,
        _ => null,
      },
    );

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          children: [
            Text('B1', style: tokens.eyebrow),
            const SizedBox(height: 8),
            Text('Hello, ${user?.name ?? '-'}', style: tokens.display),
            if (user?.email != null) ...[
              const SizedBox(height: 8),
              Text(user!.email!, style: tokens.caption),
            ],
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => context.read<AuthCubit>().logout(),
              child: const Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }
}
