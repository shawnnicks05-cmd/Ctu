import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'dart:async';
import '../models/calendar_event.dart';
import '../services/user_preferences_service.dart';
import 'ctu_calendar_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  final UserPreferencesService _prefsService = UserPreferencesService();
  Timer? _dailyCheckTimer;

  // Notification channels
  static const String _eventChannelId = 'ctu_events';
  static const String _eventChannelName = 'CTU Events';
  static const String _eventChannelDescription = 'Notifications for CTU academic events';

  Future<void> initialize() async {
    // Initialize timezone
    tz.initializeTimeZones();
    
    // Initialize notifications
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channel
    await _createNotificationChannel();
    
    // Request permissions
    await _requestPermissions();
    
    // Start daily check for upcoming events
    _startDailyNotificationCheck();
  }

  Future<void> _createNotificationChannel() async {
    const androidChannel = AndroidNotificationChannel(
      _eventChannelId,
      _eventChannelName,
      description: _eventChannelDescription,
      importance: Importance.high,
      enableVibration: true,
      playSound: true,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  Future<void> _requestPermissions() async {
    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    
    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
    }

    final iosPlugin = _notifications
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    
    if (iosPlugin != null) {
      await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  Future<void> scheduleEventNotifications(CalendarEvent event) async {
    if (!await _prefsService.getNotificationsEnabled()) {
      return;
    }

    final now = DateTime.now();
    final eventDate = DateTime(
      event.startDate.year,
      event.startDate.month,
      event.startDate.day,
    );

    // Skip if event is in the past
    if (eventDate.isBefore(now)) {
      return;
    }

    // Get user's reminder preference for this event
    final reminders = await _prefsService.getEventReminders();
    final minutesBefore = reminders[event.id] ?? 1440; // Default 24 hours

    // Schedule 2-day advance notification
    await _scheduleNotification(
      id: int.parse('${event.id}_2days'),
      title: 'Upcoming Event: ${event.title}',
      body: '${event.title} is in 2 days. ${event.description}',
      scheduledTime: eventDate.subtract(const Duration(days: 2)),
      event: event,
      notificationType: 'advance_2days',
    );

    // Schedule day-of notification
    await _scheduleNotification(
      id: int.parse('${event.id}_dayof'),
      title: 'Today: ${event.title}',
      body: '${event.title} is today! ${event.description}',
      scheduledTime: DateTime(
        eventDate.year,
        eventDate.month,
        eventDate.day,
        9, // 9:00 AM
      ),
      event: event,
      notificationType: 'day_of',
    );

    // Schedule custom reminder if set
    if (minutesBefore != 1440) {
      await _scheduleNotification(
        id: int.parse('${event.id}_custom'),
        title: 'Reminder: ${event.title}',
        body: '${event.title} starts in ${_formatMinutes(minutesBefore)}.',
        scheduledTime: eventDate.subtract(Duration(minutes: minutesBefore)),
        event: event,
        notificationType: 'custom',
      );
    }
  }

  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    required CalendarEvent event,
    required String notificationType,
  }) async {
    final now = DateTime.now();
    
    // Don't schedule if notification time is in the past
    if (scheduledTime.isBefore(now)) {
      return;
    }

    final tzScheduledTime = tz.TZDateTime.from(
      scheduledTime,
      tz.local,
    );

    final androidDetails = AndroidNotificationDetails(
      _eventChannelId,
      _eventChannelName,
      channelDescription: _eventChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
      color: _getNotificationColor(event.category),
      largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      styleInformation: BigTextStyleInformation(
        body,
        htmlFormatBigText: true,
        contentTitle: title,
        htmlFormatContentTitle: true,
      ),
      actions: [
        const AndroidNotificationAction(
          'view_details',
          'View Details',
          showsUserInterface: true,
        ),
        const AndroidNotificationAction(
          'dismiss',
          'Dismiss',
          showsUserInterface: true,
        ),
      ],
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tzScheduledTime,
      details,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: '${event.id}|$notificationType',
    );
  }

  Color _getNotificationColor(EventCategory category) {
    switch (category) {
      case EventCategory.holiday:
        return const Color(0xFFF44336); // Red
      case EventCategory.exam:
        return const Color(0xFFFF9800); // Orange
      case EventCategory.breakType:
        return const Color(0xFF4CAF50); // Green
      case EventCategory.academic:
        return const Color(0xFF2196F3); // Blue
      case EventCategory.sports:
        return const Color(0xFF9C27B0); // Purple
      case EventCategory.cultural:
        return const Color(0xFF009688); // Teal
      case EventCategory.administrative:
        return const Color(0xFF607D8B); // Grey
    }
  }

  String _formatMinutes(int minutes) {
    if (minutes < 60) {
      return '$minutes minutes';
    } else if (minutes < 1440) {
      final hours = minutes ~/ 60;
      return '$hours hour${hours > 1 ? 's' : ''}';
    } else {
      final days = minutes ~/ 1440;
      return '$days day${days > 1 ? 's' : ''}';
    }
  }

  void _startDailyNotificationCheck() {
    _dailyCheckTimer?.cancel();
    
    _dailyCheckTimer = Timer.periodic(
      const Duration(hours: 6), // Check every 6 hours
      (timer) async {
        await _checkAndScheduleUpcomingEvents();
      },
    );
    
    // Also check immediately on startup
    _checkAndScheduleUpcomingEvents();
  }

  Future<void> _checkAndScheduleUpcomingEvents() async {
    if (!await _prefsService.getNotificationsEnabled()) {
      return;
    }

    final ctuService = CTUCalendarService();
    final upcomingEvents = ctuService.getUpcomingEvents(days: 7);

    for (final event in upcomingEvents) {
      await scheduleEventNotifications(event);
    }
  }

  Future<void> cancelEventNotifications(String eventId) async {
    await _notifications.cancel(int.parse('${eventId}_2days'));
    await _notifications.cancel(int.parse('${eventId}_dayof'));
    await _notifications.cancel(int.parse('${eventId}_custom'));
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  Future<void> testNotification() async {
    await _notifications.show(
      999999,
      'Test Notification',
      'CTU Calendar notifications are working!',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _eventChannelId,
          _eventChannelName,
          channelDescription: _eventChannelDescription,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  void _onNotificationTapped(NotificationResponse response) async {
    final payload = response.payload;
    if (payload != null) {
      final parts = payload.split('|');
      if (parts.length == 2) {
        // Handle notification tap
        if (response.actionId == 'view_details') {
          // Navigate to event details
          // This would require navigation context from main app
        }
      }
    }
  }

  void dispose() {
    _dailyCheckTimer?.cancel();
  }
}
