
import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/api/auth_service.dart';
import 'package:flutter_application_ecommerce/api/request_service/reset_password_request.dart';


class ResetPasswordController {
  final emailController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final AuthService authService = AuthService();

  bool isObscure = true;

  Future<bool> resetPassword() async {
    final request = ResetPasswordRequest(
      email: emailController.text.trim(),
      newPassword: newPasswordController.text,
      confirmPassword: confirmPasswordController.text,
    );

    final response = await authService.resetPassword(request);

    print("Status Code: ${response.statusCode}");
    print("Response: ${response.body}");

    return response.statusCode >= 200 &&
        response.statusCode < 300;
  }

  void dispose() {
    emailController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
  }
}
