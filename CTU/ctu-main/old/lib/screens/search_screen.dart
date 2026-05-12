import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../data/events_data.dart';
import '../models/event_model.dart';
import '../utils/app_theme.dart';
import '../widgets/event_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _query = TextEditingController();
  final List<String> _recent = ['Prelim Examination', 'Holiday'];
  EventType? _category;

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  List<Event> get _filtered {
    final q = _query.text.trim().toLowerCase();
    return sampleEvents.where((e) {
      if (_category != null && e.type != _category) return false;
      if (q.isEmpty) return true;
      final inTitle = e.title.toLowerCase().contains(q);
      final inLoc = (e.location ?? '').toLowerCase().contains(q);
      final inType = e.typeLabel.toLowerCase().contains(q);
      return inTitle || inLoc || inType;
    }).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  void _applyRecent(String text) {
    _query.text = text;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SearchHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Search',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(23),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 14),
                      Icon(Icons.search, color: Colors.grey.shade400, size: 22),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _query,
                          onChanged: (_) => setState(() {}),
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppColors.textPrimary,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            hintText: 'Search events, exams, holidays...',
                            hintStyle: GoogleFonts.poppins(
                              color: Colors.grey.shade400,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      Icon(Icons.tune_rounded,
                          color: Colors.grey.shade500, size: 22),
                      const SizedBox(width: 14),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filter Categories',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      CategoryFilterChip(
                        label: 'All',
                        selected: _category == null,
                        color: AppColors.primary,
                        onTap: () => setState(() => _category = null),
                      ),
                      CategoryFilterChip(
                        label: 'Academic',
                        selected: _category == EventType.academic,
                        color: AppColors.academic,
                        onTap: () =>
                            setState(() => _category = EventType.academic),
                      ),
                      CategoryFilterChip(
                        label: 'Examination',
                        selected: _category == EventType.examination,
                        color: AppColors.examination,
                        onTap: () =>
                            setState(() => _category = EventType.examination),
                      ),
                      CategoryFilterChip(
                        label: 'Holiday',
                        selected: _category == EventType.holiday,
                        color: AppColors.holiday,
                        onTap: () =>
                            setState(() => _category = EventType.holiday),
                      ),
                      CategoryFilterChip(
                        label: 'Extracurricular',
                        selected: _category == EventType.extracurricular,
                        color: AppColors.extracurricular,
                        onTap: () => setState(
                            () => _category = EventType.extracurricular),
                      ),
                      CategoryFilterChip(
                        label: 'Meeting',
                        selected: _category == EventType.meeting,
                        color: AppColors.meeting,
                        onTap: () =>
                            setState(() => _category = EventType.meeting),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'Recent Searches',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _recent
                        .map(
                          (t) => ActionChip(
                            label: Text(
                              t,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            backgroundColor: const Color(0xFFEEEEEE),
                            side: BorderSide.none,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            onPressed: () => _applyRecent(t),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'Search Results',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._filtered.map((e) => _SearchResultCard(event: e)),
                  if (_filtered.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: Center(
                        child: Text(
                          'No events match your search.',
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
          ),
        ],
      ),
    );
  }
}

class _SearchHeader extends StatelessWidget {
  const _SearchHeader({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
          child: child,
        ),
      ),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  const _SearchResultCard({required this.event});

  final Event event;

  String get _whenLine {
    final date = DateFormat('MMMM d, yyyy').format(event.date);
    if (event.isAllDay) return '$date • All Day';
    final t = event.time ?? '';
    final end = event.endTime != null ? ' - ${event.endTime}' : '';
    if (t.isEmpty) return date;
    return '$date • $t$end';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EventTypeIcon(type: event.type, size: 48),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _whenLine,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (event.location != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded,
                          size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          event.location!,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: EventTypeBadge(type: event.type),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
