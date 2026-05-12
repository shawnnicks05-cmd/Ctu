import '../models/calendar_event.dart';
import '../event/event_model.dart';

class EventAdapter {
  static Event fromCalendarEvent(CalendarEvent calendarEvent) {
    // Map EventCategory to EventType
    EventType eventType;
    switch (calendarEvent.category) {
      case EventCategory.holiday:
        eventType = EventType.holiday;
        break;
      case EventCategory.exam:
        eventType = EventType.examination;
        break;
      case EventCategory.academic:
        eventType = EventType.academic;
        break;
      case EventCategory.sports:
      case EventCategory.cultural:
        eventType = EventType.extracurricular;
        break;
      case EventCategory.breakType:
        eventType = EventType.meeting;
        break;
      case EventCategory.administrative:
        eventType = EventType.meeting;
        break;
      case EventCategory.enrollment:
        eventType = EventType.academic;
        break;
      }

    return Event(
      id: calendarEvent.id,
      title: calendarEvent.title,
      date: calendarEvent.startDate,
      endDate: calendarEvent.endDate,
      time: _formatTime(calendarEvent.startDate),
      endTime: calendarEvent.endDate != null ? _formatTime(calendarEvent.endDate!) : null,
      location: calendarEvent.location,
      type: eventType,
      description: calendarEvent.description,
      isAllDay: calendarEvent.endDate != null && 
                calendarEvent.endDate!.difference(calendarEvent.startDate).inDays >= 1,
    );
  }

  static List<Event> fromCalendarEvents(List<CalendarEvent> calendarEvents) {
    return calendarEvents.map((event) => fromCalendarEvent(event)).toList();
  }

  static CalendarEvent toCalendarEvent(Event event) {
    // Map EventType back to EventCategory
    EventCategory eventCategory;
    switch (event.type) {
      case EventType.holiday:
        eventCategory = EventCategory.holiday;
        break;
      case EventType.examination:
        eventCategory = EventCategory.exam;
        break;
      case EventType.academic:
        eventCategory = EventCategory.academic;
        break;
      case EventType.extracurricular:
        eventCategory = EventCategory.cultural;
        break;
      case EventType.meeting:
        eventCategory = EventCategory.administrative;
        break;
    }

    // Parse time if available
    DateTime? endDate;
    if (event.endTime != null && event.time != null) {
      final timeParts = event.time!.split(' ');
      final endTimeParts = event.endTime!.split(' ');
      if (timeParts.length >= 2 && endTimeParts.length >= 2) {
        final startHourMin = timeParts[0].split(':');
        final endHourMin = endTimeParts[0].split(':');
        final startHour = int.parse(startHourMin[0]);
        final startMin = int.parse(startHourMin[1]);
        final endHour = int.parse(endHourMin[0]);
        final endMin = int.parse(endHourMin[1]);
        
        final startDateTime = DateTime(
          event.date.year, event.date.month, event.date.day,
          startHour % 12 + (timeParts[1] == 'PM' && startHour != 12 ? 12 : 0),
          startMin
        );
        
        endDate = DateTime(
          event.date.year, event.date.month, event.date.day,
          endHour % 12 + (endTimeParts[1] == 'PM' && endHour != 12 ? 12 : 0),
          endMin
        );
        
        return CalendarEvent(
          id: event.id,
          title: event.title,
          description: event.description ?? '',
          startDate: startDateTime,
          endDate: endDate,
          category: eventCategory,
          importance: EventImportance.medium,
          location: event.location,
          isRecurring: false,
          tags: [],
          isForAllCampuses: true,
          specificCampuses: [],
        );
      }
    }

    return CalendarEvent(
      id: event.id,
      title: event.title,
      description: event.description ?? '',
      startDate: event.date,
      endDate: event.endDate,
      category: eventCategory,
      importance: EventImportance.medium,
      location: event.location,
      isRecurring: false,
      tags: [],
      isForAllCampuses: true,
      specificCampuses: [],
    );
  }

  static String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }
}
