import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_theme.dart';
import 'notification_settings_screen.dart';

class CalendarPreferencesScreen extends StatefulWidget {
  const CalendarPreferencesScreen({super.key});

  @override
  State<CalendarPreferencesScreen> createState() => _CalendarPreferencesScreenState();
}

class _CalendarPreferencesScreenState extends State<CalendarPreferencesScreen> {
  bool _notificationsEnabled = true;
  bool _showHolidays = true;
  bool _showExams = true;
  bool _showEvents = true;
  String _defaultView = 'Month';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Calendar Preferences',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Notifications Section
          Text(
            'Notifications',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              title: Text(
                'Event Reminders',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                'Get notified about upcoming events',
                style: GoogleFonts.poppins(fontSize: 12),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Switch(
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationSettingsScreen(),
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Event Types Section
          Text(
            'Event Types',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: Text(
                    'Show Holidays',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  value: _showHolidays,
                  onChanged: (value) {
                    setState(() {
                      _showHolidays = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: Text(
                    'Show Examinations',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  value: _showExams,
                  onChanged: (value) {
                    setState(() {
                      _showExams = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: Text(
                    'Show Events',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  value: _showEvents,
                  onChanged: (value) {
                    setState(() {
                      _showEvents = value;
                    });
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Default View Section
          Text(
            'Default View',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: ['Month', 'Week', 'Day'].map((view) => RadioListTile<String>(
                title: Text(
                  view,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                ),
                value: view,
                groupValue: _defaultView,
                onChanged: (value) {
                  setState(() {
                    _defaultView = value!;
                  });
                },
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
