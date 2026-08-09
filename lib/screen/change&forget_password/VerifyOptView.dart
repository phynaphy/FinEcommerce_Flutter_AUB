// import 'package:flutter/material.dart';
// import 'package:flutter_application_ecommerce/api/auth_service.dart';
// import 'change_password_view.dart'; // Ensure correct import path

// class VerifyOtpView extends StatefulWidget {
//   final String email;

//   const VerifyOtpView({
//     super.key,
//     required this.email,
//   });

//   @override
//   State<VerifyOtpView> createState() => _VerifyOtpViewState();
// }

// class _VerifyOtpViewState extends State<VerifyOtpView> {
//   final _formKey = GlobalKey<FormState>();
//   final _otpController = TextEditingController();
//   bool _isLoading = false;

//   static const Color primaryBlue = Color(0xFF003D91);

//   @override
//   void dispose() {
//     _otpController.dispose();
//     super.dispose();
//   }

// void _verifyOtp() async {
//   if (!_formKey.currentState!.validate()) return;

//   setState(() => _isLoading = true);

//   try {
//    final response = await AuthService().verifyOtp(
//   _otpController.text.trim(),
//   widget.email,
// );

//     print("OTP Status: ${response.statusCode}");
//     print("OTP Response: ${response.body}");

//     if (!mounted) return;

//     setState(() => _isLoading = false);

//     if (response.statusCode == 200) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ChangePasswordView(
//             email: widget.email,
//           ),
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Invalid or expired OTP"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   } catch (e) {
//     if (!mounted) return;

//     setState(() => _isLoading = false);

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text("Error: $e"),
//         backgroundColor: Colors.red,
//       ),
//     );
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF0F172A), size: 20),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'OTP Verification',
//           style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 18),
//         ),
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Email Banner Card
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     gradient: const LinearGradient(
//                       colors: [primaryBlue, Color(0xFF002866)],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(
//                         color: primaryBlue.withOpacity(0.25),
//                         blurRadius: 15,
//                         offset: const Offset(0, 8),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.12),
//                           shape: BoxShape.circle,
//                           border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
//                         ),
//                         child: const Icon(Icons.mark_email_read_outlined, color: Colors.white, size: 26),
//                       ),
//                       const SizedBox(width: 16),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'Code Sent',
//                               style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               'We sent a 6-digit code to ${widget.email}.',
//                               style: const TextStyle(color: Color(0xFF93C5FD), fontSize: 12, height: 1.3),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 28),
//                 const Text(
//                   'Enter Verification Code',
//                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
//                 ),
//                 const SizedBox(height: 8),
//                 TextFormField(
//                   controller: _otpController,
//                   keyboardType: TextInputType.number,
//                   maxLength: 6,
//                   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 6, color: Color(0xFF0F172A)),
//                   decoration: InputDecoration(
//                     counterText: '',
//                     hintText: '000000',
//                     hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 16, letterSpacing: 6, fontWeight: FontWeight.normal),
//                     filled: true,
//                     fillColor: Colors.white,
//                     contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                     prefixIcon: const Icon(Icons.pin_outlined, color: Color(0xFF64748B), size: 20),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(14),
//                       borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(14),
//                       borderSide: const BorderSide(color: primaryBlue, width: 2),
//                     ),
//                     errorBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(14),
//                       borderSide: const BorderSide(color: Color(0xFFEF4444)),
//                     ),
//                     focusedErrorBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(14),
//                       borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
//                     ),
//                   ),
//                   validator: (val) {
//                     if (val == null || val.isEmpty) return 'Please enter the code';
//                     if (val.length < 6) return 'Code must be 6 digits';
//                     return null;
//                   },
//                 ),
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: TextButton(
//                     onPressed: () {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('A new OTP code has been sent to ${widget.email}')),
//                       );
//                     },
//                     child: const Text(
//                       "Didn't receive code? Resend",
//                       style: TextStyle(color: primaryBlue, fontWeight: FontWeight.w600, fontSize: 13),
//                     ),
//                   ),
//                 ),
//                 const Spacer(),
//                 SizedBox(
//                   width: double.infinity,
//                   height: 52,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: primaryBlue,
//                       elevation: 4,
//                       shadowColor: primaryBlue.withOpacity(0.35),
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                     ),
//                     onPressed: _isLoading ? null : _verifyOtp,
//                     child: _isLoading
//                         ? const SizedBox(
//                             height: 20,
//                             width: 20,
//                             child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
//                           )
//                         : const Text(
//                             'Verify & Continue',
//                             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
//                           ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

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
  State<VerifyOtpView> createState() => _VerifyOtpViewState();
}

