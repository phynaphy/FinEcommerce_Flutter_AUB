import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/app/routes/approutes.dart';
import 'package:flutter_application_ecommerce/screen/home_screen/homescreen_view.dart';
import 'package:google_fonts/google_fonts.dart';

class EletronicView extends StatefulWidget {
  const EletronicView({Key? key}) : super(key: key);

  @override
  State<EletronicView> createState() => _ElectronicsScreenState();
}

class _ElectronicsScreenState extends State<EletronicView> {
  int selectedCategoryIndex = 0;

  final List<String> categories = [
    'All',
    'Smartphones',
    'Laptops',
    'Audio',
    'Cameras',
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final int crossAxisCount = width >= 1000
        ? 4
        : width >= 650
            ? 3
            : 2;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),

      // ============================================================
      // APP BAR
      // ============================================================

      appBar: AppBar(
        backgroundColor: const Color(0xFF0F2B5B),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 68,

        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: _appBarIcon(
            icon: Icons.arrow_back_rounded,
     onTap: () {
  Navigator.pushNamedAndRemoveUntil(
    context,
    AppRoutes.homescreen,
    (route) => false,
  );
},
          ),
        ),

        titleSpacing: 12,

        title: Text(
          'Electronics',
          style: GoogleFonts.spaceGrotesk(
            color: Colors.white,
            fontSize: 23,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),

        actions: [
          _appBarIcon(
            icon: Icons.search_rounded,
            onTap: () {},
          ),

          const SizedBox(width: 4),

          Stack(
            clipBehavior: Clip.none,
            children: [
              _appBarIcon(
                icon: Icons.shopping_bag_outlined,
                onTap: () {},
              ),

              Positioned(
                right: 3,
                top: 4,
                child: Container(
                  width: 17,
                  height: 17,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE85D5D),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '3',
                      style: GoogleFonts.spaceGrotesk(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 10),
        ],
      ),

      // ============================================================
      // BODY
      // ============================================================

      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ========================================================
          // HERO
          // ========================================================

          SliverToBoxAdapter(
            child: _buildHeroBanner(),
          ),

          // ========================================================
          // CATEGORY HEADER
          // ========================================================

          SliverToBoxAdapter(
            child: _buildSectionHeader(
              title: 'Explore Electronics',
              subtitle: 'Find the perfect tech for you',
            ),
          ),

          // ========================================================
          // CATEGORY CHIPS
          // ========================================================

          SliverToBoxAdapter(
            child: _buildCategoryBar(),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 22),
          ),

          // ========================================================
          // FILTER / SORT
          // ========================================================

          SliverToBoxAdapter(
            child: _buildFilterAndSortRow(),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 18),
          ),

          // ========================================================
          // PRODUCT HEADER
          // ========================================================

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  Text(
                    'Popular Products',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF101B3A),
                      letterSpacing: -0.4,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '124 Items',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF8A94A8),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 14),
          ),

          // ========================================================
          // PRODUCT GRID
          // ========================================================

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              delegate: SliverChildListDelegate(
                [
                  _buildProductCard(
                    brand: 'TECHPRO',
                    title: 'X-Phone 15 Pro Max',
                    rating: '4.9',
                    reviews: '1.2k',
                    price: '\$999.00',
                    originalPrice: '\$1,139.00',
                    discount: '-15%',
                    imageUrl:
                        'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?q=80&w=400&auto=format&fit=crop',
                  ),

                  _buildProductCard(
                    brand: 'AUDIOPURE',
                    title: 'Zenith ANC Headphones',
                    rating: '4.8',
                    reviews: '850',
                    price: '\$342.00',
                    imageUrl:
                        'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=400&auto=format&fit=crop',
                  ),

                  _buildProductCard(
                    brand: 'LUMINA',
                    title: 'BladeBook 14 Ultra',
                    rating: '4.7',
                    reviews: '430',
                    price: '\$1,299.00',
                    discount: 'SAVE \$200',
                    imageUrl:
                        'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?q=80&w=400&auto=format&fit=crop',
                  ),

                  _buildProductCard(
                    brand: 'OPTIC',
                    title: 'Alpha Z1 Mirrorless',
                    rating: '4.9',
                    reviews: '210',
                    price: '\$2,499.00',
                    imageUrl:
                        'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?q=80&w=400&auto=format&fit=crop',
                  ),

                  _buildProductCard(
                    brand: 'VISION',
                    title: 'UltraView 4K Monitor',
                    rating: '4.8',
                    reviews: '620',
                    price: '\$699.00',
                    originalPrice: '\$799.00',
                    discount: '-12%',
                    imageUrl:
                        'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?q=80&w=400&auto=format&fit=crop',
                  ),

                  _buildProductCard(
                    brand: 'SONIQ',
                    title: 'Studio Pro Speaker',
                    rating: '4.6',
                    reviews: '320',
                    price: '\$249.00',
                    imageUrl:
                        'https://images.unsplash.com/photo-1545454675-3531b543be5d?q=80&w=400&auto=format&fit=crop',
                  ),
                ],
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 14,
                childAspectRatio: width >= 650 ? 0.70 : 0.60,
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 35),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // APP BAR ICON
  // ============================================================

  Widget _appBarIcon({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white.withOpacity(0.10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(
            icon,
            color: Colors.white,
            size: 21,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HERO BANNER
  // ============================================================

  Widget _buildHeroBanner() {
    return Container(
      height: 205,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F2B5B).withOpacity(0.16),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.network(
                'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?q=80&w=1000&auto=format&fit=crop',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFF172F5F),
                  );
                },
              ),
            ),

            // Gradient
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [
                      Colors.transparent,
                      const Color(0xFF061A3A).withOpacity(0.35),
                      const Color(0xFF061A3A).withOpacity(0.92),
                    ],
                  ),
                ),
              ),
            ),

            // Decorative Circle
            Positioned(
              right: -55,
              top: -55,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.10),
                    width: 20,
                  ),
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Small Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2C08D).withOpacity(0.18),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFE2C08D).withOpacity(0.35),
                      ),
                    ),
                    child: Text(
                      'NEW COLLECTION',
                      style: GoogleFonts.spaceGrotesk(
                        color: const Color(0xFFE2C08D),
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),

                  const Spacer(),

                  Text(
                    'Future Tech\nToday.',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white,
                      fontSize: 27,
                      height: 0.98,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1,
                    ),
                  ),

                  const SizedBox(height: 7),

                  Text(
                    'Discover high-performance gadgets\nbuilt for your lifestyle.',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white.withOpacity(0.78),
                      fontSize: 11,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // CTA
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Explore Now',
                      style: GoogleFonts.spaceGrotesk(
                        color: const Color(0xFF0F2B5B),
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
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

  // ============================================================
  // SECTION HEADER
  // ============================================================

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF101B3A),
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF8A94A8),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CATEGORY BAR
  // ============================================================

  Widget _buildCategoryBar() {
    return SizedBox(
      height: 52,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final bool isSelected = selectedCategoryIndex == index;

          return Padding(
            padding: const EdgeInsets.only(right: 9),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedCategoryIndex = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                padding: const EdgeInsets.symmetric(
                  horizontal: 17,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF0F2B5B)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF0F2B5B)
                        : const Color(0xFFE8EBF0),
                  ),
                  boxShadow: [
                    if (isSelected)
                      BoxShadow(
                        color: const Color(0xFF0F2B5B).withOpacity(0.18),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                  ],
                ),
                child: Center(
                  child: Text(
                    categories[index],
                    style: GoogleFonts.spaceGrotesk(
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF5F687A),
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // FILTER & SORT
  // ============================================================

  Widget _buildFilterAndSortRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          Expanded(
            child: _controlButton(
              icon: Icons.tune_rounded,
              label: 'Filter',
              onTap: () {},
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: _controlButton(
              icon: Icons.swap_vert_rounded,
              label: 'Sort: Low to High',
              onTap: () {},
            ),
          ),

          const SizedBox(width: 10),

          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFFE7EAF0),
              ),
            ),
            child: const Icon(
              Icons.grid_view_rounded,
              size: 19,
              color: Color(0xFF45516A),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CONTROL BUTTON
  // ============================================================

  Widget _controlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 45,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFFE7EAF0),
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: const Color(0xFF45516A),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF45516A),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PRODUCT CARD
  // ============================================================

 Widget _buildProductCard({
  required String brand,
  required String title,
  required String rating,
  required String reviews,
  required String price,
  String? originalPrice,
  String? discount,
  required String imageUrl,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(
        color: const Color(0xFFE9ECF1),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==========================================================
          // PRODUCT IMAGE
          // ==========================================================
          SizedBox(
            height: 140,
            width: double.infinity,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    color: const Color(0xFFF6F8FA),
                    padding: const EdgeInsets.all(6),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: const Color(0xFFF0F1F3),
                            child: const Center(
                              child: Icon(
                                Icons.image_not_supported_outlined,
                                size: 28,
                                color: Color(0xFF9AA2B1),
                              ),
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF0F2B5B),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                // DISCOUNT BADGE
                if (discount != null)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F2B5B),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        discount,
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),

                // WISHLIST BUTTON
                Positioned(
                  top: 10,
                  right: 10,
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    elevation: 2,
                    shadowColor: Colors.black.withOpacity(0.12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {},
                      child: const SizedBox(
                        width: 34,
                        height: 34,
                        child: Icon(
                          Icons.favorite_border_rounded,
                          size: 18,
                          color: Color(0xFF263143),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ==========================================================
          // PRODUCT DETAILS
          // ==========================================================
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // BRAND
                Text(
                  brand.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 10,
                    letterSpacing: 1.0,
                    color: const Color(0xFF8A94A8),
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 2),

                // PRODUCT TITLE
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 15,
                    height: 1.2,
                    color: const Color(0xFF101B3A),
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),

                const SizedBox(height: 4),

                // RATING ROW
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 16,
                      color: Color(0xFFE2A632),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      rating,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 12,
                        color: const Color(0xFF334155),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '($reviews)',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 11,
                        color: const Color(0xFF94A3B8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // PRICE ROW
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      price,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 18,
                        color: const Color(0xFF0F2B5B),
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    if (originalPrice != null) ...[
                      const SizedBox(width: 6),
                      Text(
                        originalPrice,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 11,
                          color: const Color(0xFF94A3B8),
                          decoration: TextDecoration.lineThrough,
                          decorationColor: const Color(0xFF94A3B8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
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