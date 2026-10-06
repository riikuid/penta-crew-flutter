import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../core/utils/app_dates.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/eyebrow.dart';
import '../../../../core/widgets/status_pill.dart';
import '../../../../core/widgets/tag_chip.dart';
import '../../../auth/models/user.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../profile_routes.dart';
import '../widgets/avatar_circle.dart';
import '../widgets/confirm_sheet.dart';
import '../widgets/grouped_card.dart';
import '../widgets/profile_values.dart';

/// E1 — the Profile tab. Read-only view of `AuthCubit.user`; edits happen on
/// E2/E3 and come back through `AuthCubit.updateUser`, so this screen simply
/// rebuilds.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _signingOut = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final user = context.watch<AuthCubit>().user;
    // The shell adds the pill nav's footprint to the bottom padding.
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset + 24),
          children: [
            const Eyebrow('Crew account'),
            const SizedBox(height: 6),
            Text('Profile', style: tokens.display),
            const SizedBox(height: 18),
            if (user != null) ...[
              _IdentityCard(user: user),
              const SizedBox(height: 18),
              GroupedCard(
                children: [
                  InfoRow(
                    icon: Icons.phone_outlined,
                    label: 'Phone',
                    value: ProfileValues.orDash(user.phone),
                  ),
                  InfoRow(
                    icon: Icons.cake_outlined,
                    label: 'Date of birth',
                    value: ProfileValues.dateOfBirthAndGender(user),
                  ),
                  InfoRow(
                    icon: Icons.location_on_outlined,
                    label: 'Home address',
                    value: ProfileValues.orDash(user.address),
                  ),
                  if (user.memberSince != null)
                    InfoRow(
                      icon: Icons.calendar_today_outlined,
                      label: 'Member since',
                      value: AppDates.short(user.memberSince!),
                    ),
                ],
              ),
              const SizedBox(height: 18),
            ],
            GroupedCard(
              children: [
                ActionRow(
                  icon: Icons.edit_outlined,
                  label: 'Edit profile',
                  onTap: () => context.push(ProfileRoutes.edit),
                ),
                ActionRow(
                  icon: Icons.lock_outline,
                  label: 'Change password',
                  onTap: () => context.push(ProfileRoutes.password),
                ),
              ],
            ),
            const SizedBox(height: 18),
            AppButton(
              label: 'Sign out',
              icon: Icons.logout,
              variant: AppButtonVariant.danger,
              size: AppButtonSize.tall,
              loading: _signingOut,
              onPressed: _signOut,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signOut() async {
    if (!await confirmSignOut(context)) return;
    if (!mounted) return;
    setState(() => _signingOut = true);
    await context.read<AuthCubit>().logout();
    if (mounted) setState(() => _signingOut = false);
  }
}

/// Avatar + name/email, the Verified and branch pills, then the admin-set
/// roles under a hairline (prototype E1 top card, radius 40).
class _IdentityCard extends StatelessWidget {
  const _IdentityCard({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final textTheme = Theme.of(context).textTheme;
    final branchName = user.branch?.name;

    return AppCard(
      radius: AppRadius.cardLarge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AvatarCircle(user: user),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.name, style: textTheme.headlineSmall),
                    const SizedBox(height: 4),
                    Text(
                      user.email ?? '',
                      style: textTheme.bodySmall?.copyWith(color: tokens.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (user.isVerified) const StatusPill.verified(),
              if (branchName != null)
                StatusPill(label: '$branchName branch', tone: PillTone.sunken),
            ],
          ),
          if (user.roles.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 18),
            const Eyebrow('Roles · set by admin'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final role in user.roles)
                  TagChip(label: role.name, tone: TagChipTone.accent),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
