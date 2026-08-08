
import 'dart:convert';

import 'package:flutter_application_ecommerce/api/api_constant.dart';

import 'package:flutter_application_ecommerce/api/request_service/login_request.dart';
import 'package:flutter_application_ecommerce/api/request_service/register_request.dart';
import 'package:flutter_application_ecommerce/api/request_service/reset_password_request.dart';
import 'package:http/http.dart' as http;

class AuthService {

  // =========================
  // LOGIN
  // =========================
  Future<http.Response> login(LoginRequest request) async {
    final url = Uri.parse(
      "${ApiConstant.baseUrl}/auth/login",
    );

    return await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(request.toJson()),
    );
  }

  // =========================
  // REGISTER
  // =========================
  Future<http.Response> register(RegisterRequest request) async {
    final url = Uri.parse(
      "${ApiConstant.baseUrl}/auth/register",
    );

    return await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(request.toJson()),
    );
  }

// Reset Password
Future<http.Response> resetPassword(
  ResetPasswordRequest request,
) async {
  final url = Uri.parse(
    "${ApiConstant.baseUrl}/auth/reset-password",
  );

  return await http.post(
    url,
    headers: {
      "Content-Type": "application/json",
    },
    body: jsonEncode(request.toJson()),
  );
}


}

