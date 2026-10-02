import 'package:flutter/material.dart';

import '../../../../core/widgets/placeholder_screen.dart';

/// C1 Open / C2 Tracked — implemented by TASK-016.
class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const PlaceholderScreen(title: 'Events', screenId: 'C1');
}
