import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class RecommendedProducts extends StatefulWidget {
  const RecommendedProducts({super.key});

  @override
  State<RecommendedProducts> createState() => _RecommendedProductsState();
}

class _RecommendedProductsState extends State<RecommendedProducts> {
  static const String baseUrl = 'http://192.168.56.1:8080';

  static const Color primaryColor = Color(0xFF06499F);
  static const Color backgroundColor = Color(0xFFF7F9FC);
  static const Color textColor = Color(0xFF172033);
  static const Color secondaryTextColor = Color(0xFF7B8496);
  static const Color discountColor = Color(0xFFE53935);
  static const Color borderColor = Color(0xFFEDF0F5);

  static const double discountRate = 0.20;

  final ScrollController _scrollController = ScrollController();

  bool isLoading = true;
  String? errorMessage;

  List<RecommendedCategory> categories = [];

  // Static demo prices. These are not fetched from the backend.
  // Prices repeat when the API returns more than six categories.
  static const List<double> _originalPrices = [
    49.99,
    79.99,
    39.99,
    99.99,
    59.99,
    129.99,
  ];

  @override
  void initState() {
    super.initState();
    fetchRecommendedCategories();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  double _getOriginalPrice(int index) {
    return _originalPrices[index % _originalPrices.length];
  }

  double _getDiscountedPrice(int index) {
    return _getOriginalPrice(index) * (1 - discountRate);
  }

  Future<void> fetchRecommendedCategories() async {
    if (mounted) {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
    }

    try {
      final uri = Uri.parse(
        '$baseUrl/api/v1/mobile/categories/recommended-with-products',
      );

      final response = await http
          .get(
            uri,
            headers: const {
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception(
          'Unable to load recommendations (${response.statusCode}).',
        );
      }

      final dynamic decoded = jsonDecode(response.body);

      final List<dynamic> rawCategories;

      if (decoded is List) {
        rawCategories = decoded;
      } else if (decoded is Map<String, dynamic>) {
        final dynamic data = decoded['data'] ?? decoded['categories'];

        if (data is List) {
          rawCategories = data;
        } else {
          throw Exception('Unexpected API response format.');
        }
      } else {
        throw Exception('Unexpected API response format.');
      }

      final List<RecommendedCategory> loadedCategories = rawCategories
          .whereType<Map<String, dynamic>>()
          .map(RecommendedCategory.fromJson)
          .where((category) => category.isRecommended)
          .toList();

      if (!mounted) return;

      setState(() {
        categories = loadedCategories;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = 'Unable to load recommendations. Please try again.';
        isLoading = false;
      });

      debugPrint('Recommended categories error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.only(top: 24, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(),
          const SizedBox(height: 20),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 38,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recommended For You',
                  style: GoogleFonts.poppins(
                    color: textColor,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Discover something you will love',
                  style: GoogleFonts.poppins(
                    color: secondaryTextColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          if (!isLoading && categories.isNotEmpty)
            _buildArrowButton(
              icon: Icons.arrow_forward_ios_rounded,
              onTap: () {
                _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeInOut,
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildArrowButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: borderColor),
          ),
          child: Icon(
            icon,
            color: primaryColor,
            size: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const SizedBox(
        height: 280,
        child: Center(
          child: CircularProgressIndicator(
            color: primaryColor,
            strokeWidth: 2.5,
          ),
        ),
      );
    }

    if (errorMessage != null) {
      return _buildMessage(
        icon: Icons.cloud_off_outlined,
        message: errorMessage!,
        buttonText: 'Try Again',
        onPressed: fetchRecommendedCategories,
      );
    }

    if (categories.isEmpty) {
      return _buildMessage(
        icon: Icons.shopping_bag_outlined,
        message: 'No recommended categories available yet.',
        buttonText: 'Refresh',
        onPressed: fetchRecommendedCategories,
      );
    }

    return SizedBox(
      height: 310,
      child: ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 15),
        itemBuilder: (context, index) {
          return _buildCategoryCard(categories[index], index);
        },
      ),
    );
  }

  Widget _buildMessage({
    required IconData icon,
    required String message,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 230,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 42, color: secondaryTextColor),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: secondaryTextColor,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 14),
            OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: primaryColor,
                side: const BorderSide(color: primaryColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    RecommendedCategory category,
    int index,
  ) {
    final double originalPrice = _getOriginalPrice(index);
    final double discountedPrice = _getDiscountedPrice(index);

    return Container(
      width: 205,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF172033).withValues(alpha: 0.045),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category image with a discount badge.
          SizedBox(
            height: 155,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _buildCategoryImage(category.imageUrl),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: discountColor,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: discountColor.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      '20% OFF',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 12,
                  top: 12,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.local_offer_outlined,
                      color: primaryColor,
                      size: 17,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Category name, product count and demo price.
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(13, 12, 13, 11),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(
                        Icons.inventory_2_outlined,
                        size: 12,
                        color: secondaryTextColor,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          '${category.totalProducts} products',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            color: secondaryTextColor,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\$${originalPrice.toStringAsFixed(2)}',
                              style: GoogleFonts.poppins(
                                color: secondaryTextColor,
                                fontSize: 10,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: secondaryTextColor,
                              ),
                            ),
                            const SizedBox(height: 1),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '\$${discountedPrice.toStringAsFixed(2)}',
                                style: GoogleFonts.poppins(
                                  color: primaryColor,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 19,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.trim().isEmpty) {
      return _buildImagePlaceholder();
    }

    final String resolvedUrl = imageUrl.startsWith('http')
        ? imageUrl
        : '$baseUrl${imageUrl.startsWith('/') ? '' : '/'}$imageUrl';

    return Image.network(
      resolvedUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _buildImagePlaceholder(),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;

        return Container(
          color: const Color(0xFFF0F4FA),
          child: const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: primaryColor,
                strokeWidth: 2,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: const Color(0xFFF0F4FA),
      child: const Center(
        child: Icon(
          Icons.shopping_bag_outlined,
          color: Color(0xFF9BAAC0),
          size: 48,
        ),
      ),
    );
  }
}

class RecommendedCategory {
  final int id;
  final String name;
  final String? imageUrl;
  final int totalProducts;
  final bool isRecommended;

  const RecommendedCategory({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.totalProducts,
    required this.isRecommended,
  });

  factory RecommendedCategory.fromJson(Map<String, dynamic> json) {
    return RecommendedCategory(
      id: int.tryParse('${json['id'] ?? 0}') ?? 0,
      name: (json['name'] ?? 'Unnamed Category').toString(),
      imageUrl: json['imageUrl']?.toString(),
      totalProducts:
          int.tryParse('${json['totalProducts'] ?? 0}') ?? 0,
      isRecommended: json['isRecommended'] == true,
    );
  }
}