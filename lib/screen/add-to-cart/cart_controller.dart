
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:get/get.dart';

// import 'cart_model.dart';

// class CartController extends GetxController {
//   // Android Emulator
//   // Spring Boot runs on your PC localhost:8080
//   static const String baseUrl =
//       'http://192.168.56.1:8080/api/v1/mobile/cart';

//   final cart = Rxn<CartModel>();

//   final isLoading = false.obs;
//   final isUpdating = false.obs;
//   final errorMessage = ''.obs;

//   // ============================================================
//   // GET TOKEN
//   // ============================================================

//   Future<String> _getToken() async {
//     final prefs = await SharedPreferences.getInstance();

//     final token = prefs.getString('token');

//     debugPrint('');
//     debugPrint('========================================');
//     debugPrint('CART TOKEN');
//     debugPrint('========================================');
//     debugPrint(
//       'TOKEN EXISTS: ${token != null && token.isNotEmpty}',
//     );

//     if (token != null && token.isNotEmpty) {
//       debugPrint(
//         'TOKEN: ${token.substring(
//           0,
//           token.length > 20 ? 20 : token.length,
//         )}...',
//       );
//     } else {
//       debugPrint('TOKEN: NULL / EMPTY');
//     }

//     debugPrint('========================================');

//     return token?.trim() ?? '';
//   }

//   // ============================================================
//   // HEADERS
//   // ============================================================

//   Future<Map<String, String>> _headers() async {
//     final token = await _getToken();

//     return {
//       'Content-Type': 'application/json',
//       'Accept': 'application/json',
//       'Authorization': 'Bearer $token',
//     };
//   }

//   // ============================================================
//   // DECODE RESPONSE
//   // ============================================================

//   Map<String, dynamic> _decodeResponse(
//     http.Response response,
//   ) {
//     if (response.body.isEmpty) {
//       return {};
//     }

//     final decoded = jsonDecode(response.body);

//     if (decoded is! Map) {
//       throw Exception(
//         'Unexpected server response.',
//       );
//     }

//     final result =
//         Map<String, dynamic>.from(decoded);

//     // Support:
//     // {
//     //   "data": {
//     //      ...
//     //   }
//     // }
//     if (result['data'] is Map) {
//       return Map<String, dynamic>.from(
//         result['data'] as Map,
//       );
//     }

//     return result;
//   }

//   // ============================================================
//   // SERVER MESSAGE
//   // ============================================================

//   String _serverMessage(
//     http.Response response,
//   ) {
//     try {
//       if (response.body.isNotEmpty) {
//         final decoded =
//             jsonDecode(response.body);

//         if (decoded is Map) {
//           return (
//             decoded['message'] ??
//             decoded['error'] ??
//             decoded['detail'] ??
//             'Request failed (${response.statusCode})'
//           ).toString();
//         }
//       }
//     } catch (_) {}

//     return 'Request failed (${response.statusCode}).';
//   }

//   // ============================================================
//   // FETCH CART
//   //
//   // GET:
//   // /api/v1/mobile/cart
//   // ============================================================

//   Future<void> fetchCart() async {
//     final token = await _getToken();

//     if (token.isEmpty) {
//       errorMessage.value =
//           'Please log in to view your cart.';

//       cart.value = null;

//       debugPrint(
//         'FETCH CART: TOKEN NOT FOUND',
//       );

//       return;
//     }

//     isLoading.value = true;
//     errorMessage.value = '';

//     try {
//       final url = Uri.parse(baseUrl);

//       debugPrint('');
//       debugPrint('========================================');
//       debugPrint('FETCH CART');
//       debugPrint('========================================');
//       debugPrint('URL: $url');
//       debugPrint('========================================');

//       final response = await http
//           .get(
//             url,
//             headers: await _headers(),
//           )
//           .timeout(
//             const Duration(seconds: 20),
//           );

//       debugPrint('');
//       debugPrint('FETCH CART RESPONSE');
//       debugPrint(
//         'STATUS: ${response.statusCode}',
//       );
//       debugPrint(
//         'BODY: ${response.body}',
//       );

