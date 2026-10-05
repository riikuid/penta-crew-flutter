import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/labeled_field.dart';
import '../../auth_routes.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';
import '../form_validators.dart';
import '../widgets/auth_intro.dart';
import '../widgets/auth_page.dart';

/// A2 Sign in / A3 Sign in · error.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.from});

  /// Where to go after a successful login (set by the guard).
  final String? from;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  /// A3: set from `invalid_credentials`, cleared as soon as the user types.
  bool _showCredentialsError = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return BlocConsumer<LoginCubit, LoginState>(
      listener: _onStateChanged,
      builder: (context, state) {
        final submitting = state is LoginSubmitting;
        final serverErrors = state is LoginFailure
            ? state.fieldErrors
            : const <String, List<String>>{};

        return AuthPage(
          children: [
            AuthIntro(
              headline: 'Welcome back.',
              body: 'Sign in with the email you registered with.',
              headlineStyle: tokens.displayLarge,
            ),
            const SizedBox(height: 36),
            Form(
              key: _formKey,
              child: AutofillGroup(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppTextField(
                      label: 'Email',
                      hint: 'name@email.com',
                      controller: _emailController,
                      enabled: !submitting,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.username],
                      errorText: serverErrors['email']?.firstOrNull,
                      validator: _validateEmail,
                      onChanged: _clearCredentialsError,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Password',
                      hint: 'Enter password',
                      controller: _passwordController,
                      enabled: !submitting,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.password],
                      errorText: _showCredentialsError
                          ? 'Email or password is incorrect.'
                          : serverErrors['password']?.firstOrNull,
                      validator: _validatePassword,
                      onChanged: _clearCredentialsError,
                      onFieldSubmitted: (_) => _submit(),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: _ForgotPasswordLink(
                        onPressed: submitting ? null : _openForgotPassword,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          actions: [
            AppButton(
              label: 'Sign in',
              loading: submitting,
              onPressed: _submit,
            ),
            AppButton(
              label: 'Create account',
              variant: AppButtonVariant.secondary,
              onPressed: submitting
                  ? null
                  : () => context.push(AuthRoutes.register),
            ),
          ],
        );
      },
    );
  }

  void _onStateChanged(BuildContext context, LoginState state) {
    switch (state) {
      case LoginSuccess():
        context.go(widget.from ?? AppRoutes.home);
      case LoginInvalidCredentials():
        // A3: email is kept, password cleared, error inline under the field.
        _passwordController.clear();
        setState(() => _showCredentialsError = true);
      case LoginFailure(:final message, :final fieldErrors)
          when fieldErrors.isEmpty:
        AppToast.error(message);
      case _:
        break;
    }
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Enter your email.';
    if (!FormValidators.isEmail(email)) return 'Enter a valid email address.';
    return null;
  }

  String? _validatePassword(String? value) =>
      (value == null || value.isEmpty) ? 'Enter your password.' : null;

  void _clearCredentialsError(String _) {
    if (_showCredentialsError) setState(() => _showCredentialsError = false);
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    context.read<LoginCubit>().submit(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  void _openForgotPassword() => context.push(
    AuthRoutes.forgotPassword,
    extra: _emailController.text.trim(),
  );
}

/// Right-aligned 14/500 ghost link that sits *below* the password field.
class _ForgotPasswordLink extends StatelessWidget {
  const _ForgotPasswordLink({required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        minimumSize: Size.zero,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        textStyle: Theme.of(context).textTheme.labelLarge,
      ),
      child: const Text('Forgot password?'),
    );
  }
}
