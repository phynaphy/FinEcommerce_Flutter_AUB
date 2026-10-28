
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_application_ecommerce/screen/product_detail/product_detail_screen.dart';

// ============================================================
// API CONFIGURATION
// ============================================================

class ApiConfig {
  // Android Emulator:
  // static const String baseUrl = 'http://10.0.2.2:8080';

  // Windows Desktop:
  static const String baseUrl = 'http://192.168.56.1:8080';

  // static const String baseUrl = 'http://192.168.56.1:8080';

  static const String categoriesUrl =
      '$baseUrl/api/v1/mobile/categories';

  static const String favoritesUrl =
      '$baseUrl/api/v1/mobile/favorites';

  // ----------------------------------------------------------
  // GET TOKEN DYNAMICALLY
  // ----------------------------------------------------------

  static Future<String?> getToken(
    SharedPreferences prefs,
  ) async {
    String? token = prefs.getString('token');

    token ??= prefs.getString('authToken');
    token ??= prefs.getString('accessToken');

    if (token == null || token.trim().isEmpty) {
      return null;
    }

    token = token.trim();

    token = token.replaceFirst(
      RegExp(r'^Bearer\s+', caseSensitive: false),
      '',
    );

    return token.isEmpty ? null : token;
  }

  // ----------------------------------------------------------
  // REQUEST HEADERS
  // ----------------------------------------------------------

  static Future<Map<String, String>> getHeaders({
    bool jsonContentType = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = await getToken(prefs);

    final headers = <String, String>{
      'Accept': 'application/json',
    };

    if (jsonContentType) {
      headers['Content-Type'] = 'application/json';
    }

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  // ----------------------------------------------------------
  // FORMAT PRODUCT IMAGE URL
  // ----------------------------------------------------------

  static String? formatmainImageUrl(String? rawUrl) {
    if (rawUrl == null || rawUrl.trim().isEmpty) {
      return null;
    }

    final value = rawUrl.trim();

    if (value.startsWith('http://') ||
        value.startsWith('https://')) {
      return value;
    }

    final cleanPath = value.startsWith('/') ? value : '/$value';

    return '$baseUrl$cleanPath';
  }
}

// ============================================================
// API RESPONSE HELPER
// ============================================================

class ApiResponseHelper {
  static List<dynamic>? extractList(dynamic decoded) {
    if (decoded is List) {
      return decoded;
    }

    if (decoded is Map) {
      for (final key in [
        'data',
        'content',
        'products',
        'categories',
        'favorites',
        'items',
      ]) {
        if (decoded[key] is List) {
          return decoded[key] as List<dynamic>;
        }
      }
    }

    return null;
  }

  static int toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double? toDouble(dynamic value) {
    if (value is num) return value.toDouble();

    if (value != null) {
      return double.tryParse(value.toString());
    }

    return null;
  }
}

// ============================================================
// CATEGORY MODEL
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

  factory CategoryItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return CategoryItem(
      id: ApiResponseHelper.toInt(json['id']),
      name: json['name']?.toString() ?? '',
      mainImageUrl: ApiConfig.formatmainImageUrl(
        json['mainImageUrl']?.toString(),
      ),
      totalProducts: ApiResponseHelper.toInt(
        json['totalProducts'],
      ),
    );
  }
}

// ============================================================
// PRODUCT MODEL
// ============================================================

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

  factory ProductItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProductItem(
      id: ApiResponseHelper.toInt(json['id']),
      title: json['title']?.toString() ??
          json['name']?.toString() ??
          json['productName']?.toString() ??
          'Product',
      brand: json['brand']?.toString() ?? 'BRAND',
      price: ApiResponseHelper.toDouble(json['price']) ?? 0.0,
      oldPrice: ApiResponseHelper.toDouble(
        json['oldPrice'] ?? json['originalPrice'],
      ),
      discountPercentage: ApiResponseHelper.toDouble(
        json['discountPercentage'] ?? json['discount'],
      ),
      rating: json['rating']?.toString() ?? '5.0',
      reviews: json['reviews']?.toString() ?? '(0)',
      mainImageUrl: ApiConfig.formatmainImageUrl(
        json['mainImageUrl']?.toString(),
      ),
      isFavorite: json['isFavorite'] == true,
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
      'mainImageUrl': mainImageUrl,
      'isFavorite': isFavorite,
    };
  }
}

// ============================================================
// CATEGORY CONTROLLER
// ============================================================

class CategoryController extends GetxController {
  final RxList<CategoryItem> categories = <CategoryItem>[].obs;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await http.get(
        Uri.parse(ApiConfig.categoriesUrl),
        headers: await ApiConfig.getHeaders(),
      );

