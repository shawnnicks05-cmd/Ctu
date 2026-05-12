import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/app_theme.dart';

/// Branding block matching the Smart School Calendar System logo (graphic + text).
/// Used on the sign-in screen when `assets/images/smart_school_calendar_logo.png` is unavailable.
class SmartSchoolBrandLogo extends StatelessWidget {
  const SmartSchoolBrandLogo({super.key, this.maxWidth = 280});

  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    const maroon = AppColors.primary;
    const brightRed = AppColors.accent;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(48),
              border: Border.all(color: brightRed, width: 3),
              boxShadow: [
                BoxShadow(
                  color: brightRed.withOpacity(0.22),
                  blurRadius: 18,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.schedule_rounded, color: maroon, size: 28),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: maroon.withOpacity(0.35)),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 10,
                            width: 52,
                            decoration: BoxDecoration(
                              color: brightRed,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(4),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 3),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          SizedBox(
                            width: 56,
                            height: 32,
                            child: Wrap(
                              spacing: 2,
                              runSpacing: 2,
                              children: List.generate(12, (i) {
                                final highlight = i % 4 == 0 || i > 8;
                                return Container(
                                  width: 12,
                                  height: 8,
                                  color: highlight ? brightRed : maroon,
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(Icons.notifications_none_rounded,
                            color: maroon, size: 30),
                        Positioned(
                          right: -2,
                          top: -2,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                  width: 3,
                                  height: 3,
                                  decoration: BoxDecoration(
                                      color: brightRed,
                                      shape: BoxShape.circle)),
                              const SizedBox(width: 2),
                              Container(
                                  width: 3,
                                  height: 3,
                                  decoration: BoxDecoration(
                                      color: brightRed,
                                      shape: BoxShape.circle)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _node(brightRed),
                    Container(
                      width: 14,
                      height: 2,
                      color: maroon.withOpacity(0.55),
                    ),
                    _node(brightRed),
                    Container(
                      width: 14,
                      height: 2,
                      color: maroon.withOpacity(0.55),
                    ),
                    _node(brightRed),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'SMART SCHOOL',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: maroon,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'CALENDAR SYSTEM',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: brightRed,
              letterSpacing: 2.2,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: Divider(color: maroon.withOpacity(0.45))),
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: brightRed,
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(child: Divider(color: maroon.withOpacity(0.45))),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'PLAN SMART. STAY CONNECTED.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: maroon,
              letterSpacing: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _node(Color c) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(color: c, shape: BoxShape.circle),
    );
  }
}
