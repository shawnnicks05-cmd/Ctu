import 'package:flutter/foundation.dart' show debugPrint;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/calendar_event.dart';
import '../event/event_model.dart';

class UserPreferencesService {
  static final UserPreferencesService _instance = UserPreferencesService._internal();
  factory UserPreferencesService() => _instance;
  UserPreferencesService._internal();

  static const String _keyFavoriteEvents = 'favorite_events';
  static const String _keyUserCampus = 'user_campus';
  static const String _keyNotificationsEnabled = 'notifications_enabled';
  static const String _keyEventReminders = 'event_reminders';
  static const String _keyPreferredCategories = 'preferred_categories';
  static const String _keyRegisteredEvents = 'registered_events';
  static const String _keyUserEvents = 'user_events';

  SharedPreferences? _prefs;

  Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Favorite Events Management
  Future<void> addToFavorites(CalendarEvent event) async {
    await _ensureInitialized();
    final favorites = await getFavoriteEvents();
    if (!favorites.any((e) => e.id == event.id)) {
      favorites.add(event);
      await _saveFavoriteEvents(favorites);
    }
  }

  Future<void> removeFromFavorites(String eventId) async {
    await _ensureInitialized();
    final favorites = await getFavoriteEvents();
    favorites.removeWhere((event) => event.id == eventId);
    await _saveFavoriteEvents(favorites);
  }

  Future<List<CalendarEvent>> getFavoriteEvents() async {
    await _ensureInitialized();
    final favoritesJson = _prefs?.getStringList(_keyFavoriteEvents) ?? [];
    return favoritesJson
        .map((json) => CalendarEvent.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<bool> isFavorite(String eventId) async {
    final favorites = await getFavoriteEvents();
    return favorites.any((event) => event.id == eventId);
  }

  Future<void> _saveFavoriteEvents(List<CalendarEvent> events) async {
    await _ensureInitialized();
    final favoritesJson = events.map((event) => jsonEncode(event.toJson())).toList();
    await _prefs?.setStringList(_keyFavoriteEvents, favoritesJson);
  }

  // Registered Events Management
  Future<void> registerEvent(String eventId) async {
    await _ensureInitialized();
    final registeredEvents = await getRegisteredEvents();
    debugPrint('Current registered events: $registeredEvents');
    if (!registeredEvents.contains(eventId)) {
      registeredEvents.add(eventId);
      await _saveRegisteredEvents(registeredEvents);
      debugPrint('Registered event: $eventId');
      debugPrint('Updated registered events: $registeredEvents');
    } else {
      debugPrint('Event already registered: $eventId');
    }
  }

  Future<void> unregisterEvent(String eventId) async {
    await _ensureInitialized();
    final registeredEvents = await getRegisteredEvents();
    debugPrint('Current registered events before unregister: $registeredEvents');
    registeredEvents.remove(eventId);
    await _saveRegisteredEvents(registeredEvents);
    debugPrint('Unregistered event: $eventId');
    debugPrint('Updated registered events: $registeredEvents');
  }

  Future<List<String>> getRegisteredEvents() async {
    await _ensureInitialized();
    final events = _prefs?.getStringList(_keyRegisteredEvents) ?? [];
    debugPrint('Loaded registered events: $events');
    return events;
  }

  Future<bool> isRegistered(String eventId) async {
    final registeredEvents = await getRegisteredEvents();
    return registeredEvents.contains(eventId);
  }

  Future<void> _saveRegisteredEvents(List<String> eventIds) async {
    await _ensureInitialized();
    debugPrint('Saving registered events to storage: $eventIds');
    await _prefs?.setStringList(_keyRegisteredEvents, eventIds);
    debugPrint('Saved registered events successfully');
  }

  // User Events Management
  Future<void> addUserEvent(Event event) async {
    await _ensureInitialized();
    final userEvents = await getUserEvents();
    userEvents.add(event);
    await _saveUserEvents(userEvents);
    debugPrint('Added user event: ${event.title}');
  }

  Future<void> updateUserEvent(Event updatedEvent) async {
    await _ensureInitialized();
    final userEvents = await getUserEvents();
    final index = userEvents.indexWhere((event) => event.id == updatedEvent.id);
    if (index != -1) {
      userEvents[index] = updatedEvent;
      await _saveUserEvents(userEvents);
      debugPrint('Updated user event: ${updatedEvent.title}');
    }
  }

  Future<void> deleteUserEvent(String eventId) async {
    await _ensureInitialized();
    final userEvents = await getUserEvents();
    userEvents.removeWhere((event) => event.id == eventId);
    await _saveUserEvents(userEvents);
    debugPrint('Deleted user event: $eventId');
  }

  Future<List<Event>> getUserEvents() async {
    await _ensureInitialized();
    final userEventsJson = _prefs?.getStringList(_keyUserEvents) ?? [];
    return userEventsJson
        .map((json) => _eventFromJson(jsonDecode(json)))
        .toList();
  }

  Future<void> _saveUserEvents(List<Event> events) async {
    await _ensureInitialized();
    final userEventsJson = events.map((event) => jsonEncode(_eventToJson(event))).toList();
    await _prefs?.setStringList(_keyUserEvents, userEventsJson);
    debugPrint('Saved ${events.length} user events');
  }

  Map<String, dynamic> _eventToJson(Event event) {
    return {
      'id': event.id,
      'title': event.title,
      'date': event.date.millisecondsSinceEpoch,
      'endDate': event.endDate?.millisecondsSinceEpoch,
      'time': event.time,
      'endTime': event.endTime,
      'location': event.location,
      'type': event.type.name,
      'description': event.description,
      'isAllDay': event.isAllDay,
    };
  }

  Event _eventFromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(json['date'] ?? 0),
      endDate: json['endDate'] != null ? DateTime.fromMillisecondsSinceEpoch(json['endDate']) : null,
      time: json['time'],
      endTime: json['endTime'],
      location: json['location'],
      type: EventType.values.firstWhere((type) => type.name == json['type'], orElse: () => EventType.academic),
      description: json['description'],
      isAllDay: json['isAllDay'] ?? false,
    );
  }

