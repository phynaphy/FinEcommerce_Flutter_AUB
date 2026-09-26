import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_ecommerce/screen/product_detail/product_detail_screen.dart';

// ============================================================
// BASE API CONFIG & HELPER
// ============================================================

class ApiConfig {
  // Replace 'localhost' with '10.0.2.2' if running on Android Emulator
  // static const String baseUrl = 'http://localhost:8080';
  // static const String baseUrl = 'http://10.0.2.2:8080';
  static const String baseUrl = 'http://192.168.56.1:8080';

  /// Helper to convert relative or missing image paths to valid network URLs
  static String? formatmainImageUrl(String? rawUrl) {
    if (rawUrl == null || rawUrl.trim().isEmpty) return null;
    if (rawUrl.startsWith('http://') || rawUrl.startsWith('https://')) {
      return rawUrl;
    }
    // Ensures leading slash is handled correctly
    final cleanPath = rawUrl.startsWith('/') ? rawUrl : '/$rawUrl';
    return '$baseUrl$cleanPath';
  }
}

// ============================================================
// MODELS & CONTROLLERS (GetX)
// ============================================================

class CategoryItem {
  final int id;
  final String name;
  final String? mainImageUrl;
  final int totalProducts;

  CategoryItem({
    required this.id,
    required this.name,
    this.mainImageUrl,
    required this.totalProducts,
  });

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      mainImageUrl: ApiConfig.formatmainImageUrl(
        json['mainImageUrl'] as String?,
      ),
      totalProducts: json['totalProducts'] as int? ?? 0,
    );
  }
}

class ProductItem {
  final int id;
  final String title;
  final String? brand;
  final double price;
  final double? oldPrice;
  final double? discountPercentage;
  final String? rating;
  final String? reviews;
  final String? mainImageUrl;
  bool isFavorite;

  ProductItem({
    required this.id,
    required this.title,
    this.brand,
    required this.price,
    this.oldPrice,
    this.discountPercentage,
    this.rating,
    this.reviews,
    this.mainImageUrl,
    this.isFavorite = false,
  });

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
      id: json['id'] as int,
      title: json['title'] as String? ?? json['name'] as String? ?? 'Product',
      brand: json['brand'] as String? ?? 'BRAND',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      oldPrice: (json['oldPrice'] as num?)?.toDouble(),
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble() ?? 
                         (json['discount'] as num?)?.toDouble(),
      rating: json['rating']?.toString() ?? '5.0',
      reviews: json['reviews']?.toString() ?? '(0)',
      mainImageUrl: ApiConfig.formatmainImageUrl(
        json['mainImageUrl'] as String?,
      ),
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'brand': brand,
      'price': '\$$price',
      'oldPrice': oldPrice != null ? '\$$oldPrice' : null,
      'discountPercentage': discountPercentage,
      'rating': rating,
      'reviews': reviews,
      'mainImageUrl':
          mainImageUrl ??
          '${ApiConfig.baseUrl}/uploads/66841e7c-2f7b-4f07-a4c7-bb79c2845853.jpg',
      'isFavorite': isFavorite,
    };
  }
}

class CategoryController extends GetxController {
  final RxList<CategoryItem> categories = <CategoryItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final String _apiUrl = '${ApiConfig.baseUrl}/api/v1/mobile/categories';

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await http.get(Uri.parse(_apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> body = jsonDecode(response.body);
        categories.value = body
            .map((item) => CategoryItem.fromJson(item))
            .toList();
      } else {
        errorMessage.value =
            'Failed to load categories (${response.statusCode})';
      }
    } catch (e) {
      errorMessage.value = 'Error fetching data: $e';
    } finally {
      isLoading.value = false;
    }
  }
}

