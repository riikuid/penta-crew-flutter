import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../auth/models/user.dart';

/// Blush circle with the user's initials (E1: 64 px, 22/500; E2: 72 px,
/// 24/500), or the network photo when `avatar_url` is set.
class AvatarCircle extends StatelessWidget {
  const AvatarCircle({super.key, required this.user, this.size = 64});

  final User user;
  final double size;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final avatarUrl = user.avatarUrl;
    // headlineSmall is the E1 22/500 −0.02em style; E2 scales it to 24.
    final base = Theme.of(context).textTheme.headlineSmall;
    final initialsStyle = size >= 72
        ? base?.copyWith(fontSize: 24, letterSpacing: -0.02 * 24)
        : base;

    return SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: BoxDecoration(color: tokens.accent, shape: BoxShape.circle),
        child: avatarUrl == null
            ? Center(child: Text(user.initials, style: initialsStyle))
            : ClipOval(
                child: Image.network(
                  avatarUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Icon(Icons.person_outline, color: tokens.ink),
                  ),
                ),
              ),
      ),
    );
  }
}
