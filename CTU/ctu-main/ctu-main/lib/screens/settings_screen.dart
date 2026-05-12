import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _autoSync = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Account Section
          Text(
            'Account',
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
                  leading: const Icon(Icons.person),
                  title: Text(
                    'Edit Profile',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Edit Profile - Coming Soon')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.lock),
                  title: Text(
                    'Change Password',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Change Password - Coming Soon')),
                    );
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Preferences Section
          Text(
            'Preferences',
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
                    'Push Notifications',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    'Receive push notifications',
                    style: GoogleFonts.poppins(fontSize: 12),
                  ),
                  value: _notifications,
                  onChanged: (value) {
                    setState(() {
                      _notifications = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: Text(
                    'Auto Sync',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    'Automatically sync calendar data',
                    style: GoogleFonts.poppins(fontSize: 12),
                  ),
                  value: _autoSync,
                  onChanged: (value) {
                    setState(() {
                      _autoSync = value;
                    });
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // About Section
          Text(
            'About',
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
                  leading: const Icon(Icons.info),
                  title: Text(
                    'About',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    'CTU Smart Calendar v1.0.0',
                    style: GoogleFonts.poppins(fontSize: 12),
                  ),
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'CTU Smart Calendar',
                      applicationVersion: '1.0.0',
                      applicationIcon: const Icon(Icons.calendar_today, size: 48),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.privacy_tip),
                  title: Text(
                    'Privacy Policy',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Privacy Policy - Coming Soon')),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
