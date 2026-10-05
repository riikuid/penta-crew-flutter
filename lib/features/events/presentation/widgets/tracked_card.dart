import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../core/utils/app_dates.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/progress_timeline.dart';
import '../../../../core/widgets/status_pill.dart';
import '../../models/application.dart';
import '../event_formats.dart';

/// One application on the Tracked tab (C2, prototype `screens.html`
/// :679-699): 32-radius card, 17/500 title, `MON 05 OCT · AS CREW` meta,
/// a small status pill, then the Applied → Closes → Result bar — one segment
/// filled while waiting, all three once the admin has decided.
class TrackedCard extends StatelessWidget {
  const TrackedCard({super.key, required this.application, this.onTap});

  final Application application;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final text = Theme.of(context).textTheme;
    final event = application.event;
    final roleName = application.position.role.name;

    return AppCard(
      padding: const EdgeInsets.all(20),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event?.title ?? '',
                      style: text.titleMedium?.copyWith(
                        fontSize: 17,
                        letterSpacing: -0.17,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      (event == null
                              ? 'as $roleName'
                              : EventFormats.trackedMeta(event.date, roleName))
                          .toUpperCase(),
                      style: tokens.eyebrow.copyWith(
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.44,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _pill(),
            ],
          ),
          const SizedBox(height: 14),
          ProgressTimeline.bar(steps: _steps()),
        ],
      ),
    );
  }

  Widget _pill() => switch (application.status) {
    ApplicationStatus.selected => const StatusPill.selected(small: true),
    ApplicationStatus.notSelected => const StatusPill.notSelected(small: true),
    _ => const StatusPill.waiting(label: 'Waiting', small: true),
  };

  List<TimelineStep> _steps() {
    final decided = !application.isWaiting;
    final later = decided ? TimelineStepState.done : TimelineStepState.upcoming;
    return [
      const TimelineStep(label: 'Applied', state: TimelineStepState.done),
      TimelineStep(label: AppDates.closes(application.closesAt), state: later),
      TimelineStep(label: 'Result', state: later),
    ];
  }
}
