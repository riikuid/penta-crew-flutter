import 'dart:convert';
import 'dart:math';

import 'fixtures/mock_data.dart' as seed;

/// What the mock backend answers with. 2xx bodies use the Laravel envelope
/// (`{ message, data }`); errors use `{ message, code?, errors? }`.
class MockResponse {
  const MockResponse(this.status, this.body);

  final int status;
  final Map<String, dynamic> body;

  bool get isError => status >= 400;
}

/// Dev-only, in-memory implementation of `docs/api-contract.md` §2–§6
/// (D-13 §2.2). Pure Dart — no Dio, no Flutter — so it can be unit-tested
/// and driven by `MockInterceptor`.
///
/// Personas (password `password1`): `nadia@example.com` (approved, Crew +
/// Event Manager, Jakarta), `pending@example.com`, `rejected@example.com`.
/// Reset-password tokens: anything starting with `mock` is valid, `expired`
/// → `token_expired`, anything else → `token_invalid`.
class MockServer {
  MockServer({DateTime Function()? clock, Random? random})
    : _clock = clock ?? DateTime.now,
      _random = random ?? Random() {
    _reset();
  }

  final DateTime Function() _clock;
  final Random _random;

  late List<Map<String, dynamic>> _users;
  late List<Map<String, dynamic>> _events;
  late List<Map<String, dynamic>> _applications;
  late List<Map<String, dynamic>> _notifications;
  final Map<String, int> _tokens = {};
  int _nextId = 1000;

  DateTime get now => _clock();
  DateTime get _today => DateTime(now.year, now.month, now.day);

  /// Latency to simulate per request so skeletons are visible (300–800 ms).
  Duration nextLatency() => Duration(milliseconds: 300 + _random.nextInt(500));

  /// Drop every change and go back to the seed dataset.
  void reset() => _reset();

  // ---------------------------------------------------------------------------
  // Routing
  // ---------------------------------------------------------------------------

