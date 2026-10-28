// // product_controller.dart
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'product_model.dart';

// class ProductDetailController extends GetxController {
//   // Replace this with your actual IP or base domain
//   // Use 10.0.2.2 for Android Emulator, localhost for iOS simulator
//   static const String baseUrl = 'http://10.0.2.2:8080';

//   var isLoading = true.obs;
//   var errorMessage = ''.obs;
//   var product = Rxn<ProductModel>();

//   // Interactive selection states
//   var selectedImageIndex = 0.obs;
//   var selectedVariantIndex = 0.obs;
//   var quantity = 1.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchProductDetail(7); // Fetching product with ID 7
//   }

//   Future<void> fetchProductDetail(int productId) async {
//     try {
//       isLoading(true);
//       errorMessage('');
//       final response = await http.get(
//         Uri.parse('$baseUrl/api/v1/mobile/products/detail/$productId'),
//       );

//       if (response.statusCode == 200) {
//         final jsonResponseBody = json.decode(response.body);
//         if (jsonResponseBody['data'] != null) {
//           product.value = ProductModel.fromJson(jsonResponseBody['data'], baseUrl);
//         } else {
//           errorMessage.value = 'Product data not found.';
//         }
//       } else {
//         errorMessage.value = 'Failed to load product. Status: ${response.statusCode}';
//       }
//     } catch (e) {
//       errorMessage.value = 'Error fetching data: $e';
//     } finally {
//       isLoading(false);
//     }
//   }

//   void updateImageIndex(int index) {
//     selectedImageIndex.value = index;
//   }

//   void selectVariant(int index) {
//     selectedVariantIndex.value = index;
//   }

//   void incrementQuantity() {
//     quantity.value++;
//   }

//   void decrementQuantity() {
//     if (quantity.value > 1) {
//       quantity.value--;
//     }
//   }

//   // Calculate dynamic price based on base price and variant adjustment
//   double get totalPrice {
//     if (product.value == null) return 0.0;
//     double base = product.value!.price;
//     if (product.value!.variants.isNotEmpty) {
//       base += product.value!.variants[selectedVariantIndex.value].priceAdjustment;
//     }
//     return base * quantity.value;
//   }
// }



import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'product_model.dart';

class ProductDetailController extends GetxController {
  static const String baseUrl = 'http://192.168.56.1:8080';

  final int productId;

  ProductDetailController({required this.productId});

  final isLoading = true.obs;
  final errorMessage = ''.obs;
  final product = Rxn<ProductModel>();

  final selectedImageIndex = 0.obs;
  final selectedVariantIndex = 0.obs;
  final quantity = 1.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProductDetail(productId);
  }

  Future<void> fetchProductDetail(int id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final uri = Uri.parse(
        '$baseUrl/api/v1/mobile/products/detail/$id',
      );

      final response = await http
          .get(
            uri,
            headers: {
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to load product. HTTP ${response.statusCode}',
        );
      }

      final decoded = jsonDecode(response.body);

      if (decoded is! Map) {
        throw const FormatException(
          'Invalid API response format.',
        );
      }

      // Supports both { "data": {...} } and a direct product object.
      final dynamic data = decoded.containsKey('data')
          ? decoded['data']
          : decoded;

      if (data is! Map) {
        throw Exception('Product data not found.');
      }

      final loadedProduct = ProductModel.fromJson(
        Map<String, dynamic>.from(data),
        baseUrl,
      );

      if (loadedProduct.id == 0) {
        throw Exception('Invalid product data received.');
      }

      product.value = loadedProduct;

      selectedImageIndex.value = 0;
      selectedVariantIndex.value = 0;
      quantity.value = 1;
    } on FormatException catch (e) {
      errorMessage.value = 'Invalid server response: ${e.message}';
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst(
        'Exception: ',
        '',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> retry() => fetchProductDetail(productId);

  void updateImageIndex(int index) {
    final images = product.value?.imageUrls ?? [];

    if (index >= 0 && index < images.length) {
      selectedImageIndex.value = index;
    }
  }

  void selectVariant(int index) {
    final variants = product.value?.variants ?? [];

    if (index < 0 || index >= variants.length) return;

    selectedVariantIndex.value = index;

    // Keep quantity within the newly selected variant's stock.
    final stock = variants[index].stockQuantity;

    if (stock <= 0) {
      quantity.value = 1;
    } else if (quantity.value > stock) {
      quantity.value = stock;
    }
  }

  ProductVariant? get selectedVariant {
    final variants = product.value?.variants ?? [];

    if (variants.isEmpty) return null;

    final index = selectedVariantIndex.value;

    if (index < 0 || index >= variants.length) {
      return variants.first;
    }

    return variants[index];
  }

  int get availableStock {
    final variant = selectedVariant;

    // Without variants, stock must be supplied by the API
    // if you want to enforce a stock limit for the base product.
    return variant?.stockQuantity ?? 999999;
  }

  bool get canAddToCart {
    final p = product.value;

    if (p == null || isLoading.value) return false;

    if (p.variants.isNotEmpty) {
      return availableStock > 0 &&
          quantity.value <= availableStock;
    }

    return quantity.value > 0;
  }

  void incrementQuantity() {
    if (quantity.value >= availableStock) return;

    quantity.value++;
  }

  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  double get unitPrice {
    final p = product.value;

    if (p == null) return 0;

    return p.price + (selectedVariant?.priceAdjustment ?? 0);
  }

  double get totalPrice => unitPrice * quantity.value;
}