import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

import '../../events/models/application.dart';

part 'month_group.freezed.dart';

/// One month section of the Upcoming list (D1): the applications whose
/// `event.date` falls in [month], in the order the server returned them.
/// Grouping is done client-side (contract §5.1).
@freezed
abstract class MonthGroup with _$MonthGroup {
  const MonthGroup._();

  const factory MonthGroup({
    /// First day of the month, used as the group key.
    required DateTime month,
    required List<Application> items,
  }) = _MonthGroup;

  /// `October 2026 · 2 events` (`1 event` when singular) — the month header
  /// eyebrow on D1.
  String get label {
    final count = items.length == 1 ? '1 event' : '${items.length} events';
    return '${DateFormat('MMMM yyyy').format(month)} · $count';
  }

  /// Splits [applications] into consecutive month groups, preserving the
  /// server's date ASC order. Applications without an `event` cannot be
  /// placed on a calendar and are dropped.
  static List<MonthGroup> fromApplications(Iterable<Application> applications) {
    // Freezed collections are unmodifiable, so collect first, wrap last.
    // A Dart map literal keeps insertion order, which is the server's order.
    final itemsByMonth = <DateTime, List<Application>>{};
    for (final application in applications) {
      final event = application.event;
      if (event == null) continue;
      final month = DateTime(event.date.year, event.date.month);
      (itemsByMonth[month] ??= []).add(application);
    }
    return [
      for (final entry in itemsByMonth.entries)
        MonthGroup(month: entry.key, items: entry.value),
    ];
  }
}
