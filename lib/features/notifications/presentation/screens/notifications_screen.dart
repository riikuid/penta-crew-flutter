import 'package:flutter/material.dart';

import '../../../../core/widgets/placeholder_screen.dart';

/// Notifications list — implemented by TASK-019.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) => const PlaceholderScreen(
    title: 'Notifications',
    showBack: true,
  );
}
