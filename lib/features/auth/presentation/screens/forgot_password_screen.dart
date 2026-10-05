import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/labeled_field.dart';
import '../../auth_routes.dart';
import '../cubit/forgot_password_cubit.dart';
import '../cubit/forgot_password_state.dart';
import '../form_validators.dart';
import '../widgets/auth_intro.dart';
import '../widgets/auth_page.dart';
import '../widgets/circle_back_button.dart';

/// A2b Forgot password.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key, this.initialEmail});

  /// Prefilled from whatever the user typed on Sign in (passed via `extra`).
  final String? initialEmail;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _emailController = TextEditingController(
    text: widget.initialEmail,
  );

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
      listener: _onStateChanged,
      builder: (context, state) {
        final submitting = state is ForgotPasswordSubmitting;
        return AuthPage(
          leading: const CircleBackButton(),
          actions: [
            AppButton(
              label: 'Send link',
              loading: submitting,
              onPressed: _submit,
            ),
            AppButton(
              label: 'Back to sign in',
              variant: AppButtonVariant.ghost,
              size: AppButtonSize.medium,
              onPressed: submitting ? null : () => context.go(AppRoutes.login),
            ),
          ],
          children: [
            const AuthIntro(
              headline: 'Reset your password.',
              body:
                  "Enter the email you registered with and we'll send you a "
                  'link.',
            ),
            const SizedBox(height: 36),
            Form(
              key: _formKey,
              child: AppTextField(
                label: 'Email',
                hint: 'name@email.com',
                controller: _emailController,
                enabled: !submitting,
                autofocus: widget.initialEmail?.isEmpty ?? true,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.email],
                validator: (value) => FormValidators.isEmail(value ?? '')
                    ? null
                    : 'Enter a valid email address.',
                onFieldSubmitted: (_) => _submit(),
              ),
            ),
          ],
        );
      },
    );
  }

  void _onStateChanged(BuildContext context, ForgotPasswordState state) {
    switch (state) {
      case ForgotPasswordSent(:final email):
        context.go(AuthRoutes.checkEmail, extra: email);
      case ForgotPasswordFailure(:final message):
        AppToast.error(message);
      case _:
        break;
    }
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    context.read<ForgotPasswordCubit>().submit(_emailController.text);
  }
}
