import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  static const List<Map<String, dynamic>> categories = [
    {'icon': Icons.devices_rounded, 'label': 'Electronics'},
    {'icon': Icons.checkroom_rounded, 'label': 'Fashion'},
    {'icon': Icons.face_retouching_natural_rounded, 'label': 'Beauty'},
    {'icon': Icons.home_outlined, 'label': 'Home'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Browse Categories',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0F172A),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'See All >',
                style: GoogleFonts.spaceGrotesk(
                  color: const Color(0xFF003D91),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: categories.map((cat) {
            return Column(
              children: [
                Container(
                  height: 64,
                  width: 64,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(cat['icon'], color: const Color(0xFF0F172A), size: 26),
                ),
                const SizedBox(height: 8),
                Text(
                  cat['label'],
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}