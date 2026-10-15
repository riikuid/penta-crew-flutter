import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../core/utils/app_dates.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/eyebrow.dart';
import '../../../../core/widgets/progress_timeline.dart';
import '../../../../core/widgets/status_pill.dart';
import '../../../auth/models/user.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../profile/presentation/widgets/confirm_sheet.dart';
import '../../../profile/profile_routes.dart';
import '../../verification_routes.dart';

/// A6 (pending) / A7 (not approved). Everything comes from `AuthCubit.user`
/// (contract §3: no `GET /me/verification`); pull-to-refresh re-runs
/// `checkSession()` so an approval made meanwhile moves the user to Home
/// through the route guard.
class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  bool _signingOut = false;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthCubit>().user;
    final rejected = user?.verificationStatus == VerificationStatus.rejected;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: SafeArea(
                minimum: const EdgeInsets.fromLTRB(20, 24, 20, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (rejected)
                      _RejectedBody(user: user!)
                    else
                      _PendingBody(user: user),
                    const Spacer(),
                    const SizedBox(height: 32),
                    if (rejected)
                      AppButton(
                        label: 'Edit profile',
                        onPressed: () => context.push(ProfileRoutes.edit),
                      )
                    else
                      AppButton(
                        label: 'View my data',
                        variant: AppButtonVariant.secondary,
                        onPressed: () => context.push(VerificationRoutes.data),
                      ),
                    const SizedBox(height: 6),
                    AppButton(
                      label: 'Sign out',
                      variant: AppButtonVariant.ghost,
                      size: AppButtonSize.medium,
                      loading: _signingOut,
                      onPressed: _signOut,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refresh() => context.read<AuthCubit>().checkSession();

  Future<void> _signOut() async {
    if (!await confirmSignOut(context)) return;
    if (!mounted) return;
    setState(() => _signingOut = true);
    await context.read<AuthCubit>().logout();
    if (mounted) setState(() => _signingOut = false);
  }
}

/// A6: "Under review" pill, headline, body and the three-step timeline card.
class _PendingBody extends StatelessWidget {
  const _PendingBody({required this.user});

  final User? user;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final textTheme = Theme.of(context).textTheme;
    final submittedAt = user?.submittedAt;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StatusPill(
          label: 'Under review',
          icon: Icons.schedule,
          tone: PillTone.accent,
        ),
        const SizedBox(height: 14),
        Text("We're reviewing your profile.", style: tokens.display),
        const SizedBox(height: 14),
        Text(
          "An admin will check your data and assign your crew roles. We'll "
          "notify you when it's done.",
          style: textTheme.bodyMedium?.copyWith(color: tokens.muted),
        ),
        const SizedBox(height: 32),
        AppCard(
          radius: AppRadius.cardLarge,
          child: ProgressTimeline(
            steps: [
              TimelineStep(
                label: 'Profile submitted',
                sublabel: submittedAt == null
                    ? null
                    : AppDates.stampWithTime(submittedAt),
                state: TimelineStepState.done,
              ),
              const TimelineStep(
                label: 'Admin review',
                sublabel: 'IN PROGRESS',
                state: TimelineStepState.current,
              ),
              const TimelineStep(
                label: 'Roles assigned',
                sublabel: 'NEXT',
                state: TimelineStepState.upcoming,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// A7: "Not approved" pill, headline, body and the admin note on a blush card.
class _RejectedBody extends StatelessWidget {
  const _RejectedBody({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final textTheme = Theme.of(context).textTheme;
    final reviewedAt = user.reviewedAt;
    final meta = reviewedAt == null
        ? ''
        : AppDates.short(reviewedAt).toUpperCase();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StatusPill.notApproved(),
        const SizedBox(height: 14),
        Text('Your profile needs changes.', style: tokens.display),
        const SizedBox(height: 14),
        Text(
          'Update the details below and submit again. Your account stays '
          "inactive until it's approved.",
          style: textTheme.bodyMedium?.copyWith(color: tokens.muted),
        ),
        const SizedBox(height: 32),
        AppCard(
          tone: AppCardTone.accent,
          radius: AppRadius.cardLarge,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Eyebrow('Note from admin', color: tokens.ink),
              const SizedBox(height: 12),
              Text(
                '"${user.verificationNote ?? ''}"',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                  height: 1.45,
                ),
              ),
              if (meta.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  meta,
                  style: tokens.eyebrow.copyWith(
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
