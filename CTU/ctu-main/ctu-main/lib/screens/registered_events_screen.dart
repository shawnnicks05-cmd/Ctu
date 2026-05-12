import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/event_model.dart';
import '../services/ctu_calendar_service.dart';
import '../services/event_adapter.dart';
import '../services/user_preferences_service.dart';
import '../utils/app_theme.dart';
import '../widgets/event_card.dart';

class RegisteredEventsScreen extends StatefulWidget {
  const RegisteredEventsScreen({super.key});

  @override
  State<RegisteredEventsScreen> createState() => _RegisteredEventsScreenState();
}

class _RegisteredEventsScreenState extends State<RegisteredEventsScreen> {
  final CTUCalendarService _calendarService = CTUCalendarService();
  final UserPreferencesService _preferencesService = UserPreferencesService();
  List<Event> _allEvents = [];
  List<Event> _registeredEvents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRegisteredEvents();
  }

  Future<void> _loadRegisteredEvents() async {
    await _preferencesService.initialize();
    _calendarService.initializeEvents();
    _allEvents = EventAdapter.fromCalendarEvents(_calendarService.events);
    
    final registeredEventIds = await _preferencesService.getRegisteredEvents();
    
    setState(() {
      _registeredEvents = _allEvents.where((event) => 
        registeredEventIds.contains(event.id)
      ).toList();
      _isLoading = false;
    });
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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            )
          : _registeredEvents.isEmpty
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
              : RefreshIndicator(
                  onRefresh: _loadRegisteredEvents,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _registeredEvents.length,
                    itemBuilder: (context, index) {
                      return EventListCard(event: _registeredEvents[index]);
                    },
                  ),
                ),
    );
  }
}
