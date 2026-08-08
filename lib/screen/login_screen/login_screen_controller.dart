// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class LoginScreenController extends GetxController {
//   // Add your reactive variables here (e.g., text controllers or loading states)
//   final count = 0.obs;
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   bool isObsecure = true;
//   void togglePasswordVisibility(VoidCallback updateUi){
//     isObsecure = !isObsecure;
//     updateUi();
//   }
//   void dispose() {
//     emailController.dispose();
//     passwordController.dispose();
//   }

//   @override
//   void onInit() {
//     super.onInit();
//   }

//   @override
//   void onReady() {
//     super.onReady();
//   }

//   @override
//   void onClose() {
//     super.onClose();
//   }

//   void increment() => count.value++;
// }
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/api/auth_service.dart';
import 'package:flutter_application_ecommerce/api/request_service/login_request.dart';

import 'package:get/get.dart';


class LoginScreenController extends GetxController {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final AuthService authService = AuthService();

  var loading = false.obs;

  bool isObsecure = true;

  Future<void> login() async {

    loading.value = true;

    final request = LoginRequest(
      username: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    final response = await authService.login(request);

    loading.value = false;

    if(response.statusCode == 200){

      final data = jsonDecode(response.body);

     Get.snackbar(
  "Success",
  "Login successful!",
);

      print(data);

    }else{

      Get.snackbar(
        "Error",
        response.body,
      );

    }

  }

}