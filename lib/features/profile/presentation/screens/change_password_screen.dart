import 'package:flutter/material.dart';

import '../../../../core/widgets/placeholder_screen.dart';

/// E3 — implemented by TASK-015.
class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) => const PlaceholderScreen(
    title: 'Change password',
    screenId: 'E3',
    showBack: true,
  );
}
