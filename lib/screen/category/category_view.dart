// import 'package:flutter/material.dart';
// import 'package:flutter_application_ecommerce/app/routes/approutes.dart'; // 👈 Import AppRoutes
// import 'package:get/get.dart';
// import 'category_controller.dart';

// class CategoryView extends GetView<CategoryController> {
//   const CategoryView({super.key});

//   static const Color primaryBlue = Color(0xFF06499F);
//   static const Color backgroundColor = Color(0xFFF8F9FB);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         backgroundColor: backgroundColor,
//         elevation: 0,
//         leading: const Icon(Icons.menu, color: primaryBlue, size: 28),
//         title: const Text(
//           'Categories',
//           style: TextStyle(
//             color: primaryBlue,
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.search, color: Colors.grey, size: 26),
//             onPressed: () {},
//           ),
//           IconButton(
//             icon: const Icon(Icons.shopping_cart_outlined, color: Colors.grey, size: 26),
//             onPressed: () {
//               Get.toNamed(AppRoutes.cart); // 👈 Navigate via route name
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextField(
//               style: const TextStyle(fontSize: 16),
//               decoration: InputDecoration(
//                 hintText: 'Search products in categories...',
//                 hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
//                 prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 24),
//                 filled: true,
//                 fillColor: Colors.white,
//                 contentPadding: const EdgeInsets.symmetric(vertical: 14),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Featured Collections',
//                   style: TextStyle(
//                     fontSize: 19,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 TextButton(
//                   onPressed: () {},
//                   child: const Text(
//                     'View All', 
//                     style: TextStyle(color: primaryBlue, fontSize: 15, fontWeight: FontWeight.w600),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             Obx(() => Column(
//                   children: controller.featuredCollections
//                       .map((item) => _buildFeaturedCard(item))
//                       .toList(),
//                 )),
//             const SizedBox(height: 20),
//             const Text(
//               'All Categories',
//               style: TextStyle(
//                 fontSize: 19,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 12),
//             Obx(() => Column(
//                   children: controller.categories
//                       .map((item) => _buildCategoryTile(item))
//                       .toList(),
//                 )),
//           ],
//         ),
//       ),
//       // bottomNavigationBar: _buildBottomNavigationBar(),
//     );
//   }

//   Widget _buildFeaturedCard(FeaturedCollection item) {
//     return Container(
//       height: 130,
//       width: double.infinity,
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(14),
//         image: DecorationImage(
//           image: NetworkImage(item.imageUrl),
//           fit: BoxFit.cover,
//         ),
//       ),
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(14),
//           gradient: LinearGradient(
//             begin: Alignment.bottomCenter,
//             end: Alignment.topCenter,
//             colors: [
//               Colors.black.withOpacity(0.8),
//               Colors.transparent,
//             ],
//           ),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               item.title,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 2),
//             Text(
//               item.subtitle,
//               style: const TextStyle(
//                 color: Colors.white70,
//                 fontSize: 13,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCategoryTile(CategoryItem item) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: const Color(0xFFE5E7EB)),
//       ),
//       child: ListTile(
//         contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
//         leading: ClipRRect(
//           borderRadius: BorderRadius.circular(10),
//           child: Image.network(
//             item.imageUrl,
//             width: 52,
//             height: 52,
//             fit: BoxFit.cover,
//           ),
//         ),
//         title: Text(
//           item.name,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 16,
//           ),
//         ),
//         subtitle: Text(
//           item.productCount,
//           style: const TextStyle(
//             color: Colors.grey,
//             fontSize: 13,
//           ),
//         ),
//         trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 24),
//         onTap: () {},
//       ),
//     );
//   }

//   // Widget _buildBottomNavigationBar() {
//   //   return Container(
//   //     height: 66,
//   //     decoration: const BoxDecoration(
//   //       color: Colors.white,
//   //       border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
//   //     ),
//   //     child: Row(
//   //       mainAxisAlignment: MainAxisAlignment.spaceAround,
//   //       children: [
//   //         _buildNavItem(Icons.home_outlined, 'Home', false, () {
//   //           Get.offAllNamed(AppRoutes.homescreen);
//   //         }),
//   //         _buildNavItem(Icons.grid_view_rounded, 'Categories', true, () {}),
//   //         _buildNavItem(Icons.shopping_cart_outlined, 'Cart', false, () {
//   //           Get.toNamed(AppRoutes.cart); // 👈 Navigate via route name
//   //         }),
//   //         _buildNavItem(Icons.receipt_long_outlined, 'Orders', false, () {}),
//   //         _buildNavItem(Icons.person_outline, 'Profile', false, () {
//   //           Get.toNamed(AppRoutes.profile);
//   //         }),
//   //       ],
//   //     ),
//   //   );
//   // }

//   // Widget _buildNavItem(IconData icon, String label, bool isSelected, VoidCallback onTap) {
//   //   return InkWell(
//   //     onTap: onTap,
//   //     child: Column(
//   //       mainAxisAlignment: MainAxisAlignment.center,
//   //       children: [
//   //         Container(
//   //           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//   //           decoration: isSelected
//   //               ? BoxDecoration(
//   //                   color: const Color(0xFF60A5FA),
//   //                   borderRadius: BorderRadius.circular(10),
//   //                 )
//   //               : null,
//   //           child: Icon(
//   //             icon,
//   //             color: isSelected ? Colors.white : Colors.grey,
//   //             size: 22,
//   //           ),
//   //         ),
//   //         const SizedBox(height: 3),
//   //         Text(
//   //           label,
//   //           style: TextStyle(
//   //             fontSize: 11,
//   //             color: isSelected ? primaryBlue : Colors.grey,
//   //             fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//   //           ),
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }
// }
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter_application_ecommerce/app/routes/approutes.dart';
// import 'category_controller.dart';

