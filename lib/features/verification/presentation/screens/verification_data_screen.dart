import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/eyebrow.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../profile/presentation/widgets/circle_back_button.dart';
import '../../../profile/presentation/widgets/grouped_card.dart';
import '../../../profile/presentation/widgets/profile_values.dart';

/// "View my data" from A6 (no prototype frame): the E1 rows, read-only, for
/// a user whose profile is still under review (D-01).
class VerificationDataScreen extends StatelessWidget {
  const VerificationDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final textTheme = Theme.of(context).textTheme;
    final user = context.watch<AuthCubit>().user;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: CircleBackButton(),
            ),
            const SizedBox(height: 28),
            const Eyebrow('Crew account'),
            const SizedBox(height: 6),
            Text('My data', style: tokens.display),
            const SizedBox(height: 14),
            Text(
              'This is what the admin will review. You can edit it if changes '
              'are requested.',
              style: textTheme.bodyMedium?.copyWith(color: tokens.muted),
            ),
            const SizedBox(height: 24),
            if (user != null)
              GroupedCard(
                children: [
                  InfoRow(
                    icon: Icons.person_outline,
                    label: 'Full name',
                    value: user.name,
                  ),
                  InfoRow(
                    icon: Icons.mail_outline,
                    label: 'Email',
                    value: ProfileValues.orDash(user.email),
                  ),
                  InfoRow(
                    icon: Icons.store_outlined,
                    label: 'Branch',
                    value: ProfileValues.orDash(user.branch?.name),
                  ),
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
                ],
              ),
          ],
        ),
      ),
    );
  }
}
