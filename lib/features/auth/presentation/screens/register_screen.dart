import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/labeled_field.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../../core/widgets/state_views.dart';
import '../../models/branch.dart';
import '../../models/user.dart';
import '../cubit/register_cubit.dart';
import '../cubit/register_state.dart';
import '../widgets/step_header.dart';

/// A4 Create account → A5 Complete profile. One screen, two steps; the text
/// controllers live here so going back keeps what the user typed.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  /// Youngest allowed crew member (date-of-birth picker upper bound).
  static const minimumAge = 17;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: _onStatusChanged,
      builder: (context, state) {
        final onAccountStep = state.step == RegisterStep.account;
        return PopScope(
          canPop: onAccountStep,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) _back(state);
          },
          child: Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: StepHeader(
                      step: onAccountStep ? 1 : 2,
                      total: 2,
                      onBack: () => _back(state),
                    ),
                  ),
                ),
                Expanded(
                  child: onAccountStep
                      ? _AccountStep(
                          state: state,
                          nameController: _nameController,
                          emailController: _emailController,
                          phoneController: _phoneController,
                          passwordController: _passwordController,
                          confirmPasswordController: _confirmPasswordController,
                          onSubmit: _continue,
                        )
                      : _ProfileStep(
                          state: state,
                          addressController: _addressController,
                        ),
                ),
                _BottomBar(
                  child: onAccountStep
                      ? _ContinueButton(onPressed: _continue)
                      : AppButton(
                          label: 'Submit for review',
                          loading: state.isSubmitting,
                          onPressed: _submit,
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onStatusChanged(BuildContext context, RegisterState state) {
    switch (state.status) {
      case RegisterStatus.success:
        // The guard sends a pending user on to `/verification` (D-01).
        context.go(AppRoutes.home);
      case RegisterStatus.failure:
        AppToast.error(state.failureMessage ?? 'Something went wrong.');
      case RegisterStatus.editing || RegisterStatus.submitting:
        break;
    }
  }

  void _back(RegisterState state) {
    if (state.step == RegisterStep.profile) {
      context.read<RegisterCubit>().backToAccountStep();
    } else if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.login);
    }
  }

  void _continue() {
    FocusScope.of(context).unfocus();
    context.read<RegisterCubit>().submitAccountStep(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
    );
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    context.read<RegisterCubit>().submit(address: _addressController.text);
  }
}

/// A4 — account details.
class _AccountStep extends StatelessWidget {
  const _AccountStep({
    required this.state,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.onSubmit,
  });

  final RegisterState state;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterCubit>();
    return _StepBody(
      headline: 'Tell us who you are.',
      body: "Account details. You'll add your crew profile next.",
      children: [
        AppTextField(
          label: 'Full name',
          hint: 'As on your ID',
          controller: nameController,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.name],
          errorText: state.errorFor(RegisterField.name),
          onChanged: (_) => cubit.clearError(RegisterField.name),
        ),
        const SizedBox(height: 14),
        AppTextField(
          label: 'Email',
          hint: 'name@email.com',
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.email],
          errorText: state.errorFor(RegisterField.email),
          onChanged: (_) => cubit.clearError(RegisterField.email),
        ),
        const SizedBox(height: 14),
        AppTextField(
          label: 'Phone number',
          hint: '0812 3456 7890',
          controller: phoneController,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.telephoneNumber],
          errorText: state.errorFor(RegisterField.phone),
          onChanged: (_) => cubit.clearError(RegisterField.phone),
        ),
        const SizedBox(height: 14),
        AppTextField(
          label: 'Password',
          hint: 'At least 8 characters',
          controller: passwordController,
          obscureText: true,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.newPassword],
          errorText: state.errorFor(RegisterField.password),
          onChanged: (_) => cubit.clearError(RegisterField.password),
        ),
        const SizedBox(height: 14),
        AppTextField(
          label: 'Confirm password',
          controller: confirmPasswordController,
          obscureText: true,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.newPassword],
          errorText: state.errorFor(RegisterField.passwordConfirmation),
          onChanged: (_) => cubit.clearError(RegisterField.passwordConfirmation),
          onFieldSubmitted: (_) => onSubmit(),
        ),
      ],
    );
  }
}

/// A5 — crew profile.
class _ProfileStep extends StatelessWidget {
  const _ProfileStep({required this.state, required this.addressController});

  final RegisterState state;
  final TextEditingController addressController;

