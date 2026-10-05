import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/labeled_field.dart';
import '../../auth_routes.dart';
import '../cubit/reset_password_cubit.dart';
import '../cubit/reset_password_state.dart';
import '../form_validators.dart';
import '../widgets/auth_intro.dart';
import '../widgets/auth_page.dart';
import '../widgets/circle_back_button.dart';

/// A2d Reset password. Opened from the email deep link
/// (`/reset-password?token=…&email=…`, D-02), so it may be the only page on
/// the stack: every exit is a `go`, never a `pop`.
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({
    super.key,
    required this.token,
    required this.email,
  });

  final String token;
  final String email;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // The rules card and the CTA follow the fields live.
    _passwordController.addListener(_onChanged);
    _confirmController.addListener(_onChanged);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
      listener: _onStateChanged,
      builder: (context, state) => switch (state) {
        ResetPasswordExpired() => const _ExpiredView(),
        _ => _buildForm(state is ResetPasswordSubmitting),
      },
    );
  }

  Widget _buildForm(bool submitting) {
    final password = _passwordController.text;
    final confirm = _confirmController.text;
    final hasMinLength = FormValidators.hasMinLength(password);
    final containsDigit = FormValidators.containsDigit(password);
    final matches = password.isNotEmpty && password == confirm;
    final allRulesPass = hasMinLength && containsDigit && matches;

    return AuthPage(
      leading: const CircleBackButton(),
      actions: [
        AppButton(
          label: 'Update password',
          loading: submitting,
          onPressed: allRulesPass ? _submit : null,
        ),
      ],
      children: [
        const AuthIntro(
          headline: 'Choose a new password.',
          body: 'Use it to sign in on every device.',
        ),
        const SizedBox(height: 36),
        AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                label: 'New password',
                hint: 'At least 8 characters',
                controller: _passwordController,
                enabled: !submitting,
                obscureText: true,
                autofocus: true,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.newPassword],
              ),
              const SizedBox(height: 14),
              AppTextField(
                label: 'Confirm new password',
                hint: 'Type it again',
                controller: _confirmController,
                enabled: !submitting,
                obscureText: true,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.newPassword],
                onFieldSubmitted: (_) {
                  if (allRulesPass) _submit();
                },
              ),
              const SizedBox(height: 14),
              _PasswordRules(
                hasMinLength: hasMinLength,
                containsDigit: containsDigit,
                matches: matches,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _onStateChanged(BuildContext context, ResetPasswordState state) {
    switch (state) {
      case ResetPasswordSuccess():
        AppToast.success(
          'Password updated',
          description: 'Sign in with your new password.',
        );
        context.go(AppRoutes.login);
      case ResetPasswordFailure(:final message):
        AppToast.error(message);
      case _:
        break;
    }
  }

  void _onChanged() => setState(() {});

  void _submit() {
    FocusScope.of(context).unfocus();
    context.read<ResetPasswordCubit>().submit(_passwordController.text);
  }
}

/// `token_expired` / `token_invalid` or a link without a token.
class _ExpiredView extends StatelessWidget {
  const _ExpiredView();

  @override
  Widget build(BuildContext context) {
    return AuthPage(
      leading: const CircleBackButton(),
      actions: [
        AppButton(
          label: 'Request new link',
          onPressed: () => context.go(AuthRoutes.forgotPassword),
        ),
      ],
      children: const [
        AuthIntro(
          headline: 'This link has expired.',
          body:
              'Reset links work for 60 minutes. Request a new one to '
              'continue.',
        ),
      ],
    );
  }
}

/// E3 rules card: white, radius 24, `padding: 18px 20px`, 12 between rows.
/// Each row is a 22 px circle (ink with a 12 px check when satisfied, 2 px
/// hairline ring otherwise) and 14 px text.
class _PasswordRules extends StatelessWidget {
  const _PasswordRules({
    required this.hasMinLength,
    required this.containsDigit,
    required this.matches,
  });

  final bool hasMinLength;
  final bool containsDigit;
  final bool matches;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      radius: AppRadius.note,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _RuleRow(label: 'At least 8 characters', satisfied: hasMinLength),
          const SizedBox(height: 12),
          _RuleRow(label: 'Contains a number', satisfied: containsDigit),
          const SizedBox(height: 12),
          _RuleRow(label: 'Both new passwords match', satisfied: matches),
        ],
      ),
    );
  }
}

class _RuleRow extends StatelessWidget {
  const _RuleRow({required this.label, required this.satisfied});

  final String label;
  final bool satisfied;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Row(
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: satisfied ? tokens.ink : null,
            border: satisfied ? null : Border.all(color: tokens.line, width: 2),
          ),
          child: satisfied
              ? Icon(Icons.check, size: 12, color: tokens.surface)
              : null,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodySmall),
        ),
      ],
    );
  }
}
