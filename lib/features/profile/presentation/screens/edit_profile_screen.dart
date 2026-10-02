import 'package:flutter/material.dart';

import '../../../../core/widgets/placeholder_screen.dart';

/// E2 — implemented by TASK-015.
class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) => const PlaceholderScreen(
    title: 'Edit profile',
    screenId: 'E2',
    showBack: true,
  );
}
