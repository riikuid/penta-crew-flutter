import 'package:flutter/material.dart';

import '../../../../core/widgets/placeholder_screen.dart';

/// "View my data" from A6 — implemented by TASK-015.
class VerificationDataScreen extends StatelessWidget {
  const VerificationDataScreen({super.key});

  @override
  Widget build(BuildContext context) => const PlaceholderScreen(
    title: 'My data',
    screenId: 'A6',
    showBack: true,
  );
}