  static final _dateOfBirthFormat = DateFormat('dd / MM / yyyy');

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterCubit>();
    final enabled = !state.isSubmitting;
    return _StepBody(
      headline: 'Your crew profile.',
      body: 'An admin reviews this before your first event.',
      children: [
        AppPickerField(
          label: 'Date of birth',
          placeholder: 'DD / MM / YYYY',
          icon: Icons.calendar_today_outlined,
          value: state.dateOfBirth == null
              ? null
              : _dateOfBirthFormat.format(state.dateOfBirth!),
          errorText: state.errorFor(RegisterField.dateOfBirth),
          enabled: enabled,
          onTap: () => _pickDateOfBirth(context),
        ),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AppPickerField(
                label: 'Gender',
                placeholder: 'Select',
                value: switch (state.gender) {
                  Gender.female => 'Female',
                  Gender.male => 'Male',
                  _ => null,
                },
                errorText: state.errorFor(RegisterField.gender),
                enabled: enabled,
                onTap: () => _pickGender(context),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppPickerField(
                label: 'Branch',
                placeholder: 'Select',
                value: state.branch?.name,
                errorText: state.errorFor(RegisterField.branchId),
                enabled: enabled,
                onTap: () => _pickBranch(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        AppTextField(
          label: 'Home address',
          hint: 'Street, district, city',
          controller: addressController,
          enabled: enabled,
          maxLines: 3,
          keyboardType: TextInputType.streetAddress,
          textCapitalization: TextCapitalization.sentences,
          errorText: state.errorFor(RegisterField.address),
          onChanged: (_) => cubit.clearError(RegisterField.address),
        ),
        const SizedBox(height: 28),
        const _InfoNote(
          'Your crew roles and tags are set by an admin after they review '
          'your profile.',
        ),
      ],
    );
  }

  Future<void> _pickDateOfBirth(BuildContext context) async {
    final cubit = context.read<RegisterCubit>();
    final today = DateTime.now();
    final latest = DateTime(
      today.year - RegisterScreen.minimumAge,
      today.month,
      today.day,
    );
    final picked = await showDatePicker(
      context: context,
      initialDate: state.dateOfBirth ?? latest,
      firstDate: DateTime(1900),
      lastDate: latest,
    );
    if (picked != null) cubit.setDateOfBirth(picked);
  }

  Future<void> _pickGender(BuildContext context) async {
    final cubit = context.read<RegisterCubit>();
    final picked = await showModalBottomSheet<Gender>(
      context: context,
      builder: (_) => _OptionSheet<Gender>(
        title: 'Gender',
        options: const {Gender.female: 'Female', Gender.male: 'Male'},
        selected: state.gender,
      ),
    );
    if (picked != null) cubit.setGender(picked);
  }

  Future<void> _pickBranch(BuildContext context) async {
    final cubit = context.read<RegisterCubit>()..loadBranches();
    final picked = await showModalBottomSheet<Branch>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: _BranchSheet(selected: state.branch),
      ),
    );
    if (picked != null) cubit.setBranch(picked);
  }
}

/// Scrollable step content: `padding: 32px 20px 24px`, 28 between the title
/// block and the fields, 10 between headline and body.
class _StepBody extends StatelessWidget {
  const _StepBody({
    required this.headline,
    required this.body,
    required this.children,
  });

  final String headline;
  final String body;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final textTheme = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      children: [
        Text(headline, style: textTheme.displaySmall),
        const SizedBox(height: 10),
        Text(body, style: textTheme.bodyMedium?.copyWith(color: tokens.muted)),
        const SizedBox(height: 28),
        ...children,
      ],
    );
  }
}

/// Fixed footer: hairline on top, `padding: 12px 20px 36px` (safe area
/// absorbs the bottom).
class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.background,
        border: Border(top: BorderSide(color: tokens.line)),
      ),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: child,
        ),
      ),
    );
  }
}

/// A4 CTA: ink pill with a trailing 18 px arrow (`AppButton` only supports a
/// leading icon).
class _ContinueButton extends StatelessWidget {
  const _ContinueButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: const ButtonStyle(
        minimumSize: WidgetStatePropertyAll(
          Size(double.infinity, AppSize.control),
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Continue'),
          SizedBox(width: 8),
          Icon(Icons.arrow_forward, size: 18),
        ],
      ),
    );
  }
}

/// A5 blush note: radius 24, `padding: 18px 20px`, 18 px info icon, 14 px text.
class _InfoNote extends StatelessWidget {
  const _InfoNote(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      tone: AppCardTone.accent,
      radius: AppRadius.note,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 1),
            child: Icon(Icons.info_outline, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}

/// Bottom sheet with a title and tappable rows; pops with the chosen key.
class _OptionSheet<T> extends StatelessWidget {
  const _OptionSheet({
    required this.title,
    required this.options,
    required this.selected,
  });

  final String title;
  final Map<T, String> options;
  final T? selected;

  @override
  Widget build(BuildContext context) {
    return _SheetFrame(
      title: title,
      children: [
        for (final entry in options.entries)
          _OptionRow(
            label: entry.value,
            selected: entry.key == selected,
            onTap: () => Navigator.of(context).pop(entry.key),
          ),
      ],
    );
  }
}

/// Branch picker fed by `RegisterCubit.loadBranches()`: skeleton rows while
/// loading, `ErrorView` with retry on failure, rows once loaded.
class _BranchSheet extends StatelessWidget {
  const _BranchSheet({required this.selected});

  final Branch? selected;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) =>
          previous.branches != current.branches ||
          previous.branchesLoading != current.branchesLoading ||
          previous.branchesError != current.branchesError,
      builder: (context, state) {
        final List<Widget> children;
        if (state.branchesLoading) {
          children = [
            for (var index = 0; index < 3; index++)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 18),
                child: Skeleton.line(width: 160),
              ),
          ];
        } else if (state.branchesError case final message?) {
          children = [
            ErrorView(
              message: message,
              onRetry: context.read<RegisterCubit>().loadBranches,
            ),
          ];
        } else {
          children = [
            for (final branch in state.branches)
              _OptionRow(
                label: branch.name,
                selected: branch.id == selected?.id,
                onTap: () => Navigator.of(context).pop(branch),
              ),
          ];
        }
        return _SheetFrame(title: 'Branch', children: children);
      },
    );
  }
}

class _SheetFrame extends StatelessWidget {
  const _SheetFrame({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.input),
      child: SizedBox(
        height: AppSize.row,
        child: Row(
          children: [
            Expanded(
              child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
            ),
            if (selected) Icon(Icons.check, size: 20, color: tokens.ink),
          ],
        ),
      ),
    );
  }
}
