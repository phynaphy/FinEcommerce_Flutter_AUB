import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreenController extends GetxController {
  
  // TODO: Implement LoginController
    final TextEditingController fullnameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController= TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController comfirmpassController = TextEditingController();
   bool isObscure = true;


  final count = 0.obs;
     @override
  void dispose() {
    fullnameController.dispose();
    emailController.dispose();
    phoneNumberController .dispose();
    passwordController.dispose();
    comfirmpassController.dispose();
    

    super.dispose();
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