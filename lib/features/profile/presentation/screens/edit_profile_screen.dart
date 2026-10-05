import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/labeled_field.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../auth/models/branch.dart';
import '../../../auth/models/profile_fields.dart';
import '../../../auth/models/user.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../cubit/edit_profile_cubit.dart';
import '../cubit/edit_profile_state.dart';
import '../widgets/avatar_circle.dart';
import '../widgets/circle_back_button.dart';
import '../widgets/option_sheet.dart';
import '../widgets/profile_values.dart';

/// E2 — the registration fields, prefilled from `AuthCubit.user`. Email is
/// shown but cannot change (contract §2.7). No re-review warning (D-08).
/// While the user is `rejected` the CTA reads "Submit again" (A7 flow).
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  DateTime? _dateOfBirth;
  Gender? _gender;
  Branch? _branch;
  // Picker fields have no validator; their "required" errors live here.
  String? _dateOfBirthError;
  String? _genderError;
  String? _branchError;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthCubit>().user;
    if (user == null) return;
    _nameController.text = user.name;
    _emailController.text = user.email ?? '';
    _phoneController.text = user.phone ?? '';
    _addressController.text = user.address ?? '';
    _dateOfBirth = user.dateOfBirth;
    _gender = switch (user.gender) {
      Gender.female || Gender.male => user.gender,
      _ => null,
    };
    _branch = user.branch;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditProfileCubit, EditProfileState>(
      listener: _onStateChanged,
      builder: (context, state) {
        final user = context.watch<AuthCubit>().user;
        return Scaffold(
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: switch (state) {
                    EditProfileLoading() => const LoadingView(),
                    EditProfileError(:final message) => ErrorView(
                      message: message,
                      onRetry: context.read<EditProfileCubit>().load,
                    ),
                    _ => _buildForm(context, state, user),
                  },
                ),
                if (state is! EditProfileLoading && state is! EditProfileError)
                  _buildBottomBar(context, state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: Row(
        children: [
          const CircleBackButton(),
          const SizedBox(width: 16),
          Text('Edit profile', style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context, EditProfileState state, User? user) {
    final busy = state.saving || state.uploadingAvatar;
    final errors = state.fieldErrors;

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
        children: [
          Row(
            children: [
              if (user != null) AvatarCircle(user: user, size: 72),
              const SizedBox(width: 16),
              AppButton(
                label: 'Change photo',
                icon: Icons.camera_alt_outlined,
                variant: AppButtonVariant.outlined,
                size: AppButtonSize.medium,
                expand: false,
                loading: state.uploadingAvatar,
                onPressed: busy
                    ? null
                    : context.read<EditProfileCubit>().changePhoto,
              ),
            ],
          ),
          const SizedBox(height: 24),
          AppTextField(
            label: 'Full name',
            controller: _nameController,
            enabled: !busy,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            errorText: errors['name']?.firstOrNull,
            validator: (value) => (value == null || value.trim().isEmpty)
                ? 'Enter your full name.'
                : null,
          ),
          const SizedBox(height: 14),
          AppTextField(
            label: 'Email',
            controller: _emailController,
            enabled: false,
          ),
          const SizedBox(height: 14),
          AppTextField(
            label: 'Phone',
            controller: _phoneController,
            enabled: !busy,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            errorText: errors['phone']?.firstOrNull,
            validator: (value) => (value == null || value.trim().isEmpty)
                ? 'Enter your phone number.'
                : null,
          ),
          const SizedBox(height: 14),
          AppPickerField(
            label: 'Date of birth',
            value: _dateOfBirth == null
                ? null
                : ProfileValues.dateOfBirthInput(_dateOfBirth!),
            placeholder: 'DD / MM / YYYY',
            icon: Icons.calendar_today_outlined,
            enabled: !busy,
            errorText:
                errors['date_of_birth']?.firstOrNull ?? _dateOfBirthError,
            onTap: _pickDateOfBirth,
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppPickerField(
                  label: 'Gender',
                  value: ProfileValues.gender(_gender),
                  placeholder: 'Select',
                  enabled: !busy,
                  errorText: errors['gender']?.firstOrNull ?? _genderError,
                  onTap: _pickGender,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppPickerField(
                  label: 'Branch',
                  value: _branch?.name,
                  placeholder: 'Select',
                  enabled: !busy,
                  errorText: errors['branch_id']?.firstOrNull ?? _branchError,
                  onTap: () => _pickBranch(state.branches),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          AppTextField(
            label: 'Home address',
            controller: _addressController,
            enabled: !busy,
            hint: 'Street, district, city',
            maxLines: 3,
            keyboardType: TextInputType.multiline,
            textCapitalization: TextCapitalization.sentences,
            errorText: errors['address']?.firstOrNull,
            validator: (value) => (value == null || value.trim().isEmpty)
                ? 'Enter your home address.'
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, EditProfileState state) {
    final tokens = context.tokens;
    final cubit = context.read<EditProfileCubit>();
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.background,
        border: Border(top: BorderSide(color: tokens.line)),
      ),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(20, 12, 20, 36),
        child: AppButton(
          label: cubit.resubmits ? 'Submit again' : 'Save changes',
          loading: state.saving,
          onPressed: state.uploadingAvatar ? null : _submit,
        ),
      ),
    );
  }

  void _onStateChanged(BuildContext context, EditProfileState state) {
    switch (state) {
      case EditProfileSaved(:final resubmitted):
        if (!resubmitted) {
          AppToast.success(
            'Profile updated',
            description: 'Your changes are saved.',
          );
        }
        context.pop();
      case EditProfileFailure(:final message, :final fieldErrors)
          when fieldErrors.isEmpty:
        AppToast.error(message);
      case _:
        break;
    }
  }

  Future<void> _pickDateOfBirth() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime(now.year - 20, now.month, now.day),
      firstDate: DateTime(now.year - 100),
      lastDate: now,
    );
    if (picked == null || !mounted) return;
    setState(() {
      _dateOfBirth = picked;
      _dateOfBirthError = null;
    });
  }

  Future<void> _pickGender() async {
    final picked = await OptionSheet.show<Gender>(
      context,
      title: 'Gender',
      options: const [Gender.female, Gender.male],
      label: (gender) => ProfileValues.gender(gender) ?? '',
      selected: _gender,
    );
    if (picked == null || !mounted) return;
    setState(() {
      _gender = picked;
      _genderError = null;
    });
  }

  Future<void> _pickBranch(List<Branch> branches) async {
    final picked = await OptionSheet.show<Branch>(
      context,
      title: 'Branch',
      options: branches,
      label: (branch) => branch.name,
      selected: _branch,
    );
    if (picked == null || !mounted) return;
    setState(() {
      _branch = picked;
      _branchError = null;
    });
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    final fieldsValid = _formKey.currentState!.validate();
    setState(() {
      _dateOfBirthError = _dateOfBirth == null
          ? 'Enter your date of birth.'
          : null;
      _genderError = _gender == null ? 'Select your gender.' : null;
      _branchError = _branch == null ? 'Select your branch.' : null;
    });
    if (!fieldsValid ||
        _dateOfBirth == null ||
        _gender == null ||
        _branch == null) {
      return;
    }

    context.read<EditProfileCubit>().save(
      ProfileFields(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        dateOfBirth: _dateOfBirth!,
        gender: _gender!,
        branchId: _branch!.id,
        address: _addressController.text.trim(),
      ),
    );
  }
}
