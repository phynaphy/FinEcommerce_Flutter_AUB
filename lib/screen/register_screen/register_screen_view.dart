import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/color/Premium_fintech_color.dart';
import 'package:flutter_application_ecommerce/screen/Textfield/custom_textfield.dart';
import 'package:flutter_application_ecommerce/screen/login_screen/login_screen_view.dart';
import 'package:flutter_application_ecommerce/screen/register_screen/register_screen_controller.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class RegisterScreenView extends StatefulWidget {
  const RegisterScreenView({super.key});

  @override
  State<RegisterScreenView> createState() => _RegisterScreenViewState();
}

class _RegisterScreenViewState extends State<RegisterScreenView> {
  final RegisterScreenController controller = RegisterScreenController();
  bool isTermsAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              children: [
               
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
                      onPressed: () {
                       Get.off(() =>  LoginScreenView());
                        
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    Row(
                      children: [
                        Text(
                          "FinEcommerce",
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
                      "Secure\nSetup",
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
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
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
                      // Title & Subtitle
                      const Text(
                        "CREATE ACCOUNT",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Please fill in your details to get started.",
                        style: TextStyle(
                          fontSize: 14,
                          color: PremiumFintechColor.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 1. Full Name Field
                      _buildFieldLabel("Full Name",),
                      CustomTextField(
                        
                        controller: controller.fullnameController,
                        hintText: "Please Input FullName",
                        prefixIcon: const Icon(Icons.person_outline, size: 20, color: PremiumFintechColor.primaryColor),
                      ),
                      const SizedBox(height: 14),

                      // 2. Email Address Field
                      _buildFieldLabel("Email Address"),
                      CustomTextField(
                        controller: controller.emailController,
                        hintText: "Please Input EmailAddress",
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(Icons.email_outlined, size: 20, color: PremiumFintechColor.primaryColor),
                      ),
                      const SizedBox(height: 14),

                      // 3. Phone Number Field
                      _buildFieldLabel("Phone Number"),
                      CustomTextField(
                        controller: controller.phoneNumberController,
                        hintText: "Please Enter Phone Number",
                        keyboardType: TextInputType.phone,
                        prefixIcon: const Icon(Icons.phone_outlined, size: 20, color: PremiumFintechColor.primaryColor),
                      ),
                      const SizedBox(height: 14),

                      // 4. Password Field
                      _buildFieldLabel("Password"),
                      CustomTextField(
                        controller: controller.passwordController,
                        hintText: "Please Password",
                        isObscure: controller.isObscure,
                        keyboardType: TextInputType.visiblePassword,
                        prefixIcon: const Icon(Icons.lock_outline, size: 20, color: PremiumFintechColor.primaryColor),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              controller.isObscure = !controller.isObscure;
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
                        "Must be at least 8 characters with a symbol.",
                        style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                      ),
                      const SizedBox(height: 14),

                      // 5. Confirm Password Field
                      _buildFieldLabel("Confirm Password"),
                      CustomTextField(
                        controller: controller.comfirmpassController,
                        hintText: "Please Enter Comfirm Password",
                        isObscure: controller.isObscure,
                        keyboardType: TextInputType.visiblePassword,
                        prefixIcon: const Icon(Icons.lock_outline, size: 20, color: PremiumFintechColor.primaryColor),
                      ),
                      const SizedBox(height: 16),

                      // Terms & Conditions Checkbox
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
                              onChanged: (val) {
                                setState(() {
                                  isTermsAccepted = val ?? false;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(fontSize: 12, color: Color(0xFF475569)),
                                children: [
                                  const TextSpan(text: "I agree to the "),
                                  TextSpan(
                                    text: "Terms of Service",
                                    style: TextStyle(
                                      color: PremiumFintechColor.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const TextSpan(text: " and "),
                                  TextSpan(
                                    text: "Privacy Policy",
                                    style: TextStyle(
                                      color: PremiumFintechColor.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const TextSpan(text: "."),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Register Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: PremiumFintechColor.primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                "Register",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, size: 18),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Divider "OR"
                      Row(
                        children: const [
                          Expanded(child: Divider(color: Color(0xFFE2E8F0))),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "OR",
                              style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                            ),
                          ),
                          Expanded(child: Divider(color: Color(0xFFE2E8F0))),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Social Buttons (Google & Apple)
                      Row(
                        children: [
                          Expanded(
                            child: _buildSocialButton(
                              label: "Google",
                              icon: Image.network(
                                "https://images.icon-icons.com/2642/PNG/512/google_logo_g_logo_icon_159348.png",
                                height: 18,
                                width: 18,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.g_mobiledata, size: 20),
                              ),
                              onTap: () {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildSocialButton(
                              label: "Apple",
                              icon: const Icon(Icons.apple, size: 20, color: Colors.black),
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Already have an account? Login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account? ",
                            style: TextStyle(fontSize: 13, color: PremiumFintechColor.primaryColor),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              "Login",
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

                      // Bottom Security Connection Badge
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
                            "VERIFIED SECURE CONNECTION",
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

  // Label builder helper for text inputs
  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
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

  // Social Login Button builder
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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