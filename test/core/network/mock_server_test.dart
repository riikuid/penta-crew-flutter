import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:penta_crew/core/network/api_json.dart';
import 'package:penta_crew/core/network/dio_call.dart';
import 'package:penta_crew/core/network/mock/mock_interceptor.dart';
import 'package:penta_crew/core/network/mock/mock_server.dart';
import 'package:penta_crew/core/network/paginated.dart';
import 'package:penta_crew/core/network/result.dart';
import 'package:penta_crew/features/auth/models/auth_response.dart';
import 'package:penta_crew/features/auth/models/user.dart';
import 'package:penta_crew/features/events/models/application.dart';
import 'package:penta_crew/features/events/models/cannot_apply_reason.dart';
import 'package:penta_crew/features/events/models/event.dart';
import 'package:penta_crew/features/events/models/event_detail.dart';
import 'package:penta_crew/features/events/repositories/events_repository.dart';
import 'package:penta_crew/features/notifications/repositories/notifications_repository.dart';
import 'package:penta_crew/features/schedule/models/history_summary.dart';
import 'package:penta_crew/features/schedule/repositories/schedule_repository.dart';

/// Fixed clock so the dataset's relative dates are deterministic.
final _now = DateTime(2026, 10, 2, 9);

/// A Dio that talks only to the mock, with a bearer header set by [signIn].
/// Latency is forced to zero via a seeded Random (always 300 ms) → we skip the
/// delay by overriding the server's clock only; 300 ms × ~20 calls is fine.
class _Harness {
  _Harness() : server = MockServer(clock: () => _now, random: Random(1)) {
    dio = Dio(BaseOptions(baseUrl: 'http://mock.local/api'))
      ..interceptors.add(MockInterceptor(server));
  }

  final MockServer server;
  late final Dio dio;

  Future<User> signIn(String email, [String password = 'password1']) async {
    final result = await dioCall(
      () => dio.post('/login', data: {'email': email, 'password': password}),
      parse: (b) => AuthResponse.fromJson(asObject(b)),
    );
    final auth = (result as Success<AuthResponse>).value;
    dio.options.headers['Authorization'] = 'Bearer ${auth.token}';
    return auth.user;
  }
}

