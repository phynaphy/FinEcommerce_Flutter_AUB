import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/screen/Favorites/favorite_response.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesController extends GetxController {
  static const String baseUrl = 'http://192.168.56.1:8080/api/v1/mobile';

  final RxList<FavoriteResponse> favorites = <FavoriteResponse>[].obs;
  final isLoading = false.obs;
  String username = '';

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  // Robust method to get username from Arguments, SharedPreferences, or JWT Token
  Future<String?> _getUsername(SharedPreferences prefs) async {
    final arguments = Get.arguments;

    if (arguments is Map && arguments['username'] != null) {
      final value = arguments['username'].toString().trim();
      if (value.isNotEmpty) return value;
    }

    final savedUsername = prefs.getString('username');
    if (savedUsername != null && savedUsername.trim().isNotEmpty) {
      return savedUsername.trim();
    }

    // Fallback if the JWT stores the username in the "sub" claim.
    final token = prefs.getString('token');
    if (token == null || token.isEmpty) return null;

    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = base64Url.normalize(parts[1]);
      final decoded = jsonDecode(
        utf8.decode(base64Url.decode(payload)),
      );

      if (decoded is! Map<String, dynamic>) return null;

      final subject = decoded['sub'];
      if (subject == null || subject.toString().trim().isEmpty) {
        return null;
      }

      return subject.toString().trim();
    } catch (e) {
      debugPrint('Could not read username from JWT: $e');
      return null;
    }
  }

  Map<String, String> _headers(String token) => {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

  void _showMessage(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }

  Future<void> loadFavorites() async {
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final currentUsername = await _getUsername(prefs);

      if (token == null || token.isEmpty) {
        _showMessage('Login Required', 'Token missing. Please log in.');
        return;
      }

      if (currentUsername == null || currentUsername.isEmpty) {
        _showMessage('Login Required', 'Username could not be determined. Please log in again.');
        return;
      }

      username = currentUsername;

      final uri = Uri.parse('$baseUrl/favorites/${Uri.encodeComponent(username)}');
      final response = await http.get(uri, headers: _headers(token));

      if (response.statusCode == 200) {
        final List<dynamic> decoded = jsonDecode(response.body);
        favorites.value = decoded
            .map((item) => FavoriteResponse.fromJson(item))
            .toList();
      } else {
        _showMessage('Failed', 'Could not load favorite items.');
      }
    } on SocketException {
      _showMessage('Connection Error', 'Cannot reach the server.');
    } catch (e) {
      debugPrint('Load favorites error: $e');
      _showMessage('Error', 'An unexpected error occurred.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeFavorite(int productId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null || token.isEmpty || username.isEmpty) return;

      final uri = Uri.parse(
        '$baseUrl/favorites/${Uri.encodeComponent(username)}/$productId',
      );

      final response = await http.delete(uri, headers: _headers(token));

      if (response.statusCode == 200) {
        favorites.removeWhere((item) => item.productId == productId);
        _showMessage('Removed', 'Product removed from favorites.');
      } else {
        _showMessage('Error', 'Failed to remove product from favorites.');
      }
    } catch (e) {
      debugPrint('Remove favorite error: $e');
      _showMessage('Error', 'Could not remove favorite.');
    }
  }
}