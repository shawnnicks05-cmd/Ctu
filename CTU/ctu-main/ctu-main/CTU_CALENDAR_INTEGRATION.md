# CTU Academic Calendar Integration

## Overview
This document outlines the complete integration of the Cebu Technological University (CTU) Academic Calendar for AY 2025-2026 into the CTU Smart School Calendar mobile application.

## Features Implemented

### 1. Comprehensive Event Database
- **Complete AY 2025-2026 Events**: All holidays, examinations, breaks, and important dates
- **Event Categories**: Holiday, Examination, Academic, Sports, Cultural, Administrative, Break
- **Importance Levels**: Low, Medium, High, Critical
- **Campus-Specific Events**: Events specific to Cebu City Campus and other campuses
- **Multi-Day Events**: Support for events spanning multiple days

### 2. Event Categories & Filtering
- **Category Filtering**: Filter by event type (Holiday, Exam, Academic, etc.)
- **Importance Filtering**: Filter by importance level
- **Time-Based Filtering**: Today only, Upcoming events
- **Search Functionality**: Full-text search across titles, descriptions, and tags
- **Real-Time Updates**: Instant filter results as user types

### 3. User Authentication Integration
- **User-Specific Features**: Favorite events, personal preferences
- **Campus Selection**: Users can select their home campus
- **Event Reminders**: Set custom reminders for important events
- **Notification Preferences**: Control which events trigger notifications
- **Data Persistence**: User preferences saved locally

### 4. Enhanced User Interface
- **Event Details Dialog**: Comprehensive event information display
- **Interactive Calendar**: Tap events to view full details
- **Favorite System**: Save important events for quick access
- **Responsive Design**: Optimized for all screen sizes
- **Material Design**: Modern, intuitive interface

## Data Structure

### Calendar Event Model
```dart
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
}
```

### Event Categories
- **Holiday**: National and local holidays (Red theme)
- **Examination**: Prelim, Midterm, Semi-Final, Final exams (Orange theme)
- **Break/Vacation**: Christmas, Summer, Semestral breaks (Green theme)
- **Academic**: Class start/end, service days (Blue theme)
- **Sports**: Intramurals, sports competitions (Purple theme)
- **Cultural**: CTU Anniversary, festivals (Teal theme)
- **Administrative**: Administrative events (Grey theme)

## Key Events Included

### Academic Calendar
- **First Day of Service**: August 4, 2025
- **Classes Start**: August 11, 2025 (First Semester)
- **Classes End**: December 12, 2025 (First Semester)
- **Classes Start**: May 12, 2026 (Summer)
- **Last Day of Service**: July 31, 2026

### Examination Schedule
- **Preliminary Exams**: Sept 15-21, 2025 & Feb 16-22, 2026
- **Midterm Exams**: Oct 20-26, 2025 & Mar 23-29, 2026
- **Semi-Final Exams**: Nov 23-29, 2025 & Apr 27-May 3, 2026
- **Final Exams**: Dec 1-7, 2025 & May 9-13, 2026

### Holidays & Breaks
- **Regular Holidays**: Independence Day, National Heroes Day, Christmas Day, etc.
- **Special Holidays**: Ninoy Aquino Day, All Saints Day, etc.
- **Local Holidays**: Cebu Provincial Charter Day, Cebu City Charter Day
- **Break Periods**: Christmas Break (Dec 15-Jan 4), Summer Vacation (May 25-Jul 11)

### Sports & Cultural Events
- **Intramural Week**: November 3-9, 2025
- **Cell Meet**: November 29, 2025
- **Tri-Meet**: November 26-28, 2025
- **CTU Founding Anniversary**: October 10, 2025
- **Sinulog Fiesta**: January 18, 2026 (Cebu City Campus)

## Technical Implementation

### Services Created
1. **CTUCalendarService**: Main calendar data management
2. **UserPreferencesService**: User-specific data and preferences
3. **EventAdapter**: Compatibility layer with existing event system
4. **FirebaseAuthService**: Authentication backend
5. **AuthProvider**: Authentication state management

### Key Files
- `lib/models/calendar_event.dart`: Core event model
- `lib/services/ctu_calendar_service.dart`: Calendar data service
- `lib/services/user_preferences_service.dart`: User preferences
- `lib/screens/calendar_filter_screen.dart`: Main calendar interface
- `lib/widgets/event_details_dialog.dart`: Event details display
- `lib/services/event_adapter.dart`: Event compatibility layer

### Integration Points
- **Main App**: Calendar service initialized on app start
- **Authentication**: User-specific features require login
- **Navigation**: Calendar accessible from main navigation
- **Home Screen**: Shows today's and upcoming events
- **Search Screen**: Integrated with calendar search

## User Features

### For All Users
- Browse all CTU academic events
- Filter by category, importance, and time
- Search events by keyword
- View detailed event information
- See campus-specific events

### For Authenticated Users
- Save favorite events
- Set event reminders
- Select home campus
- Customize notification preferences
- Personalized event recommendations

## Data Sources

The calendar data is based on the official CTU Academic Calendar for AY 2025-2026, including:
- University Academic Calendar
- Official Holiday Schedule
- Examination Periods
- Sports Competition Schedule
- Cultural Events
- Campus-Specific Activities

## Future Enhancements

### Planned Features
- **Push Notifications**: Real-time event reminders
- **Calendar Sync**: Export to device calendars
- **Offline Support**: Access events without internet
- **Multi-Language Support**: Cebuano/Bisaya language options
- **Admin Panel**: For calendar administrators
- **Event Sharing**: Share events with other users

### Data Updates
- **Real-time Updates**: Live calendar updates from CTU
- **API Integration**: Direct connection to CTU systems
- **Automatic Sync**: Periodic data synchronization
- **Change Detection**: Notify users of calendar changes

## Usage Instructions

### For Users
1. **Login**: Sign in with email and password
2. **Browse**: Navigate to Calendar tab
3. **Filter**: Use category and importance filters
4. **Search**: Type keywords to find specific events
5. **Favorite**: Tap heart icon to save events
6. **Set Reminders**: Configure notification preferences

### For Developers
1. **Initialize**: Call `CTUCalendarService().initializeEvents()` in main.dart
2. **Access**: Use `CTUCalendarService()` singleton to access events
3. **Filter**: Use built-in filtering methods
4. **Adapt**: Use `EventAdapter` for compatibility with existing UI
5. **Customize**: Extend models for additional features

## Benefits

### For Students
- **Complete Schedule**: All academic dates in one place
- **Never Miss Events**: Timely notifications and reminders
- **Easy Planning**: Filter and search capabilities
- **Personalization**: Save important events
- **Campus Relevance**: See relevant campus-specific events

### For Faculty & Staff
- **Academic Planning**: Clear view of academic calendar
- **Event Coordination**: Avoid scheduling conflicts
- **Holiday Awareness**: Stay informed about holidays
- **Break Planning**: Plan around vacation periods

### For Administration
- **Centralized Information**: Single source of truth
- **Easy Updates**: Maintain calendar data efficiently
- **User Engagement**: Increase app usage and adoption
- **Data Analytics**: Track event popularity and usage

## Conclusion

The CTU Academic Calendar integration provides a comprehensive, user-friendly solution for managing academic events at Cebu Technological University. It combines official calendar data with modern mobile app features to create an indispensable tool for the entire CTU community.

The system is designed to be scalable, maintainable, and extensible, allowing for future enhancements and integration with other CTU systems.