  /// Dispatch one request. [path] is relative to the API base (`/login`).
  MockResponse handle({
    required String method,
    required String path,
    Map<String, dynamic> query = const {},
    Map<String, dynamic>? body,
    String? bearer,
  }) {
    final seg = path.split('/').where((s) => s.isNotEmpty).toList();
    final m = method.toUpperCase();
    final data = body ?? const {};

    // --- public -------------------------------------------------------------
    if (m == 'POST' && _is(seg, ['login'])) return _login(data);
    if (m == 'POST' && _is(seg, ['register'])) return _register(data);
    if (m == 'POST' && _is(seg, ['forgot-password'])) return _ok(null);
    if (m == 'POST' && _is(seg, ['reset-password'])) {
      return _resetPassword(data);
    }
    if (m == 'GET' && _is(seg, ['branches'])) return _ok(seed.branches);

    // --- authenticated -------------------------------------------------------
    final user = bearer == null ? null : _userForToken(bearer);
    if (user == null) return _error(401, 'Unauthenticated.');

    if (m == 'GET' && _is(seg, ['me'])) return _ok(_publicUser(user));
    if (m == 'POST' && _is(seg, ['logout'])) {
      _tokens.remove(bearer);
      return _ok(null);
    }
    if (m == 'PUT' && _is(seg, ['me', 'profile'])) {
      return _updateProfile(user, data);
    }
    if (m == 'PUT' && _is(seg, ['me', 'password'])) {
      return _changePassword(user, data);
    }
    if (m == 'POST' && _is(seg, ['me', 'avatar'])) {
      user['avatar_url'] = 'https://i.pravatar.cc/512?u=${user['id']}';
      return _ok({'avatar_url': user['avatar_url']});
    }
    if (m == 'PUT' && _is(seg, ['me', 'device-token'])) return _ok(null);
    if (m == 'POST' && _is(seg, ['me', 'verification', 'resubmit'])) {
      return _resubmit(user);
    }

    // --- verified only (§4–§6) ----------------------------------------------
    if (user['verification_status'] != 'approved') {
      return _error(
        403,
        'Your profile has not been approved yet.',
        code: 'not_verified',
      );
    }

    if (m == 'GET' && _is(seg, ['events'])) return _openEvents(user, query);
    if (m == 'GET' && seg.length == 2 && seg[0] == 'events') {
      return _eventDetail(user, _int(seg[1]));
    }
    if (m == 'POST' &&
        seg.length == 3 &&
        seg[0] == 'events' &&
        seg[2] == 'applications') {
      return _apply(user, _int(seg[1]), data);
    }
    if (m == 'DELETE' && seg.length == 2 && seg[0] == 'applications') {
      return _withdraw(user, _int(seg[1]));
    }
    if (m == 'GET' && _is(seg, ['applications'])) {
      return _applicationsList(user, query);
    }
    if (m == 'GET' && _is(seg, ['schedule', 'upcoming'])) {
      return _upcoming(user, query);
    }
    if (m == 'GET' && _is(seg, ['schedule', 'history'])) {
      return _history(user, query);
    }
    if (m == 'GET' && _is(seg, ['notifications'])) {
      return _notificationsList(user, query);
    }
    if (m == 'GET' && _is(seg, ['notifications', 'unread-count'])) {
      return _ok({'count': _unread(user).length});
    }
    if (m == 'POST' && _is(seg, ['notifications', 'read-all'])) {
      for (final n in _unread(user)) {
        n['read_at'] = _iso(now);
      }
      return _ok(null);
    }
    if (m == 'POST' &&
        seg.length == 3 &&
        seg[0] == 'notifications' &&
        seg[2] == 'read') {
      final n = _notifications
          .where((n) => n['id'] == _int(seg[1]) && n['user_id'] == user['id'])
          .firstOrNull;
      if (n == null) return _error(404, 'Notification not found.');
      n['read_at'] ??= _iso(now);
      return _ok(null);
    }

    return _error(404, 'No mock route for $m $path');
  }

  // ---------------------------------------------------------------------------
  // Auth & account (§2–§3)
  // ---------------------------------------------------------------------------

  MockResponse _login(Map<String, dynamic> data) {
    final email = (data['email'] as String?)?.trim().toLowerCase();
    final user = _users.where((u) => u['email'] == email).firstOrNull;
    if (user == null || user['password'] != data['password']) {
      return _error(
        401,
        'Email or password is incorrect',
        code: 'invalid_credentials',
      );
    }
    return _ok({'token': _issueToken(user), 'user': _publicUser(user)});
  }

  MockResponse _register(Map<String, dynamic> data) {
    final errors = <String, List<String>>{};
    final email = (data['email'] as String?)?.trim().toLowerCase() ?? '';
    for (final key in [
      'name',
      'email',
      'phone',
      'password',
      'date_of_birth',
      'gender',
      'branch_id',
      'address',
    ]) {
      if (data[key] == null || data[key].toString().isEmpty) {
        errors[key] = ['The ${key.replaceAll('_', ' ')} field is required.'];
      }
    }
    if (_users.any((u) => u['email'] == email)) {
      errors['email'] = ['The email has already been taken.'];
    }
    if (data['password'] != data['password_confirmation']) {
      errors['password'] = ['The password confirmation does not match.'];
    }
    if (errors.isNotEmpty) return _validation(errors);

    final branch = _branch(_int(data['branch_id']));
    if (branch == null) {
      return _validation({
        'branch_id': ['The selected branch is invalid.'],
      });
    }

    final user = <String, dynamic>{
      'id': _nextId++,
      'name': data['name'],
      'email': email,
      'password': data['password'],
      'phone': data['phone'],
      'avatar_url': null,
      'date_of_birth': data['date_of_birth'],
      'gender': data['gender'],
      'address': data['address'],
      'branch': branch,
      'roles': <Map<String, dynamic>>[],
      'verification_status': 'pending',
      'verification_note': null,
      'submitted_at': _iso(now),
      'reviewed_at': null,
      'member_since': _dateOnly(now),
    };
    _users.add(user);
    return MockResponse(201, {
      'message': 'Registered',
      'data': {'token': _issueToken(user), 'user': _publicUser(user)},
    });
  }

