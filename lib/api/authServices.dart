// ignore: file_names
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_constant.dart'; // Adjust path based on your folder structure

class AuthService {
  // Replace baseUrl with your ApiConstant or actual base URL
  static const String baseUrl = ApiConstant.baseUrl; 

  /// Call change password endpoint:
  /// POST /api/v1/auth/change-password/complete?email=email
  Future<Map<String, dynamic>> changePasswordComplete({
    required String email,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final Uri url = Uri.parse(
      '$baseUrl/auth/change-password/complete?email=${Uri.encodeComponent(email)}',
    );

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        }),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'Password changed successfully.'
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to change password.'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network connection error: $e'
      };
    }
  }
}