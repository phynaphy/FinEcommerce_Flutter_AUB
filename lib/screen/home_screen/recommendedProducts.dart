import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecommendedProducts extends StatelessWidget {
  const RecommendedProducts({super.key});

  static const List<Map<String, String>> products = [
    {
      'title': 'Luminous Face Ser...',
      'category': 'SKINCARE',
      'price': '\$48.00',
      'image': 'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=400',
    },
    {
      'title': 'M8 Custom Mechan...',
      'category': 'TECH ACCESSORIES',
      'price': '\$185.00',
      'image': 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=400',
    },
    {
      'title': 'Summer Gold Edition',
      'category': 'ACCESSORIES',
      'price': '\$210.00',
      'image': 'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=400',
    },
    {
      'title': 'Barista Express Espresso',
      'category': 'HOME APPLIANCES',
      'price': '\$699.00',
      'image': 'https://images.unsplash.com/photo-1570968915860-54d5c301fa9f?w=400',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recommended For You',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0F172A),
              ),
            ),
            Row(
              children: [
                _buildArrowButton(Icons.chevron_left_rounded),
                const SizedBox(width: 6),
                _buildArrowButton(Icons.chevron_right_rounded),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.72,
            crossAxisSpacing: 12,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            final item = products[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.network(
                      item['image']!,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['category']!,
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['title']!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item['price']!,
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF003D91),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildArrowButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Icon(icon, size: 18, color: const Color(0xFF64748B)),
    );
  }
}