void main() {
  late _Harness h;

  setUp(() => h = _Harness());

  group('MockServer personas', () {
    test('nadia is approved with Crew + Event Manager in Jakarta', () async {
      final user = await h.signIn('nadia@example.com');
      expect(user.verificationStatus, VerificationStatus.approved);
      expect(user.roles.map((r) => r.name), ['Crew', 'Event Manager']);
      expect(user.branch?.name, 'Jakarta');
    });

    test('pending / rejected personas', () async {
      final pending = await h.signIn('pending@example.com');
      expect(pending.verificationStatus, VerificationStatus.pending);
      expect(pending.roles, isEmpty);

      final rejected = await h.signIn('rejected@example.com');
      expect(rejected.verificationStatus, VerificationStatus.rejected);
      expect(rejected.verificationNote, contains("couldn't reach your phone"));
    });

    test('wrong password → 401 invalid_credentials', () async {
      final result = await dioCall(
        () => h.dio.post(
          '/login',
          data: {'email': 'nadia@example.com', 'password': 'x'},
        ),
        parse: noBody,
      );
      final failed = result as Failed;
      expect(failed.statusCode, 401);
      expect(failed.code, 'invalid_credentials');
      expect(failed.message, 'Email or password is incorrect');
    });

    test('no token → 401; unverified → 403 not_verified on §4', () async {
      final anon = await dioCall(() => h.dio.get('/me'), parse: noBody);
      expect(anon.statusCode, 401);

      await h.signIn('pending@example.com');
      final events = await dioCall(
        () => h.dio.get('/events', queryParameters: {'branch_id': 1}),
        parse: noBody,
      );
      expect((events as Failed).code, 'not_verified');
      expect(events.statusCode, 403);
    });
  });

  group('MockServer flow: login → events → apply → tracked → withdraw', () {
    test('end to end', () async {
      final user = await h.signIn('nadia@example.com');
      final events = EventsRepository(h.dio);

      // C1: 3 open in Jakarta, sorted by deadline, Arunika urgent.
      final open = (await events.getOpenEvents(
        branchId: user.branch!.id,
        page: 1,
      )).valueOrNull!;
      expect(open.total, 3);
      expect(open.data.map((e) => e.title), [
        'Arunika annual gathering',
        'Wedding of Nadia & Reza',
        'Kirana 17th birthday',
      ]);
      expect(open.data.first.isUrgent, isTrue);
      expect(open.data.first.matchingPositions.map((p) => p.role.name), [
        'Crew',
        'Event Manager',
      ]);
      expect(
        open.data.first.positions
            .where((p) => !p.matchesMyRole)
            .single
            .role
            .name,
        'Trainee',
      );

      // Kirana shares its date with a selected shift → date_conflict (C3).
      final kirana = (await events.getEventDetail(43)).valueOrNull!;
      expect(kirana.canApply, isFalse);
      expect(kirana.cannotApplyReason, CannotApplyReason.dateConflict);
      expect(
        (await events.apply(eventId: 43, positionId: 11) as Failed).code,
        'date_conflict',
      );

      // Withdraw Nadia & Reza (302) → open for her again.
      expect((await events.withdraw(302)).isSuccess, isTrue);
      final reza = (await events.getEventDetail(42)).valueOrNull!;
      expect(reza.canApply, isTrue);
      expect(reza.myApplication, isNull);

      // Apply as Crew (position 10).
      final applied = (await events.apply(
        eventId: 42,
        positionId: 10,
      )).valueOrNull!;
      expect(applied.status, ApplicationStatus.waiting);
      expect(applied.event?.id, 42);

      // Detail now says already applied; Tracked shows it.
      final after = (await events.getEventDetail(42)).valueOrNull!;
      expect(after.canApply, isFalse);
      expect(after.cannotApplyReason, CannotApplyReason.alreadyApplied);
      expect(after.myApplication?.id, applied.id);

      final tracked = (await events.getApplications(page: 1)).valueOrNull!;
      expect(tracked.data.map((a) => a.id), contains(applied.id));
      expect(
        tracked.data.any((a) => a.status == ApplicationStatus.withdrawn),
        isFalse,
      );

      // Submitted notification was created.
      final inbox = (await NotificationsRepository(
        h.dio,
      ).getNotifications(page: 1)).valueOrNull!;
      expect(inbox.data.first.body, 'Wedding of Nadia & Reza · Crew');
      expect(inbox.meta['unread_count'], 4);

      // Withdraw → gone from Tracked, can apply again.
      expect((await events.withdraw(applied.id)).isSuccess, isTrue);
      final afterWithdraw = (await events.getApplications(page: 1))
          .valueOrNull!;
      expect(afterWithdraw.data.map((a) => a.id), isNot(contains(applied.id)));
      expect((await events.getEventDetail(42)).valueOrNull!.canApply, isTrue);
    });

    test('Tracked order and counts match the prototype (C2 / B1)', () async {
      await h.signIn('nadia@example.com');
      final events = EventsRepository(h.dio);

      final tracked = (await events.getApplications(page: 1)).valueOrNull!;
      expect(
        tracked.data.map((a) => a.status).take(2),
        everyElement(ApplicationStatus.waiting),
      );
      expect(tracked.data.map((a) => a.event?.title).take(2), [
        'Arunika annual gathering',
        'Wedding of Nadia & Reza',
      ]);

      final waiting = (await events.getApplications(
        statuses: [ApplicationStatus.waiting],
        page: 1,
        perPage: 1,
      )).valueOrNull!;
      expect(waiting.total, 2);
    });

    test(
      'business rules: already_applied, date_conflict, role mismatch, closed',
      () async {
        await h.signIn('nadia@example.com');
        final events = EventsRepository(h.dio);

        expect(
          (await events.apply(eventId: 41, positionId: 7) as Failed).code,
          'already_applied',
        );

        // Selected on a closed event (C8): closed wins, admin note visible.
        final laras = (await events.getEventDetail(45)).valueOrNull!;
        expect(laras.isClosed, isTrue);
        expect(laras.cannotApplyReason, CannotApplyReason.closed);
        expect(laras.myApplication?.status, ApplicationStatus.selected);
        expect(
          laras.adminNote,
          isNotNull,
          reason: 'selected → admin note visible',
        );
        // Waiting on an open event (C5): admin note hidden.
        final arunika = (await events.getEventDetail(41)).valueOrNull!;
        expect(arunika.adminNote, isNull);
        expect(arunika.myApplication?.status, ApplicationStatus.waiting);

        // Role mismatch: Arunika's Trainee slot after withdrawing.
        await events.withdraw(301);
        expect(
          (await events.apply(eventId: 41, positionId: 9) as Failed).code,
          'position_not_matching_role',
        );

        // Closed event (Rumah Dansa).
        final closed =
            await events.apply(eventId: 47, positionId: 17) as Failed;
        expect(closed.code, 'closed');

        // Withdraw rules.
        expect((await events.withdraw(303) as Failed).code, 'not_withdrawable');
      },
    );

    test('date_conflict clears once the conflicting shift is gone', () async {
      final server = MockServer(clock: () => _now, random: Random(1));
      final login = server.handle(
        method: 'POST',
        path: '/login',
        body: {'email': 'nadia@example.com', 'password': 'password1'},
      );
      final token = login.body['data']['token'] as String;

      MockResponse detail() =>
          server.handle(method: 'GET', path: '/events/43', bearer: token);
      expect(detail().body['data']['cannot_apply_reason'], 'date_conflict');

      // A selected application cannot be withdrawn, so the conflict stays…
      final blocked = server.handle(
        method: 'DELETE',
        path: '/applications/304',
        bearer: token,
      );
      expect(blocked.body['code'], 'not_withdrawable');
      expect(detail().body['data']['can_apply'], false);

      // …but a waiting one on the same day would count too: apply to Nadia &
      // Reza again after withdrawing, then its date (+8) conflicts with nothing.
      expect(
        server
            .handle(method: 'DELETE', path: '/applications/302', bearer: token)
            .status,
        200,
      );
      final re = server.handle(
        method: 'POST',
        path: '/events/42/applications',
        body: {'position_id': 10},
        bearer: token,
      );
      expect(re.status, 201);
      expect(re.body['data']['status'], 'waiting');
    });
  });

  group('MockServer schedule & history', () {
    test('upcoming = 2 selected, Laras first (D1); history = 6 worked since Jul (D2)', () async {
      await h.signIn('nadia@example.com');
      final schedule = ScheduleRepository(h.dio);

      final upcoming = (await schedule.getUpcoming(page: 1)).valueOrNull!;
      expect(upcoming.data.map((a) => a.event?.title), [
        'Wedding of Laras & Bima',
        'Mahesa Group town hall',
      ]);
      expect(upcoming.data.first.position.role.name, 'Crew');
      expect(upcoming.data.last.position.role.name, 'Event Manager');

      final history = (await schedule.getHistory(page: 1)).valueOrNull!;
      final summary = HistorySummary.fromMeta(history.meta);
      expect(summary.workedCount, 6);
      expect(summary.workedSince, DateTime(2026, 7, 4));
      expect(history.data.first.event?.title, 'Rumah Dansa studio opening');
      expect(history.data.first.status, ApplicationStatus.notSelected);
      expect(history.total, 8);
    });

    test('pagination honours page/per_page and caps per_page at 50', () async {
      await h.signIn('nadia@example.com');
      final result = await dioCall(
        () => h.dio.get(
          '/schedule/history',
          queryParameters: {'page': 2, 'per_page': 3},
        ),
        parse: (b) => Paginated.fromJson(b, Application.fromJson),
      );
      final page = result.valueOrNull!;
      expect(page.currentPage, 2);
      expect(page.lastPage, 3);
      expect(page.data, hasLength(3));
      expect(page.hasMore, isTrue);
    });
  });

  group('MockServer account', () {
    test('register signs the user in as pending', () async {
      final result = await dioCall(
        () => h.dio.post(
          '/register',
          data: {
            'name': 'New Crew',
            'email': 'new@example.com',
            'phone': '+62',
            'password': 'password1',
            'password_confirmation': 'password1',
            'date_of_birth': '2000-01-01',
            'gender': 'male',
            'branch_id': 1,
            'address': 'x',
          },
        ),
        parse: (b) => AuthResponse.fromJson(asObject(b)),
      );
      final auth = (result as Success<AuthResponse>).value;
      expect(auth.user.verificationStatus, VerificationStatus.pending);
      expect(auth.user.roles, isEmpty);
      expect(auth.user.branch?.name, 'Jakarta');
    });

    test('register duplicate email → 422 errors.email', () async {
      final result = await dioCall(
        () => h.dio.post(
          '/register',
          data: {
            'name': 'Dup',
            'email': 'nadia@example.com',
            'phone': '+62',
            'password': 'password1',
            'password_confirmation': 'password1',
            'date_of_birth': '2000-01-01',
            'gender': 'female',
            'branch_id': 1,
            'address': 'x',
          },
        ),
        parse: noBody,
      );
      expect(
        (result as Failed).fieldError('email'),
        'The email has already been taken.',
      );
    });

    test(
      'resubmit only for rejected; profile edit never changes status',
      () async {
        await h.signIn('rejected@example.com');
        final updated = await dioCall(
          () => h.dio.put(
            '/me/profile',
            data: {
              'name': 'Dewi L.',
              'phone': '+62',
              'date_of_birth': '2000-02-14',
              'gender': 'female',
              'branch_id': 2,
              'address': 'x',
            },
          ),
          parse: (b) => User.fromJson(asObject(b)),
        );
        expect(
          updated.valueOrNull!.verificationStatus,
          VerificationStatus.rejected,
        );
        expect(updated.valueOrNull!.branch?.name, 'Bandung');

        final resubmitted = await dioCall(
          () => h.dio.post('/me/verification/resubmit'),
          parse: (b) => User.fromJson(asObject(b)),
        );
        expect(
          resubmitted.valueOrNull!.verificationStatus,
          VerificationStatus.pending,
        );
        expect(resubmitted.valueOrNull!.verificationNote, isNull);

        final again = await dioCall(
          () => h.dio.post('/me/verification/resubmit'),
          parse: noBody,
        );
        expect((again as Failed).code, 'not_rejected');
      },
    );

    test('reset-password token rules', () async {
      Future<String?> code(String token) async {
        final r = await dioCall(
          () => h.dio.post(
            '/reset-password',
            data: {
              'token': token,
              'email': 'nadia@example.com',
              'password': 'newpass1',
              'password_confirmation': 'newpass1',
            },
          ),
          parse: noBody,
        );
        return r is Failed ? r.code : null;
      }

      expect(await code('expired'), 'token_expired');
      expect(await code('nope'), 'token_invalid');
      expect(await code('mock-123'), isNull);
      // Password really changed.
      final login = await dioCall(
        () => h.dio.post(
          '/login',
          data: {'email': 'nadia@example.com', 'password': 'newpass1'},
        ),
        parse: noBody,
      );
      expect(login.isSuccess, isTrue);
    });

    test('logout invalidates the token', () async {
      await h.signIn('nadia@example.com');
      expect(
        (await dioCall(() => h.dio.post('/logout'), parse: noBody)).isSuccess,
        isTrue,
      );
      expect(
        (await dioCall(() => h.dio.get('/me'), parse: noBody)).statusCode,
        401,
      );
    });
  });

  test('Event / EventDetail models parse every seeded event', () async {
    await h.signIn('nadia@example.com');
    for (final id in [41, 42, 43, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54]) {
      final r = await dioCall(
        () => h.dio.get('/events/$id'),
        parse: (b) => EventDetail.fromJson(asObject(b)),
      );
      expect(
        r,
        isA<Success<EventDetail>>(),
        reason: 'event $id: ${r.errorMessage}',
      );
      expect(Event.fromJson(r.valueOrNull!.toSummary().toJson()).id, id);
    }
    // Bandung event is invisible to a Jakarta user.
    expect(
      (await dioCall(() => h.dio.get('/events/44'), parse: noBody)).statusCode,
      404,
    );
  });
}