//       if (response.statusCode == 200) {
//         cart.value = CartModel.fromJson(
//           _decodeResponse(response),
//         );
//       } else if (response.statusCode == 204) {
//         cart.value = const CartModel();
//       } else if (response.statusCode == 401) {
//         errorMessage.value =
//             'Your login session has expired.';
//       } else if (response.statusCode == 403) {
//         errorMessage.value =
//             'You do not have permission to access the cart.';
//       } else {
//         errorMessage.value =
//             _serverMessage(response);
//       }
//     } catch (e) {
//       debugPrint(
//         'FETCH CART ERROR: $e',
//       );

//       errorMessage.value =
//           'Unable to load cart. Check your connection.';
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // ============================================================
//   // ADD TO CART
//   //
//   // POST:
//   // /api/v1/mobile/cart/add
//   //
//   // BODY:
//   // {
//   //   "productId": 7,
//   //   "quantity": 1,
//   //   "variantId": 1
//   // }
//   // ============================================================

//   Future<bool> addToCart({
//     required int productId,
//     int? variantId,
//     required int quantity,
//   }) async {
//     final token = await _getToken();

//     // ----------------------------------------------------------
//     // CHECK TOKEN
//     // ----------------------------------------------------------

//     if (token.isEmpty) {
//       Get.snackbar(
//         'Login required',
//         'Please log in before adding products.',
//         snackPosition: SnackPosition.BOTTOM,
//       );

//       return false;
//     }

//     // ----------------------------------------------------------
//     // CHECK QUANTITY
//     // ----------------------------------------------------------

//     if (quantity < 1) {
//       Get.snackbar(
//         'Invalid quantity',
//         'Quantity must be at least 1.',
//         snackPosition: SnackPosition.BOTTOM,
//       );

//       return false;
//     }

//     isUpdating.value = true;

//     try {
//       final url = Uri.parse(
//         '$baseUrl/add',
//       );

//       final Map<String, dynamic> body = {
//         'productId': productId,
//         'quantity': quantity,
//       };

//       // Add variantId only when selected
//       if (variantId != null) {
//         body['variantId'] = variantId;
//       }

//       debugPrint('');
//       debugPrint('========================================');
//       debugPrint('ADD TO CART');
//       debugPrint('========================================');
//       debugPrint('URL: $url');
//       debugPrint(
//         'BODY: ${jsonEncode(body)}',
//       );
//       debugPrint(
//         'TOKEN EXISTS: ${token.isNotEmpty}',
//       );
//       debugPrint('========================================');

//       final response = await http
//           .post(
//             url,
//             headers: await _headers(),
//             body: jsonEncode(body),
//           )
//           .timeout(
//             const Duration(seconds: 20),
//           );

//       debugPrint('');
//       debugPrint('========================================');
//       debugPrint('ADD TO CART RESPONSE');
//       debugPrint('========================================');
//       debugPrint(
//         'STATUS: ${response.statusCode}',
//       );
//       debugPrint(
//         'BODY: ${response.body}',
//       );
//       debugPrint('========================================');

//       // --------------------------------------------------------
//       // SUCCESS
//       // --------------------------------------------------------

//       if (response.statusCode == 200 ||
//           response.statusCode == 201) {
//         await fetchCart();

//         Get.snackbar(
//           'Added to cart',
//           'Product added successfully.',
//           snackPosition: SnackPosition.BOTTOM,
//         );

//         return true;
//       }

//       // --------------------------------------------------------
//       // UNAUTHORIZED
//       // --------------------------------------------------------

//       if (response.statusCode == 401) {
//         Get.snackbar(
//           'Unauthorized',
//           'Your login session is invalid or expired.',
//           snackPosition: SnackPosition.BOTTOM,
//         );

//         return false;
//       }

//       // --------------------------------------------------------
//       // FORBIDDEN
//       // --------------------------------------------------------

//       if (response.statusCode == 403) {
//         Get.snackbar(
//           'Permission denied',
//           'You do not have permission to add this product.',
//           snackPosition: SnackPosition.BOTTOM,
//         );

//         return false;
//       }

//       // --------------------------------------------------------
//       // OTHER ERROR
//       // --------------------------------------------------------

//       Get.snackbar(
//         'Could not add product',
//         _serverMessage(response),
//         snackPosition: SnackPosition.BOTTOM,
//       );

//       return false;
//     } catch (e) {
//       debugPrint(
//         'ADD TO CART ERROR: $e',
//       );

