import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/event_model.dart';
import '../services/ctu_calendar_service.dart';
import '../services/event_adapter.dart';
import '../utils/app_theme.dart';
import '../widgets/event_card.dart';

class RegisteredEventsScreen extends StatefulWidget {
  const RegisteredEventsScreen({super.key});

  @override
  State<RegisteredEventsScreen> createState() => _RegisteredEventsScreenState();
}

class _RegisteredEventsScreenState extends State<RegisteredEventsScreen> {
  final CTUCalendarService _calendarService = CTUCalendarService();
  List<Event> _allEvents = [];

  @override
  void initState() {
    super.initState();
    _calendarService.initializeEvents();
    _allEvents = EventAdapter.fromCalendarEvents(_calendarService.events);
  }

  // For demo purposes, show some events as "registered"
  List<Event> get _registeredEvents {
    return _allEvents.where((event) => 
      event.type == EventType.academic || 
      event.type == EventType.examination
    ).take(5).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'My Registered Events',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _registeredEvents.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_available_rounded,
                    size: 80,
                    color: AppColors.primary.withOpacity(0.6),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'No Registered Events',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'You haven\'t registered for any events yet.\nBrowse the calendar to find events to join.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _registeredEvents.length,
              itemBuilder: (context, index) {
                return EventListCard(event: _registeredEvents[index]);
              },
            ),
    );
  }
}
