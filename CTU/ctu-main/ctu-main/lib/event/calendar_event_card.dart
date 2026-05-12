// lib/event/calendar_event_card.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/calendar_event.dart';
import '../utils/app_theme.dart';

class CalendarEventIcon extends StatelessWidget {
  final EventCategory category;
  final double size;

  const CalendarEventIcon({super.key, required this.category, this.size = 40});

  IconData get icon {
    switch (category) {
      case EventCategory.academic:
        return Icons.menu_book_rounded;
      case EventCategory.exam:
        return Icons.assignment_rounded;
      case EventCategory.holiday:
        return Icons.star_rounded;
      case EventCategory.breakType:
        return Icons.beach_access_rounded;
      case EventCategory.sports:
        return Icons.sports_basketball_rounded;
      case EventCategory.cultural:
        return Icons.theater_comedy_rounded;
      case EventCategory.administrative:
        return Icons.admin_panel_settings_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: category.color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: category.color, size: size * 0.55),
    );
  }
}

class CalendarEventBadge extends StatelessWidget {
  final EventCategory category;

  const CalendarEventBadge({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: category.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: category.color.withOpacity(0.3)),
      ),
      child: Text(
        category.displayName,
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: category.color,
        ),
      ),
    );
  }
}

class CalendarEventListCard extends StatelessWidget {
  final CalendarEvent event;
  final VoidCallback? onTap;

  const CalendarEventListCard({super.key, required this.event, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border(left: BorderSide(color: event.category.color, width: 4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CalendarEventIcon(category: event.category, size: 44),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    if (event.isMultiDay())
                      Text(
                        'Multi-day event',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      )
                    else
                      Text(
                        '${event.startDate.day}/${event.startDate.month}/${event.startDate.year}',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    if (event.location != null) ...[
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 12, color: AppColors.textSecondary),
                          const SizedBox(width: 2),
                          Text(
                            event.location!,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              CalendarEventBadge(category: event.category),
            ],
          ),
        ),
      ),
    );
  }
}
