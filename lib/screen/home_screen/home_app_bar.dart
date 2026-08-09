import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      title: Text(
        'FinEcommerce',
        style: GoogleFonts.spaceGrotesk(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF003D91),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search_rounded, color: Color(0xFF0F172A)),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.shopping_bag_outlined, color: Color(0xFF0F172A)),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}