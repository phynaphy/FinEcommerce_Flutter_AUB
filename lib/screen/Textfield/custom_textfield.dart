import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/color/Premium_fintech_color.dart';

// --- MAIN LOGIN SCREEN ---
class LoginScreenView extends StatefulWidget {
  const LoginScreenView({super.key});

  @override
  State<LoginScreenView> createState() => _LoginScreenViewState();
}

class _LoginScreenViewState extends State<LoginScreenView> {
  // State variables for controllers stay here!
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              // Email Field Usage
              CustomTextField(
                controller: _emailController,
                hintText: "Email Address",
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              
              // Password Field Usage
              CustomTextField(
                controller: _passwordController,
                hintText: "Password",
                isObscure: _isObscure,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    color: const Color(0xFF64748B),
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- REUSABLE TEXT FIELD WIDGET ---
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isObscure;
  final Widget? suffixIcon; // Fixed naming to lower camelCase
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isObscure = false,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 14, color: Color(0xFF0F172A)),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: PremiumFintechColor.primaryColor
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: PremiumFintechColor.primaryColor,
            width: 1.8,
          ),
        ),
      ),
    );
  }
}