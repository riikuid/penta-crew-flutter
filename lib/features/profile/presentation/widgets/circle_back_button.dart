import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_tokens.dart';

/// 44 px white circle with a hairline border and a 20 px arrow — the back
/// control of every root-level page (E2, E3, "View my data").
///
/// Defaults to `context.pop()`; pass [onPressed] to override.
class CircleBackButton extends StatelessWidget {
  const CircleBackButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Material(
      color: tokens.surface,
      shape: CircleBorder(side: BorderSide(color: tokens.line)),
      clipBehavior: Clip.antiAlias,
      child: IconButton(
        onPressed: onPressed ?? () => context.pop(),
        tooltip: 'Back',
        constraints: const BoxConstraints.tightFor(
          width: AppSize.tab,
          height: AppSize.tab,
        ),
        padding: EdgeInsets.zero,
        icon: Icon(Icons.arrow_back, size: 20, color: tokens.ink),
      ),
    );
  }
}
