import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/color/Premium_fintech_color.dart';

class SecondSplash extends StatefulWidget {
   SecondSplash({super.key});

  @override
  State<SecondSplash> createState() => _SecondSplashState();
}

class _SecondSplashState extends State<SecondSplash>
    with TickerProviderStateMixin {
  // 1. Controller for Floating Banner
  late AnimationController _floatingController;
  late Animation<Offset> _floatingAnimation;

  // 2. Controller for Dot Indicators (1 -> 2 -> 3 loop)
  late AnimationController _dotsController;
  int _activeDotIndex = 1; // Starts at second dot

  @override
  void initState() {
    super.initState();

    // Setup Floating Animation (2-second cycle, smooth up & down)
    _floatingController = AnimationController(
      duration:  Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _floatingAnimation = Tween<Offset>(
      begin: Offset.zero,
      end:  Offset(0, -0.06), // Moves up by ~12px
    ).animate(
      CurvedAnimation(
        parent: _floatingController,
        curve: Curves.easeInOut,
      ),
    );

    // Setup Dots Cycling Animation (switches every 1.5 seconds)
    _dotsController = AnimationController(
      duration:  Duration(milliseconds: 1500),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _activeDotIndex = (_activeDotIndex + 1) % 3; // Cycle 0 -> 1 -> 2
          });
          _dotsController.forward(from: 0);
        }
      });

    _dotsController.forward();
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  // Helper widget to build animated dots dynamically
  Widget _buildDot(int index) {
    bool isActive = _activeDotIndex == index;
    return AnimatedContainer(
      duration:  Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      margin:  EdgeInsets.symmetric(horizontal: 3),
      width: isActive ? 20 : 6,
      height: 6,
      decoration: BoxDecoration(
        color: isActive
            ? PremiumFintechColor.primaryColor
            :  Color(0xFF94A3B8),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox( height: 25,),
          // 1. Tech / Matrix Background Image
          Positioned.fill(
            child: Image.network(
              'https://i.pinimg.com/736x/df/f2/e8/dff2e82270f460099987dc98c8fb0b7d.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // Dark overlay gradient to ensure readability
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ),

          // 2. Main Content Layout
          SafeArea(
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                   Spacer(),

                  // Top Illustration Card with Floating Animation
                  SlideTransition(
                    position: _floatingAnimation,
                    child: Container(
                      height: 190,
                      width: 260,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 20,
                            offset:  Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          'https://i.pinimg.com/736x/be/43/b5/be43b52c8e21a7f83088d65e3218f81a.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                   SizedBox(height: 30),

                  // Bottom Light Content Card
                  Container(
                    width: double.infinity,
                    padding:  EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 28,
                    ),
                    decoration: BoxDecoration(
                      color:  Color(0xFFF8FAFC).withOpacity(0.95),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.6),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 25,
                          offset:  Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Animated Pagination Indicators (Dots 0, 1, 2)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            3,
                            (index) => _buildDot(index),
                          ),
                        ),

                         SizedBox(height: 20),

                        // Title
                         Text(
                          "Experience Premium\nShopping",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                            height: 1.25,
                            letterSpacing: -0.3,
                          ),
                        ),

                         SizedBox(height: 12),

                        // Description
                         Text(
                          "Access the world's most elite brands with secure banking-grade payments.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF64748B),
                            height: 1.4,
                          ),
                        ),

                         SizedBox(height: 28),

                        // Next Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: PremiumFintechColor.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:  [
                                Text(
                                  "Next",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),

                         SizedBox(height: 16),

                        // Skip Action
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            "Skip",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: PremiumFintechColor.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                   Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}