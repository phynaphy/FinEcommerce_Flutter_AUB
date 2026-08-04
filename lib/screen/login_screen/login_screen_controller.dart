import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreenController extends GetxController {
  // Add your reactive variables here (e.g., text controllers or loading states)
  final count = 0.obs;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isObsecure = true;
  void togglePasswordVisibility(VoidCallback updateUi){
    isObsecure = !isObsecure;
    updateUi();
  }
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}