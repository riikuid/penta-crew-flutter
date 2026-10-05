import 'package:flutter_test/flutter_test.dart';
import 'package:penta_crew/features/notifications/presentation/notification_formats.dart';

import '../fixtures.dart';

void main() {
  group('relativeTime', () {
    test('under an hour today → Just now', () {
      expect(
        NotificationFormats.relativeTime(
          now.subtract(const Duration(minutes: 40)),
          now: now,
        ),
        'Just now',
      );
    });

    test('earlier today → whole hours ago', () {
      expect(
        NotificationFormats.relativeTime(
          now.subtract(const Duration(hours: 2, minutes: 30)),
          now: now,
        ),
        '2 h ago',
      );
      expect(
        NotificationFormats.relativeTime(
          DateTime(2026, 10, 5, 0, 30),
          now: now,
        ),
        '13 h ago',
      );
    });

    test('previous calendar day → Yesterday, even late at night', () {
      expect(
        NotificationFormats.relativeTime(
          DateTime(2026, 10, 4, 23, 50),
          now: now,
        ),
        'Yesterday',
      );
      expect(
        NotificationFormats.relativeTime(DateTime(2026, 10, 4, 1), now: now),
        'Yesterday',
      );
    });

    test('older → d MMM', () {
      expect(
        NotificationFormats.relativeTime(DateTime(2026, 10, 3, 9), now: now),
        '3 Oct',
      );
      expect(
        NotificationFormats.relativeTime(DateTime(2026, 9, 25, 9), now: now),
        '25 Sep',
      );
    });

    test('a UTC instant is compared on the local calendar', () {
      final localTwoHoursAgo = now.subtract(const Duration(hours: 2));
      expect(
        NotificationFormats.relativeTime(localTwoHoursAgo.toUtc(), now: now),
        '2 h ago',
      );
    });
  });

  group('isToday', () {
    test('same local day', () {
      expect(
        NotificationFormats.isToday(DateTime(2026, 10, 5, 0, 1), now: now),
        isTrue,
      );
      expect(
        NotificationFormats.isToday(DateTime(2026, 10, 4, 23, 59), now: now),
        isFalse,
      );
    });
  });

  group('group', () {
    test('splits into Today / Earlier keeping server order', () {
      final todayA = notification(id: 1);
      final todayB = notification(
        id: 2,
        createdAt: now.subtract(const Duration(hours: 5)),
      );
      final yesterday = notification(
        id: 3,
        createdAt: DateTime(2026, 10, 4, 20),
      );
      final lastWeek = notification(id: 4, createdAt: DateTime(2026, 9, 28));

      final groups = NotificationFormats.group([
        todayA,
        todayB,
        yesterday,
        lastWeek,
      ], now: now);

      expect(groups.today.map((item) => item.id), [1, 2]);
      expect(groups.earlier.map((item) => item.id), [3, 4]);
    });

    test('empty input → two empty sections', () {
      final groups = NotificationFormats.group([], now: now);
      expect(groups.today, isEmpty);
      expect(groups.earlier, isEmpty);
    });
  });
}
