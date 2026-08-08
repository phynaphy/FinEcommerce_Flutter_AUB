import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/app/routes/approutes.dart';
import 'package:flutter_application_ecommerce/color/Premium_fintech_color.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _zoomController;
  late Animation<double> _zoomAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Controller set for a slow, smooth 2.8-second duration
    _zoomController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );

    // 2. Define single zoom-in range (from 0.5 to 1.0)
    _zoomAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _zoomController,
        curve: Curves.easeOutCubic,
      ),
    );

    // 3. Play the zoom animation ONLY ONCE after the first frame renders
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _zoomController.forward();
    });

    // 4. Timer to navigate to the next screen after 4.5 seconds
    Timer(const Duration(milliseconds: 4500), () {
      if (mounted) {
        Get.offNamed(AppRoutes.splash2);
      }
    });
  }

  @override
  void dispose() {
    _zoomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PremiumFintechColor.primaryColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),

                // Static White Circle Container
                Container(
                  width: 110,
                  height: 110,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.3),
                        blurRadius: 35,
                        spreadRadius: 6,
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  // Only the logo image inside zooms in slowly
                  child: ScaleTransition(
                    scale: _zoomAnimation,
                    child: Image.network(
                      "https://cdn-icons-png.flaticon.com/512/10149/10149443.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Main Title
                Text(
                  "FINECOMMERCE",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: 8),

                // Subtitle
                Text(
                  "INSTITUTIONAL TRUST, MODERN FLUIDITY",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: PremiumFintechColor.neutral.withOpacity(0.9),
                    letterSpacing: 1.2,
                  ),
                ),

                const Spacer(),

                // Loading Indicator
                const SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    backgroundColor: Colors.white24,
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}