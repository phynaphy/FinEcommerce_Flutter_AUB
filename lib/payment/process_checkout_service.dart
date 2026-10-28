
// import 'dart:convert';

// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class ProcessCheckoutService {
//   // Android emulator -> computer running Spring Boot.
//   static const String baseUrl =
//       'http://10.0.2.2:8080/api/v1';

//   Future<String> _getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('token') ?? '';
//   }

//   Future<Map<String, String>> _headers() async {
//     final token = await _getToken();

//     return {
//       'Accept': 'application/json',
//       'Content-Type': 'application/json',
//       if (token.isNotEmpty) 'Authorization': 'Bearer $token',
//     };
//   }

//   // TEMPORARY:
//   // Do not call GET /checkout because your backend only
//   // supports POST for the endpoint you tested.
//   //
//   // Replace this method with your actual cart API when
//   // you provide its endpoint and JSON response.
//   Future<Map<String, dynamic>> getCheckout() async {
//     throw Exception(
//       'Checkout summary is not connected yet. '
//       'Connect this method to your existing cart API.',
//     );
//   }

//   // STEP 1: Create order using your working Postman endpoint.
//   Future<Map<String, dynamic>> createOrder({
//     required String shippingAddress,
//     required String phoneNumber,
//     required String paymentMethod,
//     required String notes,
//   }) async {
//     final token = await _getToken();

//     if (token.isEmpty) {
//       Get.snackbar(
//         'Login Required',
//         'Please log in first.',
//       );
//       throw Exception('Authentication token is missing.');
//     }

//     final response = await http
//         .post(
//           Uri.parse('$baseUrl/checkout'),
//           headers: await _headers(),
//           body: jsonEncode({
//             'shippingAddress': shippingAddress,
//             'phoneNumber': phoneNumber,
//             'paymentMethod': paymentMethod,
//             'notes': notes,
//           }),
//         )
//         .timeout(const Duration(seconds: 20));

//     debugPrint('CREATE ORDER STATUS: ${response.statusCode}');
//     debugPrint('CREATE ORDER BODY: ${response.body}');

//     if (response.statusCode >= 200 &&
//         response.statusCode < 300) {
//       return _decodeResponse(response.body);
//     }

//     throw Exception(
//       'Create order failed: '
//       '${response.statusCode} ${response.body}',
//     );
//   }

//   // STEP 2: Request ACLEDA payment session / KHQR.
//   Future<Map<String, dynamic>> generateAcledaSession({
//     required int orderId,
//   }) async {
//     final token = await _getToken();

//     if (token.isEmpty) {
//       throw Exception('Authentication token is missing.');
//     }

//     final response = await http
//         .post(
//           Uri.parse('$baseUrl/payments/acleda/session'),
//           headers: await _headers(),
//           body: jsonEncode({
//             'orderId': orderId,
//           }),
//         )
//         .timeout(const Duration(seconds: 30));

//     debugPrint('ACLEDA SESSION STATUS: ${response.statusCode}');
//     debugPrint('ACLEDA SESSION BODY: ${response.body}');

//     if (response.statusCode >= 200 &&
//         response.statusCode < 300) {
//       return _decodeResponse(response.body);
//     }

//     throw Exception(
//       'Generate KHQR failed: '
//       '${response.statusCode} ${response.body}',
//     );
//   }

//   // STEP 3: Create order, then request KHQR if selected.
//   Future<Map<String, dynamic>> submitCheckout({
//     required String shippingAddress,
//     required String phoneNumber,
//     required String paymentMethod,
//     required String notes,
//   }) async {
//     // This POST call matches your working Postman request.
//     final order = await createOrder(
//       shippingAddress: shippingAddress,
//       phoneNumber: phoneNumber,
//       paymentMethod: paymentMethod,
//       notes: notes,
//     );

//     // Other methods create the order only.
//     if (paymentMethod != 'ACLEDA_KHQR') {
//       return order;
//     }

//     final rawOrderId = order['orderId'] ?? order['id'];

//     if (rawOrderId == null) {
//       throw Exception(
//         'Order created, but the response has no orderId.',
//       );
//     }

//     final orderId = int.tryParse(rawOrderId.toString());

//     if (orderId == null) {
//       throw Exception('The returned order ID is invalid.');
//     }

//     final payment = await generateAcledaSession(
//       orderId: orderId,
//     );

//     return {
//       ...order,
//       ...payment,
//     };
//   }

//   Map<String, dynamic> _decodeResponse(String body) {
//     if (body.trim().isEmpty) {
//       return <String, dynamic>{};
//     }

//     final dynamic decoded = jsonDecode(body);

//     if (decoded is Map) {
//       final result = Map<String, dynamic>.from(decoded);

