import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/api/auth_service.dart';
import 'package:flutter_application_ecommerce/api/request_service/login_request.dart';
import 'package:flutter_application_ecommerce/screen/home_screen/homescreen_view.dart';
import 'package:get/get.dart';


class LoginScreenController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final AuthService authService = AuthService();

  var loading = false.obs;
  var isObsecure = true.obs;

  void togglePasswordVisibility() {
    isObsecure.value = !isObsecure.value;
  }

  Future<void> login() async {
    if (emailController.text.trim().isEmpty || passwordController.text.trim().isEmpty) {
      Get.snackbar(
        "Warning",
        "Please fill in all fields",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    loading.value = true;

    try {
      final request = LoginRequest(
        username: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final response = await authService.login(request);

      loading.value = false;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        Get.snackbar(
          "Success",
          "Login successful!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        print(data);

        // 2. NAVIGATE TO HOME SCREEN
        Get.offAll(() => const HomescreenView());

      } else {
        Get.snackbar(
          "Error",
          response.body.isNotEmpty ? response.body : "Login failed",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      loading.value = false;
      Get.snackbar(
        "Error",
        "An unexpected error occurred: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}