class CategoryProductController extends GetxController {
  final RxList<ProductItem> products = <ProductItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<void> fetchProductsByCategory(int categoryId) async {
    final String apiUrl =
        '${ApiConfig.baseUrl}/api/v1/mobile/categories/$categoryId/products';

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> body = jsonDecode(response.body);
        products.value = body
            .map((item) => ProductItem.fromJson(item))
            .toList();
      } else {
        errorMessage.value = 'Failed to load products (${response.statusCode})';
      }
    } catch (e) {
      errorMessage.value = 'Error fetching products: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void toggleFavorite(int index) {
    products[index].isFavorite = !products[index].isFavorite;
    products.refresh();
  }
}

class FeaturedCategory {
  final String title;
  final String subtitle;
  final String mainImageUrl;
  final IconData icon;
  final Color iconColor;

  FeaturedCategory({
    required this.title,
    required this.subtitle,
    required this.mainImageUrl,
    required this.icon,
    required this.iconColor,
  });
}

// ============================================================
// DYNAMIC CATEGORY PRODUCTS DETAIL GRID VIEW
// ============================================================
// ============================================================
// DYNAMIC CATEGORY PRODUCTS DETAIL GRID VIEW
// ============================================================

class Cat extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const Cat({super.key, required this.categoryId, required this.categoryName});

  @override
  State<Cat> createState() => _CatState();
}

class _CatState extends State<Cat> {
  late final CategoryProductController productController;

  @override
  void initState() {
    super.initState();
    productController = Get.put(
      CategoryProductController(),
      tag: 'cat_${widget.categoryId}',
    );
    productController.fetchProductsByCategory(widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF101B3A),
          ),
          onPressed: () => Get.back(), // Updated to GetX navigation
        ),
        title: Text(
          widget.categoryName,
          style: const TextStyle(
            color: Color(0xFF101B3A),
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            productController.fetchProductsByCategory(widget.categoryId),
        child: Obx(() {
          if (productController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (productController.errorMessage.value.isNotEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  productController.errorMessage.value,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (productController.products.isEmpty) {
            return const Center(
              child: Text(
                'No products available in this category',
                style: TextStyle(color: Color(0xFF7B8497), fontSize: 16),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.70,
            ),
            itemCount: productController.products.length,
            itemBuilder: (context, index) {
              final product = productController.products[index];
              final isFavorite = product.isFavorite;

              return GestureDetector(
                onTap: () {
                  // Navigation using GetX:
                  Get.to(
                    () => ProductDetailScreen(product: product.toMap()),
                    transition: Transition.rightToLeft,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            // 1. Product Image
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                                child:
                                    product.mainImageUrl != null &&
                                            product.mainImageUrl!.isNotEmpty
                                        ? Image.network(
                                            product.mainImageUrl!,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Container(
                                              color: Colors.grey[200],
                                              child: const Icon(
                                                Icons.image_not_supported,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          )
                                        : Container(
                                            color: Colors.grey[200],
                                            child: const Icon(
                                              Icons.image,
                                              color: Colors.grey,
                                            ),
                                          ),
                              ),
                            ),

                            if (product.discountPercentage != null &&
                                product.discountPercentage! > 0)
                              Positioned(
                                top: 8,
                                left: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFFF416C),
                                        Color(0xFFFF4B2B),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFFF416C)
                                            .withOpacity(0.3),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    '-${product.discountPercentage!.toInt()}%',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ),
                              ),

                            // 3. FAVORITE BUTTON (Top-Right)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: () {
                                  productController.toggleFavorite(index);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    isFavorite
                                        ? Icons.favorite_rounded
                                        : Icons.favorite_border_rounded,
                                    size: 18,
                                    color: isFavorite
                                        ? Colors.red
                                        : Colors.grey[700],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color(0xFF101B3A),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Color(0xFF145CE6),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.snackbar(
                                      'Success',
                                      '${product.title} added to cart!',
                                      snackPosition: SnackPosition.BOTTOM,
                                      duration: const Duration(seconds: 1),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF145CE6),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.add_shopping_cart_rounded,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

// ============================================================
// MAIN CATEGORIES SCREEN (GETX INTEGRATED)
// ============================================================
