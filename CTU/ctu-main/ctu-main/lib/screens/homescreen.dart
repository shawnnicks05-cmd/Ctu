// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/event_model.dart';
import '../models/notification_manager.dart';
import '../services/ctu_calendar_service.dart';
import '../services/event_adapter.dart';
import '../utils/app_theme.dart';
import '../widgets/event_card.dart';
import '../widgets/event_details_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.onNavigateToTab});

  /// Switches the main bottom navigation: 0 Home, 1 Calendar, 2 Search, 3 Notifications, 4 Profile.
  final void Function(int tabIndex)? onNavigateToTab;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DateTime _today = DateTime.now();
  final CTUCalendarService _ctuCalendarService = CTUCalendarService();
  final NotificationManager _notificationManager = NotificationManager();
  List<Event> _allEvents = [];
  DateTime _selectedDay = DateTime.now();
  String? _selectedCategory;
  CalendarFormat _calendarFormat = CalendarFormat.week;

  @override
  void initState() {
    super.initState();
    _selectedDay = _today;
    _ctuCalendarService.initializeEvents();
    _allEvents = EventAdapter.fromCalendarEvents(_ctuCalendarService.events);
    _notificationManager.initializeEvents();
    _notificationManager.addListener(_onNotificationChanged);
  }

  @override
  void dispose() {
    _notificationManager.removeListener(_onNotificationChanged);
    super.dispose();
  }

  void _onNotificationChanged() {
    setState(() {});
  }

  List<Event> get todaysEvents {
    return _filteredEvents
        .where((e) =>
            e.date.year == _today.year &&
            e.date.month == _today.month &&
            e.date.day == _today.day)
        .toList();
  }

  List<Event> get upcomingEvents {
    return _filteredEvents.where((e) => e.date.isAfter(_today)).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _filteredEvents
        .where((e) =>
            e.date.year == day.year &&
            e.date.month == day.month &&
            e.date.day == day.day)
        .toList();
  }

  List<Event> get selectedDayEvents {
    return _getEventsForDay(_selectedDay);
  }

  List<Event> get _filteredEvents {
    if (_selectedCategory == null) {
      return _allEvents;
    }
    return _allEvents.where((event) {
      switch (_selectedCategory) {
        case 'Academic':
          return event.type == EventType.academic;
        case 'Examination':
          return event.type == EventType.examination;
        case 'Holiday':
          return event.type == EventType.holiday;
        case 'Extracurricular':
          return event.type == EventType.extracurricular;
        case 'Meeting':
          return event.type == EventType.meeting;
        default:
          return true;
      }
    }).toList();
  }


  void _filterByCategory(String? category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // CTU Logo
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/ctu.png',
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.school,
                                  color: AppColors.primary,
                                  size: 28,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'CTU Smart School Calendar',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  'Stay updated with academic and campus events',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white70,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Stack(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.notifications_outlined,
                                    color: Colors.white, size: 26),
                                onPressed: () {
                                  // Navigate to notifications screen
                                  widget.onNavigateToTab?.call(3);
                                },
                              ),
                              Positioned(
                                right: 8,
                                top: 8,
                                child: Container(
                                  width: 16,
                                  height: 16,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                        _notificationManager.unreadCount > 9 
                                            ? '9+' 
                                            : '${_notificationManager.unreadCount}',
                                        style: GoogleFonts.poppins(
                                            color: AppColors.primary,
                                            fontSize: 9,
                                            fontWeight: FontWeight.w700)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.account_circle_outlined,
                                color: Colors.white, size: 26),
                            onPressed: () => widget.onNavigateToTab?.call(4),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      // Search bar
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(22),
                          onTap: () => widget.onNavigateToTab?.call(2),
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(22),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8),
                              ],
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 14),
                                Icon(Icons.search,
                                    color: Colors.grey.shade400, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Search events, exams, holidays...',
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey.shade400,
                                    fontSize: 13,
                                  ),
                                ),
                                const Spacer(),
                                Icon(Icons.tune,
                                    color: Colors.grey.shade500, size: 20),
                                const SizedBox(width: 14),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Category filters
          SliverToBoxAdapter(
            child: SizedBox(
              height: 38,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _CategoryBtn(
                      label: 'All',
                      icon: Icons.apps,
                      color: Colors.grey,
                      isSelected: _selectedCategory == null,
                      onTap: () => _filterByCategory(null)),
                  const SizedBox(width: 8),
                  _CategoryBtn(
                      label: 'Academic',
                      icon: Icons.menu_book_rounded,
                      color: AppColors.academic,
                      isSelected: _selectedCategory == 'Academic',
                      onTap: () => _filterByCategory('Academic')),
                  const SizedBox(width: 8),
                  _CategoryBtn(
                      label: 'Examination',
                      icon: Icons.assignment_rounded,
                      color: AppColors.examination,
                      isSelected: _selectedCategory == 'Examination',
                      onTap: () => _filterByCategory('Examination')),
                  const SizedBox(width: 8),
                  _CategoryBtn(
                      label: 'Holiday',
                      icon: Icons.calendar_today_rounded,
                      color: AppColors.holiday,
                      isSelected: _selectedCategory == 'Holiday',
                      onTap: () => _filterByCategory('Holiday')),
                  const SizedBox(width: 8),
                  _CategoryBtn(
                      label: 'Extracurricular',
                      icon: Icons.groups_rounded,
                      color: AppColors.extracurricular,
                      isSelected: _selectedCategory == 'Extracurricular',
                      onTap: () => _filterByCategory('Extracurricular')),
                  const SizedBox(width: 8),
                  _CategoryBtn(
                      label: 'Meeting',
                      icon: Icons.people_rounded,
                      color: AppColors.meeting,
                      isSelected: _selectedCategory == 'Meeting',
                      onTap: () => _filterByCategory('Meeting')),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // Today's Events
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Today's Events",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (todaysEvents.isNotEmpty)
                    _TodayEventCard(event: todaysEvents.first),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // Upcoming Events
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Upcoming Events',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Row(
                      children: [
                        Text('View All',
                            style: GoogleFonts.poppins(
                                color: AppColors.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600)),
                        const Icon(Icons.chevron_right,
                            color: AppColors.primary, size: 18),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final event = upcomingEvents[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _UpcomingEventCard(event: event),
                );
              },
              childCount: upcomingEvents.take(3).length,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // Mini calendar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _MiniCalendarCard(
                today: _today,
                selectedDay: _selectedDay,
                eventsForDay: selectedDayEvents,
                calendarFormat: _calendarFormat,
                onOpenFullCalendar: () => widget.onNavigateToTab?.call(1),
                onDaySelected: (DateTime selectedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                  });
                },
                onFormatChanged: (CalendarFormat format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // Recent Notifications
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Notifications',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      TextButton(
                        onPressed: () => widget.onNavigateToTab?.call(3),
                        child: Row(
                          children: [
                            Text('View All',
                                style: GoogleFonts.poppins(
                                    color: AppColors.primary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600)),
                            const Icon(Icons.chevron_right,
                                color: AppColors.primary, size: 18),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _NotificationCard(
                    title: 'Midterm Exam Schedule Updated',
                    message: 'CS101 midterm exam has been rescheduled to next Monday',
                    time: '2 hours ago',
                    onTap: () => widget.onNavigateToTab?.call(3),
                  ),
                  const SizedBox(height: 8),
                  _NotificationCard(
                    title: 'Holiday Announcement',
                    message: 'University closed on Monday for Independence Day',
                    time: '5 hours ago',
                    onTap: () => widget.onNavigateToTab?.call(3),
                  ),
                  const SizedBox(height: 8),
                  _NotificationCard(
                    title: 'Meeting Reminder',
                    message: 'Faculty meeting at 3:00 PM in Conference Room A',
                    time: '1 day ago',
                    onTap: () => widget.onNavigateToTab?.call(3),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Announcements
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.campaign_rounded,
                          color: Colors.orange.shade700, size: 26),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Official Announcements',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'New updates from authorized offices are posted here to ensure accurate and reliable information.',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: Colors.orange.shade700),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryBtn({
    required this.label,
    required this.icon,
    required this.color,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : color.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : color,
              size: 14,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: isSelected ? Colors.white : color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TodayEventCard extends StatelessWidget {
  final Event event;

  const _TodayEventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.eventColor(event.type);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.assignment_rounded, color: color, size: 36),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.title,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.access_time_rounded,
                      size: 13, color: AppColors.textSecondary),
                  const SizedBox(width: 3),
                  Text('${event.time} - ${event.endTime}',
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: AppColors.textSecondary)),
                ]),
                const SizedBox(height: 2),
                Row(children: [
                  const Icon(Icons.location_on_rounded,
                      size: 13, color: AppColors.textSecondary),
                  const SizedBox(width: 3),
                  Text(event.location ?? '',
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: AppColors.textSecondary)),
                ]),
                const SizedBox(height: 6),
                EventTypeBadge(type: event.type),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            child: Text('View Details',
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _UpcomingEventCard extends StatelessWidget {
  final Event event;

  const _UpcomingEventCard({required this.event});

  Widget get _actionButton {
    switch (event.type) {
      case EventType.holiday:
        return const _OutlineBtn(label: 'Holiday', color: AppColors.holiday);
      case EventType.extracurricular:
        return const _FilledBtn(
            label: 'Pre-register', color: AppColors.extracurricular);
      case EventType.meeting:
        return const _OutlineBtn(label: 'Remind Me', color: AppColors.meeting);
      default:
        return _OutlineBtn(
            label: event.typeLabel, color: AppColors.eventColor(event.type));
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = AppColors.eventColor(event.type);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: color, width: 4)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          EventTypeIcon(type: event.type, size: 46),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.title,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 3),
                Row(children: [
                  const Icon(Icons.calendar_today_rounded,
                      size: 12, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('MMMM d, yyyy').format(event.date),
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: AppColors.textSecondary),
                  ),
                ]),
                if (event.location != null) ...[
                  const SizedBox(height: 2),
                  Row(children: [
                    const Icon(Icons.location_on_rounded,
                        size: 12, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(event.location!,
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: AppColors.textSecondary)),
                  ]),
                ],
                if (event.isAllDay)
                  Text('No classes',
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.holiday,
                          fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          _actionButton,
        ],
      ),
    );
  }
}

