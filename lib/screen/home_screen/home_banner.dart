import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeBanners extends StatefulWidget {
  const HomeBanners({super.key});

  @override
  State<HomeBanners> createState() => _HomeBannersState();
}

class _HomeBannersState extends State<HomeBanners> {
  // Set initial page to a high number so user can scroll forward endlessly
  final PageController _pageController = PageController(initialPage: 1000);
  int _activeDotIndex = 0;
  Timer? _bannerTimer;

  // Banner Data
  final List<Map<String, dynamic>> _bannerList = [
    {
      'tagline': 'UPGRADE YOUR TECH TODAY',
      'title': 'Explore Collections',
      'buttonText': 'Explore Categories',
      'colors': [const Color(0xFF003D91), const Color(0xFF0F172A)],
      'icon': Icons.devices_other_rounded,
    },
    {
      'tagline': 'LIMITED TIME DEAL',
      'title': 'Next-Gen Smart Devices',
      'buttonText': 'View Deals',
      'colors': [const Color(0xFF4F46E5), const Color(0xFF1E1B4B)],
      'icon': Icons.bolt_rounded,
    },
    {
      'tagline': 'EXCLUSIVE DISCOUNTS',
      'title': 'Premium Audio Gear',
      'buttonText': 'Shop Audio',
      'colors': [const Color(0xFF0F766E), const Color(0xFF111827)],
      'icon': Icons.headphones_rounded,
    },
  ];

  @override
  void initState() {
    super.initState();
    // 🚀 Always slides forward using nextPage
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Endless Forward PageView
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _activeDotIndex = index % _bannerList.length;
              });
            },
            itemBuilder: (context, index) {
              final banner = _bannerList[index % _bannerList.length];
              return _buildBannerCard(
                tagline: banner['tagline'],
                title: banner['title'],
                buttonText: banner['buttonText'],
                gradientColors: banner['colors'],
                icon: banner['icon'],
                onPressed: () {},
              );
            },
          ),
        ),
        const SizedBox(height: 12),

        // Animated Page Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_bannerList.length, (index) {
            final bool isActive = _activeDotIndex == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 6,
              width: isActive ? 26 : 6,
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFF003D91) : const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(12),
              ),
            );
          }),
        ),
        const SizedBox(height: 20),

        // Secondary Banner
        _AnimatedSecondaryBanner(
          tagline: 'AUDIO MASTERCLASS',
          title: 'Sony Precision Audio',
          actionText: 'Shop Now',
          gradientColors: const [Color(0xFF1E293B), Color(0xFF0F172A)],
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildBannerCard({
    required String tagline,
    required String title,
    required String buttonText,
    required List<Color> gradientColors,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.06),
                ),
              ),
            ),
            Positioned(
              right: 20,
              bottom: 16,
              child: Icon(
                icon,
                size: 90,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(22.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      tagline,
                      style: GoogleFonts.spaceGrotesk(
                        color: Colors.white,
                        fontSize: 10,
                        letterSpacing: 1.1,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton(
                    onPressed: onPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF0F172A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          buttonText,
                          style: GoogleFonts.spaceGrotesk(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.arrow_forward_rounded, size: 14),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedSecondaryBanner extends StatefulWidget {
  final String tagline;
  final String title;
  final String actionText;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  const _AnimatedSecondaryBanner({
    required this.tagline,
    required this.title,
    required this.actionText,
    required this.gradientColors,
    required this.onTap,
  });

  @override
  State<_AnimatedSecondaryBanner> createState() => _AnimatedSecondaryBannerState();
}

class _AnimatedSecondaryBannerState extends State<_AnimatedSecondaryBanner> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: widget.gradientColors,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Positioned(
                  right: -20,
                  bottom: -20,
                  child: Icon(
                    Icons.headphones_rounded,
                    size: 110,
                    color: Colors.white.withOpacity(0.07),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.tagline,
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.white70,
                          fontSize: 10,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.title,
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            widget.actionText,
                            style: GoogleFonts.spaceGrotesk(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_forward_ios_rounded, size: 10, color: Colors.white),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}