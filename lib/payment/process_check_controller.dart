
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'process_checkout_service.dart';

class ProcessCheckoutController extends GetxController {
  final ProcessCheckoutService checkoutService =
      ProcessCheckoutService();

  // Checkout data displayed by PaymentScreen.
  final Rxn<CheckoutData> checkout = Rxn<CheckoutData>();

  // Loading states.
  final isLoading = false.obs;
  final isSubmitting = false.obs;

  // Error message.
  final errorMessage = ''.obs;

  // Selected payment method.
  final selectedPaymentMethod = 'ACLEDA_KHQR'.obs;

  // Result returned by checkout/payment APIs.
  final checkoutResult = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadCheckout();
  }

  // Load checkout summary from the backend.
  Future<void> loadCheckout() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await checkoutService.getCheckout();

      checkout.value = CheckoutData.fromJson(response);
    } catch (e) {
      errorMessage.value =
          e.toString().replaceFirst('Exception: ', '');

      debugPrint('LOAD CHECKOUT ERROR: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh checkout summary.
  Future<void> refreshCheckout() async {
    await loadCheckout();
  }

  // Update selected payment method.
  void selectPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  // Create order and request KHQR if selected.
  Future<Map<String, dynamic>?> submitCheckout(
    String paymentMethod,
  ) async {
    if (isSubmitting.value) return null;

    final currentCheckout = checkout.value;

    if (currentCheckout == null) {
      Get.snackbar(
        'Checkout unavailable',
        'Please load your checkout information first.',
      );
      return null;
    }

    try {
      isSubmitting.value = true;
      errorMessage.value = '';
      checkoutResult.clear();

      final result = await checkoutService.submitCheckout(
        shippingAddress: currentCheckout.shippingAddress,
        phoneNumber: currentCheckout.phoneNumber,
        paymentMethod: paymentMethod,
        notes: currentCheckout.notes,
      );

      checkoutResult.assignAll(result);

      debugPrint('CHECKOUT RESULT: $result');

      return result;
    } catch (e) {
      errorMessage.value =
          e.toString().replaceFirst('Exception: ', '');

      debugPrint('SUBMIT CHECKOUT ERROR: $e');

      Get.snackbar(
        'Checkout failed',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );

      return null;
    } finally {
      isSubmitting.value = false;
    }
  }
}

// Checkout data model used by PaymentScreen.
class CheckoutData {
  final String shippingAddress;
  final String phoneNumber;
  final String notes;
  final List<CheckoutItem> items;
  final double subtotal;
  final double shippingFee;
  final double total;

  CheckoutData({
    required this.shippingAddress,
    required this.phoneNumber,
    required this.notes,
    required this.items,
    required this.subtotal,
    required this.shippingFee,
    required this.total,
  });

  factory CheckoutData.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] ?? json['cartItems'] ?? [];

    final items = rawItems is List
        ? rawItems
            .whereType<Map>()
            .map(
              (item) => CheckoutItem.fromJson(
                Map<String, dynamic>.from(item),
              ),
            )
            .toList()
        : <CheckoutItem>[];

    double number(dynamic value) {
      if (value is num) return value.toDouble();
      return double.tryParse(value?.toString() ?? '') ?? 0.0;
    }

    return CheckoutData(
      shippingAddress:
          (json['shippingAddress'] ?? '').toString(),
      phoneNumber: (json['phoneNumber'] ?? '').toString(),
      notes: (json['notes'] ?? '').toString(),
      items: items,
      subtotal: number(json['subtotal']),
      shippingFee: number(json['shippingFee']),
      total: number(json['total']),
    );
  }
}

class CheckoutItem {
  final String name;
  final int quantity;
  final double price;

  CheckoutItem({
    required this.name,
    required this.quantity,
    required this.price,
  });

  factory CheckoutItem.fromJson(Map<String, dynamic> json) {
    return CheckoutItem(
      name: (json['name'] ?? json['productName'] ?? '').toString(),
      quantity: int.tryParse(
            (json['quantity'] ?? 0).toString(),
          ) ??
          0,
      price: _parsePrice(json['price'] ?? json['unitPrice']),
    );
  }

  static double _parsePrice(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }
}
