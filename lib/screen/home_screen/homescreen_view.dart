// import 'package:flutter/material.dart';
// import 'package:flutter_application_ecommerce/screen/category/category_view.dart';

// import 'package:flutter_application_ecommerce/screen/home_screen/categories_section.dart';
// import 'package:flutter_application_ecommerce/screen/home_screen/home_app_bar.dart';
// import 'package:flutter_application_ecommerce/screen/home_screen/home_banner.dart';
// import 'package:flutter_application_ecommerce/screen/home_screen/recommendedProducts.dart';

// import 'package:flutter_application_ecommerce/screen/button_navigation/curved_navigation_bar.dart';

// // Profile Screen
// import 'package:flutter_application_ecommerce/screen/profile_screen/profile_screen_view.dart';

// class HomeScreenView extends StatefulWidget {
//   final String email;

//   const HomeScreenView({
//     super.key,
//     required this.email,
//   });

//   @override
//   State<HomeScreenView> createState() => _HomeScreenViewState();
// }

// class _HomeScreenViewState extends State<HomeScreenView> {
//   int _selectedIndex = 0;
//   late final PageController _pageController;

//   // =========================
//   // COLORS
//   // =========================

//   static const Color backgroundColor = Color(0xFFF5F7FA);
//   static const Color navBarColor = Colors.white;
//   static const Color selectedNavColor = Color(0xFF0F4C81);
//   static const Color unselectedNavColor = Color(0xFF64748B);

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController(initialPage: _selectedIndex);
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   // =========================
//   // NAVIGATION ITEMS
//   // =========================

//   List<Widget> get _navItems => [
//         Icon(
//           Icons.home_rounded,
//           size: 28,
//           color: _selectedIndex == 0 ? Colors.white : unselectedNavColor,
//         ),
//         Icon(
//           Icons.grid_view_rounded,
//           size: 28,
//           color: _selectedIndex == 1 ? Colors.white : unselectedNavColor,
//         ),
//         Icon(
//           Icons.shopping_cart_rounded,
//           size: 28,
//           color: _selectedIndex == 2 ? Colors.white : unselectedNavColor,
//         ),
//         Icon(
//           Icons.favorite_rounded,
//           size: 28,
//           color: _selectedIndex == 3 ? Colors.white : unselectedNavColor,
//         ),
//         Icon(
//           Icons.person_rounded,
//           size: 28,
//           color: _selectedIndex == 4 ? Colors.white : unselectedNavColor,
//         ),
//       ];

//   // =========================
//   // SCREENS LIST
//   // =========================

//   List<Widget> get _screens => [
//         _buildHomeContent(),
//         // const Center(child: Text('Categories Screen')), // Placeholder
//         CategoryView(),
//         const Center(child: Text('Cart Screen')), // Placeholder
//         const Center(child: Text('Favorites Screen')), // Placeholder
//         ProfileScreenView(email: widget.email),
//       ];

//   // =========================
//   // HOME CONTENT BUILDER
//   // =========================

//   Widget _buildHomeContent() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 16.0,
//         vertical: 12.0,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: const [
//           HomeBanners(),
//           SizedBox(height: 24),
//           CategoriesSection(),
//           SizedBox(height: 24),
//           RecommendedProducts(),
//           SizedBox(height: 20),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,

//       appBar: _selectedIndex == 0 ? const HomeAppBar() : null,

//       // =========================
//       // PERSISTENT TAB BODY
//       // =========================

//       body: PageView(
//         controller: _pageController,
//         physics: const NeverScrollableScrollPhysics(), // Disable swipe gestures if you only want tap navigation
//         onPageChanged: (index) {
//           setState(() {
//             _selectedIndex = index;
//           });
//         },
//         children: _screens,
//       ),

//       // =========================
//       // CURVED BOTTOM NAVIGATION
//       // =========================

//       bottomNavigationBar: CurvedNavigationBar(
//         items: _navItems,
//         index: _selectedIndex,
//         color: navBarColor,
//         buttonBackgroundColor: selectedNavColor,
//         backgroundColor: backgroundColor,
//         height: 75,
//         animationCurve: Curves.easeOut,
//         animationDuration: const Duration(
//           milliseconds: 600,
//         ),
//         onTap: (index) {
//           setState(() {
//             _selectedIndex = index;
//           });

//           // Smooth animated transition to the selected screen
//           _pageController.animateToPage(
//             index,
//             duration: const Duration(milliseconds: 300),
//             curve: Curves.easeInOut,
//           );
//         },
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:flutter_application_ecommerce/app/routes/approutes.dart';
// import 'package:flutter_application_ecommerce/screen/add-to-cart/cart_screen.dart';
// import 'package:flutter_application_ecommerce/screen/category/categoryscreen.dart';
// import 'package:get/get.dart';

