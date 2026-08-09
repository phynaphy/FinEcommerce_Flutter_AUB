import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/api/auth_service.dart';

class ChangePasswordView extends StatefulWidget {
  final int id;

  const ChangePasswordView({
    super.key,
    required this.id,
  });

  @override
  State<ChangePasswordView> createState() =>
      _ChangePasswordViewState();
}

class _ChangePasswordViewState
    extends State<ChangePasswordView> {
  final _formKey =
      GlobalKey<FormState>();

  // ============================================================
  // CONTROLLERS
  // ============================================================

  final _currentPasswordController =
      TextEditingController();

  final _newPasswordController =
      TextEditingController();

  final _confirmPasswordController =
      TextEditingController();

  // ============================================================
  // VISIBILITY
  // ============================================================

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  // ============================================================
  // LOADING
  // ============================================================

  bool _isLoading = false;

  // ============================================================
  // PASSWORD REQUIREMENTS
  // ============================================================

  bool _hasMinLength = false;
  bool _hasNumber = false;
  bool _hasSpecialChar = false;

  static const Color primaryBlue =
      Color(0xFF003D91);

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _newPasswordController.addListener(
      _validatePasswordRequirements,
    );
  }

  // ============================================================
  // PASSWORD VALIDATION
  // ============================================================

  void _validatePasswordRequirements() {
    final text =
        _newPasswordController.text;

    if (!mounted) return;

    setState(() {
      _hasMinLength =
          text.length >= 8;

      _hasNumber =
          RegExp(r'[0-9]')
              .hasMatch(text);

      _hasSpecialChar =
          RegExp(
        r'[!@#$%^&*(),.?":{}|<>]',
      ).hasMatch(text);
    });
  }

  // ============================================================
  // CHANGE PASSWORD
  // ============================================================

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final int id = widget.id;

    final currentPassword =
        _currentPasswordController
            .text
            .trim();

    final newPassword =
        _newPasswordController
            .text
            .trim();

    final confirmPassword =
        _confirmPasswordController
            .text
            .trim();

    setState(() {
      _isLoading = true;
    });

    try {
      print("=================================");
      print("COMPLETE RESET PASSWORD");
      print("ID: $id");
      print(
        "Current Password: ********",
      );
      print(
        "New Password: ********",
      );
      print(
        "Confirm Password: ********",
      );
      print("=================================");

      final response =
          await AuthService()
              .completeResetPassword(
        id,
        currentPassword,
        newPassword,
        confirmPassword,
      );

      print("=================================");
      print("RESET PASSWORD RESULT");
      print(
        "STATUS: ${response.statusCode}",
      );
      print(
        "BODY: ${response.body}",
      );
      print("=================================");

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      // ========================================================
      // SUCCESS
      // ========================================================

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              "Password changed successfully!",
            ),
            backgroundColor:
                Color(0xFF10B981),
          ),
        );

        // Go back
        Navigator.pop(context);
      }

      // ========================================================
      // ERROR
      // ========================================================

      else {
        String message =
            "Failed to change password.";

        try {
          if (response.body.isNotEmpty) {
            final data =
                jsonDecode(response.body);

            if (data is Map<String, dynamic>) {
              message =
                  data["message"]
                          ?.toString() ??
                      data["error"]
                          ?.toString() ??
                      message;
            }
          }
        } catch (e) {
          print(
            "ERROR PARSING RESPONSE: $e",
          );
        }

        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor:
                Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      print(
        "RESET PASSWORD ERROR: $e",
      );

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "Error: $e",
          ),
          backgroundColor:
              Colors.red,
        ),
      );
    }
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF8FAFC),

      appBar: AppBar(
        backgroundColor:
            Colors.transparent,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF0F172A),
            size: 20,
          ),
          onPressed: () =>
              Navigator.pop(context),
        ),

        title: const Text(
          "Change Password",
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),

        centerTitle: true,
      ),

      body: SingleChildScrollView(
        physics:
            const BouncingScrollPhysics(),

        padding:
            const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),

        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              const Text(
                "Change Your Password",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight:
                      FontWeight.bold,
                  color:
                      Color(0xFF0F172A),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Create a new password for your account.",
                style: TextStyle(
                  fontSize: 14,
                  color:
                      Color(0xFF64748B),
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 28),

              // ==================================================
              // CURRENT PASSWORD
              // ==================================================

              const Text(
                "Current Password",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight:
                      FontWeight.w600,
                  color:
                      Color(0xFF0F172A),
                ),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller:
                    _currentPasswordController,

                obscureText:
                    _obscureCurrent,

                decoration:
                    _buildInputDecoration(
                  hintText:
                      "Enter current password",

                  prefixIcon:
                      Icons.lock_outline_rounded,

                  obscureText:
                      _obscureCurrent,

                  onToggleVisibility: () {
                    setState(() {
                      _obscureCurrent =
                          !_obscureCurrent;
                    });
                  },
                ),

                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return
                        "Please enter your current password";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              // ==================================================
              // NEW PASSWORD
              // ==================================================

              const Text(
                "New Password",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight:
                      FontWeight.w600,
                  color:
                      Color(0xFF0F172A),
                ),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller:
                    _newPasswordController,

                obscureText:
                    _obscureNew,

                decoration:
                    _buildInputDecoration(
                  hintText:
                      "Enter new password",

                  prefixIcon:
                      Icons.lock_reset_rounded,

                  obscureText:
                      _obscureNew,

                  onToggleVisibility: () {
                    setState(() {
                      _obscureNew =
                          !_obscureNew;
                    });
                  },
                ),

                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return
                        "Please enter a new password";
                  }

                  if (!_hasMinLength ||
                      !_hasNumber ||
                      !_hasSpecialChar) {
                    return
                        "Password does not meet requirements";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              // ==================================================
              // CONFIRM PASSWORD
              // ==================================================

              const Text(
                "Confirm New Password",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight:
                      FontWeight.w600,
                  color:
                      Color(0xFF0F172A),
                ),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller:
                    _confirmPasswordController,

                obscureText:
                    _obscureConfirm,

                decoration:
                    _buildInputDecoration(
                  hintText:
                      "Re-enter new password",

                  prefixIcon:
                      Icons
                          .check_circle_outline_rounded,

                  obscureText:
                      _obscureConfirm,

                  onToggleVisibility: () {
                    setState(() {
                      _obscureConfirm =
                          !_obscureConfirm;
                    });
                  },
                ),

                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return
                        "Please confirm your new password";
                  }

                  if (value !=
                      _newPasswordController
                          .text) {
                    return
                        "Passwords do not match";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 24),

              // ==================================================
              // REQUIREMENTS
              // ==================================================

              Container(
                padding:
                    const EdgeInsets.all(16),

                decoration:
                    BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                      BorderRadius.circular(
                    16,
                  ),

                  border: Border.all(
                    color:
                        const Color(
                      0xFFE2E8F0,
                    ),
                  ),
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    const Text(
                      "Password Requirements:",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            FontWeight.w600,
                        color:
                            Color(0xFF475569),
                      ),
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    _buildRequirementRow(
                      "At least 8 characters long",
                      _hasMinLength,
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    _buildRequirementRow(
                      "Contains at least one number (0-9)",
                      _hasNumber,
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    _buildRequirementRow(
                      "Contains a special character (!@#\$%)",
                      _hasSpecialChar,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ==================================================
              // BUTTON
              // ==================================================

              SizedBox(
                width:
                    double.infinity,
                height: 52,

                child:
                    ElevatedButton(
                  style:
                      ElevatedButton
                          .styleFrom(
                    backgroundColor:
                        primaryBlue,

                    elevation: 4,

                    shadowColor:
                        primaryBlue
                            .withOpacity(
                      0.35,
                    ),

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius
                              .circular(
                        16,
                      ),
                    ),
                  ),

                  onPressed:
                      _isLoading
                          ? null
                          : _changePassword,

                  child: _isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child:
                              CircularProgressIndicator(
                            color:
                                Colors.white,
                            strokeWidth:
                                2,
                          ),
                        )
                      : const Text(
                          "Change Password",
                          style:
                              TextStyle(
                            fontSize: 16,
                            fontWeight:
                                FontWeight
                                    .bold,
                            color:
                                Colors.white,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // INPUT DECORATION
  // ============================================================

  InputDecoration _buildInputDecoration({
    required String hintText,
    required IconData prefixIcon,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
  }) {
    return InputDecoration(
      hintText: hintText,

      hintStyle:
          const TextStyle(
        color:
            Color(0xFF94A3B8),
        fontSize: 14,
      ),

      filled: true,
      fillColor: Colors.white,

      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),

      prefixIcon: Icon(
        prefixIcon,
        color:
            const Color(0xFF64748B),
        size: 20,
      ),

      suffixIcon:
          IconButton(
        icon: Icon(
          obscureText
              ? Icons
                  .visibility_off_outlined
              : Icons
                  .visibility_outlined,

          color:
              const Color(0xFF94A3B8),

          size: 20,
        ),

        onPressed:
            onToggleVisibility,
      ),

      enabledBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(14),

        borderSide:
            const BorderSide(
          color:
              Color(0xFFE2E8F0),
        ),
      ),

      focusedBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(14),

        borderSide:
            const BorderSide(
          color: primaryBlue,
          width: 2,
        ),
      ),

      errorBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(14),

        borderSide:
            const BorderSide(
          color:
              Color(0xFFEF4444),
        ),
      ),

      focusedErrorBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(14),

        borderSide:
            const BorderSide(
          color:
              Color(0xFFEF4444),
          width: 2,
        ),
      ),
    );
  }

  // ============================================================
  // PASSWORD REQUIREMENT ROW
  // ============================================================

  Widget _buildRequirementRow(
    String label,
    bool isMet,
  ) {
    return Row(
      children: [
        AnimatedContainer(
          duration:
              const Duration(
            milliseconds: 250,
          ),

          width: 18,
          height: 18,

          decoration:
              BoxDecoration(
            shape:
                BoxShape.circle,

            color: isMet
                ? const Color(
                    0xFF10B981,
                  )
                : const Color(
                    0xFFCBD5E1,
                  ),
          ),

          child: Icon(
            isMet
                ? Icons.check
                : Icons.close,

            color:
                Colors.white,

            size: 12,
          ),
        ),

        const SizedBox(
          width: 10,
        ),

        Expanded(
          child: Text(
            label,

            style:
                TextStyle(
              fontSize: 12,

              color: isMet
                  ? const Color(
                      0xFF0F172A,
                    )
                  : const Color(
                      0xFF64748B,
                    ),

              fontWeight: isMet
                  ? FontWeight.w600
                  : FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}