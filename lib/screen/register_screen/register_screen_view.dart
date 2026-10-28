import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/color/Premium_fintech_color.dart';
import 'package:flutter_application_ecommerce/screen/Textfield/custom_textfield.dart';
import 'package:flutter_application_ecommerce/screen/login_screen/login_screen_view.dart';
import 'package:flutter_application_ecommerce/screen/register_screen/register_screen_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RegisterScreenView extends StatefulWidget {
  const RegisterScreenView({super.key});

  @override
  State<RegisterScreenView> createState() => _RegisterScreenViewState();
}

class _RegisterScreenViewState extends State<RegisterScreenView> {
  final RegisterScreenController controller = RegisterScreenController();

  // Username is managed directly in this file.
  final TextEditingController usernameController = TextEditingController();

  bool isTermsAccepted = false;
  bool isLoading = false;

  // Android emulator uses 10.0.2.2.
  // Flutter Web and Windows desktop use localhost.
  String get baseUrl {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://192.168.56.1:8080';
    }
    return 'http://192.168.56.1:8080';
  }

  Future<void> register() async {
    final username = usernameController.text.trim();
    final fullName = controller.fullnameController.text.trim();
    final email = controller.emailController.text.trim();
    final phoneNumber = controller.phoneNumberController.text.trim();
    final password = controller.passwordController.text;
    final confirmPassword = controller.comfirmpassController.text;

    // Validate required fields.
    if (username.isEmpty ||
        fullName.isEmpty ||
        email.isEmpty ||
        phoneNumber.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      Get.snackbar(
        'Required Fields',
        'Please fill in all fields.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        'Invalid Email',
        'Please enter a valid email address.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (password.length < 8) {
      Get.snackbar(
        'Invalid Password',
        'Password must contain at least 8 characters.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar(
        'Password Mismatch',
        'Password and confirm password do not match.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!isTermsAccepted) {
      Get.snackbar(
        'Terms Required',
        'Please accept the Terms of Service and Privacy Policy.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final uri = Uri.parse('$baseUrl/api/v1/mobile/auth/register');

      final response = await http
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'username': username,
              'email': email,
              'password': password,
              'confirmPassword': confirmPassword,
              'fullName': fullName,
              'phoneNumber': phoneNumber,
            }),
          )
          .timeout(const Duration(seconds: 30));

      dynamic responseData;
      try {
        responseData = jsonDecode(response.body);
      } catch (_) {
        responseData = null;
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (!mounted) return;

        Get.snackbar(
          'Success',
          responseData is Map
              ? (responseData['message']?.toString() ??
                  'Account created successfully.')
              : 'Account created successfully.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.off(() => LoginScreenView());
      } else {
        String errorMessage = 'Registration failed. Please try again.';

        if (responseData is Map) {
          errorMessage =
              responseData['message']?.toString() ??
              responseData['error']?.toString() ??
              errorMessage;
        } else if (response.body.isNotEmpty) {
          errorMessage = response.body;
        }

        Get.snackbar(
          'Registration Failed (${response.statusCode})',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Connection Error',
        'Could not connect to the server. Check that your backend is running.\n$e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF1E293B),
                      ),
                      onPressed: () {
                        Get.off(() => LoginScreenView());
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    Row(
                      children: [
                        Text(
                          'FinEcommerce',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: PremiumFintechColor.primaryColor,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.verified_user_outlined,
                          size: 18,
                          color: PremiumFintechColor.primaryColor,
                        ),
                      ],
                    ),
                    const Text(
                      'Secure\nSetup',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 11,
                        color: PremiumFintechColor.primaryColor,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CREATE ACCOUNT',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Please fill in your details to get started.',
                        style: TextStyle(
                          fontSize: 14,
                          color: PremiumFintechColor.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 20),

                      _buildFieldLabel('Username'),
                      CustomTextField(
                        controller: usernameController,
                        hintText: 'Please enter username',
                        prefixIcon: const Icon(
                          Icons.account_circle_outlined,
                          size: 20,
                          color: PremiumFintechColor.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 14),

                      _buildFieldLabel('Full Name'),
                      CustomTextField(
                        controller: controller.fullnameController,
                        hintText: 'Please input full name',
                        prefixIcon: const Icon(
                          Icons.person_outline,
                          size: 20,
                          color: PremiumFintechColor.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 14),

                      _buildFieldLabel('Email Address'),
                      CustomTextField(
                        controller: controller.emailController,
                        hintText: 'Please input email address',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          size: 20,
                          color: PremiumFintechColor.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 14),

                      _buildFieldLabel('Phone Number'),
                      CustomTextField(
                        controller: controller.phoneNumberController,
                        hintText: 'Please enter phone number',
                        keyboardType: TextInputType.phone,
                        prefixIcon: const Icon(
                          Icons.phone_outlined,
                          size: 20,
                          color: PremiumFintechColor.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 14),

                      _buildFieldLabel('Password'),
                      CustomTextField(
                        controller: controller.passwordController,
                        hintText: 'Please enter password',
                        isObscure: controller.isObscure,
                        keyboardType: TextInputType.visiblePassword,
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          size: 20,
                          color: PremiumFintechColor.primaryColor,
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              controller.isObscure =
                                  !controller.isObscure;
                            });
                          },
                          child: Icon(
                            controller.isObscure
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 20,
                            color: PremiumFintechColor.primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Must be at least 8 characters.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                      const SizedBox(height: 14),

                      _buildFieldLabel('Confirm Password'),
                      CustomTextField(
                        controller: controller.comfirmpassController,
                        hintText: 'Please confirm password',
                        isObscure: controller.isObscure,
                        keyboardType: TextInputType.visiblePassword,
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          size: 20,
                          color: PremiumFintechColor.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: Checkbox(
                              value: isTermsAccepted,
                              activeColor: PremiumFintechColor.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  isTermsAccepted = value ?? false;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF475569),
                                ),
                                children: [
                                  const TextSpan(
                                    text: 'I agree to the ',
                                  ),
                                  TextSpan(
                                    text: 'Terms of Service',
                                    style: TextStyle(
                                      color: PremiumFintechColor.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const TextSpan(text: ' and '),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: TextStyle(
                                      color: PremiumFintechColor.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const TextSpan(text: '.'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                PremiumFintechColor.primaryColor,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor:
                                PremiumFintechColor.primaryColor
                                    .withOpacity(0.6),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      'Register',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(
                                      Icons.arrow_forward,
                                      size: 18,
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      Row(
                        children: const [
                          Expanded(
                            child: Divider(
                              color: Color(0xFFE2E8F0),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              'OR',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Color(0xFFE2E8F0),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            child: _buildSocialButton(
                              label: 'Google',
                              icon: Image.network(
                                'https://images.icon-icons.com/2642/PNG/512/google_logo_g_logo_icon_159348.png',
                                height: 18,
                                width: 18,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(
                                      Icons.g_mobiledata,
                                      size: 20,
                                    ),
                              ),
                              onTap: () {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildSocialButton(
                              label: 'Apple',
                              icon: const Icon(
                                Icons.apple,
                                size: 20,
                                color: Colors.black,
                              ),
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account? ',
                            style: TextStyle(
                              fontSize: 13,
                              color: PremiumFintechColor.primaryColor,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.off(() => LoginScreenView());
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 13,
                                color: PremiumFintechColor.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.verified_user_outlined,
                            size: 13,
                            color: Color(0xFF94A3B8),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'VERIFIED SECURE CONNECTION',
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFF94A3B8),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF334155),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required String label,
    required Widget icon,
    required VoidCallback onTap,
  }) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10),
        side: const BorderSide(color: Color(0xFFCBD5E1)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }
}