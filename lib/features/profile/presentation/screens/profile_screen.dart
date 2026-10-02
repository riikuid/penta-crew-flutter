import 'package:flutter/material.dart';

import '../../../../core/widgets/placeholder_screen.dart';

/// E1 — implemented by TASK-015.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) => const PlaceholderScreen(
    title: 'Profile',
    screenId: 'E1',
    showBack: false,
  );
}
