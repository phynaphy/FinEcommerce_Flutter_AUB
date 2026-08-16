import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/api/auth_service.dart';
import 'package:flutter_application_ecommerce/screen/change&forget_password/VerifyOptView.dart';

class EmailInputView extends StatefulWidget {
  const EmailInputView({super.key});

  @override
  State<EmailInputView> createState() => _EmailInputViewState();
}

class _EmailInputViewState extends State<EmailInputView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  static const Color primaryBlue = Color(0xFF003D91);

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submitEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await AuthService().forgotPassword(
        _emailController.text.trim(),
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (!mounted) return;

      setState(() => _isLoading = false);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyOtpView(
              email: _emailController.text.trim(),
            ),
          ),
        );
      } else {
        String message = "Failed to send OTP";

        try {
          final data = jsonDecode(response.body);
          message = data["message"] ?? message;
        } catch (_) {}

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() => _isLoading = false);

      print("Forgot Password Error: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF0F172A), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Email Verification',
          style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Enter Your Email',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
                const SizedBox(height: 8),
                const Text(
                  'We will send a 6-digit verification code to your email address.',
                  style: TextStyle(fontSize: 14, color: Color(0xFF64748B), height: 1.4),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Email Address',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF0F172A)),
                  decoration: InputDecoration(
                    hintText: 'e.g. name@domain.com',
                    hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    prefixIcon: const Icon(Icons.mail_outline_rounded, color: Color(0xFF64748B), size: 20),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: primaryBlue, width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFFEF4444)),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Please enter your email address';
                    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!emailRegex.hasMatch(val.trim())) return 'Please enter a valid email address';
                    return null;
                  },
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      elevation: 4,
                      shadowColor: primaryBlue.withOpacity(0.35),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: _isLoading ? null : _submitEmail,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Text(
                            'Send OTP',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}