class _VerifyOtpViewState extends State<VerifyOtpView> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  bool _isLoading = false;

  static const Color primaryBlue = Color(0xFF003D91);

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  // =========================
  // VERIFY OTP
  // =========================
  Future<void> _verifyOtp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final otp = _otpController.text.trim();
      final email = widget.email.trim();

      // Debug information
      print("================================");
      print("VERIFY OTP");
      print("Email: $email");
      print("OTP: $otp");
      print("================================");

      final response = await AuthService().verifyOtp(
        otp,
        email,
      );

      print("OTP Status Code: ${response.statusCode}");
      print("OTP Response: ${response.body}");

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      // =========================
      // SUCCESS
      // =========================
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("OTP verified successfully"),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChangePasswordView(
              email: widget.email,
            ),
          ),
        );
      }

      // =========================
      // OTP INVALID / EXPIRED
      // =========================
      else {
        String message = "Invalid or expired OTP";

        try {
          // If backend returns JSON like:
          // {"message":"Invalid OTP"}
          final responseBody = response.body;

          if (responseBody.isNotEmpty) {
            print("Backend Error: $responseBody");
          }
        } catch (e) {
          print("Could not read response: $e");
        }

        ScaffoldMessenger.of(context).showSnackBar(
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

      print("VERIFY OTP ERROR: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // =========================
  // RESEND OTP
  // =========================
  Future<void> _resendOtp() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final email = widget.email.trim();

      print("Resending OTP to: $email");

      final response = await AuthService().forgotPassword(email);

      print("Resend OTP Status: ${response.statusCode}");
      print("Resend OTP Response: ${response.body}");

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "A new OTP code has been sent to $email",
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to resend OTP"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      print("RESEND OTP ERROR: $e");

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

      // =========================
      // APP BAR
      // =========================
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF0F172A),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),

        title: const Text(
          'OTP Verification',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),

        centerTitle: true,
      ),

      // =========================
      // BODY
      // =========================
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                // =========================
                // EMAIL BANNER
                // =========================
                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        primaryBlue,
                        Color(0xFF002866),
                      ],

                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),

                    borderRadius: BorderRadius.circular(20),

                    boxShadow: [
                      BoxShadow(
                        color: primaryBlue.withOpacity(0.25),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),

                  child: Row(
                    children: [

                      // Email Icon
                      Container(
                        padding: const EdgeInsets.all(12),

                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          shape: BoxShape.circle,

                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),

                        child: const Icon(
                          Icons.mark_email_read_outlined,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Email Text
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [

                            const Text(
                              'Code Sent',

                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              'We sent a 6-digit code to ${widget.email}.',

                              style: const TextStyle(
                                color: Color(0xFF93C5FD),
                                fontSize: 12,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // =========================
                // TITLE
                // =========================
                const Text(
                  'Enter Verification Code',

                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F172A),
                  ),
                ),

                const SizedBox(height: 8),

                // =========================
                // OTP INPUT
                // =========================
                TextFormField(
                  controller: _otpController,

                  keyboardType: TextInputType.number,

                  maxLength: 6,

                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 6,
                    color: Color(0xFF0F172A),
                  ),

                  decoration: InputDecoration(
                    counterText: '',

                    hintText: '000000',

                    hintStyle: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 16,
                      letterSpacing: 6,
                      fontWeight: FontWeight.normal,
                    ),

                    filled: true,
                    fillColor: Colors.white,

                    contentPadding:
                        const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),

                    prefixIcon: const Icon(
                      Icons.pin_outlined,
                      color: Color(0xFF64748B),
                      size: 20,
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(14),

                      borderSide: const BorderSide(
                        color: Color(0xFFE2E8F0),
                      ),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(14),

                      borderSide: const BorderSide(
                        color: primaryBlue,
                        width: 2,
                      ),
                    ),

                    errorBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(14),

                      borderSide: const BorderSide(
                        color: Color(0xFFEF4444),
                      ),
                    ),

                    focusedErrorBorder:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(14),

                      borderSide: const BorderSide(
                        color: Color(0xFFEF4444),
                        width: 2,
                      ),
                    ),
                  ),

                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Please enter the code';
                    }

                    if (value.length != 6) {
                      return 'Code must be 6 digits';
                    }

                    if (!RegExp(r'^[0-9]+$')
                        .hasMatch(value)) {
                      return 'Code must contain numbers only';
                    }

                    return null;
                  },
                ),

                // =========================
                // RESEND OTP
                // =========================
                Align(
                  alignment: Alignment.centerRight,

                  child: TextButton(
                    onPressed:
                        _isLoading ? null : _resendOtp,

                    child: const Text(
                      "Didn't receive code? Resend",

                      style: TextStyle(
                        color: primaryBlue,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // =========================
                // VERIFY BUTTON
                // =========================
                SizedBox(
                  width: double.infinity,
                  height: 52,

                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,

                      elevation: 4,

                      shadowColor:
                          primaryBlue.withOpacity(0.35),

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(16),
                      ),
                    ),

                    onPressed:
                        _isLoading ? null : _verifyOtp,

                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,

                            child:
                                CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )

                        : const Text(
                            'Verify & Continue',

                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
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

