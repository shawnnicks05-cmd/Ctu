import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/calendar_event.dart';

class UserPreferencesService {
  static final UserPreferencesService _instance = UserPreferencesService._internal();
  factory UserPreferencesService() => _instance;
  UserPreferencesService._internal();

  static const String _keyFavoriteEvents = 'favorite_events';
  static const String _keyUserCampus = 'user_campus';
  static const String _keyNotificationsEnabled = 'notifications_enabled';
  static const String _keyEventReminders = 'event_reminders';
  static const String _keyPreferredCategories = 'preferred_categories';

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
    _prefs ??= await SharedPreferences.getInstance();
  }
}
