import 'package:flutter/material.dart';

import '../../../../core/widgets/placeholder_screen.dart';

/// C3–C9 — implemented by TASK-016.
class EventDetailScreen extends StatelessWidget {
  const EventDetailScreen({super.key, required this.eventId});

  final int eventId;

  @override
  Widget build(BuildContext context) => PlaceholderScreen(
    title: 'Event $eventId',
    screenId: 'C3',
    showBack: true,
  );
}