//       Get.snackbar(
//         'Connection error',
//         'Could not connect to the server.',
//         snackPosition: SnackPosition.BOTTOM,
//       );

//       return false;
//     } finally {
//       isUpdating.value = false;
//     }
//   }

//   // ============================================================
//   // UPDATE QUANTITY
//   //
//   // PUT:
//   // /api/v1/mobile/cart/items/{cartItemId}?quantity=2
//   // ============================================================

//   Future<void> updateQuantity(
//     int cartItemId,
//     int quantity,
//   ) async {
//     if (quantity < 1) {
//       await removeItem(cartItemId);
//       return;
//     }

//     final token = await _getToken();

//     if (token.isEmpty) {
//       Get.snackbar(
//         'Login required',
//         'Please log in first.',
//       );
//       return;
//     }

//     isUpdating.value = true;

//     try {
//       final uri = Uri.parse(
//         '$baseUrl/items/$cartItemId',
//       ).replace(
//         queryParameters: {
//           'quantity': quantity.toString(),
//         },
//       );

//       debugPrint(
//         'UPDATE CART URL: $uri',
//       );

//       final response = await http
//           .put(
//             uri,
//             headers: await _headers(),
//           )
//           .timeout(
//             const Duration(seconds: 20),
//           );

//       debugPrint(
//         'UPDATE CART STATUS: '
//         '${response.statusCode}',
//       );

//       debugPrint(
//         'UPDATE CART BODY: '
//         '${response.body}',
//       );

//       if (response.statusCode == 200 ||
//           response.statusCode == 204) {
//         await fetchCart();
//       } else {
//         Get.snackbar(
//           'Error',
//           _serverMessage(response),
//         );
//       }
//     } catch (e) {
//       debugPrint(
//         'UPDATE CART ERROR: $e',
//       );

//       Get.snackbar(
//         'Error',
//         'Could not update quantity.',
//       );
//     } finally {
//       isUpdating.value = false;
//     }
//   }

//   // ============================================================
//   // REMOVE ITEM
//   //
//   // DELETE:
//   // /api/v1/mobile/cart/items/{cartItemId}
//   // ============================================================

//   Future<void> removeItem(
//     int cartItemId,
//   ) async {
//     final token = await _getToken();

//     if (token.isEmpty) {
//       Get.snackbar(
//         'Login required',
//         'Please log in first.',
//       );
//       return;
//     }

//     isUpdating.value = true;

//     try {
//       final url = Uri.parse(
//         '$baseUrl/items/$cartItemId',
//       );

//       final response = await http
//           .delete(
//             url,
//             headers: await _headers(),
//           )
//           .timeout(
//             const Duration(seconds: 20),
//           );

//       debugPrint(
//         'REMOVE CART STATUS: '
//         '${response.statusCode}',
//       );

//       debugPrint(
//         'REMOVE CART BODY: '
//         '${response.body}',
//       );

//       if (response.statusCode == 200 ||
//           response.statusCode == 204) {
//         await fetchCart();

//         Get.snackbar(
//           'Removed',
//           'Item removed from your cart.',
//           snackPosition: SnackPosition.BOTTOM,
//         );
//       } else {
//         Get.snackbar(
//           'Error',
//           _serverMessage(response),
//         );
//       }
//     } catch (e) {
//       debugPrint(
//         'REMOVE CART ERROR: $e',
//       );

//       Get.snackbar(
//         'Error',
//         'Could not remove this item.',
//       );
//     } finally {
//       isUpdating.value = false;
//     }
//   }

//   // ============================================================
//   // CLEAR CART
//   //
//   // DELETE:
//   // /api/v1/mobile/cart/clear
//   // ============================================================

//   Future<void> clearCart() async {
//     final token = await _getToken();

//     if (token.isEmpty) {
//       Get.snackbar(
//         'Login required',
//         'Please log in first.',
//       );
//       return;
//     }

//     isUpdating.value = true;

//     try {
//       final url = Uri.parse(
//         '$baseUrl/clear',
//       );

//       final response = await http
//           .delete(
//             url,
//             headers: await _headers(),
//           )
//           .timeout(
//             const Duration(seconds: 20),
//           );

//       debugPrint(
//         'CLEAR CART STATUS: '
//         '${response.statusCode}',
//       );

//       debugPrint(
//         'CLEAR CART BODY: '
//         '${response.body}',
//       );

