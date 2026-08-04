import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/color/Premium_fintech_color.dart';
import 'package:flutter_application_ecommerce/screen/Textfield/custom_textfield.dart';
import 'package:flutter_application_ecommerce/screen/login_screen/login_screen_controller.dart';
import 'package:get/get.dart';

class LoginScreenView extends StatefulWidget {
  LoginScreenView({super.key});

  @override
  State<LoginScreenView> createState() => _LoginScreenViewState();
}

class _LoginScreenViewState extends State<LoginScreenView> {
  final LoginScreenController controller = LoginScreenController();
  @override
  void dispose() {
    controller.dispose(); // Clean up controllers when screen is destroyed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 25,
                    height: 25,
                    // 1. ADD THIS LINE TO CLIP THE IMAGE TO THE BORDER RADIUS
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: PremiumFintechColor.primaryColor,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Image.network(
                      "https://i.pinimg.com/736x/e8/fb/a2/e8fba2f647fa4c0a40d462ef85e91af9.jpg",
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(width: 20),
                  Text(
                    "FinEcommerce",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: PremiumFintechColor.primaryColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              // designmian_login_card_container
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                  // Crisp border matching Tailwind / Material 3 card outline
                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                    width: 1.2,
                  ),
                  boxShadow: [
                    // 1. Direct crisp drop shadow (bottom edge outline shadow)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 2,
                      spreadRadius: 0,
                      offset: const Offset(0, 2),
                    ),
                    // 2. Wide ambient glow shadow (creates the floating card effect)
                    BoxShadow(
                      color: const Color(0xFF0F172A).withOpacity(0.12),
                      blurRadius: 30,
                      spreadRadius: -4,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Weolcome back",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Please enter your credentials to access your secure dashboard",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 15),
                      CustomTextField(
                        controller: controller.emailController,
                        hintText: "Email Adress",
                        keyboardType: TextInputType.emailAddress,
                        suffixIcon: Icon(
                          Icons.email_outlined,
                          color: PremiumFintechColor.primaryColor,
                        ),
                      ),
                      SizedBox(height: 10),
 CustomTextField(
  controller: controller.passwordController, // Fixed controller binding
  hintText: "Password",
  isObscure: controller.isObsecure,
  keyboardType: TextInputType.visiblePassword,
  suffixIcon: GestureDetector(
    onTap: () {
      setState(() {
        controller.isObsecure = !controller.isObsecure;
      });
    },
    child: Icon(
      controller.isObsecure
          ? Icons.visibility_outlined
          : Icons.visibility_off_outlined,
      color: PremiumFintechColor.primaryColor,
    ),
  ),
),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
