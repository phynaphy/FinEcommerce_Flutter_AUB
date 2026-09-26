// product_controller.dart
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'product_model.dart';

class ProductDetailController extends GetxController {
  // Replace this with your actual IP or base domain
  // Use 10.0.2.2 for Android Emulator, localhost for iOS simulator
  static const String baseUrl = 'http://10.0.2.2:8080';

  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var product = Rxn<ProductModel>();

  // Interactive selection states
  var selectedImageIndex = 0.obs;
  var selectedVariantIndex = 0.obs;
  var quantity = 1.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProductDetail(7); // Fetching product with ID 7
  }

  Future<void> fetchProductDetail(int productId) async {
    try {
      isLoading(true);
      errorMessage('');
      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/mobile/products/detail/$productId'),
      );

      if (response.statusCode == 200) {
        final jsonResponseBody = json.decode(response.body);
        if (jsonResponseBody['data'] != null) {
          product.value = ProductModel.fromJson(jsonResponseBody['data'], baseUrl);
        } else {
          errorMessage.value = 'Product data not found.';
        }
      } else {
        errorMessage.value = 'Failed to load product. Status: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Error fetching data: $e';
    } finally {
      isLoading(false);
    }
  }

  void updateImageIndex(int index) {
    selectedImageIndex.value = index;
  }

  void selectVariant(int index) {
    selectedVariantIndex.value = index;
  }

  void incrementQuantity() {
    quantity.value++;
  }

  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  // Calculate dynamic price based on base price and variant adjustment
  double get totalPrice {
    if (product.value == null) return 0.0;
    double base = product.value!.price;
    if (product.value!.variants.isNotEmpty) {
      base += product.value!.variants[selectedVariantIndex.value].priceAdjustment;
    }
    return base * quantity.value;
  }
}