      if (response.statusCode == 200) {
        final dynamic decoded = jsonDecode(response.body);
        final list = ApiResponseHelper.extractList(decoded);

        if (list == null) {
          errorMessage.value =
              'Unexpected categories response format.';
          return;
        }

        categories.assignAll(
          list
              .whereType<Map>()
              .map(
                (item) => CategoryItem.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList(),
        );
      } else {
        errorMessage.value =
            'Failed to load categories (${response.statusCode})';

        debugPrint('Categories response: ${response.body}');
      }
    } catch (e) {
      errorMessage.value = 'Error fetching categories: $e';
      debugPrint('Categories error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

// ============================================================
// CATEGORY PRODUCT CONTROLLER
// ============================================================

class CategoryProductController extends GetxController {
  final RxList<ProductItem> products = <ProductItem>[].obs;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final RxSet<int> favoriteLoadingIds = <int>{}.obs;

  int? _currentCategoryId;

  // ----------------------------------------------------------
  // GET USERNAME DYNAMICALLY
  // ----------------------------------------------------------

  Future<String?> _getUsername(
    SharedPreferences prefs,
  ) async {
    // 1. Navigation arguments.
    final arguments = Get.arguments;

    if (arguments is Map && arguments['username'] != null) {
      final username = arguments['username'].toString().trim();

      if (username.isNotEmpty) {
        await prefs.setString('username', username);
        return username;
      }
    }

    // 2. Saved username.
    final savedUsername = prefs.getString('username');

    if (savedUsername != null &&
        savedUsername.trim().isNotEmpty) {
      return savedUsername.trim();
    }

    // 3. JWT claims.
    final token = await ApiConfig.getToken(prefs);

    if (token == null) return null;

    try {
      final parts = token.split('.');

      if (parts.length != 3) return null;

      final payload = base64Url.normalize(parts[1]);

      final decoded = jsonDecode(
        utf8.decode(base64Url.decode(payload)),
      );

      if (decoded is! Map) return null;

      final username =
          decoded['username'] ??
          decoded['preferred_username'] ??
          decoded['sub'];

      if (username == null ||
          username.toString().trim().isEmpty) {
        return null;
      }

      final result = username.toString().trim();

      await prefs.setString('username', result);

      return result;
    } catch (e) {
      debugPrint('JWT username error: $e');
      return null;
    }
  }

  // ----------------------------------------------------------
  // FETCH PRODUCTS BY CATEGORY
  // ----------------------------------------------------------

  Future<void> fetchProductsByCategory(
    int categoryId,
  ) async {
    _currentCategoryId = categoryId;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final url =
          '${ApiConfig.categoriesUrl}/$categoryId/products';

      final response = await http.get(
        Uri.parse(url),
        headers: await ApiConfig.getHeaders(),
      );

      if (response.statusCode == 200) {
        final dynamic decoded = jsonDecode(response.body);
        final list = ApiResponseHelper.extractList(decoded);

        if (list == null) {
          errorMessage.value =
              'Unexpected products response format.';
          return;
        }

        products.assignAll(
          list
              .whereType<Map>()
              .map(
                (item) => ProductItem.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList(),
        );

        // Load saved favorite status after loading products.
        await loadFavorites();
      } else {
        errorMessage.value =
            'Failed to load products (${response.statusCode})';

        debugPrint('Products response: ${response.body}');
      }
    } catch (e) {
      errorMessage.value = 'Error fetching products: $e';
      debugPrint('Products error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ----------------------------------------------------------
  // LOAD FAVORITES FROM BACKEND
  // ----------------------------------------------------------

  Future<void> loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final username = await _getUsername(prefs);

      if (username == null || username.isEmpty) {
        debugPrint(
          'Cannot load favorites: username not found.',
        );
        return;
      }

      final url =
          '${ApiConfig.favoritesUrl}/'
          '${Uri.encodeComponent(username)}';

      final response = await http.get(
        Uri.parse(url),
        headers: await ApiConfig.getHeaders(),
      );

      if (response.statusCode != 200) {
        debugPrint(
          'Load favorites failed: '
          '${response.statusCode} ${response.body}',
        );
        return;
      }

      final dynamic decoded = jsonDecode(response.body);
      final favoriteRecords =
          ApiResponseHelper.extractList(decoded);

      if (favoriteRecords == null) {
        debugPrint(
          'Unexpected favorites response: ${response.body}',
        );
        return;
      }

      // Use productId, NOT the favorite record id.
      final Set<int> favoriteProductIds = {};

      for (final record in favoriteRecords) {
        if (record is! Map) continue;

        final productId = ApiResponseHelper.toInt(
          record['productId'],
        );

        if (productId > 0) {
          favoriteProductIds.add(productId);
        }
      }

      for (final product in products) {
        product.isFavorite =
            favoriteProductIds.contains(product.id);
      }

      products.refresh();

      debugPrint(
        'Loaded favorites for $username: $favoriteProductIds',
      );
    } catch (e) {
      debugPrint('loadFavorites error: $e');
    }
  }

  // ----------------------------------------------------------
  // ADD OR REMOVE FAVORITE
  // ----------------------------------------------------------

  Future<void> toggleFavorite(int index) async {
    if (index < 0 || index >= products.length) return;

    final product = products[index];
    final productId = product.id;

    if (favoriteLoadingIds.contains(productId)) return;

    favoriteLoadingIds.add(productId);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = await ApiConfig.getToken(prefs);
      final username = await _getUsername(prefs);

      if (token == null || token.isEmpty) {
        Get.snackbar(
          'Login Required',
          'Please log in before updating favorites.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      if (username == null || username.isEmpty) {
        Get.snackbar(
          'Username Missing',
          'Unable to identify the logged-in user.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final bool wasFavorite = product.isFavorite;

      final uri = Uri.parse(
        '${ApiConfig.favoritesUrl}/'
        '${Uri.encodeComponent(username)}/$productId',
      );

      final headers = <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final http.Response response;

      if (wasFavorite) {
        response = await http.delete(
          uri,
          headers: headers,
        );
      } else {
        response = await http.post(
          uri,
          headers: headers,
        );
      }

      debugPrint(
        'Favorite API: ${response.statusCode} ${response.body}',
      );

      if (response.statusCode >= 200 &&
          response.statusCode < 300) {
        product.isFavorite = !wasFavorite;
        products.refresh();

        Get.snackbar(
          'Success',
          product.isFavorite
              ? 'Added to favorites.'
              : 'Removed from favorites.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Favorite Error',
          'Request failed (${response.statusCode}).',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      debugPrint('toggleFavorite error: $e');

      Get.snackbar(
        'Connection Error',
        'Unable to update favorites.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      favoriteLoadingIds.remove(productId);
    }
  }

  // ----------------------------------------------------------
  // REFRESH WHEN RETURNING TO CATEGORY
  // ----------------------------------------------------------

  Future<void> refreshFavoritesOnReturn() async {
    await loadFavorites();
  }
}

// ============================================================
// FEATURED CATEGORY MODEL
// ============================================================

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
// CATEGORY PRODUCTS SCREEN
// ============================================================

class Cat extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const Cat({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

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

    productController.fetchProductsByCategory(
      widget.categoryId,
    );
  }

  @override
  void dispose() {
    Get.delete<CategoryProductController>(
      tag: 'cat_${widget.categoryId}',
    );

    super.dispose();
  }

  Future<void> _openProductDetail(int productId) async {
    await Get.to(
      () => ProductDetailScreen(
        productId: productId,
      ),
      transition: Transition.rightToLeft,
    );

    if (!mounted) return;

    await productController.refreshFavoritesOnReturn();
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
          onPressed: () => Get.back(),
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
        onRefresh: () async {
          await productController.fetchProductsByCategory(
            widget.categoryId,
          );
        },
        child: Obx(() {
          if (productController.isLoading.value &&
              productController.products.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (productController.errorMessage.value.isNotEmpty &&
              productController.products.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 100),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    productController.errorMessage.value,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      productController.fetchProductsByCategory(
                        widget.categoryId,
                      );
                    },
                    child: const Text('Try Again'),
                  ),
                ),
              ],
            );
          }

          if (productController.products.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 150),
                Center(
                  child: Text(
                    'No products available in this category',
                    style: TextStyle(
                      color: Color(0xFF7B8497),
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            );
          }

          return GridView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.70,
            ),
            itemCount: productController.products.length,
            itemBuilder: (context, index) {
              final product =
                  productController.products[index];

              return GestureDetector(
                onTap: () => _openProductDetail(product.id),
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
                      // PRODUCT IMAGE AND FAVORITE BUTTON
                      Expanded(
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius:
                                    const BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                                child: product.mainImageUrl != null &&
                                        product.mainImageUrl!.isNotEmpty
                                    ? Image.network(
                                        product.mainImageUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          return Container(
                                            color: Colors.grey[200],
                                            child: const Icon(
                                              Icons.image_not_supported,
                                              color: Colors.grey,
                                            ),
                                          );
                                        },
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

                            // DISCOUNT BADGE
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
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '-${product.discountPercentage!.toInt()}%',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),

                            // FAVORITE HEART
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Obx(() {
                                final currentProduct =
                                    productController.products.firstWhereOrNull(
                                  (item) => item.id == product.id,
                                );

                                final bool isFavorite =
                                    currentProduct?.isFavorite ?? false;

                                final bool isUpdating =
                                    productController.favoriteLoadingIds
                                        .contains(product.id);

                                return GestureDetector(
                                  onTap: isUpdating
                                      ? null
                                      : () {
                                          productController.toggleFavorite(
                                            index,
                                          );
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
                                    child: SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: Center(
                                        child: isUpdating
                                            ? const SizedBox(
                                                width: 14,
                                                height: 14,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                ),
                                              )
                                            : Icon(
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
                                );
                              }),
                            ),
                          ],
                        ),
                      ),

                      // PRODUCT DETAILS
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
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    '\$${product.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: Color(0xFF145CE6),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                    ),
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
