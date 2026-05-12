import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../event/event_model.dart';
import '../services/user_preferences_service.dart';
import '../utils/app_theme.dart';

class CalendarEventCardWithRegistration extends StatefulWidget {
  final Event event;
  final VoidCallback? onTap;

  const CalendarEventCardWithRegistration({super.key, required this.event, this.onTap});

  @override
  State<CalendarEventCardWithRegistration> createState() => _CalendarEventCardWithRegistrationState();
}

class _CalendarEventCardWithRegistrationState extends State<CalendarEventCardWithRegistration> {
  final UserPreferencesService _preferencesService = UserPreferencesService();
  bool _isRegistered = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkRegistrationStatus();
  }

  Future<void> _checkRegistrationStatus() async {
    await _preferencesService.initialize();
    final isRegistered = await _preferencesService.isRegistered(widget.event.id);
    if (mounted) {
      setState(() {
        _isRegistered = isRegistered;
      });
    }
  }

  Future<void> _toggleRegistration() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _preferencesService.initialize();
      
      if (_isRegistered) {
        await _preferencesService.unregisterEvent(widget.event.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Unregistered from ${widget.event.title}'),
              backgroundColor: Colors.grey[600],
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else {
        await _preferencesService.registerEvent(widget.event.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Registered for ${widget.event.title}'),
              backgroundColor: AppColors.primary,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }

      if (mounted) {
        setState(() {
          _isRegistered = !_isRegistered;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  IconData get _eventTypeIcon {
    switch (widget.event.type) {
      case EventType.academic:
        return Icons.menu_book_rounded;
      case EventType.examination:
        return Icons.assignment_rounded;
      case EventType.holiday:
        return Icons.star_rounded;
      case EventType.extracurricular:
        return Icons.groups_rounded;
      case EventType.meeting:
        return Icons.people_rounded;
    }
  }

  Color get _eventColor {
    return AppColors.eventColor(widget.event.type);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border(left: BorderSide(color: _eventColor, width: 4)),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _eventColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(_eventTypeIcon, color: _eventColor, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.event.title,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        if (widget.event.isAllDay)
                          Text(
                            'All Day',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          )
                        else if (widget.event.time != null)
                          Text(
                            '${widget.event.time}${widget.event.endTime != null ? ' - ${widget.event.endTime}' : ''}',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: _eventColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _eventColor.withOpacity(0.3)),
                    ),
                    child: Text(
                      widget.event.typeLabel,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: _eventColor,
                      ),
                    ),
                  ),
                ],
              ),
              if (widget.event.location != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        size: 12, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      widget.event.location!,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_isRegistered)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle, size: 14, color: Colors.green[700]),
                          const SizedBox(width: 4),
                          Text(
                            'Registered',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.green[700],
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    const SizedBox(width: 80), // Placeholder for alignment
                  
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : _toggleRegistration,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(
                            _isRegistered ? Icons.event_busy : Icons.event_available,
                            size: 14,
                          ),
                    label: Text(
                      _isRegistered ? 'Unregister' : 'Register',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isRegistered ? Colors.grey[600] : AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      elevation: 0,
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
    );
  }
}
