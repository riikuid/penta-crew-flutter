import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../auth/models/user.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';

/// A6 pending / A7 not approved — implemented by TASK-015. The placeholder
/// shows the status and offers Sign out so the guard loop can be verified.
class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final status = context.select(
      (AuthCubit c) => c.user?.verificationStatus ?? VerificationStatus.unknown,
    );
    final (id, title) = switch (status) {
      VerificationStatus.rejected => ('A7', 'Not approved'),
      _ => ('A6', 'Under review'),
    };

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(id, style: tokens.eyebrow),
              const SizedBox(height: 8),
              Text(title, style: tokens.display),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => context.read<AuthCubit>().logout(),
                child: const Text('Sign out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
