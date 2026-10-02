import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';
import 'app_button.dart';
import 'app_card.dart';

/// Full-area loading indicator. Prefer `Skeleton`s for list/section loads;
/// use this only where the layout is unknown until data arrives.
class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator.adaptive());
}

/// Empty list / no data, in the prototype's card form: blush icon circle,
/// 28px headline, muted body, optional action.
class EmptyView extends StatelessWidget {
  const EmptyView({
    super.key,
    this.title,
    this.message = 'Nothing here yet.',
    this.icon = Icons.inbox_outlined,
    this.action,
  });

  final String? title;
  final String message;
  final IconData icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return _StateCard(
      icon: icon,
      title: title,
      message: message,
      action: action,
    );
  }
}

/// Error with optional retry. Same card as [EmptyView] so the two states sit
/// in the same place and the only difference is copy + icon.
class ErrorView extends StatelessWidget {
  const ErrorView({
    super.key,
    required this.message,
    this.title,
    this.onRetry,
    this.retryLabel = 'Try again',
  });

  final String message;
  final String? title;
  final VoidCallback? onRetry;
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    return _StateCard(
      icon: Icons.error_outline,
      title: title,
      message: message,
      action: onRetry == null
          ? null
          : AppButton(
              label: retryLabel,
              onPressed: onRetry,
              variant: AppButtonVariant.outlined,
              size: AppButtonSize.medium,
              expand: false,
            ),
    );
  }
}

class _StateCard extends StatelessWidget {
  const _StateCard({
    required this.icon,
    required this.title,
    required this.message,
    required this.action,
  });

  final IconData icon;
  final String? title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSize.pagePadding),
        child: AppCard(
          radius: AppRadius.cardLarge,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: ShapeDecoration(
                  color: tokens.accent,
                  shape: const CircleBorder(),
                ),
                alignment: Alignment.center,
                child: Icon(icon, size: 22, color: tokens.ink),
              ),
              const SizedBox(height: 14),
              if (title != null) ...[
                Text(title!, style: textTheme.headlineMedium),
                const SizedBox(height: 8),
              ],
              Text(
                message,
                style: textTheme.bodySmall?.copyWith(color: tokens.muted),
              ),
              if (action != null) ...[
                const SizedBox(height: 20),
                action!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
