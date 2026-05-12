import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/calendar_event.dart';
import '../services/user_preferences_service.dart';
import '../services/auth_provider.dart';

class EventDetailsDialog extends StatefulWidget {
  final CalendarEvent event;

  const EventDetailsDialog({
    super.key,
    required this.event,
  });

  @override
  State<EventDetailsDialog> createState() => _EventDetailsDialogState();
}

class _EventDetailsDialogState extends State<EventDetailsDialog> {
  bool _isFavorite = false;
  bool _isLoading = false;
  final UserPreferencesService _prefsService = UserPreferencesService();

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    final isFavorite = await _prefsService.isFavorite(widget.event.id);
    if (mounted) {
      setState(() {
        _isFavorite = isFavorite;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (_isFavorite) {
        await _prefsService.removeFromFavorites(widget.event.id);
      } else {
        await _prefsService.addToFavorites(widget.event);
      }
      
      if (mounted) {
        setState(() {
          _isFavorite = !_isFavorite;
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isFavorite ? 'Added to favorites' : 'Removed from favorites',
            ),
            backgroundColor: _isFavorite ? Colors.green : Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error updating favorites'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with title and favorite button
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.event.title,
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: widget.event.category.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: widget.event.category.color.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            widget.event.category.displayName,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: widget.event.category.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      if (!authProvider.isAuthenticated) {
                        return const SizedBox.shrink();
                      }
                      
                      return IconButton(
                        onPressed: _isLoading ? null : _toggleFavorite,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Icon(
                                _isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: _isFavorite ? Colors.red : Colors.grey[600],
                                size: 28,
                              ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Date and Time
              _buildInfoSection(
                '📅 Date & Time',
                _formatDateTime(widget.event.startDate),
                Icons.calendar_today,
              ),

              if (widget.event.endDate != null) ...[
                const SizedBox(height: 12),
                _buildInfoSection(
                  '🏁 End Date',
                  _formatDateTime(widget.event.endDate!),
                  Icons.event_available,
                ),
              ],

              // Location
              if (widget.event.location != null) ...[
                const SizedBox(height: 12),
                _buildInfoSection(
                  '📍 Location',
                  widget.event.location!,
                  Icons.location_on,
                ),
              ],

              // Importance
              const SizedBox(height: 12),
              _buildInfoSection(
                '⭐ Importance',
                widget.event.importance.displayName,
                Icons.priority_high,
                textColor: _getImportanceColor(widget.event.importance),
              ),

              // Description
              if (widget.event.description.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text(
                  'Description',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Text(
                    widget.event.description,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                ),
              ],

              // Tags
              if (widget.event.tags.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text(
                  'Tags',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.event.tags.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.blue.withOpacity(0.3)),
                      ),
                      child: Text(
                        '#$tag',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],

              // Campus Information
              if (!widget.event.isForAllCampuses) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.orange[700], size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'This event is only for: ${widget.event.specificCampuses.join(', ')}',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.orange[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),
              // Close Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Close',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(String label, String value, IconData icon, {Color? textColor}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textColor ?? Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    
    final weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    
    return '${weekdays[dateTime.weekday - 1]}, ${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
  }

  Color _getImportanceColor(EventImportance importance) {
    switch (importance) {
      case EventImportance.low:
        return Colors.green;
      case EventImportance.medium:
        return Colors.orange;
      case EventImportance.high:
        return Colors.red;
      case EventImportance.critical:
        return Colors.purple;
    }
  }
}
