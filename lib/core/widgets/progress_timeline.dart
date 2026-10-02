import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

enum TimelineStepState { done, current, upcoming }

class TimelineStep {
  const TimelineStep({required this.label, this.sublabel, required this.state});

  final String label;

  /// Small muted line under the label (`25 SEP 2026 · 09:40`, `NEXT`).
  final String? sublabel;
  final TimelineStepState state;
}

/// Progress through a fixed set of steps, in the two shapes the prototype
/// uses:
///
/// - [ProgressTimeline] (vertical, A6): 28 px circles joined by a 2 px line —
///   done = ink with a check, current = blush with an ink ring and dot,
///   upcoming = hairline ring; label 15/500, sublabel 11/500 muted.
/// - [ProgressTimeline.bar] (horizontal, C5): three 4 px pills, filled ink
///   up to the current step, with 10/600 uppercase labels underneath.
class ProgressTimeline extends StatelessWidget {
  const ProgressTimeline({super.key, required this.steps})
    : _horizontal = false;

  const ProgressTimeline.bar({super.key, required this.steps})
    : _horizontal = true;

  final List<TimelineStep> steps;
  final bool _horizontal;

  @override
  Widget build(BuildContext context) =>
      _horizontal ? _Bar(steps: steps) : _Vertical(steps: steps);
}

class _Vertical extends StatelessWidget {
  const _Vertical({required this.steps});

  final List<TimelineStep> steps;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final labelStyle = Theme.of(context).textTheme.bodyLarge
        ?.copyWith(fontSize: 15, fontWeight: FontWeight.w500);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < steps.length; i++)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  _Marker(state: steps[i].state),
                  if (i < steps.length - 1)
                    Container(
                      width: 2,
                      height: 28,
                      color: steps[i].state == TimelineStepState.done
                          ? tokens.ink
                          : tokens.line,
                    ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        steps[i].label,
                        style: labelStyle?.copyWith(
                          color: steps[i].state == TimelineStepState.upcoming
                              ? tokens.muted
                              : tokens.ink,
                        ),
                      ),
                      if (steps[i].sublabel != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          steps[i].sublabel!,
                          style: tokens.eyebrow.copyWith(
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0,
                            color: tokens.muted,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _Marker extends StatelessWidget {
  const _Marker({required this.state});

  final TimelineStepState state;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return SizedBox.square(
      dimension: 28,
      child: switch (state) {
        TimelineStepState.done => DecoratedBox(
          decoration: BoxDecoration(color: tokens.ink, shape: BoxShape.circle),
          child: Icon(Icons.check, size: 14, color: tokens.surface),
        ),
        TimelineStepState.current => DecoratedBox(
          decoration: BoxDecoration(
            color: tokens.accent,
            shape: BoxShape.circle,
            border: Border.all(color: tokens.ink, width: 2),
          ),
          child: Center(
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: tokens.ink,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        TimelineStepState.upcoming => DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: tokens.line, width: 2),
          ),
        ),
      },
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.steps});

  final List<TimelineStep> steps;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final labelStyle = tokens.eyebrowSmall.copyWith(
      letterSpacing: 0.4,
      color: tokens.muted,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            for (var i = 0; i < steps.length; i++) ...[
              if (i > 0) const SizedBox(width: 4),
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    color: steps[i].state == TimelineStepState.upcoming
                        ? tokens.ink.withValues(alpha: 0.15)
                        : tokens.ink,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            for (var i = 0; i < steps.length; i++)
              Expanded(
                child: Text(
                  steps[i].label.toUpperCase(),
                  style: labelStyle,
                  textAlign: i == 0
                      ? TextAlign.start
                      : i == steps.length - 1
                      ? TextAlign.end
                      : TextAlign.center,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
