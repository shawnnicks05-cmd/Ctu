import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/event_model.dart';
import '../services/ctu_calendar_service.dart';
import '../services/event_adapter.dart';
import '../utils/app_theme.dart';
import '../widgets/event_details_dialog.dart';
import '../widgets/event_card.dart';

class CalendarFilterScreen extends StatefulWidget {
  const CalendarFilterScreen({super.key});

  @override
  State<CalendarFilterScreen> createState() => _CalendarFilterScreenState();
}

class _CalendarFilterScreenState extends State<CalendarFilterScreen> {
  final CTUCalendarService _ctuService = CTUCalendarService();
  EventType? _selectedCategory;
  String _searchQuery = '';
  bool _showUpcomingOnly = false;
  bool _showTodayOnly = false;
  List<Event> _allEvents = [];

  @override
  void initState() {
    super.initState();
    _ctuService.initializeEvents();
    _allEvents = EventAdapter.fromCalendarEvents(_ctuService.events);
  }

  List<Event> get _filteredEvents {
    List<Event> events = List.from(_allEvents); // Create mutable copy

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      events = events.where((event) =>
        event.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        (event.location?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false)
      ).toList();
    }

    // Filter by category
    if (_selectedCategory != null) {
      events = events.where((event) => event.type == _selectedCategory).toList();
    }

    // Filter by time
    if (_showTodayOnly) {
      final today = DateTime.now();
      events = events.where((event) {
        final eventDate = DateTime(event.date.year, event.date.month, event.date.day);
        final checkDate = DateTime(today.year, today.month, today.day);
        return eventDate.isAtSameMomentAs(checkDate);
      }).toList();
    } else if (_showUpcomingOnly) {
      final now = DateTime.now();
      events = events.where((event) => event.date.isAfter(now)).toList();
    }

    // Sort by date (now safe since events is mutable)
    events.sort((a, b) => a.date.compareTo(b.date));

    return events;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Calendar Events',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search events...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Filter Options
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category Filter
                Text(
                  'Category',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildCategoryChip(null, 'All'),
                      ...EventType.values.map((type) {
                        final dummyEvent = Event(
                          id: '',
                          title: '',
                          date: DateTime.now(),
                          type: type,
                        );
                        return _buildCategoryChip(type, dummyEvent.typeLabel);
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Time Filter
                Row(
                  children: [
                    Expanded(
                      child: FilterChip(
                        label: const Text('Today Only'),
                        selected: _showTodayOnly,
                        onSelected: (selected) {
                          setState(() {
                            _showTodayOnly = selected;
                            if (selected) _showUpcomingOnly = false;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilterChip(
                        label: const Text('Upcoming'),
                        selected: _showUpcomingOnly,
                        onSelected: (selected) {
                          setState(() {
                            _showUpcomingOnly = selected;
                            if (selected) _showTodayOnly = false;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Events List
          Expanded(
            child: _filteredEvents.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_busy,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No events found',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your filters',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredEvents.length,
                    itemBuilder: (context, index) {
                      final event = _filteredEvents[index];
                      
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: () {
                            final calendarEvent = EventAdapter.toCalendarEvent(event);
                            showDialog(
                              context: context,
                              builder: (context) => EventDetailsDialog(event: calendarEvent),
                            );
                          },
                          child: EventListCard(event: event),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(EventType? type, String label) {
    final isSelected = _selectedCategory == type;
    final Color chipColor = type != null ? AppColors.eventColor(type) : Colors.grey;
    
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = selected ? type : null;
          });
        },
        backgroundColor: Colors.grey[100],
        selectedColor: chipColor.withOpacity(0.2),
        checkmarkColor: chipColor,
        labelStyle: GoogleFonts.poppins(
          color: isSelected ? chipColor : Colors.grey[700],
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}