  MockResponse _resetPassword(Map<String, dynamic> data) {
    final token = data['token'] as String? ?? '';
    if (token == 'expired') {
      return _error(
        422,
        'This reset link has expired. Request a new one.',
        code: 'token_expired',
      );
    }
    if (!token.startsWith('mock')) {
      return _error(
        422,
        'This reset link is not valid.',
        code: 'token_invalid',
      );
    }
    final user = _users.where((u) => u['email'] == data['email']).firstOrNull;
    user?['password'] = data['password'];
    return _ok(null);
  }

  MockResponse _updateProfile(
    Map<String, dynamic> user,
    Map<String, dynamic> data,
  ) {
    final branch = _branch(_int(data['branch_id']));
    if (branch == null) {
      return _validation({
        'branch_id': ['The selected branch is invalid.'],
      });
    }
    user
      ..['name'] = data['name'] ?? user['name']
      ..['phone'] = data['phone'] ?? user['phone']
      ..['date_of_birth'] = data['date_of_birth'] ?? user['date_of_birth']
      ..['gender'] = data['gender'] ?? user['gender']
      ..['address'] = data['address'] ?? user['address']
      ..['branch'] = branch;
    return _ok(_publicUser(user));
  }

  MockResponse _changePassword(
    Map<String, dynamic> user,
    Map<String, dynamic> data,
  ) {
    if (data['current_password'] != user['password']) {
      return _validation({
        'current_password': ['The current password is incorrect.'],
      });
    }
    user['password'] = data['password'];
    return _ok(null);
  }

  MockResponse _resubmit(Map<String, dynamic> user) {
    if (user['verification_status'] != 'rejected') {
      return _error(
        422,
        'Only a rejected profile can be submitted again.',
        code: 'not_rejected',
      );
    }
    user
      ..['verification_status'] = 'pending'
      ..['verification_note'] = null
      ..['submitted_at'] = _iso(now)
      ..['reviewed_at'] = null;
    return _ok(_publicUser(user));
  }

  // ---------------------------------------------------------------------------
  // Events & applications (§4)
  // ---------------------------------------------------------------------------

  MockResponse _openEvents(
    Map<String, dynamic> user,
    Map<String, dynamic> query,
  ) {
    final branchId = _int(query['branch_id']);
    if (branchId != (user['branch'] as Map)['id']) {
      return _error(
        403,
        'You can only browse events of your own branch.',
        code: 'wrong_branch',
      );
    }
    final search = (query['search'] as String?)?.toLowerCase();
    final list =
        _events
            .where((e) => (e['branch'] as Map)['id'] == branchId && _isOpen(e))
            .where(
              (e) =>
                  search == null ||
                  (e['title'] as String).toLowerCase().contains(search),
            )
            .toList()
          ..sort((a, b) => _deadline(a).compareTo(_deadline(b)));
    return _paginated(query, list.map((e) => _eventSummary(e, user)).toList());
  }

  MockResponse _eventDetail(Map<String, dynamic> user, int id) {
    final event = _event(id);
    if (event == null ||
        (event['branch'] as Map)['id'] != (user['branch'] as Map)['id']) {
      return _error(404, 'Event not found.');
    }
    final mine = _activeApplication(user, event);
    final reason = _cannotApplyReason(user, event, mine);
    return _ok({
      ..._eventSummary(event, user),
      'venue_address': event['venue_address'],
      'briefing_time': event['briefing_time'],
      'requirements': event['requirements'],
      'description': event['description'],
      'admin_note': mine?['status'] == 'selected' ? event['admin_note'] : null,
      'status': _isOpen(event) ? 'open' : 'closed',
      'can_apply': reason == null,
      'cannot_apply_reason': reason,
      'my_application': mine == null
          ? null
          : _applicationJson(mine, withEvent: false),
    });
  }

