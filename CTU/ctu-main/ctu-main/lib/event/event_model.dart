// lib/models/event_model.dart

enum EventType { academic, examination, holiday, extracurricular, meeting }

class Event {
  final String id;
  final String title;
  final DateTime date;
  final DateTime? endDate;
  final String? time;
  final String? endTime;
  final String? location;
  final EventType type;
  final String? description;
  final bool isAllDay;

  const Event({
    required this.id,
    required this.title,
    required this.date,
    this.endDate,
    this.time,
    this.endTime,
    this.location,
    required this.type,
    this.description,
    this.isAllDay = false,
  });

  String get typeLabel {
    switch (type) {
      case EventType.academic:
        return 'Academic';
      case EventType.examination:
        return 'Examination';
      case EventType.holiday:
        return 'Holiday';
      case EventType.extracurricular:
        return 'Extracurricular';
      case EventType.meeting:
        return 'Meeting';
    }
  }
}
