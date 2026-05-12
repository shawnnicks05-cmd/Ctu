// lib/data/events_data.dart
import '../models/event_model.dart';

final List<Event> sampleEvents = [
  Event(
    id: '1',
    title: 'Prelim Examination',
    date: DateTime(2026, 5, 15),
    time: '9:00 AM',
    endTime: '11:00 AM',
    location: 'Engineering Building',
    type: EventType.examination,
    description: 'Preliminary examination for all engineering courses.',
  ),
  Event(
    id: '2',
    title: 'University Holiday',
    date: DateTime(2026, 5, 15),
    type: EventType.holiday,
    description: 'No classes today.',
    isAllDay: true,
  ),
  Event(
    id: '3',
    title: 'Department Meeting',
    date: DateTime(2026, 5, 15),
    time: '1:00 PM',
    endTime: '3:00 PM',
    location: 'Conference Room A',
    type: EventType.meeting,
    description: 'Monthly department meeting for all faculty members.',
  ),
  Event(
    id: '4',
    title: 'Student Organization Fair',
    date: DateTime(2026, 5, 20),
    time: '9:00 AM',
    location: 'CTU Gymnasium',
    type: EventType.extracurricular,
    description:
        'Annual student org fair. All students are encouraged to join.',
  ),
  Event(
    id: '5',
    title: 'Final Examination',
    date: DateTime(2026, 5, 30),
    time: '9:00 AM',
    endTime: '11:00 AM',
    location: 'Engineering Building',
    type: EventType.examination,
    description: 'Final examination for all courses.',
  ),
  Event(
    id: '6',
    title: 'Academic Convocation',
    date: DateTime(2026, 5, 5),
    time: '8:00 AM',
    location: 'Main Auditorium',
    type: EventType.academic,
    description: 'Annual academic convocation ceremony.',
  ),
  Event(
    id: '7',
    title: 'Faculty Development',
    date: DateTime(2026, 5, 7),
    time: '10:00 AM',
    location: 'Room 201',
    type: EventType.meeting,
    description: 'Faculty development training session.',
  ),
  Event(
    id: '8',
    title: 'Sports Fest',
    date: DateTime(2026, 5, 27),
    time: '7:00 AM',
    location: 'CTU Sports Complex',
    type: EventType.extracurricular,
    description: 'Intramural sports festival for all students.',
  ),
  Event(
    id: '9',
    title: 'Science Fair',
    date: DateTime(2026, 5, 27),
    time: '9:00 AM',
    location: 'Engineering Building Lobby',
    type: EventType.academic,
    description: 'Annual science and technology fair.',
  ),
  Event(
    id: '10',
    title: 'Enrollment Period',
    date: DateTime(2026, 5, 13),
    time: '8:00 AM',
    endTime: '5:00 PM',
    location: 'Registrar Office',
    type: EventType.academic,
    description: 'Enrollment for the next semester.',
  ),
  Event(
    id: '11',
    title: 'Independence Day Holiday',
    date: DateTime(2026, 5, 25),
    type: EventType.holiday,
    isAllDay: true,
    description: 'Philippine Independence Day. No classes.',
  ),
];

Map<DateTime, List<Event>> get eventsMap {
  final map = <DateTime, List<Event>>{};
  for (final event in sampleEvents) {
    final key = DateTime(event.date.year, event.date.month, event.date.day);
    map[key] = [...(map[key] ?? []), event];
  }
  return map;
}
