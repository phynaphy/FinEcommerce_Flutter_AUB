import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/screen/category/category_controller.dart';
import 'package:flutter_application_ecommerce/screen/category/category_view.dart' hide CategoryController, CategoryItem;
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class CategoriesScreen extends StatelessWidget {
  CategoriesScreen({super.key});

  final CategoryController controller = Get.put(CategoryController());

  final List<FeaturedCategory> featuredCategories = [
    FeaturedCategory(
      title: 'Tech Innovations',
      subtitle: 'Latest electronics & gadgets',
      mainImageUrl:
          'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?auto=format&fit=crop&w=900&q=85',
      icon: Icons.devices_rounded,
      iconColor: const Color(0xFF2563EB),
    ),
    FeaturedCategory(
      title: 'Corporate Style',
      subtitle: 'Premium professional wear',
      mainImageUrl:
          'https://images.unsplash.com/photo-1507679799987-c73779587ccf?auto=format&fit=crop&w=900&q=85',
      icon: Icons.checkroom_rounded,
      iconColor: const Color(0xFF7C3AED),
    ),
    FeaturedCategory(
      title: 'Elite Living',
      subtitle: 'Comfort meets aesthetics',
      mainImageUrl:
          'https://images.unsplash.com/photo-1497366811353-6870744d04b2?auto=format&fit=crop&w=900&q=85',
      icon: Icons.home_rounded,
      iconColor: const Color(0xFF22C55E),
    ),
    FeaturedCategory(
      title: 'Luxury Details',
      subtitle: 'Timeless, elegant & rare',
      mainImageUrl:
          'https://images.unsplash.com/photo-1523170335258-f5ed11844a49?auto=format&fit=crop&w=900&q=85',
      icon: Icons.diamond_rounded,
      iconColor: const Color(0xFFF59E0B),
    ),
  ];

  final List<Color> cardBgColors = const [
    Color(0xFFE0EDFF),
    Color(0xFFF0E7FF),
    Color(0xFFE2F8ED),
    Color(0xFFFFE8E3),
    Color(0xFFE3F3FA),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.fetchCategories,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              SliverToBoxAdapter(child: _buildHeader(context)),
              SliverToBoxAdapter(child: _buildSearchBar()),
              SliverToBoxAdapter(child: _buildFeaturedHeader()),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return _buildFeaturedCard(
                        context, featuredCategories[index]);
                  }, childCount: featuredCategories.length),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: size.width > 600 ? 3 : 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.78,
                  ),
                ),
              ),
              SliverToBoxAdapter(child: _buildAllCategoriesHeader()),
              Obx(() {
                if (controller.isLoading.value) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(30.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  );
                }

                if (controller.errorMessage.value.isNotEmpty) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: Text(
                          controller.errorMessage.value,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  );
                }

                if (controller.categories.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Center(child: Text('No categories available')),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final category = controller.categories[index];
                      final bgColor =
                          cardBgColors[index % cardBgColors.length];
                      return _buildCategoryTile(context, category, bgColor);
                    }, childCount: controller.categories.length),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      child: Row(
        children: [
          _iconButton(
            icon: Icons.menu_rounded,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Menu clicked')),
              );
            },
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'Categories',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Color(0xFF101B3A),
                letterSpacing: -0.7,
              ),
            ),
          ),
          _iconButton(icon: Icons.search_rounded, onTap: () {}),
          const SizedBox(width: 8),
          Stack(
            clipBehavior: Clip.none,
            children: [
              _iconButton(icon: Icons.shopping_cart_outlined, onTap: () {}),
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
                  child: const Center(
                    child: Text(
                      '3',
                      style: TextStyle(
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

  Widget _iconButton({required IconData icon, required VoidCallback onTap}) {
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
          child: Icon(icon, size: 24, color: const Color(0xFF1A2747)),
        ),
      ),
    );
  }

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
              child: const TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search products in categories...',
                  hintStyle:
                      TextStyle(color: Color(0xFF8A94A8), fontSize: 14),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Color(0xFF69758B),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 18),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
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
              icon: const Icon(Icons.tune_rounded, color: Color(0xFF273653)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Featured Collections',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w800,
                color: Color(0xFF101B3A),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: const Text(
              'View All',
              style: TextStyle(
                color: Color(0xFF145CE6),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCard(BuildContext context, FeaturedCategory category) {
    return GestureDetector(
      onTap: () =>
          _openCategory(context, categoryId: 1, categoryName: category.title),
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
              Positioned.fill(
                child: Image.network(
                  category.mainImageUrl,
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
                      stops: const [0.25, 0.50, 1.0],
                    ),
                  ),
                ),
              ),
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
                  child: Icon(category.icon, color: Colors.white, size: 21),
                ),
              ),
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
                      style: const TextStyle(
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
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAllCategoriesHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 30, 20, 14),
      child: Text(
        'All Categories',
        style: TextStyle(
          fontSize: 21,
          fontWeight: FontWeight.w800,
          color: Color(0xFF101B3A),
        ),
      ),
    );
  }

  Widget _buildCategoryTile(
      BuildContext context, CategoryItem category, Color bgColor) {
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
          onTap: () => _openCategory(
            context,
            categoryId: category.id,
            categoryName: category.name,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  width: 62,
                  height: 62,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: category.mainImageUrl != null &&
                            category.mainImageUrl!.isNotEmpty
                        ? Image.network(
                            category.mainImageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.image_outlined,
                                color: Colors.grey,
                              );
                            },
                          )
                        : const Icon(
                            Icons.category_rounded,
                            color: Color(0xFF14213D),
                          ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF14213D),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${category.totalProducts} Products',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF7B8497),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
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

  void _openCategory(
    BuildContext context, {
    required int categoryId,
    required String categoryName,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Cat(
          categoryId: categoryId,
          categoryName: categoryName,
        ),
      ),
    );
  }
}