class _FilledBtn extends StatelessWidget {
  final String label;
  final Color color;
  const _FilledBtn({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(label,
          style: GoogleFonts.poppins(
              color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}

class _OutlineBtn extends StatelessWidget {
  final String label;
  final Color color;
  const _OutlineBtn({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(label,
          style: GoogleFonts.poppins(
              color: color, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}

class _MiniCalendarCard extends StatelessWidget {
  final DateTime today;
  final DateTime selectedDay;
  final List<Event> eventsForDay;
  final CalendarFormat calendarFormat;
  final VoidCallback? onOpenFullCalendar;
  final Function(DateTime)? onDaySelected;
  final Function(CalendarFormat)? onFormatChanged;

  const _MiniCalendarCard({
    required this.today,
    required this.selectedDay,
    required this.eventsForDay,
    required this.calendarFormat,
    this.onOpenFullCalendar,
    this.onDaySelected,
    this.onFormatChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Calendar format toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Calendar View',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Row(
                      children: [
                        _FormatButton(
                          label: '7 Days',
                          isSelected: calendarFormat == CalendarFormat.week,
                          onTap: () => onFormatChanged?.call(CalendarFormat.week),
                        ),
                        const SizedBox(width: 8),
                        _FormatButton(
                          label: '30 Days',
                          isSelected: calendarFormat == CalendarFormat.month,
                          onTap: () => onFormatChanged?.call(CalendarFormat.month),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TableCalendar<Event>(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: selectedDay,
                  calendarFormat: calendarFormat,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    leftChevronIcon: Icon(
                      Icons.chevron_left,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: GoogleFonts.poppins(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                    weekendStyle: GoogleFonts.poppins(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  calendarStyle: CalendarStyle(
                    outsideTextStyle: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey.shade400,
                    ),
                    weekendTextStyle: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.textPrimary,
                    ),
                    defaultTextStyle: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.textPrimary,
                    ),
                    selectedTextStyle: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    todayTextStyle: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    markerDecoration: BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  eventLoader: (day) {
                    return eventsForDay.where((event) =>
                        event.date.year == day.year &&
                        event.date.month == day.month &&
                        event.date.day == day.day).toList();
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    onDaySelected?.call(selectedDay);
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Events for ${DateFormat('MMMM d, yyyy').format(selectedDay)}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                if (eventsForDay.isEmpty)
                  Text(
                    'No events on this date',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  )
                else
                  ...eventsForDay.take(3).map((event) => GestureDetector(
                        onTap: () {
                          final calendarEvent = EventAdapter.toCalendarEvent(event);
                          showDialog(
                            context: context,
                            builder: (context) => EventDetailsDialog(event: calendarEvent),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: AppColors.eventColor(event.type),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  event.title,
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
              ],
            ),
          ),

          // Legend
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _LegendDot(color: AppColors.academic, label: 'Academic'),
                _LegendDot(color: AppColors.examination, label: 'Examination'),
                _LegendDot(color: AppColors.holiday, label: 'Holiday'),
                _LegendDot(
                    color: AppColors.extracurricular, label: 'Extracurricular'),
                _LegendDot(color: AppColors.meeting, label: 'Meeting'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 9, color: AppColors.textSecondary)),
      ],
    );
  }
}

class _FormatButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FormatButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.primary.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.primary,
          ),
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final String title;
  final String message;
  final String time;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.title,
    required this.message,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border(left: BorderSide(color: AppColors.primary, width: 3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.notifications_outlined,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    message,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  time,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Icon(
                  Icons.chevron_right,
                  color: AppColors.primary,
                  size: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