//       // Support APIs returning {"data": {...}}.
//       if (result['data'] is Map) {
//         return Map<String, dynamic>.from(
//           result['data'] as Map,
//         );
//       }

//       return result;
//     }

//     throw Exception(
//       'The API returned an unexpected JSON response.',
//     );
//   }
// }

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProcessCheckoutService {
  static const String baseUrl =
      'http://10.0.2.2:8080/api/v1';

  // Static checkout data for testing
  static const String staticShippingAddress =
      'Phnom Penh, Cambodia';
  static const String staticPhoneNumber = '012345678';
  static const String staticPaymentMethod = 'ACLEDA_KHQR';
  static const String staticNotes = 'Deliver carefully';

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  Future<Map<String, String>> _headers() async {
    final token = await _getToken();

    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  // No GET /checkout call because your tested endpoint
  // currently supports POST, not GET.
  Future<Map<String, dynamic>> getCheckout() async {
    return {
      'shippingAddress': staticShippingAddress,
      'phoneNumber': staticPhoneNumber,
      'paymentMethod': staticPaymentMethod,
      'notes': staticNotes,
      'subtotal': 1.00,
      'shippingFee': 0.00,
      'total': 1.00,
    };
  }

  // STEP 1: Create order with static data.
  Future<Map<String, dynamic>> createOrder({
    String shippingAddress = staticShippingAddress,
    String phoneNumber = staticPhoneNumber,
    String paymentMethod = staticPaymentMethod,
    String notes = staticNotes,
  }) async {
    final token = await _getToken();

    if (token.isEmpty) {
      Get.snackbar(
        'Login Required',
        'Please log in first.',
      );
      throw Exception('Authentication token is missing.');
    }

    final response = await http
        .post(
          Uri.parse('$baseUrl/checkout'),
          headers: await _headers(),
          body: jsonEncode({
            'shippingAddress': staticShippingAddress,
            'phoneNumber': staticPhoneNumber,
            'paymentMethod': staticPaymentMethod,
            'notes': staticNotes,
          }),
        )
        .timeout(const Duration(seconds: 20));

    debugPrint('CREATE ORDER STATUS: ${response.statusCode}');
    debugPrint('CREATE ORDER BODY: ${response.body}');

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return _decodeResponse(response.body);
    }

    throw Exception(
      'Create order failed: '
      '${response.statusCode} ${response.body}',
    );
  }

  // STEP 2: Request ACLEDA payment session / KHQR.
  Future<Map<String, dynamic>> generateAcledaSession({
    required int orderId,
  }) async {
    final token = await _getToken();

    if (token.isEmpty) {
      Get.snackbar(
        'Login Required',
        'Please log in first.',
      );
      throw Exception('Authentication token is missing.');
    }

    final response = await http
        .post(
          Uri.parse('$baseUrl/payments/acleda/session'),
          headers: await _headers(),
          body: jsonEncode({
            'orderId': orderId,
          }),
        )
        .timeout(const Duration(seconds: 30));

    debugPrint('ACLEDA SESSION STATUS: ${response.statusCode}');
    debugPrint('ACLEDA SESSION BODY: ${response.body}');

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return _decodeResponse(response.body);
    }

    throw Exception(
      'Generate KHQR failed: '
      '${response.statusCode} ${response.body}',
    );
  }

  // STEP 3: Create order and request KHQR.
  Future<Map<String, dynamic>> submitCheckout({
    String shippingAddress = staticShippingAddress,
    String phoneNumber = staticPhoneNumber,
    String paymentMethod = staticPaymentMethod,
    String notes = staticNotes,
  }) async {
    final order = await createOrder();

    // Only request a KHQR session for ACLEDA_KHQR.
    if (staticPaymentMethod != 'ACLEDA_KHQR') {
      return order;
    }

    final rawOrderId = order['orderId'] ?? order['id'];

    if (rawOrderId == null) {
      throw Exception(
        'Order created, but the response has no orderId.',
      );
    }

    final orderId = int.tryParse(rawOrderId.toString());

    if (orderId == null) {
      throw Exception('The returned order ID is invalid.');
    }

    final payment = await generateAcledaSession(
      orderId: orderId,
    );

    return {
      ...order,
      ...payment,
    };
  }

  Map<String, dynamic> _decodeResponse(String body) {
    if (body.trim().isEmpty) {
      return <String, dynamic>{};
    }

    final dynamic decoded = jsonDecode(body);

    if (decoded is Map) {
      final result = Map<String, dynamic>.from(decoded);

      // Support responses wrapped in {"data": {...}}.
      if (result['data'] is Map) {
        return Map<String, dynamic>.from(
          result['data'] as Map,
        );
      }

      return result;
    }

    throw Exception(
      'The API returned an unexpected JSON response.',
    );
  }
}