// // Screen Imports
// import 'package:flutter_application_ecommerce/screen/home_screen/categories_section.dart';
// import 'package:flutter_application_ecommerce/screen/home_screen/home_app_bar.dart';
// import 'package:flutter_application_ecommerce/screen/home_screen/home_banner.dart';
// import 'package:flutter_application_ecommerce/screen/home_screen/recommendedProducts.dart';
// import 'package:flutter_application_ecommerce/screen/button_navigation/curved_navigation_bar.dart';
// import 'package:flutter_application_ecommerce/screen/profile_screen/profile_screen_view.dart';

// class HomeScreenView extends StatefulWidget {
//   final String email;

//   const HomeScreenView({
//     super.key,
//     required this.email,
//   });

//   @override
//   State<HomeScreenView> createState() => _HomeScreenViewState();
// }

// class _HomeScreenViewState extends State<HomeScreenView> {
//   int _selectedIndex = 0;

//   late final PageController _pageController;

//   // Create screens only once
//   late final List<Widget> _screens;

//   // =========================
//   // COLORS
//   // =========================

//   static const Color backgroundColor = Color(0xFFF5F7FA);
//   static const Color navBarColor = Colors.white;
//   static const Color selectedNavColor = Color(0xFF0F4C81);
//   static const Color unselectedNavColor = Color(0xFF64748B);

//   @override
//   void initState() {
//     super.initState();

//     // Page controller
//     _pageController = PageController(
//       initialPage: _selectedIndex,
//     );

//     // Create screens only once
//     _screens = [
//       _buildHomeContent(),

//       CategoriesScreen(),

//       const CartScreen(),

//       const Center(
//         child: Text(
//           'Favorites Screen',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),

//       ProfileScreenView(
//         email: widget.email,
//       ),
//     ];
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   // =========================
//   // NAVIGATION ITEMS
//   // =========================

//   List<Widget> get _navItems {
//     return [
//       Icon(
//         Icons.home_rounded,
//         size: 28,
//         color: _selectedIndex == 0
//             ? Colors.white
//             : unselectedNavColor,
//       ),

//       Icon(
//         Icons.grid_view_rounded,
//         size: 28,
//         color: _selectedIndex == 1
//             ? Colors.white
//             : unselectedNavColor,
//       ),

//       Icon(
//         Icons.shopping_cart_rounded,
//         size: 28,
//         color: _selectedIndex == 2
//             ? Colors.white
//             : unselectedNavColor,
//       ),

//       Icon(
//         Icons.favorite_rounded,
//         size: 28,
//         color: _selectedIndex == 3
//             ? Colors.white
//             : unselectedNavColor,
//       ),

//       Icon(
//         Icons.person_rounded,
//         size: 28,
//         color: _selectedIndex == 4
//             ? Colors.white
//             : unselectedNavColor,
//       ),
//     ];
//   }

//   // =========================
//   // HOME CONTENT
//   // =========================

//   Widget _buildHomeContent() {
//     return RepaintBoundary(
//       child: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),

//         padding: const EdgeInsets.symmetric(
//           horizontal: 16.0,
//           vertical: 12.0,
//         ),

//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // =========================
//             // BANNER
//             // =========================

//             const HomeBanners(),

//             const SizedBox(height: 24),

//             // =========================
//             // CATEGORIES
//             // =========================

//             CategoriesSection(
//               onElectronicsTap: () {
//                 Get.toNamed(
//                   AppRoutes.eletronic,
//                 );
//               },
//             ),

//             const SizedBox(height: 24),

//             // =========================
//             // RECOMMENDED PRODUCTS
//             // =========================

//             const RecommendedProducts(),

//             const SizedBox(height: 30),
//           ],
//         ),
//       ),
//     );
//   }

//   // =========================
//   // CHANGE PAGE
//   // =========================

//   void _changePage(int index) {
//     if (_selectedIndex == index) {
//       return;
//     }

//     setState(() {
//       _selectedIndex = index;
//     });

//     _pageController.animateToPage(
//       index,
//       duration: const Duration(
//         milliseconds: 250,
//       ),
//       curve: Curves.easeOutCubic,
//     );
//   }

//   // =========================
//   // BUILD
//   // =========================

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,

//       // =========================
//       // APP BAR
//       // =========================

//       appBar: _selectedIndex == 0
//           ? const HomeAppBar()
//           : null,

//       // =========================
//       // BODY
//       // =========================

//       body: PageView(
//         controller: _pageController,

//         // Disable horizontal swipe
//         // because navigation is controlled
//         // by bottom navigation.
//         physics: const NeverScrollableScrollPhysics(),

//         onPageChanged: (index) {
//           if (_selectedIndex != index) {
//             setState(() {
//               _selectedIndex = index;
//             });
//           }
//         },

