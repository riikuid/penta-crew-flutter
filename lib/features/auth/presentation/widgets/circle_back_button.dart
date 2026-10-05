import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_tokens.dart';

/// The 44 px white circle with a hairline border and a 20 px arrow used as the
/// back control on A4/A5 and the forgot-password screens.
///
/// Pops when there is something beneath; otherwise (cold start from a deep
/// link, or `go` navigation) it falls back to [fallbackRoute].
class CircleBackButton extends StatelessWidget {
  const CircleBackButton({
    super.key,
    this.onPressed,
    this.fallbackRoute = AppRoutes.login,
  });

  /// Overrides the default pop/fallback behaviour (A5 → back to step 01).
  final VoidCallback? onPressed;
  final String fallbackRoute;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Material(
      color: tokens.surface,
      shape: CircleBorder(side: BorderSide(color: tokens.line)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed ?? () => _goBack(context),
        child: SizedBox.square(
          dimension: AppSize.tab,
          child: Center(
            child: Icon(Icons.arrow_back, size: 20, color: tokens.ink),
          ),
        ),
      ),
    );
  }

  void _goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(fallbackRoute);
    }
  }
}
