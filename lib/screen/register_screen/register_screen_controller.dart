import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/api/auth_service.dart';

import 'package:flutter_application_ecommerce/api/request_service/register_request.dart';

class RegisterScreenController {
  final fullnameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final comfirmpassController = TextEditingController();

  bool isObscure = true;

  final AuthService authService = AuthService();

  Future<void> register() async {

    final request = RegisterRequest(
      username: fullnameController.text.trim(),
      email: emailController.text.trim(),
      fullName: fullnameController.text.trim(),
      password: passwordController.text,
      confirmPassword: comfirmpassController.text,
    );

    final response = await authService.register(request);

    print("Status Code: ${response.statusCode}");
    print("Response: ${response.body}");

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      print("Registration successful!");
    } else {
      print("Registration failed!");
    }
  }

  void dispose() {
    fullnameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    comfirmpassController.dispose();
  }
}