  MockResponse _apply(
    Map<String, dynamic> user,
    int eventId,
    Map<String, dynamic> data,
  ) {
    final event = _event(eventId);
    if (event == null ||
        (event['branch'] as Map)['id'] != (user['branch'] as Map)['id']) {
      return _error(404, 'Event not found.');
    }
    final mine = _activeApplication(user, event);
    final reason = _cannotApplyReason(user, event, mine);
    switch (reason) {
      case 'closed':
        return _error(
          422,
          'Applications for this event are closed.',
          code: 'closed',
        );
      case 'already_applied':
        return _error(
          422,
          'You have already applied to this event.',
          code: 'already_applied',
        );
      case 'date_conflict':
        return _error(
          422,
          'You already have a shift on ${_longDate(_date(event))}.',
          code: 'date_conflict',
        );
      case 'no_matching_role':
        return _error(
          422,
          'None of the positions match your roles.',
          code: 'position_not_matching_role',
        );
    }
    final position = (event['positions'] as List)
        .cast<Map<String, dynamic>>()
        .where((p) => p['id'] == _int(data['position_id']))
        .firstOrNull;
    if (position == null || !_matchesRole(user, position)) {
      return _error(
        422,
        'That position does not match your roles.',
        code: 'position_not_matching_role',
      );
    }
    final application = <String, dynamic>{
      'id': _nextId++,
      'user_id': user['id'],
      'event_id': eventId,
      'position_id': position['id'],
      'status': 'waiting',
      'applied_at': _iso(now),
      'decided_at': null,
    };
    _applications.add(application);
    _notifications.add({
      'id': _nextId++,
      'user_id': user['id'],
      'type': 'application.submitted',
      'title': 'Application sent',
      'body': '${event['title']} · ${(position['role'] as Map)['name']}',
      'data': {'event_id': eventId, 'application_id': application['id']},
      'read_at': null,
      'created_at': _iso(now),
    });
    return MockResponse(201, {
      'message': 'Applied',
      'data': _applicationJson(application),
    });
  }

  MockResponse _withdraw(Map<String, dynamic> user, int id) {
    final app = _applications
        .where((a) => a['id'] == id && a['user_id'] == user['id'])
        .firstOrNull;
    if (app == null) return _error(404, 'Application not found.');
    if (app['status'] != 'waiting') {
      return _error(
        422,
        'This application can no longer be withdrawn.',
        code: 'not_withdrawable',
      );
    }
    final event = _event(app['event_id'] as int)!;
    if (now.isAfter(_deadline(event))) {
      return _error(
        422,
        'Applications closed on ${_longDate(_deadline(event))}.',
        code: 'deadline_passed',
      );
    }
    app['status'] = 'withdrawn';
    return _ok(null);
  }

  MockResponse _applicationsList(
    Map<String, dynamic> user,
    Map<String, dynamic> query,
  ) {
    final wanted = (query['status'] as String?)
        ?.split(',')
        .map((s) => s.trim())
        .toSet();
    final list =
        _mine(user)
            .where((a) => a['status'] != 'withdrawn')
            .where(
              (a) =>
                  wanted == null ||
                  wanted.isEmpty ||
                  wanted.contains(a['status']),
            )
            .toList()
          ..sort((a, b) {
            final aw = a['status'] == 'waiting', bw = b['status'] == 'waiting';
            if (aw != bw) return aw ? -1 : 1;
            if (aw) {
              return _deadline(_event(a['event_id'] as int)!)
                  .compareTo(_deadline(_event(b['event_id'] as int)!));
            }
            return _dateTime(b['decided_at'])
                .compareTo(_dateTime(a['decided_at']));
          });
    return _paginated(query, list.map(_applicationJson).toList());
  }

