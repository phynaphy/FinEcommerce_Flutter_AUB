import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/api/auth_service.dart';
import 'change_password_view.dart';

class VerifyOtpView extends StatefulWidget {
  final String email;

  const VerifyOtpView({
    super.key,
    required this.email,
  });

  @override
  State<VerifyOtpView> createState() =>
      _VerifyOtpViewState();
}

class _VerifyOtpViewState
    extends State<VerifyOtpView> {
  final _formKey =
      GlobalKey<FormState>();

  final _otpController =
      TextEditingController();

  bool _isLoading = false;

  static const Color primaryBlue =
      Color(0xFF003D91);

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  // ============================================================
  // VERIFY OTP
  // ============================================================

  Future<void> _verifyOtp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final otp =
          _otpController.text.trim();

      final email =
          widget.email.trim();

      print("=================================");
      print("VERIFY OTP");
      print("EMAIL: $email");
      print("OTP: $otp");
      print("=================================");

      final response =
          await AuthService().verifyOtp(
        otp,
        email,
      );

      print(
        "STATUS: ${response.statusCode}",
      );

      print(
        "BODY: ${response.body}",
      );

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      // ========================================================
      // SUCCESS
      // ========================================================

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        try {
          final data =
              jsonDecode(response.body);

          print(
            "OTP RESPONSE DATA: $data",
          );

          // ====================================================
          // GET ID FROM BACKEND
          // ====================================================

          int? id;

          if (data is Map<String, dynamic>) {
            // Example:
            // {"id": 12}

            if (data["id"] != null) {
              id = int.tryParse(
                data["id"].toString(),
              );
            }

            // In case backend uses userId
            if (id == null &&
                data["userId"] != null) {
              id = int.tryParse(
                data["userId"].toString(),
              );
            }

            // In case backend returns:
            // {"data": {"id": 12}}

            if (id == null &&
                data["data"] is Map) {
              final nested =
                  data["data"]
                      as Map;

              if (nested["id"] != null) {
                id = int.tryParse(
                  nested["id"].toString(),
                );
              }
            }

            // In case backend returns:
            // {"user": {"id": 12}}

            if (id == null &&
                data["user"] is Map) {
              final user =
                  data["user"] as Map;

              if (user["id"] != null) {
                id = int.tryParse(
                  user["id"].toString(),
                );
              }
            }
          }

          // ====================================================
          // ID NOT FOUND
          // ====================================================

          if (id == null) {
            ScaffoldMessenger.of(context)
                .showSnackBar(
              const SnackBar(
                content: Text(
                  "OTP verified, but user ID was not returned by the server.",
                ),
                backgroundColor:
                    Colors.red,
              ),
            );

            print(
              "❌ ID NOT FOUND IN RESPONSE",
            );

            return;
          }

          print(
            "=================================",
          );
          print(
            "OTP VERIFIED SUCCESSFULLY",
          );
          print("USER ID: $id");
          print(
            "=================================",
          );

          // ====================================================
          // GO TO CHANGE PASSWORD
          // ====================================================

          ScaffoldMessenger.of(context)
              .showSnackBar(
            const SnackBar(
              content: Text(
                "OTP verified successfully",
              ),
              backgroundColor:
                  Colors.green,
            ),
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ChangePasswordView(
                id: id!,
              ),
            ),
          );
        } catch (e) {
          print(
            "ERROR READING OTP RESPONSE: $e",
          );

          ScaffoldMessenger.of(context)
              .showSnackBar(
            SnackBar(
              content: Text(
                "Invalid server response: $e",
              ),
              backgroundColor:
                  Colors.red,
            ),
          );
        }
      }

      // ========================================================
      // INVALID OTP
      // ========================================================

      else {
        String message =
            "Invalid or expired OTP";

        try {
          if (response.body.isNotEmpty) {
            final data =
                jsonDecode(response.body);

            if (data is Map<String, dynamic>) {
              message =
                  data["message"]?.toString() ??
                  data["error"]?.toString() ??
                  message;
            }
          }
        } catch (e) {
          print(
            "ERROR PARSING OTP ERROR: $e",
          );
        }

        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      print(
        "VERIFY OTP ERROR: $e",
      );

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ============================================================
  // RESEND OTP
  // ============================================================

  Future<void> _resendOtp() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final email =
          widget.email.trim();

      print(
        "RESENDING OTP TO: $email",
      );

      final response =
          await AuthService().resendOtp(
        email,
      );

      print(
        "RESEND STATUS: "
        "${response.statusCode}",
      );

      print(
        "RESEND BODY: "
        "${response.body}",
      );

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
              "A new OTP code has been sent to $email",
            ),
            backgroundColor:
                Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              "Failed to resend OTP",
            ),
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

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
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
          "OTP Verification",
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),

        centerTitle: true,
      ),

      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.all(20),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                // ==================================================
                // EMAIL CARD
                // ==================================================

                Container(
                  width:
                      double.infinity,

                  padding:
                      const EdgeInsets.all(
                    20,
                  ),

                  decoration:
                      BoxDecoration(
                    gradient:
                        const LinearGradient(
                      colors: [
                        primaryBlue,
                        Color(0xFF002866),
                      ],
                      begin:
                          Alignment.topLeft,
                      end: Alignment
                          .bottomRight,
                    ),

                    borderRadius:
                        BorderRadius
                            .circular(
                      20,
                    ),

                    boxShadow: [
                      BoxShadow(
                        color:
                            primaryBlue
                                .withOpacity(
                          0.25,
                        ),
                        blurRadius: 15,
                        offset:
                            const Offset(
                          0,
                          8,
                        ),
                      ),
                    ],
                  ),

                  child: Row(
                    children: [
                      Container(
                        padding:
                            const EdgeInsets
                                .all(
                          12,
                        ),

                        decoration:
                            BoxDecoration(
                          color: Colors
                              .white
                              .withOpacity(
                            0.12,
                          ),
                          shape:
                              BoxShape.circle,
                        ),

                        child: const Icon(
                          Icons
                              .mark_email_read_outlined,
                          color:
                              Colors.white,
                          size: 26,
                        ),
                      ),

                      const SizedBox(
                        width: 16,
                      ),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            const Text(
                              "Code Sent",
                              style:
                                  TextStyle(
                                color:
                                    Colors.white,
                                fontSize:
                                    16,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),

                            const SizedBox(
                              height: 4,
                            ),

                            Text(
                              "We sent a 6-digit code to ${widget.email}.",
                              style:
                                  const TextStyle(
                                color:
                                    Color(
                                  0xFF93C5FD,
                                ),
                                fontSize:
                                    12,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 28,
                ),

                const Text(
                  "Enter Verification Code",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight:
                        FontWeight.w600,
                    color:
                        Color(0xFF0F172A),
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

                // ==================================================
                // OTP
                // ==================================================

                TextFormField(
                  controller:
                      _otpController,

                  keyboardType:
                      TextInputType.number,

                  maxLength: 6,

                  style:
                      const TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                    letterSpacing: 6,
                    color:
                        Color(0xFF0F172A),
                  ),

                  decoration:
                      InputDecoration(
                    counterText: "",
                    hintText: "000000",

                    hintStyle:
                        const TextStyle(
                      color:
                          Color(0xFF94A3B8),
                      fontSize: 16,
                      letterSpacing: 6,
                    ),

                    filled: true,
                    fillColor:
                        Colors.white,

                    prefixIcon:
                        const Icon(
                      Icons.pin_outlined,
                      color:
                          Color(0xFF64748B),
                    ),

                    enabledBorder:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius
                              .circular(
                        14,
                      ),
                      borderSide:
                          const BorderSide(
                        color:
                            Color(
                          0xFFE2E8F0,
                        ),
                      ),
                    ),

                    focusedBorder:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius
                              .circular(
                        14,
                      ),
                      borderSide:
                          const BorderSide(
                        color:
                            primaryBlue,
                        width: 2,
                      ),
                    ),
                  ),

                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return
                          "Please enter the code";
                    }

                    if (value.length !=
                        6) {
                      return
                          "Code must be 6 digits";
                    }

                    if (!RegExp(
                      r'^[0-9]+$',
                    ).hasMatch(value)) {
                      return
                          "Code must contain numbers only";
                    }

                    return null;
                  },
                ),

                Align(
                  alignment:
                      Alignment.centerRight,

                  child: TextButton(
                    onPressed:
                        _isLoading
                            ? null
                            : _resendOtp,

                    child: const Text(
                      "Didn't receive code? Resend",
                      style: TextStyle(
                        color:
                            primaryBlue,
                        fontWeight:
                            FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // ==================================================
                // VERIFY BUTTON
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
                            : _verifyOtp,

                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child:
                                CircularProgressIndicator(
                              color:
                                  Colors.white,
                              strokeWidth:
                                  2,
                            ),
                          )
                        : const Text(
                            "Verify & Continue",
                            style:
                                TextStyle(
                              fontSize:
                                  16,
                              fontWeight:
                                  FontWeight
                                      .bold,
                              color:
                                  Colors.white,
                            ),
                          ),
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}