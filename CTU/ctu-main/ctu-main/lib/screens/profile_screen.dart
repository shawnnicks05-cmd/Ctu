import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../services/auth_provider.dart';
import '../utils/app_theme.dart';
import 'registered_events_screen.dart';
import 'saved_schedules_screen.dart';
import 'calendar_preferences_screen.dart';
import 'settings_screen.dart';
import 'help_support_screen.dart';
import 'notification_settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 22),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: const Color(0xFFD4AF37), width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: user?.photoURL != null
                            ? Image.network(
                                user!.photoURL!,
                                width: 72,
                                height: 72,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return ColoredBox(
                                    color: Colors.white,
                                    child: Icon(
                                      Icons.person_rounded,
                                      size: 42,
                                      color: AppColors.primary.withOpacity(0.85),
                                    ),
                                  );
                                },
                              )
                            : ColoredBox(
                                color: Colors.white,
                                child: Icon(
                                  Icons.person_rounded,
                                  size: 42,
                                  color: AppColors.primary.withOpacity(0.85),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.displayName ?? 'CTU Student',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user?.email ?? 'student@ctu.edu.ph',
                            style: GoogleFonts.poppins(
                              color: Colors.white.withOpacity(0.92),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Verified User',
                            style: GoogleFonts.poppins(
                              color: Colors.white.withOpacity(0.92),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              children: [
                Text(
                  'My Information',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _InfoRow(
                        label: 'Email',
                        value: user?.email ?? 'Not available',
                      ),
                      Divider(height: 20, color: Colors.grey.shade200),
                      _InfoRow(
                        label: 'User ID',
                        value: user?.uid.substring(0, 8) ?? 'Not available',
                      ),
                      Divider(height: 20, color: Colors.grey.shade200),
                      _InfoRow(
                        label: 'Email Verified',
                        value: user?.emailVerified == true ? 'Yes' : 'No',
                      ),
                      Divider(height: 20, color: Colors.grey.shade200),
                      _InfoRow(
                        label: 'Account Created',
                        value: user?.metadata.creationTime != null 
                            ? '${user!.metadata.creationTime!.day}/${user.metadata.creationTime!.month}/${user.metadata.creationTime!.year}'
                            : 'Not available',
                      ),
                      Divider(height: 20, color: Colors.grey.shade200),
                      _InfoRow(
                        label: 'Last Sign In',
                        value: user?.metadata.lastSignInTime != null 
                            ? '${user!.metadata.lastSignInTime!.day}/${user.metadata.lastSignInTime!.month}/${user.metadata.lastSignInTime!.year}'
                            : 'Not available',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _MenuTile(
                        icon: Icons.calendar_today_outlined,
                        label: 'My Registered Events',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisteredEventsScreen(),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      _MenuTile(
                        icon: Icons.bookmark_border_rounded,
                        label: 'Saved Schedules',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SavedSchedulesScreen(),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      _MenuTile(
                        icon: Icons.settings_suggest_outlined,
                        label: 'Calendar Preferences',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CalendarPreferencesScreen(),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      _MenuTile(
                        icon: Icons.notifications_outlined,
                        label: 'Notification Settings',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationSettingsScreen(),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      _MenuTile(
                        icon: Icons.settings_outlined,
                        label: 'Settings',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsScreen(),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      _MenuTile(
                        icon: Icons.help_outline_rounded,
                        label: 'Help & Support',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HelpSupportScreen(),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      _MenuTile(
                        icon: Icons.logout_rounded,
                        label: 'Logout',
                        iconColor: AppColors.primary,
                        textColor: AppColors.primary,
                        onTap: () async {
                          // Show confirmation dialog
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Logout'),
                              content: const Text('Are you sure you want to logout?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: Text(
                                    'Logout',
                                    style: TextStyle(color: AppColors.primary),
                                  ),
                                ),
                              ],
                            ),
                          );

                          if (confirmed == true) {
                            try {
                              await authProvider.signOut();
                              // Navigation will be handled automatically by AuthProvider in main.dart
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error signing out: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.textColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final ic = iconColor ?? AppColors.textSecondary;
    final tc = textColor ?? AppColors.textPrimary;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: Icon(icon, color: ic, size: 22),
      title: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: tc,
        ),
      ),
      trailing: Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
      onTap: onTap,
    );
  }
}
