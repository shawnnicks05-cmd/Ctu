import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/event_model.dart';
import '../models/notification_manager.dart';
import '../utils/app_theme.dart';

enum _NotifFilter { all, unread, reminders }

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  _NotifFilter _filter = _NotifFilter.all;
  final NotificationManager _notificationManager = NotificationManager();

  @override
  void initState() {
    super.initState();
    _notificationManager.addListener(_onNotificationChanged);
  }

  @override
  void dispose() {
    _notificationManager.removeListener(_onNotificationChanged);
    super.dispose();
  }

  void _onNotificationChanged() {
    setState(() {});
  }

  List<NotificationItem> get _notifications {
    return _notificationManager.notifications;
  }

  List<NotificationItem> get _visible {
    return _notifications.where((n) {
      switch (_filter) {
        case _NotifFilter.all:
          return true;
        case _NotifFilter.unread:
          return n.unread;
        case _NotifFilter.reminders:
          return n.type == EventType.examination ||
              n.type == EventType.meeting ||
              n.type == EventType.academic;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<NotificationItem>>{};
    for (final n in _visible) {
      grouped.putIfAbsent(n.section, () => []).add(n);
    }
    final order = ['Today', 'Earlier'];

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
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notifications',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _FilterChip(
                                  label: 'All',
                                  selected: _filter == _NotifFilter.all,
                                  onTap: () => setState(
                                      () => _filter = _NotifFilter.all),
                                ),
                                const SizedBox(width: 10),
                                _FilterChip(
                                  label: 'Unread',
                                  selected: _filter == _NotifFilter.unread,
                                  onTap: () => setState(
                                      () => _filter = _NotifFilter.unread),
                                ),
                                const SizedBox(width: 10),
                                _FilterChip(
                                  label: 'Reminders',
                                  selected: _filter == _NotifFilter.reminders,
                                  onTap: () => setState(
                                      () => _filter = _NotifFilter.reminders),
                                ),
                              ],
                            ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => _notificationManager.markAllAsRead(),
                          icon: const Icon(Icons.done_all,
                              size: 18, color: Colors.white),
                          label: Text('Mark All Read',
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600)),
                          style: TextButton.styleFrom(
                            backgroundColor:
                                Colors.white.withValues(alpha: 0.2),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                for (final key in order)
                  if (grouped[key] != null && grouped[key]!.isNotEmpty) ...[
                    Text(
                      key,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...grouped[key]!.asMap().entries.map((entry) {
                      return _NotificationTile(
                        item: entry.value,
                        onTap: () {
                          _notificationManager.markAsRead(entry.key);
                        },
                      );
                    }),
                    const SizedBox(height: 18),
                  ],
                if (_visible.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 48),
                    child: Center(
                      child: Text(
                        'No notifications in this view.',
                        style: GoogleFonts.poppins(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
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

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? Colors.white : Colors.white54,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? AppColors.primary : const Color(0xFFE8E8E8),
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.item,
    this.onTap,
  });

  final NotificationItem item;
  final VoidCallback? onTap;

  IconData get _icon {
    switch (item.type) {
      case EventType.academic:
        return Icons.menu_book_rounded;
      case EventType.examination:
        return Icons.assignment_rounded;
      case EventType.holiday:
        return Icons.event_rounded;
      case EventType.extracurricular:
        return Icons.groups_rounded;
      case EventType.meeting:
        return Icons.groups_2_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.eventColor(item.type);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: c.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(_icon, color: c, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.timeLabel,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (item.location != null) ...[
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(Icons.location_on_rounded,
                            size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            item.location!,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            if (item.unread)
              Padding(
                padding: const EdgeInsets.only(left: 6, top: 4),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