  // User Campus Management
  Future<void> setUserCampus(String campus) async {
    await _ensureInitialized();
    await _prefs?.setString(_keyUserCampus, campus);
  }

  Future<String?> getUserCampus() async {
    await _ensureInitialized();
    return _prefs?.getString(_keyUserCampus);
  }

  // Notification Preferences
  Future<void> setNotificationsEnabled(bool enabled) async {
    await _ensureInitialized();
    await _prefs?.setBool(_keyNotificationsEnabled, enabled);
  }

  Future<bool> getNotificationsEnabled() async {
    await _ensureInitialized();
    return _prefs?.getBool(_keyNotificationsEnabled) ?? true;
  }

  // Event Reminders
  Future<void> setEventReminder(String eventId, int minutesBefore) async {
    await _ensureInitialized();
    final reminders = await getEventReminders();
    reminders[eventId] = minutesBefore;
    await _saveEventReminders(reminders);
  }

  Future<Map<String, int>> getEventReminders() async {
    await _ensureInitialized();
    final remindersJson = _prefs?.getString(_keyEventReminders) ?? '{}';
    final remindersMap = jsonDecode(remindersJson) as Map<String, dynamic>;
    return remindersMap.map((key, value) => MapEntry(key, value as int));
  }

  Future<void> removeEventReminder(String eventId) async {
    await _ensureInitialized();
    final reminders = await getEventReminders();
    reminders.remove(eventId);
    await _saveEventReminders(reminders);
  }

  Future<void> _saveEventReminders(Map<String, int> reminders) async {
    await _ensureInitialized();
    await _prefs?.setString(_keyEventReminders, jsonEncode(reminders));
  }

  // Preferred Categories
  Future<void> setPreferredCategories(List<EventCategory> categories) async {
    await _ensureInitialized();
    final categoryNames = categories.map((c) => c.name).toList();
    await _prefs?.setStringList(_keyPreferredCategories, categoryNames);
  }

  Future<List<EventCategory>> getPreferredCategories() async {
    await _ensureInitialized();
    final categoryNames = _prefs?.getStringList(_keyPreferredCategories) ?? [];
    return categoryNames
        .map((name) => EventCategory.values.firstWhere((c) => c.name == name))
        .toList();
  }

  // Clear all user data
  Future<void> clearAllData() async {
    await _ensureInitialized();
    await _prefs?.clear();
  }

  Future<void> _ensureInitialized() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
      debugPrint('SharedPreferences initialized for registered events');
    }
  }
}
