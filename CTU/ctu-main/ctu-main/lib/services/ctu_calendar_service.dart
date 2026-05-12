import '../models/calendar_event.dart';

class CTUCalendarService {
  static final CTUCalendarService _instance = CTUCalendarService._internal();
  factory CTUCalendarService() => _instance;
  CTUCalendarService._internal();

  List<CalendarEvent> _events = [];
  List<CalendarEvent> get events => List.unmodifiable(_events);

  void initializeEvents() {
    _events = _generateCTUEvents();
  }

  List<CalendarEvent> _generateCTUEvents() {
    return [
      // ACADEMIC YEAR 2025-2026 EVENTS
      
      // AUGUST 2025
      CalendarEvent(
        id: 'aug_2025_independence_day',
        title: 'Independence Day',
        description: 'Philippine Independence Day Holiday',
        startDate: DateTime(2025, 8, 12),
        category: EventCategory.holiday,
        importance: EventImportance.high,
        isForAllCampuses: true,
        tags: ['national_holiday', 'regular_holiday'],
      ),
      CalendarEvent(
        id: 'aug_2025_cebu_charter',
        title: 'Cebu Provincial Charter Day',
        description: 'Cebu Provincial Charter Day Holiday',
        startDate: DateTime(2025, 8, 6),
        category: EventCategory.holiday,
        importance: EventImportance.medium,
        isForAllCampuses: false,
        specificCampuses: ['Cebu City Campus'],
        tags: ['local_holiday', 'cebu_holiday'],
      ),
      CalendarEvent(
        id: 'aug_2025_ninoy_aquino_day',
        title: 'Ninoy Aquino Day',
        description: 'Commemoration of Ninoy Aquino Day',
        startDate: DateTime(2025, 8, 21),
        category: EventCategory.holiday,
        importance: EventImportance.medium,
        isForAllCampuses: true,
        tags: ['national_holiday', 'special_non_working_holiday'],
      ),
      CalendarEvent(
        id: 'aug_2025_national_heroes',
        title: 'National Heroes Day',
        description: 'National Heroes Day Holiday',
        startDate: DateTime(2025, 8, 29),
        category: EventCategory.holiday,
        importance: EventImportance.high,
        isForAllCampuses: true,
        tags: ['national_holiday', 'regular_holiday'],
      ),
      CalendarEvent(
        id: 'aug_2025_first_day_service',
        title: 'First Day of Actual Service',
        description: 'First day of service for AY 2025-2026',
        startDate: DateTime(2025, 8, 4),
        category: EventCategory.academic,
        importance: EventImportance.high,
        isForAllCampuses: true,
        tags: ['academic_year_start', 'faculty'],
      ),
      CalendarEvent(
        id: 'aug_2025_classes_start',
        title: 'Classes Start - First Semester',
        description: 'Beginning of classes for First Semester AY 2025-2026',
        startDate: DateTime(2025, 8, 11),
        category: EventCategory.academic,
        importance: EventImportance.critical,
        isForAllCampuses: true,
        tags: ['classes_start', 'first_semester'],
      ),

      // SEPTEMBER 2025
      CalendarEvent(
        id: 'sep_2025_all_saints',
        title: 'All Saints Day',
        description: 'All Saints Day Holiday',
        startDate: DateTime(2025, 9, 1),
        category: EventCategory.holiday,
        importance: EventImportance.medium,
        isForAllCampuses: true,
        tags: ['religious_holiday', 'special_non_working_holiday'],
      ),
      CalendarEvent(
        id: 'sep_2025_prelim_exams',
        title: 'Preliminary Examinations',
        description: 'First Semester Preliminary Examination Period',
        startDate: DateTime(2025, 9, 15),
        endDate: DateTime(2025, 9, 21),
        category: EventCategory.exam,
        importance: EventImportance.critical,
        isForAllCampuses: true,
        tags: ['examinations', 'preliminary', 'first_semester'],
      ),

      // OCTOBER 2025
      CalendarEvent(
        id: 'oct_2025_ctu_founding',
        title: 'CTU Founding Anniversary',
        description: 'Cebu Technological University Founding Anniversary',
        startDate: DateTime(2025, 10, 10),
        category: EventCategory.cultural,
        importance: EventImportance.high,
        isForAllCampuses: true,
        tags: ['ctu_anniversary', 'founding', 'celebration'],
      ),
      CalendarEvent(
        id: 'oct_2025_midterm_exams',
        title: 'Midterm Examinations',
        description: 'First Semester Midterm Examination Period',
        startDate: DateTime(2025, 10, 20),
        endDate: DateTime(2025, 10, 26),
        category: EventCategory.exam,
        importance: EventImportance.critical,
        isForAllCampuses: true,
        tags: ['examinations', 'midterm', 'first_semester'],
      ),

      // NOVEMBER 2025
      CalendarEvent(
        id: 'nov_2025_bonifacio_day',
        title: 'Bonifacio Day',
        description: 'Commemoration of Andres Bonifacio Day',
        startDate: DateTime(2025, 11, 30),
        category: EventCategory.holiday,
        importance: EventImportance.high,
        isForAllCampuses: true,
        tags: ['national_holiday', 'regular_holiday'],
      ),
      CalendarEvent(
        id: 'nov_2025_intramural_week',
        title: 'Intramural Sports Week',
        description: 'CTU Intramural Sports Competition Week',
        startDate: DateTime(2025, 11, 3),
        endDate: DateTime(2025, 11, 9),
        category: EventCategory.sports,
        importance: EventImportance.medium,
        isForAllCampuses: true,
        tags: ['sports', 'intramurals', 'competition'],
      ),
      CalendarEvent(
        id: 'nov_2025_cell_meet',
        title: 'Cell Meet',
        description: 'CTU Cell Meet Sports Competition',
        startDate: DateTime(2025, 11, 29),
        category: EventCategory.sports,
        importance: EventImportance.medium,
        isForAllCampuses: true,
        tags: ['sports', 'cell_meet', 'competition'],
      ),
      CalendarEvent(
        id: 'nov_2025_tri_meet',
        title: 'Tri-Meet',
        description: 'CTU Tri-Meet Sports Competition',
        startDate: DateTime(2025, 11, 26),
        endDate: DateTime(2025, 11, 28),
        category: EventCategory.sports,
        importance: EventImportance.medium,
        isForAllCampuses: true,
        tags: ['sports', 'tri_meet', 'competition'],
      ),
      CalendarEvent(
        id: 'nov_2025_semi_final_exams',
        title: 'Semi-Final Examinations',
        description: 'First Semester Semi-Final Examination Period',
        startDate: DateTime(2025, 11, 23),
        endDate: DateTime(2025, 11, 29),
        category: EventCategory.exam,
        importance: EventImportance.critical,
        isForAllCampuses: true,
        tags: ['examinations', 'semi_final', 'first_semester'],
      ),

      // DECEMBER 2025
      CalendarEvent(
        id: 'dec_2025_immaculate_conception',
        title: 'Feast of Immaculate Conception',
        description: 'Feast of the Immaculate Conception',
        startDate: DateTime(2025, 12, 8),
        category: EventCategory.holiday,
        importance: EventImportance.medium,
        isForAllCampuses: true,
        tags: ['religious_holiday', 'special_non_working_holiday'],
      ),
      CalendarEvent(
        id: 'dec_2025_christmas_eve',
        title: 'Christmas Eve',
        description: 'Christmas Eve Holiday',
        startDate: DateTime(2025, 12, 24),
        category: EventCategory.holiday,
        importance: EventImportance.high,
        isForAllCampuses: true,
        tags: ['christmas', 'religious_holiday', 'special_non_working_holiday'],
      ),
      CalendarEvent(
        id: 'dec_2025_christmas_day',
        title: 'Christmas Day',
        description: 'Christmas Day Holiday',
        startDate: DateTime(2025, 12, 25),
        category: EventCategory.holiday,
        importance: EventImportance.high,
        isForAllCampuses: true,
        tags: ['christmas', 'religious_holiday', 'regular_holiday'],
      ),
      CalendarEvent(
        id: 'dec_2025_rizal_day',
        title: 'Rizal Day',
        description: 'Commemoration of Dr. Jose Rizal Day',
        startDate: DateTime(2025, 12, 30),
        category: EventCategory.holiday,
        importance: EventImportance.high,
        isForAllCampuses: true,
        tags: ['national_holiday', 'regular_holiday'],
      ),
      CalendarEvent(
        id: 'dec_2025_last_day_year',
        title: 'Last Day of the Year',
        description: 'Last Day of the Year Holiday',
        startDate: DateTime(2025, 12, 31),
        category: EventCategory.holiday,
        importance: EventImportance.medium,
        isForAllCampuses: true,
        tags: ['special_non_working_holiday'],
      ),
      CalendarEvent(
        id: 'dec_2025_christmas_break',
        title: 'Christmas Break',
        description: 'Christmas Vacation Period',
        startDate: DateTime(2025, 12, 15),
        endDate: DateTime(2026, 1, 4),
        category: EventCategory.breakType,
        importance: EventImportance.high,
        isForAllCampuses: true,
        tags: ['christmas', 'break', 'vacation'],
      ),
      CalendarEvent(
        id: 'dec_2025_final_exams',
        title: 'Final Examinations',
        description: 'First Semester Final Examination Period',
        startDate: DateTime(2025, 12, 1),
        endDate: DateTime(2025, 12, 7),
        category: EventCategory.exam,
        importance: EventImportance.critical,
        isForAllCampuses: true,
        tags: ['examinations', 'final', 'first_semester'],
      ),
      CalendarEvent(
        id: 'dec_2025_grad_final_exams',
        title: 'Final Examinations - Graduating Students',
        description: 'Final Examinations for Graduating Students',
        startDate: DateTime(2025, 12, 1),
        endDate: DateTime(2025, 12, 7),
        category: EventCategory.exam,
        importance: EventImportance.critical,
        isForAllCampuses: true,
        tags: ['examinations', 'final', 'graduating', 'first_semester'],
      ),
      CalendarEvent(
        id: 'dec_2025_classes_end',
        title: 'Classes End - First Semester',
        description: 'End of classes for First Semester AY 2025-2026',
        startDate: DateTime(2025, 12, 12),
        category: EventCategory.academic,
        importance: EventImportance.high,
        isForAllCampuses: true,
        tags: ['classes_end', 'first_semester'],
      ),

      // JANUARY 2026
      CalendarEvent(
        id: 'jan_2026_new_year_eve',
        title: 'New Year\'s Eve',
        description: 'New Year\'s Eve Holiday',
        startDate: DateTime(2026, 1, 1),
        category: EventCategory.holiday,
        importance: EventImportance.high,
        isForAllCampuses: true,
        tags: ['new_year', 'regular_holiday'],
      ),
      CalendarEvent(
        id: 'jan_2026_new_year_day',
        title: 'New Year\'s Day',
        description: 'New Year\'s Day Holiday',
        startDate: DateTime(2026, 1, 2),
        category: EventCategory.holiday,
        importance: EventImportance.high,
        isForAllCampuses: true,
        tags: ['new_year', 'regular_holiday'],
      ),
      CalendarEvent(
        id: 'jan_2026_sinulog_fiesta',
        title: 'Sinulog Fiesta',
        description: 'Sinulog Festival Celebration',
        startDate: DateTime(2026, 1, 18),
        category: EventCategory.cultural,
        importance: EventImportance.medium,
        isForAllCampuses: false,
        specificCampuses: ['Cebu City Campus'],
        tags: ['sinulog', 'festival', 'cultural', 'cebu'],
      ),
      CalendarEvent(
        id: 'jan_2026_cebu_rest_day',
        title: 'Cebu City Campus Rest Day',
        description: 'Rest Day for Cebu City Campus (Sinulog)',
        startDate: DateTime(2026, 1, 19),
        category: EventCategory.holiday,
        importance: EventImportance.medium,
        isForAllCampuses: false,
        specificCampuses: ['Cebu City Campus'],
        tags: ['sinulog', 'local_holiday', 'cebu'],
      ),
      CalendarEvent(
        id: 'jan_2026_cebu_charter_day',
        title: 'Cebu City Charter Day',
        description: 'Cebu City Charter Day Holiday',
        startDate: DateTime(2026, 1, 24),
        category: EventCategory.holiday,
        importance: EventImportance.medium,
        isForAllCampuses: false,
        specificCampuses: ['Cebu City Campus'],
        tags: ['local_holiday', 'cebu_holiday'],
      ),

      // FEBRUARY 2026
      CalendarEvent(
        id: 'feb_2026_good_friday',
        title: 'Good Friday',
        description: 'Good Friday Holiday',
        startDate: DateTime(2026, 2, 6), // Approximate date
        category: EventCategory.holiday,
        importance: EventImportance.high,
        isForAllCampuses: true,
        tags: ['holy_week', 'religious_holiday', 'regular_holiday'],
      ),
      CalendarEvent(
        id: 'feb_2026_black_saturday',
        title: 'Black Saturday',
        description: 'Black Saturday Holiday',
        startDate: DateTime(2026, 2, 7), // Approximate date
        category: EventCategory.holiday,
        importance: EventImportance.high,
        isForAllCampuses: true,
        tags: ['holy_week', 'religious_holiday', 'special_non_working_holiday'],
      ),
      CalendarEvent(
        id: 'feb_2026_prelim_exams',
        title: 'Preliminary Examinations',
        description: 'Second Semester Preliminary Examination Period',
        startDate: DateTime(2026, 2, 16),
        endDate: DateTime(2026, 2, 22),
        category: EventCategory.exam,
        importance: EventImportance.critical,
        isForAllCampuses: true,
        tags: ['examinations', 'preliminary', 'second_semester'],
      ),

      // MARCH 2026
      CalendarEvent(
        id: 'mar_2026_midterm_exams',
        title: 'Midterm Examinations',
        description: 'Second Semester Midterm Examination Period',
        startDate: DateTime(2026, 3, 23),
        endDate: DateTime(2026, 3, 29),
        category: EventCategory.exam,
        importance: EventImportance.critical,
        isForAllCampuses: true,
        tags: ['examinations', 'midterm', 'second_semester'],
      ),

      // APRIL 2026
      CalendarEvent(
        id: 'apr_2026_easter_sunday',
        title: 'Easter Sunday',
        description: 'Easter Sunday',
        startDate: DateTime(2026, 4, 9), // Approximate date
        category: EventCategory.holiday,
        importance: EventImportance.medium,
        isForAllCampuses: true,
        tags: ['easter', 'religious_holiday'],
      ),
      CalendarEvent(
        id: 'apr_2026_araw_ng_kagitingan',
        title: 'Araw ng Kagitingan',
        description: 'Day of Valor Holiday',
        startDate: DateTime(2026, 4, 9),
        category: EventCategory.holiday,
        importance: EventImportance.high,
        isForAllCampuses: true,
        tags: ['national_holiday', 'regular_holiday'],
      ),
      CalendarEvent(
        id: 'apr_2026_semi_final_exams',
        title: 'Semi-Final Examinations',
        description: 'Second Semester Semi-Final Examination Period',
        startDate: DateTime(2026, 4, 27),
        endDate: DateTime(2026, 5, 3),
        category: EventCategory.exam,
        importance: EventImportance.critical,
        isForAllCampuses: true,
        tags: ['examinations', 'semi_final', 'second_semester'],
      ),

      // MAY 2026
      CalendarEvent(
        id: 'may_2026_labor_day',
        title: 'Labor Day',
        description: 'Labor Day Holiday',
        startDate: DateTime(2026, 5, 1),
        category: EventCategory.holiday,
        importance: EventImportance.high,
        isForAllCampuses: true,
        tags: ['national_holiday', 'regular_holiday'],
      ),
      CalendarEvent(
        id: 'may_2026_final_exams',
        title: 'Final Examinations',
        description: 'Second Semester Final Examination Period',
        startDate: DateTime(2026, 5, 9),
        endDate: DateTime(2026, 5, 13),
        category: EventCategory.exam,
        importance: EventImportance.critical,
        isForAllCampuses: true,
        tags: ['examinations', 'final', 'second_semester'],
      ),
      CalendarEvent(
        id: 'may_2026_grad_final_exams',
        title: 'Final Examinations - Graduating Students',
        description: 'Final Examinations for Graduating Students',
        startDate: DateTime(2026, 4, 27),
        endDate: DateTime(2026, 5, 3),
        category: EventCategory.exam,
        importance: EventImportance.critical,
        isForAllCampuses: true,
        tags: ['examinations', 'final', 'graduating', 'second_semester'],
      ),
      CalendarEvent(
        id: 'may_2026_classes_start_summer',
        title: 'Classes Start - Summer',
        description: 'Beginning of Summer Classes',
        startDate: DateTime(2026, 5, 12),
        category: EventCategory.academic,
        importance: EventImportance.medium,
        isForAllCampuses: true,
        tags: ['classes_start', 'summer'],
      ),
      CalendarEvent(
        id: 'may_2026_classes_end',
        title: 'Classes End - Second Semester',
        description: 'End of classes for Second Semester AY 2025-2026',
        startDate: DateTime(2026, 5, 25),
        category: EventCategory.academic,
        importance: EventImportance.high,
        isForAllCampuses: true,
        tags: ['classes_end', 'second_semester'],
      ),

      // JUNE - JULY 2026
      CalendarEvent(
        id: 'jun_2026_summer_vacation',
        title: 'Summer Vacation',
        description: 'Summer Vacation Period',
        startDate: DateTime(2026, 5, 25),
        endDate: DateTime(2026, 7, 11),
        category: EventCategory.breakType,
        importance: EventImportance.high,
        isForAllCampuses: true,
        tags: ['summer', 'break', 'vacation'],
      ),
      CalendarEvent(
        id: 'jul_2026_last_day_service',
        title: 'Last Day of Service',
        description: 'Last Day of Service for AY 2025-2026',
        startDate: DateTime(2026, 7, 31),
        category: EventCategory.academic,
        importance: EventImportance.high,
        isForAllCampuses: true,
        tags: ['academic_year_end', 'faculty'],
      ),

      // SEMESTRAL BREAKS
      CalendarEvent(
        id: 'first_sem_break',
        title: 'First Semestral Break',
        description: 'First Semestral Break Period',
        startDate: DateTime(2025, 12, 12),
        endDate: DateTime(2026, 1, 4),
        category: EventCategory.breakType,
        importance: EventImportance.high,
        isForAllCampuses: true,
        tags: ['break', 'vacation', 'first_semester'],
      ),
    ];
  }

