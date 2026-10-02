import 'package:flutter_test/flutter_test.dart';
import 'package:penta_crew/features/auth/models/user.dart';

/// Contract §1 `User` sample.
const _json = {
  'id': 12,
  'name': 'Nadia Putri',
  'email': 'nadia@example.com',
  'phone': '+628123456789',
  'avatar_url': null,
  'date_of_birth': '1999-04-12',
  'gender': 'female',
  'address': 'Jl. Kemang Raya 10, Jakarta Selatan',
  'branch': {'id': 1, 'name': 'Jakarta'},
  'roles': [
    {'id': 1, 'name': 'Crew'},
    {'id': 2, 'name': 'Event Manager'},
  ],
  'verification_status': 'approved',
  'verification_note': null,
  'submitted_at': '2026-09-25T09:40:00+07:00',
  'reviewed_at': null,
  'member_since': '2026-09-25',
};

void main() {
  group('User', () {
    test('parses the contract sample', () {
      final user = User.fromJson(_json);

      expect(user.id, 12);
      expect(user.dateOfBirth, DateTime(1999, 4, 12));
      expect(user.gender, Gender.female);
      expect(user.branch?.name, 'Jakarta');
      expect(user.roles.map((r) => r.name), ['Crew', 'Event Manager']);
      expect(user.verificationStatus, VerificationStatus.approved);
      expect(user.isVerified, isTrue);
      expect(user.submittedAt, isNotNull);
      expect(user.memberSince, DateTime(2026, 9, 25));
      expect(user.initials, 'NP');
    });

    test('round-trips date-only fields as YYYY-MM-DD', () {
      final back = User.fromJson(_json).toJson();
      expect(back['date_of_birth'], '1999-04-12');
      expect(back['member_since'], '2026-09-25');
      expect(back['gender'], 'female');
      expect(back['verification_status'], 'approved');
    });

    test('unknown enum values fall back instead of throwing', () {
      final user = User.fromJson({
        ..._json,
        'verification_status': 'on_hold',
        'gender': 'other',
      });
      expect(user.verificationStatus, VerificationStatus.unknown);
      expect(user.isVerified, isFalse);
      expect(user.gender, Gender.unknown);
    });

    test('minimal payload (id + name) still parses as unverified', () {
      final user = User.fromJson({'id': 1, 'name': 'A'});
      expect(user.roles, isEmpty);
      expect(user.verificationStatus, VerificationStatus.unknown);
      expect(user.initials, 'A');
    });
  });
}
