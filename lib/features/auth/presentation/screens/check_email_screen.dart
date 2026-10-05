import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_toast.dart';
import '../cubit/check_email_cubit.dart';
import '../cubit/check_email_state.dart';
import '../widgets/auth_intro.dart';
import '../widgets/auth_page.dart';

/// A2c Check your email.
class CheckEmailScreen extends StatelessWidget {
  const CheckEmailScreen({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckEmailCubit, CheckEmailState>(
      listener: _onStateChanged,
      builder: (context, state) {
        final resendLabel = switch (state) {
          CheckEmailCoolingDown(:final secondsLeft) =>
            'Resend in ${secondsLeft}s',
          _ => 'Resend',
        };
        return AuthPage(
          actions: [
            AppButton(
              label: 'Back to sign in',
              onPressed: () => context.go(AppRoutes.login),
            ),
            AppButton(
              label: resendLabel,
              variant: AppButtonVariant.ghost,
              size: AppButtonSize.medium,
              loading: state is CheckEmailResending,
              onPressed: state is CheckEmailReady
                  ? context.read<CheckEmailCubit>().resend
                  : null,
            ),
          ],
          children: [
            AuthIntro(
              headline: 'Check your email.',
              body:
                  'If $email is registered, we\'ve sent a link to reset your '
                  'password. The link works for 60 minutes.',
            ),
          ],
        );
      },
    );
  }

  void _onStateChanged(BuildContext context, CheckEmailState state) {
    switch (state) {
      case CheckEmailResent():
        AppToast.success('Link sent again');
      case CheckEmailFailure(:final message):
        AppToast.error(message);
      case _:
        break;
    }
  }
}
