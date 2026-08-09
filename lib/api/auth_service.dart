import 'dart:convert';

import 'package:flutter_application_ecommerce/api/api_constant.dart';
import 'package:flutter_application_ecommerce/api/request_service/login_request.dart';
import 'package:flutter_application_ecommerce/api/request_service/register_request.dart';
import 'package:flutter_application_ecommerce/api/request_service/reset_password_request.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // ============================================================
  // LOGIN
  // ============================================================

  Future<http.Response> login(LoginRequest request) async {
    final url = Uri.parse(
      "${ApiConstant.baseUrl}/auth/login",
    );

    print("=================================");
    print("LOGIN");
    print("URL: $url");
    print("BODY: ${jsonEncode(request.toJson())}");
    print("=================================");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(request.toJson()),
    );

    print("LOGIN STATUS: ${response.statusCode}");
    print("LOGIN RESPONSE: ${response.body}");

    // Save token
    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      try {
        final data = jsonDecode(response.body);

        final token = data["token"];

        if (token != null &&
            token.toString().isNotEmpty) {
          final prefs =
              await SharedPreferences.getInstance();

          await prefs.setString(
            "token",
            token.toString(),
          );

          print("TOKEN SAVED");
        }
      } catch (e) {
        print("ERROR SAVING TOKEN: $e");
      }
    }

    return response;
  }

  // ============================================================
  // REGISTER
  // ============================================================

  Future<http.Response> register(
    RegisterRequest request,
  ) async {
    final url = Uri.parse(
      "${ApiConstant.baseUrl}/auth/register",
    );

    print("=================================");
    print("REGISTER");
    print("URL: $url");
    print("BODY: ${jsonEncode(request.toJson())}");
    print("=================================");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(request.toJson()),
    );

    print("REGISTER STATUS: ${response.statusCode}");
    print("REGISTER RESPONSE: ${response.body}");

    return response;
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Future<void> logout() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove("token");

    print("=================================");
    print("LOGOUT");
    print("TOKEN REMOVED");
    print("=================================");
  }

  // ============================================================
  // GET TOKEN
  // ============================================================

  Future<String?> getToken() async {
    final prefs =
        await SharedPreferences.getInstance();

    final token = prefs.getString("token");

    print("=================================");
    print("GET TOKEN");
    print(
      "TOKEN EXISTS: "
      "${token != null && token.isNotEmpty}",
    );
    print("=================================");

    return token;
  }

  // ============================================================
  // FORGOT PASSWORD - SEND OTP
  //
  // POST:
  // /auth/forgot-password
  //
  // BODY:
  // {
  //   "email": "example@gmail.com"
  // }
  // ============================================================

  Future<http.Response> forgotPassword(
    String email,
  ) async {
    final url = Uri.parse(
      "${ApiConstant.baseUrl}/auth/forgot-password",
    );

    final body = {
      "email": email.trim(),
    };

    print("=================================");
    print("FORGOT PASSWORD");
    print("URL: $url");
    print("BODY: ${jsonEncode(body)}");
    print("=================================");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(body),
    );

    print(
      "FORGOT PASSWORD STATUS: "
      "${response.statusCode}",
    );

    print(
      "FORGOT PASSWORD RESPONSE: "
      "${response.body}",
    );

    return response;
  }

  // ============================================================
  // VERIFY OTP
  //
  // POST:
  // /auth/change-password/verify-otp
  //
  // BODY:
  // {
  //   "email": "example@gmail.com",
  //   "otp": "123456"
  // }
  // ============================================================

  Future<http.Response> verifyOtp(
    String otp,
    String email,
  ) async {
    final url = Uri.parse(
      "${ApiConstant.baseUrl}/auth/change-password/verify-otp",
    );

    final body = {
      "email": email.trim(),
      "otp": otp.trim(),
    };

    print("=================================");
    print("VERIFY OTP");
    print("URL: $url");
    print("BODY: ${jsonEncode(body)}");
    print("=================================");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(body),
    );

    print(
      "VERIFY OTP STATUS: "
      "${response.statusCode}",
    );

    print(
      "VERIFY OTP RESPONSE: "
      "${response.body}",
    );

    return response;
  }

  // ============================================================
  // RESEND OTP
  // ============================================================

  Future<http.Response> resendOtp(
    String email,
  ) async {
    return await forgotPassword(email);
  }

  // ============================================================
  // NORMAL CHANGE PASSWORD
  //
  // Used when user is already logged in.
  //
  // POST:
  // /auth/change-password
  // ============================================================

  Future<http.Response> changePassword(
    String currentPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    final url = Uri.parse(
      "${ApiConstant.baseUrl}/auth/change-password",
    );

    final body = {
      "currentPassword": currentPassword,
      "newPassword": newPassword,
      "confirmPassword": confirmPassword,
    };

    final prefs =
        await SharedPreferences.getInstance();

    final token = prefs.getString("token");

    if (token == null || token.isEmpty) {
      return http.Response(
        jsonEncode({
          "message": "User is not logged in",
        }),
        401,
      );
    }

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(body),
    );

    return response;
  }

  // ============================================================
  // COMPLETE RESET PASSWORD
  //
  // POST:
  // /auth/change-password/complete?id=12
  //
  // BODY:
  // {
  //   "currentPassword": "newPassword1234",
  //   "newPassword": "newPassword12345",
  //   "confirmPassword": "newPassword12345"
  // }
  // ============================================================

  Future<http.Response> completeResetPassword(
    int id,
    String currentPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    final url = Uri.parse(
      "${ApiConstant.baseUrl}/auth/change-password/complete?id=$id",
    );

    final body = {
      "currentPassword": currentPassword,
      "newPassword": newPassword,
      "confirmPassword": confirmPassword,
    };

    print("=================================");
    print("COMPLETE RESET PASSWORD");
    print("URL: $url");
    print("ID: $id");
    print("BODY: ${jsonEncode(body)}");
    print("=================================");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(body),
    );

    print("=================================");
    print("RESET PASSWORD RESULT");
    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");
    print("=================================");

    return response;
  }

  // ============================================================
  // OLD RESET PASSWORD
  // ============================================================

  Future<http.Response> resetPassword(
    ResetPasswordRequest request,
  ) async {
    final url = Uri.parse(
      "${ApiConstant.baseUrl}/auth/change-password/request-otp",
    );

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(
        request.toJson(),
      ),
    );

    return response;
  }
}