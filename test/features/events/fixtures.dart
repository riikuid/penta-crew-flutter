import 'package:penta_crew/core/network/paginated.dart';
import 'package:penta_crew/features/auth/models/branch.dart';
import 'package:penta_crew/features/auth/models/crew_role.dart';
import 'package:penta_crew/features/events/models/application.dart';
import 'package:penta_crew/features/events/models/cannot_apply_reason.dart';
import 'package:penta_crew/features/events/models/event.dart';
import 'package:penta_crew/features/events/models/event_detail.dart';
import 'package:penta_crew/features/events/models/event_position.dart';

/// Shared Events fixtures built around the prototype's data (C1–C9): the
/// Arunika gathering on Mon 5 Oct 2026, deadline Mon 28 Sep 18:00 local.
const jakarta = Branch(id: 1, name: 'Jakarta');
const crewRole = CrewRole(id: 1, name: 'Crew');
const managerRole = CrewRole(id: 2, name: 'Event Manager');
const traineeRole = CrewRole(id: 3, name: 'Trainee');

const managerPosition = EventPosition(
  id: 8,
  role: managerRole,
  needed: 2,
  matchesMyRole: true,
);
const crewPosition = EventPosition(
  id: 7,
  role: crewRole,
  needed: 6,
  matchesMyRole: true,
);
const traineePosition = EventPosition(id: 9, role: traineeRole, needed: 1);

/// "Today" for deadline copy: Fri 25 Sep 2026 → `3 days left`.
final now = DateTime(2026, 9, 25, 9);
final deadline = DateTime(2026, 9, 28, 18);

Event event({
  int id = 41,
  String title = 'Arunika annual gathering',
  bool isUrgent = true,
  List<EventPosition> positions = const [
    managerPosition,
    crewPosition,
    traineePosition,
  ],
}) => Event(
  id: id,
  title: title,
  date: DateTime(2026, 10, 5),
  startTime: '14:00',
  endTime: '20:00',
  durationHours: 6,
  venueName: 'JIExpo Kemayoran, Hall B',
  branch: jakarta,
  applyDeadline: deadline,
  isUrgent: isUrgent,
  positions: positions,
);

EventDetail detail({
  EventStatus status = EventStatus.open,
  bool canApply = true,
  CannotApplyReason? cannotApplyReason,
  Application? myApplication,
  String? adminNote,
  String? briefingTime = '13:00',
  List<EventPosition> positions = const [
    managerPosition,
    crewPosition,
    traineePosition,
  ],
}) => EventDetail(
  id: 41,
  title: 'Arunika annual gathering',
  date: DateTime(2026, 10, 5),
  startTime: '14:00',
  endTime: '20:00',
  durationHours: 6,
  venueName: 'JIExpo Kemayoran, Hall B',
  venueAddress: 'Jl. Benyamin Sueb, Jakarta Pusat',
  branch: jakarta,
  applyDeadline: deadline,
  isUrgent: true,
  positions: positions,
  briefingTime: briefingTime,
  requirements: const ['Usher', 'Registration desk', 'Any gender'],
  description: 'All black, closed shoes. Briefing at 13:00 at the Hall B loading dock. Meals provided.',
  adminNote: adminNote,
  status: status,
  canApply: canApply,
  cannotApplyReason: cannotApplyReason,
  myApplication: myApplication,
);

Application application({
  int id = 301,
  ApplicationStatus status = ApplicationStatus.waiting,
  ApplicationPosition? assignedPosition,
  bool withEvent = true,
}) => Application(
  id: id,
  status: status,
  appliedPosition: const ApplicationPosition(id: 7, role: crewRole),
  assignedPosition: assignedPosition,
  appliedAt: DateTime(2026, 9, 25, 10, 12),
  closesAt: deadline,
  decidedAt: status == ApplicationStatus.waiting
      ? null
      : DateTime(2026, 9, 29, 9),
  event: withEvent ? event() : null,
);

Paginated<T> page<T>(
  List<T> items, {
  int currentPage = 1,
  int lastPage = 1,
  int? total,
}) => Paginated(
  data: items,
  currentPage: currentPage,
  lastPage: lastPage,
  total: total ?? items.length,
);