  // ---------------------------------------------------------------------------
  // Schedule (§5)
  // ---------------------------------------------------------------------------

  MockResponse _upcoming(
    Map<String, dynamic> user,
    Map<String, dynamic> query,
  ) {
    final list =
        _mine(user)
            .where(
              (a) =>
                  a['status'] == 'selected' &&
                  !_date(_event(a['event_id'] as int)!).isBefore(_today),
            )
            .toList()
          ..sort((a, b) {
            final ea = _event(a['event_id'] as int)!,
                eb = _event(b['event_id'] as int)!;
            final byDate = _date(ea).compareTo(_date(eb));
            return byDate != 0
                ? byDate
                : (ea['start_time'] as String).compareTo(
                    eb['start_time'] as String,
                  );
          });
    return _paginated(query, list.map(_applicationJson).toList());
  }

  MockResponse _history(Map<String, dynamic> user, Map<String, dynamic> query) {
    bool completed(Map<String, dynamic> a) =>
        a['status'] == 'selected' &&
        _date(_event(a['event_id'] as int)!).isBefore(_today);
    final list =
        _mine(user)
            .where((a) => completed(a) || a['status'] == 'not_selected')
            .toList()
          ..sort(
            (a, b) =>
                _date(_event(b['event_id'] as int)!)
                    .compareTo(_date(_event(a['event_id'] as int)!)),
          );
    final worked = list
        .where(completed)
        .map((a) => _date(_event(a['event_id'] as int)!))
        .toList();
    final since = worked.isEmpty
        ? null
        : worked.reduce((a, b) => a.isBefore(b) ? a : b);
    return _paginated(
      query,
      list.map(_applicationJson).toList(),
      extraMeta: {
        'summary': {
          'worked_count': worked.length,
          'worked_since': since == null ? null : _dateOnly(since),
        },
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Notifications (§6)
  // ---------------------------------------------------------------------------

  MockResponse _notificationsList(
    Map<String, dynamic> user,
    Map<String, dynamic> query,
  ) {
    final list =
        _notifications.where((n) => n['user_id'] == user['id']).toList()..sort(
          (a, b) =>
              _dateTime(b['created_at']).compareTo(_dateTime(a['created_at'])),
        );
    return _paginated(
      query,
      list.map((n) => {...n}..remove('user_id')).toList(),
      extraMeta: {'unread_count': _unread(user).length},
    );
  }

  List<Map<String, dynamic>> _unread(Map<String, dynamic> user) =>
      _notifications
          .where((n) => n['user_id'] == user['id'] && n['read_at'] == null)
          .toList();

  // ---------------------------------------------------------------------------
  // Serialisation
  // ---------------------------------------------------------------------------

  Map<String, dynamic> _publicUser(Map<String, dynamic> user) =>
      {...user}..remove('password');

  Map<String, dynamic> _eventSummary(
    Map<String, dynamic> e,
    Map<String, dynamic> user,
  ) {
    final deadline = _deadline(e);
    return {
      'id': e['id'],
      'title': e['title'],
      'date': _dateOnly(_date(e)),
      'start_time': e['start_time'],
      'end_time': e['end_time'],
      'duration_hours': e['duration_hours'],
      'venue_name': e['venue_name'],
      'branch': e['branch'],
      'apply_deadline': _iso(deadline),
      'is_urgent':
          _isOpen(e) && deadline.difference(now) < const Duration(hours: 48),
      'positions': [
        for (final p in (e['positions'] as List).cast<Map<String, dynamic>>())
          {...p, 'matches_my_role': _matchesRole(user, p)},
      ],
    };
  }

  Map<String, dynamic> _applicationJson(
    Map<String, dynamic> a, {
    bool withEvent = true,
  }) {
    final event = _event(a['event_id'] as int)!;
    final user = _users.firstWhere((u) => u['id'] == a['user_id']);
    final position = (event['positions'] as List)
        .cast<Map<String, dynamic>>()
        .firstWhere((p) => p['id'] == a['position_id']);
    final pos = {'id': position['id'], 'role': position['role']};
    return {
      'id': a['id'],
      'status': a['status'],
      'applied_position': pos,
      'assigned_position': a['status'] == 'selected' ? pos : null,
      'applied_at': a['applied_at'],
      'closes_at': _iso(_deadline(event)),
      'decided_at': a['decided_at'],
      if (withEvent) 'event': _eventSummary(event, user),
    };
  }

  MockResponse _paginated(
    Map<String, dynamic> query,
    List<Map<String, dynamic>> items, {
    Map<String, dynamic> extraMeta = const {},
  }) {
    final perPage =
        (_int(query['per_page']) == 0 ? 20 : _int(query['per_page'])).clamp(
          1,
          50,
        );
    final page = _int(query['page']) == 0 ? 1 : _int(query['page']);
    final lastPage = items.isEmpty ? 1 : ((items.length - 1) ~/ perPage) + 1;
    final start = (page - 1) * perPage;
    final data = start >= items.length
        ? <Map<String, dynamic>>[]
        : items.sublist(start, min(start + perPage, items.length));
    return MockResponse(200, {
      'message': 'OK',
      'data': data,
      'meta': {
        'current_page': page,
        'last_page': lastPage,
        'per_page': perPage,
        'total': items.length,
        ...extraMeta,
      },
    });
  }

  MockResponse _ok(Object? data) =>
      MockResponse(200, {'message': 'OK', 'data': data});

  MockResponse _error(int status, String message, {String? code}) =>
      MockResponse(status, {'message': message, 'code': ?code});

  MockResponse _validation(Map<String, List<String>> errors) => MockResponse(
    422,
    {'message': 'The given data was invalid.', 'errors': errors},
  );

  // ---------------------------------------------------------------------------
  // Domain helpers
  // ---------------------------------------------------------------------------

  Map<String, dynamic>? _event(int id) =>
      _events.where((e) => e['id'] == id).firstOrNull;
  Map<String, dynamic>? _branch(int id) => seed.branches
      .where((b) => b['id'] == id)
      .map(Map<String, dynamic>.from)
      .firstOrNull;

  List<Map<String, dynamic>> _mine(Map<String, dynamic> user) =>
      _applications.where((a) => a['user_id'] == user['id']).toList();

  Map<String, dynamic>? _activeApplication(
    Map<String, dynamic> user,
    Map<String, dynamic> event,
  ) => _mine(user)
      .where((a) => a['event_id'] == event['id'] && a['status'] != 'withdrawn')
      .firstOrNull;

  bool _matchesRole(Map<String, dynamic> user, Map<String, dynamic> position) {
    final roleId = (position['role'] as Map)['id'];
    return (user['roles'] as List).any((r) => (r as Map)['id'] == roleId);
  }

  bool _isOpen(Map<String, dynamic> e) =>
      e['status'] == 'open' && now.isBefore(_deadline(e));

  /// Null when the user can apply; otherwise the contract's reason, in the
  /// contract's precedence: closed → already_applied → no_matching_role →
  /// date_conflict.
  String? _cannotApplyReason(
    Map<String, dynamic> user,
    Map<String, dynamic> event,
    Map<String, dynamic>? mine,
  ) {
    if (!_isOpen(event)) return 'closed';
    if (mine != null) return 'already_applied';
    final positions = (event['positions'] as List).cast<Map<String, dynamic>>();
    if (!positions.any((p) => _matchesRole(user, p))) return 'no_matching_role';
    final date = _date(event);
    final conflict = _mine(user).any((a) {
      if (a['status'] != 'waiting' && a['status'] != 'selected') return false;
      return _date(_event(a['event_id'] as int)!) == date;
    });
    if (conflict) return 'date_conflict';
    return null;
  }

  // ---------------------------------------------------------------------------
  // Clock-relative seed → absolute values
  // ---------------------------------------------------------------------------

  void _reset() {
    _tokens.clear();
    _nextId = 1000;
    // JSON round-trip: deep copy + every nested map becomes
    // `Map<String, dynamic>`, as a decoded HTTP body would be.
    List<Map<String, dynamic>> copy(List<Map<String, Object?>> src) =>
        (jsonDecode(jsonEncode(src)) as List).cast<Map<String, dynamic>>();

    _users = [
      for (final u in copy(seed.users))
        u
          ..['submitted_at'] = _relIso(u['submitted_at'])
          ..['reviewed_at'] = _relIso(u['reviewed_at'])
          ..['member_since'] = _relDate(u['member_since']),
    ];
    _events = copy(seed.events);
    _applications = [
      for (final a in copy(seed.applications))
        a
          ..['applied_at'] = _relIso(a['applied_at'])
          ..['decided_at'] = _relIso(a['decided_at']),
    ];
    _notifications = [
      for (final n in copy(seed.notifications))
        n
          ..['read_at'] = _relIso(n['read_at'])
          ..['created_at'] = _relIso(n['created_at']),
    ];
  }

  String _issueToken(Map<String, dynamic> user) {
    final token = 'mock-token-${user['id']}-${_random.nextInt(1 << 30)}';
    _tokens[token] = user['id'] as int;
    return token;
  }

  Map<String, dynamic>? _userForToken(String bearer) {
    final id = _tokens[bearer];
    return id == null ? null : _users.where((u) => u['id'] == id).firstOrNull;
  }

  /// Event date: the seed stores a day offset; the app sends `YYYY-MM-DD`.
  DateTime _date(Map<String, dynamic> e) =>
      _today.add(Duration(days: e['date'] as int));

  /// Deadline = 23:59 local on `apply_deadline` day offset.
  DateTime _deadline(Map<String, dynamic> e) => _today.add(
    Duration(days: e['apply_deadline'] as int, hours: 23, minutes: 59),
  );

  /// Day offset (fractions allowed) → 09:00 local on that day.
  String? _relIso(Object? dayOffset) => dayOffset == null
      ? null
      : _iso(
          _today.add(
            Duration(hours: 9, minutes: ((dayOffset as num) * 24 * 60).round()),
          ),
        );

  String? _relDate(Object? dayOffset) => dayOffset == null
      ? null
      : _dateOnly(_today.add(Duration(days: dayOffset as int)));

  static bool _is(List<String> seg, List<String> pattern) =>
      seg.length == pattern.length &&
      [for (var i = 0; i < seg.length; i++) seg[i] == pattern[i]]
          .every((b) => b);

  static int _int(Object? v) => switch (v) {
    final int i => i,
    final num n => n.toInt(),
    final String s => int.tryParse(s) ?? 0,
    _ => 0,
  };

  static DateTime _dateTime(Object? iso) => iso is String
      ? DateTime.parse(iso)
      : DateTime.fromMillisecondsSinceEpoch(0);

  static String _dateOnly(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  /// ISO-8601 with the local offset (`2026-10-05T14:00:00+07:00`), as the
  /// contract requires — `DateTime.toIso8601String()` omits the offset.
  static String _iso(DateTime d) {
    final local = d.toLocal();
    final off = local.timeZoneOffset;
    final sign = off.isNegative ? '-' : '+';
    final hh = off.inHours.abs().toString().padLeft(2, '0');
    final mm = (off.inMinutes.abs() % 60).toString().padLeft(2, '0');
    String two(int n) => n.toString().padLeft(2, '0');
    return '${_dateOnly(local)}T${two(local.hour)}:${two(local.minute)}:${two(local.second)}$sign$hh:$mm';
  }

  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static String _longDate(DateTime d) => '${d.day} ${_months[d.month - 1]}';
}
