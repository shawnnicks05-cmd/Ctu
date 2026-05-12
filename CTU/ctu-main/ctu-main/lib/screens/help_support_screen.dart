import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_theme.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Help & Support',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Quick Help Section
          Text(
            'Quick Help',
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
                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: Text(
                    'How to use the calendar',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _showHelpDialog(context, 'How to use the calendar', 
                      'Navigate through different months using the arrows. Tap on any date to see events for that day. Use the filters to show specific event types.');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: Text(
                    'Setting up notifications',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _showHelpDialog(context, 'Setting up notifications', 
                      'Go to Calendar Preferences to enable event reminders. You can choose which types of events you want to be notified about.');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.bookmark),
                  title: Text(
                    'Saving schedules',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _showHelpDialog(context, 'Saving schedules', 
                      'Tap the bookmark icon on any event to save it to your favorites. Access saved schedules from the Profile menu.');
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Contact Section
          Text(
            'Contact Support',
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
                ListTile(
                  leading: const Icon(Icons.email),
                  title: Text(
                    'Email Support',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    'support@ctu.edu.ph',
                    style: GoogleFonts.poppins(fontSize: 12),
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Email client would open here')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: Text(
                    'Phone Support',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    '(032) 123-4567',
                    style: GoogleFonts.poppins(fontSize: 12),
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Phone dialer would open here')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.location_on),
                  title: Text(
                    'Campus Office',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    'Student Services Building, Room 201',
                    style: GoogleFonts.poppins(fontSize: 12),
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Map would open here')),
                    );
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // FAQ Section
          Text(
            'Frequently Asked Questions',
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
                ExpansionTile(
                  title: Text(
                    'How do I register for events?',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Tap on any event in the calendar to view details. Look for the "Register" button and follow the prompts to complete your registration.',
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                ExpansionTile(
                  title: Text(
                    'How do I add my own events?',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Tap the + button in the calendar tab to create personal events. Fill in the event details including title, date, time, location, and description. Choose an event type that best matches your activity.',
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                ExpansionTile(
                  title: Text(
                    'What event types can I create?',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'You can create 5 types of events:\n\n• Academic: Classes, deadlines, study sessions\n• Examination: Tests, quizzes, exams\n• Holiday: Personal holidays, breaks\n• Extracurricular: Sports, clubs, activities\n• Meeting: Study groups, appointments',
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                ExpansionTile(
                  title: Text(
                    'Can I edit or delete my events?',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Yes! Tap on any event you created to edit or delete it. CTU official events cannot be edited, only your personal events. Look for the edit/delete options in the event details.',
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                ExpansionTile(
                  title: Text(
                    'Can I sync with my personal calendar?',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Yes! Go to Settings > Auto Sync to enable calendar synchronization with Google Calendar, Apple Calendar, and other popular calendar apps.',
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                ExpansionTile(
                  title: Text(
                    'Why can\'t I save my event?',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Make sure you fill in the event title (required field). Check that you have a valid date selected. If the issue persists, try restarting the app or clearing the app cache.',
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                ExpansionTile(
                  title: Text(
                    'Where did my created events go?',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Your created events appear in the calendar view alongside CTU official events. They also show up in the home screen if scheduled for today. Check the calendar date where you created the event.',
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                ExpansionTile(
                  title: Text(
                    'Can I create recurring events?',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Currently, recurring events need to be created individually. We\'re working on adding recurring event functionality in a future update.',
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                ExpansionTile(
                  title: Text(
                    'How do I report a bug or issue?',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Use the Email Support option to contact our technical team. Please include details about the issue, your device type, and steps to reproduce the problem.',
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