//         children: _screens,
//       ),

//       // =========================
//       // BOTTOM NAVIGATION
//       // =========================

//       bottomNavigationBar: CurvedNavigationBar(
//         items: _navItems,

//         index: _selectedIndex,

//         color: navBarColor,

//         buttonBackgroundColor: selectedNavColor,

//         backgroundColor: backgroundColor,

//         height: 75,

//         animationCurve: Curves.easeOutCubic,

//         animationDuration: const Duration(
//           milliseconds: 350,
//         ),

//         onTap: _changePage,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/app/routes/approutes.dart';
import 'package:flutter_application_ecommerce/screen/Favorites/favorites_screen.dart';
import 'package:flutter_application_ecommerce/screen/add-to-cart/cart_screen.dart';
import 'package:flutter_application_ecommerce/screen/category/categoryscreen.dart';
import 'package:get/get.dart';

// Screen Imports
import 'package:flutter_application_ecommerce/screen/home_screen/categories_section.dart';
import 'package:flutter_application_ecommerce/screen/home_screen/home_app_bar.dart';
import 'package:flutter_application_ecommerce/screen/home_screen/home_banner.dart';
import 'package:flutter_application_ecommerce/screen/home_screen/recommendedProducts.dart';
import 'package:flutter_application_ecommerce/screen/button_navigation/curved_navigation_bar.dart';
import 'package:flutter_application_ecommerce/screen/profile_screen/profile_screen_view.dart';

class HomeScreenView extends StatefulWidget {
  final String email;

  const HomeScreenView({
    super.key,
    required this.email,
  });

  @override
  State<HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<HomeScreenView> {
  int _selectedIndex = 0;

  late final PageController _pageController;

  // Create screens only once.
  late final List<Widget> _screens;

  // Colors
  static const Color backgroundColor = Color(0xFFF5F7FA);
  static const Color navBarColor = Colors.white;
  static const Color selectedNavColor = Color(0xFF0F4C81);
  static const Color unselectedNavColor = Color(0xFF64748B);

  @override
  void initState() {
    super.initState();

    _pageController = PageController(
      initialPage: _selectedIndex,
    );

    _screens = [
      _buildHomeContent(),
      CategoriesScreen(),
      const CartScreen(),
      // const Center(
      //   child: Text(
      //     'Favorites Screen',
      //     style: TextStyle(
      //       fontSize: 18,
      //       fontWeight: FontWeight.w600,
      //     ),
      //   ),
      // ),
      const FavoritesScreen(),
      ProfileScreenView(
        email: widget.email,
      ),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Bottom navigation items
  List<Widget> get _navItems {
    return [
      Icon(
        Icons.home_rounded,
        size: 28,
        color: _selectedIndex == 0
            ? Colors.white
            : unselectedNavColor,
      ),
      Icon(
        Icons.grid_view_rounded,
        size: 28,
        color: _selectedIndex == 1
            ? Colors.white
            : unselectedNavColor,
      ),
      Icon(
        Icons.shopping_cart_rounded,
        size: 28,
        color: _selectedIndex == 2
            ? Colors.white
            : unselectedNavColor,
      ),
      Icon(
        Icons.favorite_rounded,
        size: 28,
        color: _selectedIndex == 3
            ? Colors.white
            : unselectedNavColor,
      ),
      Icon(
        Icons.person_rounded,
        size: 28,
        color: _selectedIndex == 4
            ? Colors.white
            : unselectedNavColor,
      ),
    ];
  }

  // Home content
  Widget _buildHomeContent() {
    return RepaintBoundary(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner
            const HomeBanners(),

            const SizedBox(height: 24),

            // Dynamic Browse Categories
            CategoriesSection(
              onElectronicsTap: () {
                Get.toNamed(
                  AppRoutes.eletronic,
                );
              },
            ),

            const SizedBox(height: 24),

            // Recommended products
            const RecommendedProducts(),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Change page
  void _changePage(int index) {
    if (_selectedIndex == index) {
      return;
    }

    setState(() {
      _selectedIndex = index;
    });

    _pageController.animateToPage(
      index,
      duration: const Duration(
        milliseconds: 250,
      ),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      // App bar appears only on Home.
      appBar: _selectedIndex == 0
          ? const HomeAppBar()
          : null,

      // Main pages
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          if (_selectedIndex != index) {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
        children: _screens,
      ),

      // Bottom navigation
      bottomNavigationBar: CurvedNavigationBar(
        items: _navItems,
        index: _selectedIndex,
        color: navBarColor,
        buttonBackgroundColor: selectedNavColor,
        backgroundColor: backgroundColor,
        height: 75,
        animationCurve: Curves.easeOutCubic,
        animationDuration: const Duration(
          milliseconds: 350,
        ),
        onTap: _changePage,
      ),
    );
  }
}
