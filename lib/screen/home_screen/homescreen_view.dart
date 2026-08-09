import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/screen/home_screen/categories_section.dart';
import 'package:flutter_application_ecommerce/screen/home_screen/home_app_bar.dart';
import 'package:flutter_application_ecommerce/screen/home_screen/home_banner.dart';
import 'package:flutter_application_ecommerce/screen/home_screen/home_button_nav.dart';
import 'package:flutter_application_ecommerce/screen/home_screen/recommendedProducts.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreenView extends StatefulWidget {
  const HomeScreenView({super.key});

  @override
  State<HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<HomeScreenView> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: const HomeAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            HomeBanners(),
            SizedBox(height: 24),
            CategoriesSection(),
            SizedBox(height: 24),
            RecommendedProducts(),
            SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: HomeBottomNav(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}