// class CategoryView extends StatelessWidget {
//   const CategoryView({super.key});

//   static const Color primaryBlue = Color(0xFF06499F);
//   static const Color backgroundColor = Color(0xFFF8F9FB);

//   @override
//   Widget build(BuildContext context) {
//     // Put or find CategoryController safely
//     final CategoryController controller = Get.put(CategoryController());

//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         backgroundColor: backgroundColor,
//         elevation: 0,
//         leading: const Icon(Icons.menu, color: primaryBlue, size: 28),
//         title: const Text(
//           'Categories',
//           style: TextStyle(
//             color: primaryBlue,
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.search, color: Colors.grey, size: 26),
//             onPressed: () {},
//           ),
//           IconButton(
//             icon: const Icon(Icons.shopping_cart_outlined, color: Colors.grey, size: 26),
//             onPressed: () {
//               Get.toNamed(AppRoutes.cart);
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextField(
//               style: const TextStyle(fontSize: 16),
//               decoration: InputDecoration(
//                 hintText: 'Search products in categories...',
//                 hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
//                 prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 24),
//                 filled: true,
//                 fillColor: Colors.white,
//                 contentPadding: const EdgeInsets.symmetric(vertical: 14),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Featured Collections',
//                   style: TextStyle(
//                     fontSize: 19,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 TextButton(
//                   onPressed: () {},
//                   child: const Text(
//                     'View All',
//                     style: TextStyle(
//                       color: primaryBlue,
//                       fontSize: 15,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             Obx(() => Column(
//                   children: controller.featuredCollections
//                       .map((item) => _buildFeaturedCard(item))
//                       .toList(),
//                 )),
//             const SizedBox(height: 20),
//             const Text(
//               'All Categories',
//               style: TextStyle(
//                 fontSize: 19,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 12),
//             Obx(() => Column(
//                   children: controller.categories
//                       .map((item) => _buildCategoryTile(item))
//                       .toList(),
//                 )),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFeaturedCard(FeaturedCollection item) {
//     return Container(
//       height: 130,
//       width: double.infinity,
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(14),
//         image: DecorationImage(
//           image: NetworkImage(item.imageUrl),
//           fit: BoxFit.cover,
//         ),
//       ),
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(14),
//           gradient: LinearGradient(
//             begin: Alignment.bottomCenter,
//             end: Alignment.topCenter,
//             colors: [
//               Colors.black.withOpacity(0.8),
//               Colors.transparent,
//             ],
//           ),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               item.title,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 2),
//             Text(
//               item.subtitle,
//               style: const TextStyle(
//                 color: Colors.white70,
//                 fontSize: 13,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCategoryTile(CategoryItem item) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: const Color(0xFFE5E7EB)),
//       ),
//       child: ListTile(
//         contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
//         leading: ClipRRect(
//           borderRadius: BorderRadius.circular(10),
//           child: Image.network(
//             item.imageUrl,
//             width: 52,
//             height: 52,
//             fit: BoxFit.cover,
//           ),
//         ),
//         title: Text(
//           item.name,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 16,
//           ),
//         ),
//         subtitle: Text(
//           item.productCount,
//           style: const TextStyle(
//             color: Colors.grey,
//             fontSize: 13,
//           ),
//         ),
//         trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 24),
//         onTap: () {},
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  int selectedBottomIndex = 1;

  // ============================================================
  // FEATURED CATEGORIES
  // ============================================================

  final List<FeaturedCategory> featuredCategories = [
    FeaturedCategory(
      title: 'Tech Innovations',
      subtitle: 'Latest electronics & gadgets',
      imageUrl:
          'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?auto=format&fit=crop&w=900&q=85',
      icon: Icons.devices_rounded,
      iconColor: const Color(0xFF2563EB),
    ),
    FeaturedCategory(
      title: 'Corporate Style',
      subtitle: 'Premium professional wear',
      imageUrl:
          'https://images.unsplash.com/photo-1507679799987-c73779587ccf?auto=format&fit=crop&w=900&q=85',
      icon: Icons.checkroom_rounded,
      iconColor: const Color(0xFF7C3AED),
    ),
    FeaturedCategory(
      title: 'Elite Living',
      subtitle: 'Comfort meets aesthetics',
      imageUrl:
          'https://images.unsplash.com/photo-1497366811353-6870744d04b2?auto=format&fit=crop&w=900&q=85',
      icon: Icons.home_rounded,
      iconColor: const Color(0xFF22C55E),
    ),
    FeaturedCategory(
      title: 'Luxury Details',
      subtitle: 'Timeless, elegant & rare',
      imageUrl:
          'https://images.unsplash.com/photo-1523170335258-f5ed11844a49?auto=format&fit=crop&w=900&q=85',
      icon: Icons.diamond_rounded,
      iconColor: const Color(0xFFF59E0B),
    ),
  ];

  // ============================================================
  // ALL CATEGORIES
  // ============================================================

  final List<ShopCategory> categories = [
    ShopCategory(
      title: 'Electronics',
      products: '1,240 Products',
      imageUrl:
          'https://images.unsplash.com/photo-1526738549149-8e07eca6c147?auto=format&fit=crop&w=300&q=80',
      backgroundColor: const Color(0xFFE0EDFF),
    ),
    ShopCategory(
      title: 'Fashion & Apparel',
      products: '2,840 Products',
      imageUrl:
          'https://images.unsplash.com/photo-1445205170230-053b83016050?auto=format&fit=crop&w=300&q=80',
      backgroundColor: const Color(0xFFF0E7FF),
    ),
    ShopCategory(
      title: 'Home & Kitchen',
      products: '892 Products',
      imageUrl:
          'https://images.unsplash.com/photo-1556911220-bff31c812dba?auto=format&fit=crop&w=300&q=80',
      backgroundColor: const Color(0xFFE2F8ED),
    ),
    ShopCategory(
      title: 'Beauty & Health',
      products: '1,123 Products',
      imageUrl:
          'https://images.unsplash.com/photo-1596462502278-27bfdc403348?auto=format&fit=crop&w=300&q=80',
      backgroundColor: const Color(0xFFFFE8E3),
    ),
    ShopCategory(
      title: 'Sports & Outdoors',
      products: '654 Products',
      imageUrl:
          'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?auto=format&fit=crop&w=300&q=80',
      backgroundColor: const Color(0xFFE3F3FA),
    ),
  ];

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // Header
                  SliverToBoxAdapter(
                    child: _buildHeader(),
                  ),

                  // Search
                  SliverToBoxAdapter(
                    child: _buildSearchBar(),
                  ),

                  // Featured Header
                  SliverToBoxAdapter(
                    child: _buildFeaturedHeader(),
                  ),

                  // Featured Categories
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return _buildFeaturedCard(
                            featuredCategories[index],
                          );
                        },
                        childCount: featuredCategories.length,
                      ),
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: size.width > 600 ? 3 : 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.78,
                      ),
                    ),
                  ),

                  // All Categories Header
                  SliverToBoxAdapter(
                    child: _buildAllCategoriesHeader(),
                  ),

                  // All Categories
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return _buildCategoryTile(
                            categories[index],
                          );
                        },
                        childCount: categories.length,
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
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      child: Row(
        children: [
          _iconButton(
            icon: Icons.menu_rounded,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Menu clicked',
                    style: GoogleFonts.spaceGrotesk(),
                  ),
                ),
              );
            },
          ),

          const SizedBox(width: 16),

          // Title
          Expanded(
            child: Text(
              'Categories',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF101B3A),
                letterSpacing: -0.7,
              ),
            ),
          ),

          // Search
          _iconButton(
            icon: Icons.search_rounded,
            onTap: () {},
          ),

          const SizedBox(width: 8),

          // Cart
          Stack(
            clipBehavior: Clip.none,
            children: [
              _iconButton(
                icon: Icons.shopping_cart_outlined,
                onTap: () {},
              ),

              Positioned(
                right: -2,
                top: -3,
                child: Container(
                  width: 19,
                  height: 19,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '3',
                      style: GoogleFonts.spaceGrotesk(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ICON BUTTON
  // ============================================================

  Widget _iconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.035),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Icon(
            icon,
            size: 24,
            color: const Color(0xFF1A2747),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SEARCH BAR
  // ============================================================

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 58,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.045),
                    blurRadius: 20,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: TextField(
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 14,
                  color: const Color(0xFF14213D),
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search products in categories...',
                  hintStyle: GoogleFonts.spaceGrotesk(
                    color: const Color(0xFF8A94A8),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: Color(0xFF69758B),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 18,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Filter Button
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.045),
                  blurRadius: 20,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.tune_rounded,
                color: Color(0xFF273653),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FEATURED HEADER
  // ============================================================

  Widget _buildFeaturedHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Featured Collections',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 21,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF101B3A),
              ),
            ),
          ),

          GestureDetector(
            onTap: () {},
            child: Text(
              'View All',
              style: GoogleFonts.spaceGrotesk(
                color: const Color(0xFF145CE6),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FEATURED CARD
  // ============================================================

  Widget _buildFeaturedCard(FeaturedCategory category) {
    return GestureDetector(
      onTap: () {
        _openCategory(category.title);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Image
              Positioned.fill(
                child: Image.network(
                  category.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFFE5EAF2),
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),

              // Dark Gradient
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.10),
                        Colors.black.withOpacity(0.82),
                      ],
                      stops: const [
                        0.25,
                        0.50,
                        1.0,
                      ],
                    ),
                  ),
                ),
              ),

              // Category Icon
              Positioned(
                left: 14,
                top: 14,
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: category.iconColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: category.iconColor.withOpacity(0.35),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: Icon(
                    category.icon,
                    color: Colors.white,
                    size: 21,
                  ),
                ),
              ),

              // Text
              Positioned(
                left: 15,
                right: 12,
                bottom: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.spaceGrotesk(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      category.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.spaceGrotesk(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow
              Positioned(
                right: 12,
                bottom: 13,
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    size: 20,
                    color: category.iconColor,
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
  // ALL CATEGORIES HEADER
  // ============================================================

  Widget _buildAllCategoriesHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 14),
      child: Text(
        'All Categories',
        style: GoogleFonts.spaceGrotesk(
          fontSize: 21,
          fontWeight: FontWeight.w800,
          color: const Color(0xFF101B3A),
        ),
      ),
    );
  }

  // ============================================================
  // CATEGORY TILE
  // ============================================================

  Widget _buildCategoryTile(ShopCategory category) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            _openCategory(category.title);
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                // Image
                Container(
                  width: 62,
                  height: 62,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: category.backgroundColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      category.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.image_outlined,
                          color: Colors.grey,
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(width: 15),

                // Category Information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.title,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF14213D),
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        category.products,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 12,
                          color: const Color(0xFF7B8497),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow Button
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F6FA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.chevron_right_rounded,
                    size: 23,
                    color: Color(0xFF5C667A),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // BOTTOM NAVIGATION ITEM
  // ============================================================

  Widget _bottomNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final bool isSelected = selectedBottomIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedBottomIndex = index;
        });

        _handleBottomNavigation(index);
      },
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: isSelected ? 42 : 38,
              height: isSelected ? 42 : 38,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFE8F0FF)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                isSelected ? activeIcon : icon,
                color: isSelected
                    ? const Color(0xFF145CE6)
                    : const Color(0xFF707A8D),
                size: 25,
              ),
            ),

            const SizedBox(height: 3),

            Text(
              label,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 10.5,
                fontWeight:
                    isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF145CE6)
                    : const Color(0xFF707A8D),
              ),
            ),

            const SizedBox(height: 4),

            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: isSelected ? 28 : 0,
              height: 3,
              decoration: BoxDecoration(
                color: const Color(0xFF145CE6),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

  void _handleBottomNavigation(int index) {
    switch (index) {
      case 0:
        // Navigate to Home
        break;

      case 1:
        // Already Categories
        break;

      case 2:
        // Navigate to Favorites
        break;

      case 3:
        // Navigate to Orders
        break;

      case 4:
        // Navigate to Profile
        break;
    }
  }

  // ============================================================
  // OPEN CATEGORY
  // ============================================================

  void _openCategory(String categoryName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$categoryName selected',
          style: GoogleFonts.spaceGrotesk(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

// ============================================================
// FEATURED CATEGORY MODEL
// ============================================================

class FeaturedCategory {
  final String title;
  final String subtitle;
  final String imageUrl;
  final IconData icon;
  final Color iconColor;

  FeaturedCategory({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.icon,
    required this.iconColor,
  });
}

// ============================================================
// SHOP CATEGORY MODEL
// ============================================================

class ShopCategory {
  final String title;
  final String products;
  final String imageUrl;
  final Color backgroundColor;

  ShopCategory({
    required this.title,
    required this.products,
    required this.imageUrl,
    required this.backgroundColor,
  });
}