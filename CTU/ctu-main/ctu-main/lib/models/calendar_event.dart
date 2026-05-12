import 'package:flutter/material.dart';

enum EventCategory {
  holiday('Holiday', Colors.red),
  exam('Examination', Colors.orange),
  breakType('Break/Vacation', Colors.green),
  academic('Academic', Colors.blue),
  sports('Sports', Colors.purple),
  cultural('Cultural', Colors.teal),
  administrative('Administrative', Colors.grey),
  enrollment('Enrollment', Colors.amber);

  const EventCategory(this.displayName, this.color);
  final String displayName;
  final Color color;
}

enum EventImportance {
  low('Low', 1),
  medium('Medium', 2),
  high('High', 3),
  critical('Critical', 4);

  const EventImportance(this.displayName, this.level);
  final String displayName;
  final int level;
}

class CalendarEvent {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime? endDate;
  final EventCategory category;
  final EventImportance importance;
  final String? location;
  final bool isRecurring;
  final List<String> tags;
  final bool isForAllCampuses;
  final List<String> specificCampuses;

  CalendarEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    this.endDate,
    required this.category,
    this.importance = EventImportance.medium,
    this.location,
    this.isRecurring = false,
    this.tags = const [],
    this.isForAllCampuses = true,
    this.specificCampuses = const [],
  });

  bool isMultiDay() {
    if (endDate == null) return false;
    return !endDate!.isAtSameMomentAs(startDate);
  }

  bool isToday() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final eventDate = DateTime(startDate.year, startDate.month, startDate.day);
    return eventDate.isAtSameMomentAs(today);
  }

  bool isUpcoming() {
    return startDate.isAfter(DateTime.now());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'category': category.name,
      'importance': importance.name,
      'location': location,
      'isRecurring': isRecurring,
      'tags': tags,
      'isForAllCampuses': isForAllCampuses,
      'specificCampuses': specificCampuses,
    };
  }

  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    return CalendarEvent(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      category: EventCategory.values.firstWhere((e) => e.name == json['category']),
      importance: EventImportance.values.firstWhere((e) => e.name == json['importance']),
      location: json['location'],
      isRecurring: json['isRecurring'] ?? false,
      tags: List<String>.from(json['tags'] ?? []),
      isForAllCampuses: json['isForAllCampuses'] ?? true,
      specificCampuses: List<String>.from(json['specificCampuses'] ?? []),
    );
  }
}