//       if (response.statusCode == 200 ||
//           response.statusCode == 204) {
//         await fetchCart();

//         Get.snackbar(
//           'Cart cleared',
//           'All items have been removed.',
//           snackPosition: SnackPosition.BOTTOM,
//         );
//       } else {
//         Get.snackbar(
//           'Error',
//           _serverMessage(response),
//         );
//       }
//     } catch (e) {
//       debugPrint(
//         'CLEAR CART ERROR: $e',
//       );

//       Get.snackbar(
//         'Error',
//         'Could not clear your cart.',
//       );
//     } finally {
//       isUpdating.value = false;
//     }
//   }
// }



import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

import 'cart_model.dart';

class CartController extends GetxController {
  // ============================================================
  // BASE URL
  // ============================================================

  static const String baseUrl =
      'http://192.168.56.1:8080/api/v1/mobile/cart';

  // ============================================================
  // IMAGE BASE URL
  // ============================================================

  static const String imageBaseUrl =
      'http://192.168.56.1:8080';

  final cart = Rxn<CartModel>();

  final isLoading = false.obs;
  final isUpdating = false.obs;
  final errorMessage = ''.obs;

  // ============================================================
  // GET TOKEN
  // ============================================================

  Future<String> _getToken() async {
    final prefs =
        await SharedPreferences.getInstance();

    final token =
        prefs.getString('token');

    debugPrint('');
    debugPrint('========================================');
    debugPrint('CART TOKEN');
    debugPrint('========================================');

    debugPrint(
      'TOKEN EXISTS: '
      '${token != null && token.isNotEmpty}',
    );

    if (token != null && token.isNotEmpty) {
      debugPrint(
        'TOKEN: ${token.substring(
          0,
          token.length > 20
              ? 20
              : token.length,
        )}...',
      );
    } else {
      debugPrint(
        'TOKEN: NULL / EMPTY',
      );
    }

    debugPrint(
      '========================================',
    );

    return token?.trim() ?? '';
  }

  // ============================================================
  // HEADERS
  // ============================================================

  Future<Map<String, String>> _headers() async {
    final token =
        await _getToken();

    return {
      'Content-Type':
          'application/json',

      'Accept':
          'application/json',

      'Authorization':
          'Bearer $token',
    };
  }

  // ============================================================
  // DECODE RESPONSE
  // ============================================================

  Map<String, dynamic> _decodeResponse(
    http.Response response,
  ) {
    if (response.body.isEmpty) {
      return {};
    }

    final decoded =
        jsonDecode(response.body);

    if (decoded is! Map) {
      throw Exception(
        'Unexpected server response.',
      );
    }

    final result =
        Map<String, dynamic>.from(
      decoded,
    );

    // Support:
    //
    // {
    //   "data": {
    //      "items": [...]
    //   }
    // }

    if (result['data'] is Map) {
      return Map<String, dynamic>.from(
        result['data'] as Map,
      );
    }

    return result;
  }

  // ============================================================
  // SERVER MESSAGE
  // ============================================================

  String _serverMessage(
    http.Response response,
  ) {
    try {
      if (response.body.isNotEmpty) {
        final decoded =
            jsonDecode(response.body);

        if (decoded is Map) {
          return (
            decoded['message'] ??
            decoded['error'] ??
            decoded['detail'] ??
            'Request failed '
                '(${response.statusCode})'
          ).toString();
        }
      }
    } catch (_) {}

    return 'Request failed '
        '(${response.statusCode}).';
  }

  // ============================================================
  // FETCH CART
  // ============================================================

  Future<void> fetchCart() async {
    final token =
        await _getToken();

    if (token.isEmpty) {
      errorMessage.value =
          'Please log in to view your cart.';

      cart.value = null;

      debugPrint(
        'FETCH CART: TOKEN NOT FOUND',
      );

      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final url =
          Uri.parse(baseUrl);

      debugPrint('');
      debugPrint(
        '========================================',
      );
      debugPrint('FETCH CART');
      debugPrint(
        '========================================',
      );

      debugPrint(
        'URL: $url',
      );

      debugPrint(
        '========================================',
      );

      final response =
          await http
              .get(
                url,
                headers:
                    await _headers(),
              )
              .timeout(
                const Duration(
                  seconds: 20,
                ),
              );

      debugPrint('');
      debugPrint(
        '========================================',
      );
      debugPrint(
        'FETCH CART RESPONSE',
      );
      debugPrint(
        '========================================',
      );

      debugPrint(
        'STATUS: '
        '${response.statusCode}',
      );

      debugPrint(
        'BODY: ${response.body}',
      );

      debugPrint(
        '========================================',
      );

      if (response.statusCode == 200) {
        final decoded =
            _decodeResponse(response);

        cart.value =
            CartModel.fromJson(
          decoded,
        );

        // ======================================================
        // PRINT ALL CART IMAGES
        // ======================================================

        for (final item
            in cart.value!.items) {
          debugPrint('');
          debugPrint(
            '========================================',
          );

          debugPrint(
            'PRODUCT: '
            '${item.productName}',
          );

          debugPrint(
            'PRODUCT ID: '
            '${item.productId}',
          );

          debugPrint(
            'CART IMAGE: '
            '${item.mainImageUrl}',
          );

          if (item.mainImageUrl != null) {
            final imagePath =
                item.mainImageUrl!;

            final fullImageUrl =
                imagePath.startsWith(
                  'http',
                )
                    ? imagePath
                    : '$imageBaseUrl'
                      '${imagePath.startsWith('/') ? '' : '/'}'
                      '$imagePath';

            debugPrint(
              'FULL IMAGE URL: '
              '$fullImageUrl',
            );
          }

          debugPrint(
            '========================================',
          );
        }
      } else if (response.statusCode ==
          204) {
        cart.value =
            const CartModel();
      } else if (response.statusCode ==
          401) {
        errorMessage.value =
            'Your login session has expired.';
      } else if (response.statusCode ==
          403) {
        errorMessage.value =
            'You do not have permission to access the cart.';
      } else {
        errorMessage.value =
            _serverMessage(response);
      }
    } catch (e) {
      debugPrint(
        'FETCH CART ERROR: $e',
      );

      errorMessage.value =
          'Unable to load cart. '
          'Check your connection.';
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // ADD TO CART
  // ============================================================

  Future<bool> addToCart({
    required int productId,
    int? variantId,
    required int quantity,
  }) async {
    final token =
        await _getToken();

    if (token.isEmpty) {
      Get.snackbar(
        'Login required',
        'Please log in before adding products.',
        snackPosition:
            SnackPosition.BOTTOM,
      );

      return false;
    }

    if (quantity < 1) {
      Get.snackbar(
        'Invalid quantity',
        'Quantity must be at least 1.',
        snackPosition:
            SnackPosition.BOTTOM,
      );

      return false;
    }

    isUpdating.value = true;

    try {
      final url =
          Uri.parse(
        '$baseUrl/add',
      );

      final Map<String, dynamic>
          body = {
        'productId':
            productId,
        'quantity':
            quantity,
      };

      if (variantId != null) {
        body['variantId'] =
            variantId;
      }

      debugPrint('');
      debugPrint(
        '========================================',
      );
      debugPrint(
        'ADD TO CART',
      );
      debugPrint(
        '========================================',
      );

      debugPrint(
        'URL: $url',
      );

      debugPrint(
        'BODY: '
        '${jsonEncode(body)}',
      );

      final response =
          await http
              .post(
                url,
                headers:
                    await _headers(),
                body:
                    jsonEncode(body),
              )
              .timeout(
                const Duration(
                  seconds: 20,
                ),
              );

      debugPrint(
        'STATUS: '
        '${response.statusCode}',
      );

      debugPrint(
        'BODY: '
        '${response.body}',
      );

      if (response.statusCode ==
              200 ||
          response.statusCode ==
              201) {
        await fetchCart();

        Get.snackbar(
          'Added to cart',
          'Product added successfully.',
          snackPosition:
              SnackPosition.BOTTOM,
        );

        return true;
      }

      if (response.statusCode ==
          401) {
        Get.snackbar(
          'Unauthorized',
          'Your login session is invalid or expired.',
          snackPosition:
              SnackPosition.BOTTOM,
        );

        return false;
      }

      if (response.statusCode ==
          403) {
        Get.snackbar(
          'Permission denied',
          'You do not have permission to add this product.',
          snackPosition:
              SnackPosition.BOTTOM,
        );

        return false;
      }

      Get.snackbar(
        'Could not add product',
        _serverMessage(response),
        snackPosition:
            SnackPosition.BOTTOM,
      );

      return false;
    } catch (e) {
      debugPrint(
        'ADD TO CART ERROR: $e',
      );

      Get.snackbar(
        'Connection error',
        'Could not connect to the server.',
        snackPosition:
            SnackPosition.BOTTOM,
      );

      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  // ============================================================
  // UPDATE QUANTITY
  // ============================================================

  Future<void> updateQuantity(
    int cartItemId,
    int quantity,
  ) async {
    if (quantity < 1) {
      await removeItem(
        cartItemId,
      );
      return;
    }

    final token =
        await _getToken();

    if (token.isEmpty) {
      Get.snackbar(
        'Login required',
        'Please log in first.',
      );
      return;
    }

    isUpdating.value = true;

    try {
      final uri =
          Uri.parse(
        '$baseUrl/items/$cartItemId',
      ).replace(
        queryParameters: {
          'quantity':
              quantity.toString(),
        },
      );

      final response =
          await http
              .put(
                uri,
                headers:
                    await _headers(),
              )
              .timeout(
                const Duration(
                  seconds: 20,
                ),
              );

      debugPrint(
        'UPDATE CART STATUS: '
        '${response.statusCode}',
      );

      debugPrint(
        'UPDATE CART BODY: '
        '${response.body}',
      );

      if (response.statusCode ==
              200 ||
          response.statusCode ==
              204) {
        await fetchCart();
      } else {
        Get.snackbar(
          'Error',
          _serverMessage(response),
        );
      }
    } catch (e) {
      debugPrint(
        'UPDATE CART ERROR: $e',
      );

      Get.snackbar(
        'Error',
        'Could not update quantity.',
      );
    } finally {
      isUpdating.value = false;
    }
  }

  // ============================================================
  // REMOVE ITEM
  // ============================================================

  Future<void> removeItem(
    int cartItemId,
  ) async {
    final token =
        await _getToken();

    if (token.isEmpty) {
      Get.snackbar(
        'Login required',
        'Please log in first.',
      );
      return;
    }

    isUpdating.value = true;

    try {
      final url =
          Uri.parse(
        '$baseUrl/items/$cartItemId',
      );

      final response =
          await http
              .delete(
                url,
                headers:
                    await _headers(),
              )
              .timeout(
                const Duration(
                  seconds: 20,
                ),
              );

      debugPrint(
        'REMOVE CART STATUS: '
        '${response.statusCode}',
      );

      debugPrint(
        'REMOVE CART BODY: '
        '${response.body}',
      );

      if (response.statusCode ==
              200 ||
          response.statusCode ==
              204) {
        await fetchCart();

        Get.snackbar(
          'Removed',
          'Item removed from your cart.',
          snackPosition:
              SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          _serverMessage(response),
        );
      }
    } catch (e) {
      debugPrint(
        'REMOVE CART ERROR: $e',
      );

      Get.snackbar(
        'Error',
        'Could not remove this item.',
      );
    } finally {
      isUpdating.value = false;
    }
  }

  // ============================================================
  // CLEAR CART
  // ============================================================

  Future<void> clearCart() async {
    final token =
        await _getToken();

    if (token.isEmpty) {
      Get.snackbar(
        'Login required',
        'Please log in first.',
      );
      return;
    }

    isUpdating.value = true;

    try {
      final url =
          Uri.parse(
        '$baseUrl/clear',
      );

      final response =
          await http
              .delete(
                url,
                headers:
                    await _headers(),
              )
              .timeout(
                const Duration(
                  seconds: 20,
                ),
              );

      debugPrint(
        'CLEAR CART STATUS: '
        '${response.statusCode}',
      );

      debugPrint(
        'CLEAR CART BODY: '
        '${response.body}',
      );

      if (response.statusCode ==
              200 ||
          response.statusCode ==
              204) {
        await fetchCart();

        Get.snackbar(
          'Cart cleared',
          'All items have been removed.',
          snackPosition:
              SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          _serverMessage(response),
        );
      }
    } catch (e) {
      debugPrint(
        'CLEAR CART ERROR: $e',
      );

      Get.snackbar(
        'Error',
        'Could not clear your cart.',
      );
    } finally {
      isUpdating.value = false;
    }
  }
}