  // Get events for a specific date
  List<CalendarEvent> getEventsForDate(DateTime date) {
    return _events.where((event) {
      final eventDate = DateTime(event.startDate.year, event.startDate.month, event.startDate.day);
      final checkDate = DateTime(date.year, date.month, date.day);
      return eventDate.isAtSameMomentAs(checkDate);
    }).toList();
  }

  // Get events for a specific month
  List<CalendarEvent> getEventsForMonth(DateTime month) {
    return _events.where((event) {
      return event.startDate.year == month.year && event.startDate.month == month.month;
    }).toList();
  }

  // Get events by category
  List<CalendarEvent> getEventsByCategory(EventCategory category) {
    return _events.where((event) => event.category == category).toList();
  }

  // Get upcoming events
  List<CalendarEvent> getUpcomingEvents({int days = 30}) {
    final now = DateTime.now();
    final futureDate = now.add(Duration(days: days));
    
    return _events.where((event) {
      return event.startDate.isAfter(now) && event.startDate.isBefore(futureDate);
    }).toList();
  }

  // Get today's events
  List<CalendarEvent> getTodayEvents() {
    return getEventsForDate(DateTime.now());
  }

  // Search events
  List<CalendarEvent> searchEvents(String query) {
    final lowerQuery = query.toLowerCase();
    return _events.where((event) {
      return event.title.toLowerCase().contains(lowerQuery) ||
             event.description.toLowerCase().contains(lowerQuery) ||
             event.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  // Get events by importance level
  List<CalendarEvent> getEventsByImportance(EventImportance importance) {
    return _events.where((event) => event.importance == importance).toList();
  }

  // Get multi-day events
  List<CalendarEvent> getMultiDayEvents() {
    return _events.where((event) => event.isMultiDay()).toList();
  }

  // Get events for specific campus
  List<CalendarEvent> getEventsForCampus(String campusName) {
    return _events.where((event) {
      return event.isForAllCampuses || event.specificCampuses.contains(campusName);
    }).toList();
  }
}
