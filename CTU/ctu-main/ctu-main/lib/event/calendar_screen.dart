// lib/screens/calendar_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/event_model.dart';
import '../services/ctu_calendar_service.dart';
import '../services/event_adapter.dart';
import '../utils/app_theme.dart';
import '../widgets/event_card.dart';
import '../widgets/event_details_dialog.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final CTUCalendarService _calendarService = CTUCalendarService();
  List<Event> _allEvents = [];

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    _calendarService.initializeEvents();
    _allEvents = EventAdapter.fromCalendarEvents(_calendarService.events);
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _allEvents.where((event) =>
        event.date.year == day.year &&
        event.date.month == day.month &&
        event.date.day == day.day).toList();
  }

  List<Event> get _selectedEvents => _getEventsForDay(_selectedDay);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Calendar'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: TableCalendar<Event>(
              firstDay: DateTime(2020, 1, 1),
              lastDay: DateTime(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              eventLoader: _getEventsForDay,
              startingDayOfWeek: StartingDayOfWeek.monday,
              onDaySelected: (selected, focused) {
                setState(() {
                  _selectedDay = selected;
                  _focusedDay = focused;
                });
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarStyle: CalendarStyle(
                outsideDaysVisible: true,
                todayDecoration: const BoxDecoration(
                  color: AppColors.holiday,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: const BoxDecoration(
                  color: AppColors.holiday,
                  shape: BoxShape.circle,
                ),
                todayTextStyle: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
                selectedTextStyle: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white,
                ),
                defaultTextStyle: GoogleFonts.poppins(fontSize: 14),
                weekendTextStyle: GoogleFonts.poppins(fontSize: 14),
                outsideTextStyle: GoogleFonts.poppins(
                    fontSize: 14, color: Colors.grey.shade400),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                leftChevronIcon:
                    const Icon(Icons.chevron_left, color: AppColors.primary),
                rightChevronIcon:
                    const Icon(Icons.chevron_right, color: AppColors.primary),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600),
                weekendStyle: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600),
              ),
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (events.isEmpty) return null;
                  return Positioned(
                    bottom: 2,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: events.take(3).map((e) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            color: AppColors.eventColor(e.type),
                            shape: BoxShape.circle,
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Text(
              DateFormat('MMMM d, yyyy').format(_selectedDay),
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _selectedEvents.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_available_rounded,
                            size: 48, color: Colors.grey.shade300),
                        const SizedBox(height: 12),
                        Text(
                          'No events on this day',
                          style: GoogleFonts.poppins(
                              color: AppColors.textSecondary, fontSize: 14),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _selectedEvents.length,
                    itemBuilder: (context, index) {
                      return EventListCard(
                        event: _selectedEvents[index],
                        onTap: () {
                          final calendarEvent = EventAdapter.toCalendarEvent(_selectedEvents[index]);
                          showDialog(
                            context: context,
                            builder: (context) => EventDetailsDialog(event: calendarEvent),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
