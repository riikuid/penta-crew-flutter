import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/labeled_field.dart';
import '../../../auth/auth_routes.dart';
import '../cubit/change_password_cubit.dart';
import '../cubit/change_password_state.dart';
import '../widgets/circle_back_button.dart';
import '../widgets/password_rules_card.dart';

/// E3 — current / new / confirm with the live rule checklist; the CTA is
/// enabled only once every rule passes. A wrong current password (422
/// `errors.current_password`) is shown inline under its field.
class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final textTheme = Theme.of(context).textTheme;

    return BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: _onStatusChanged,
      builder: (context, state) {
        final cubit = context.read<ChangePasswordCubit>();
        final busy = state.submitting;
        final currentPasswordError =
            state.fieldErrors['current_password']?.firstOrNull;

        return Scaffold(
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 14, 20, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: CircleBackButton(),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
                    children: [
                      Text('Change password.', style: textTheme.displaySmall),
                      const SizedBox(height: 10),
                      Text(
                        "You'll stay signed in on this phone.",
                        style: textTheme.bodyMedium?.copyWith(
                          color: tokens.muted,
                        ),
                      ),
                      const SizedBox(height: 28),
                      AppTextField(
                        label: 'Current password',
                        hint: 'Enter current password',
                        obscureText: true,
                        enabled: !busy,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.password],
                        errorText: currentPasswordError,
                        onChanged: cubit.currentPasswordChanged,
                      ),
                      const SizedBox(height: 14),
                      Align(
                        alignment: Alignment.centerRight,
                        child: AppButton(
                          label: 'Forgot password?',
                          variant: AppButtonVariant.ghost,
                          size: AppButtonSize.medium,
                          expand: false,
                          onPressed: () =>
                              context.push(AuthRoutes.forgotPassword),
                        ),
                      ),
                      const SizedBox(height: 14),
                      AppTextField(
                        label: 'New password',
                        hint: 'At least 8 characters',
                        obscureText: true,
                        enabled: !busy,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.newPassword],
                        onChanged: cubit.passwordChanged,
                      ),
                      const SizedBox(height: 14),
                      AppTextField(
                        label: 'Confirm new password',
                        hint: 'Type it again',
                        obscureText: true,
                        enabled: !busy,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.newPassword],
                        onChanged: cubit.confirmationChanged,
                        onFieldSubmitted: (_) => cubit.submit(),
                      ),
                      const SizedBox(height: 28),
                      PasswordRulesCard(
                        hasMinLength: state.hasMinLength,
                        hasNumber: state.hasNumber,
                        matches: state.matches,
                      ),
                    ],
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: tokens.background,
                    border: Border(top: BorderSide(color: tokens.line)),
                  ),
                  child: SafeArea(
                    top: false,
                    minimum: const EdgeInsets.fromLTRB(20, 12, 20, 36),
                    child: AppButton(
                      label: 'Update password',
                      loading: busy,
                      onPressed: state.canSubmit ? cubit.submit : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onStatusChanged(BuildContext context, ChangePasswordState state) {
    switch (state.status) {
      case ChangePasswordStatus.success:
        AppToast.success(
          'Password updated',
          description: "You're still signed in on this phone.",
        );
        context.pop();
      case ChangePasswordStatus.failure when state.fieldErrors.isEmpty:
        AppToast.error(state.message ?? '');
      case _:
        break;
    }
  }
}
