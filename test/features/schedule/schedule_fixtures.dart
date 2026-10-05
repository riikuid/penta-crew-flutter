import 'package:penta_crew/core/network/paginated.dart';
import 'package:penta_crew/features/auth/models/crew_role.dart';
import 'package:penta_crew/features/events/models/application.dart';
import 'package:penta_crew/features/events/models/event.dart';

/// The prototype's "today" (D1 copy `Next · in 8 days` is relative to it).
final scheduleNow = DateTime(2026, 9, 25, 9);

Event scheduleEvent({
  required int id,
  required String title,
  required DateTime date,
  String startTime = '07:00',
  String endTime = '15:00',
  String venueName = 'Plataran Menteng',
}) => Event(
  id: id,
  title: title,
  date: date,
  startTime: startTime,
  endTime: endTime,
  venueName: venueName,
  applyDeadline: date.subtract(const Duration(days: 7)),
);

Application scheduleApplication({
  required int id,
  required ApplicationStatus status,
  required Event event,
  String role = 'Crew',
  String? assignedRole,
}) => Application(
  id: id,
  status: status,
  appliedPosition: ApplicationPosition(
    id: 7,
    role: CrewRole(id: 1, name: role),
  ),
  assignedPosition: assignedRole == null
      ? null
      : ApplicationPosition(id: 8, role: CrewRole(id: 2, name: assignedRole)),
  appliedAt: event.applyDeadline.subtract(const Duration(days: 3)),
  closesAt: event.applyDeadline,
  event: event,
);

/// D1: Laras & Bima on Sat 3 Oct (Next, 8 days out), Mahesa on 18 Oct.
final upcomingOctober = [
  scheduleApplication(
    id: 1,
    status: ApplicationStatus.selected,
    event: scheduleEvent(
      id: 41,
      title: 'Wedding of Laras & Bima',
      date: DateTime(2026, 10, 3),
    ),
  ),
  scheduleApplication(
    id: 2,
    status: ApplicationStatus.selected,
    role: 'Event Manager',
    event: scheduleEvent(
      id: 42,
      title: 'Mahesa Group town hall',
      date: DateTime(2026, 10, 18),
      startTime: '09:00',
      endTime: '13:00',
      venueName: 'Menara Mahesa, Sudirman',
    ),
  ),
];

/// One November shift, for a second month group / a second page.
final upcomingNovember = [
  scheduleApplication(
    id: 3,
    status: ApplicationStatus.selected,
    event: scheduleEvent(
      id: 43,
      title: 'Arunika annual gathering',
      date: DateTime(2026, 11, 7),
    ),
  ),
];

/// D2 rows (date DESC): a Not selected first, then a Completed.
final historyRows = [
  scheduleApplication(
    id: 10,
    status: ApplicationStatus.notSelected,
    event: scheduleEvent(
      id: 50,
      title: 'Rumah Dansa studio opening',
      date: DateTime(2026, 9, 20),
    ),
  ),
  scheduleApplication(
    id: 11,
    status: ApplicationStatus.selected,
    event: scheduleEvent(
      id: 51,
      title: 'Kirana 17th birthday',
      date: DateTime(2026, 9, 12),
    ),
  ),
];

/// `meta.summary` as the D2 copy wants it: `06` since Jul 2026.
const historySummaryMeta = {
  'current_page': 1,
  'last_page': 1,
  'total': 2,
  'summary': {'worked_count': 6, 'worked_since': '2026-07-04'},
};

Paginated<Application> schedulePage(
  List<Application> data, {
  int page = 1,
  int lastPage = 1,
  Map<String, dynamic> meta = const {},
}) => Paginated(
  data: data,
  currentPage: page,
  lastPage: lastPage,
  total: data.length,
  meta: meta,
);
