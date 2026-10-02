import 'package:flutter_test/flutter_test.dart';
import 'package:penta_crew/features/events/models/application.dart';
import 'package:penta_crew/features/events/models/cannot_apply_reason.dart';
import 'package:penta_crew/features/events/models/event.dart';
import 'package:penta_crew/features/events/models/event_detail.dart';

/// Contract §1 `Event` sample.
const eventJson = {
  'id': 41,
  'title': 'Arunika annual gathering',
  'date': '2026-10-05',
  'start_time': '14:00',
  'end_time': '20:00',
  'duration_hours': 6,
  'venue_name': 'JIExpo Kemayoran, Hall B',
  'branch': {'id': 1, 'name': 'Jakarta'},
  'apply_deadline': '2026-09-28T23:59:00+07:00',
  'is_urgent': true,
  'positions': [
    {
      'id': 7,
      'role': {'id': 1, 'name': 'Crew'},
      'needed': 10,
      'matches_my_role': true,
    },
    {
      'id': 8,
      'role': {'id': 3, 'name': 'Trainee'},
      'needed': 2,
      'matches_my_role': false,
    },
  ],
};

/// Contract §1 `Application` sample.
const applicationJson = {
  'id': 301,
  'status': 'waiting',
  'applied_position': {
    'id': 7,
    'role': {'id': 1, 'name': 'Crew'},
  },
  'assigned_position': null,
  'applied_at': '2026-09-25T10:12:00+07:00',
  'closes_at': '2026-09-28T23:59:00+07:00',
  'decided_at': null,
  'event': eventJson,
};

void main() {
  group('Event', () {
    test('parses the contract sample', () {
      final event = Event.fromJson(eventJson);
      expect(event.date, DateTime(2026, 10, 5));
      expect(event.timeRange, '14:00 – 20:00');
      expect(event.isUrgent, isTrue);
      expect(event.positions, hasLength(2));
      expect(event.matchingPositions.map((p) => p.role.name), ['Crew']);
      expect(event.applyDeadline.isUtc, isTrue);
    });

    test('round-trips date as YYYY-MM-DD', () {
      expect(Event.fromJson(eventJson).toJson()['date'], '2026-10-05');
    });
  });

  group('EventDetail', () {
    test('parses detail fields and converts to summary', () {
      final detail = EventDetail.fromJson({
        ...eventJson,
        'venue_address': 'Jl. Benyamin Sueb, Jakarta Pusat',
        'briefing_time': '13:00',
        'requirements': ['Usher', 'Registration desk', 'Any gender'],
        'description': null,
        'admin_note': null,
        'status': 'open',
        'can_apply': false,
        'cannot_apply_reason': 'date_conflict',
        'my_application': null,
      });

      expect(detail.status, EventStatus.open);
      expect(detail.cannotApplyReason, CannotApplyReason.dateConflict);
      expect(detail.requirements, hasLength(3));
      expect(detail.myApplication, isNull);

      final summary = detail.toSummary();
      expect(summary.id, 41);
      expect(summary.positions, hasLength(2));
    });

    test('unknown status / reason fall back', () {
      final detail = EventDetail.fromJson({
        ...eventJson,
        'status': 'archived',
        'cannot_apply_reason': 'mystery',
      });
      expect(detail.status, EventStatus.unknown);
      expect(detail.cannotApplyReason, CannotApplyReason.unknown);
    });
  });

  group('Application', () {
    test('parses the contract sample with nested event', () {
      final app = Application.fromJson(applicationJson);
      expect(app.status, ApplicationStatus.waiting);
      expect(app.position.role.name, 'Crew');
      expect(app.event?.title, 'Arunika annual gathering');
      expect(app.canWithdrawAt(DateTime.utc(2026, 9, 20)), isTrue);
      expect(app.canWithdrawAt(DateTime.utc(2026, 9, 29)), isFalse);
    });

    test('assigned position wins over applied one', () {
      final app = Application.fromJson({
        ...applicationJson,
        'status': 'selected',
        'assigned_position': {
          'id': 9,
          'role': {'id': 2, 'name': 'Event Manager'},
        },
        'event': null,
      });
      expect(app.isSelected, isTrue);
      expect(app.position.role.name, 'Event Manager');
      expect(app.canWithdrawAt(DateTime.utc(2026, 9, 20)), isFalse);
    });

    test('not_selected / withdrawn / unknown statuses', () {
      ApplicationStatus statusOf(String s) =>
          Application.fromJson({...applicationJson, 'status': s}).status;
      expect(statusOf('not_selected'), ApplicationStatus.notSelected);
      expect(statusOf('withdrawn'), ApplicationStatus.withdrawn);
      expect(statusOf('pending'), ApplicationStatus.unknown);
    });
  });
}
