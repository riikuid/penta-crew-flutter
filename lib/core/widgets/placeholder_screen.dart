import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

/// Stand-in for a screen a later ticket implements. Shows the prototype
/// screen id and name so the route table can be verified on a simulator.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({
    super.key,
    required this.title,
    this.screenId,
    this.showBack = false,
  });

  final String title;

  /// Prototype screen id (e.g. `C3`).
  final String? screenId;

  /// Root-level pages (outside the shell) get a back button.
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Scaffold(
      appBar: showBack ? AppBar() : null,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (screenId != null)
              Text(screenId!.toUpperCase(), style: tokens.eyebrow),
            const SizedBox(height: 8),
            Text(title, style: tokens.display),
          ],
        ),
      ),
    );
  }
}
