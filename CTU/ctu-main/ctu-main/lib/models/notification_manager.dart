import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'event_model.dart';
import '../services/ctu_calendar_service.dart';
import '../services/event_adapter.dart';

class NotificationManager extends ChangeNotifier {
  static final NotificationManager _instance = NotificationManager._internal();
  factory NotificationManager() => _instance;
  NotificationManager._internal();

  final CTUCalendarService _calendarService = CTUCalendarService();
  List<Event> _allEvents = [];
  final Set<String> _readNotifications = <String>{};

  void initializeEvents() {
    _calendarService.initializeEvents();
    _allEvents = EventAdapter.fromCalendarEvents(_calendarService.events);
  }

  List<NotificationItem> get notifications {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    return _allEvents.map((event) {
      final eventDate = DateTime(event.date.year, event.date.month, event.date.day);
      final isToday = eventDate.isAtSameMomentAs(today);
      final isPast = eventDate.isBefore(today);
      
      String timeLabel;
      if (event.isAllDay) {
        timeLabel = isToday ? 'Today • All Day' : DateFormat('MMM d, yyyy • All Day').format(event.date);
      } else if (event.time != null) {
        if (isToday) {
          timeLabel = 'Today at ${event.time}';
        } else {
          timeLabel = DateFormat('MMM d, yyyy at ${event.time}').format(event.date);
        }
      } else {
        timeLabel = isToday ? 'Today' : DateFormat('MMM d, yyyy').format(event.date);
      }
      
      // Mark as unread only if it's a future event AND hasn't been read
      final isUnread = !isPast && !_readNotifications.contains(event.id);
      
      return NotificationItem(
        title: event.title,
        timeLabel: timeLabel,
        location: event.location,
        type: event.type,
        unread: isUnread,
        section: isToday ? 'Today' : 'Earlier',
      );
    }).toList();
  }

  int get unreadCount {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    return _allEvents.where((event) {
      final eventDate = DateTime(event.date.year, event.date.month, event.date.day);
      final isPast = eventDate.isBefore(today);
      return !isPast && !_readNotifications.contains(event.id);
    }).length;
  }

  void markAsRead(int index) {
    if (index >= 0 && index < _allEvents.length) {
      _readNotifications.add(_allEvents[index].id);
      notifyListeners();
    }
  }

  void markAllAsRead() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    for (final event in _allEvents) {
      final eventDate = DateTime(event.date.year, event.date.month, event.date.day);
      final isPast = eventDate.isBefore(today);
      
      // Only mark future/upcoming events as read
      if (!isPast) {
        _readNotifications.add(event.id);
      }
    }
    notifyListeners();
  }

  void markAsUnread(int index) {
    if (index >= 0 && index < _allEvents.length) {
      _readNotifications.remove(_allEvents[index].id);
      notifyListeners();
    }
  }
}

class NotificationItem {
  final String title;
  final String timeLabel;
  final String? location;
  final EventType type;
  final bool unread;
  final String section;

  NotificationItem({
    required this.title,
    required this.timeLabel,
    this.location,
    required this.type,
    required this.unread,
    required this.section,
  });
}
