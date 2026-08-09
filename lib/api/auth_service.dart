
// // import 'dart:convert';

// // import 'package:flutter_application_ecommerce/api/api_constant.dart';

// // import 'package:flutter_application_ecommerce/api/request_service/login_request.dart';
// // import 'package:flutter_application_ecommerce/api/request_service/register_request.dart';
// // import 'package:flutter_application_ecommerce/api/request_service/reset_password_request.dart';
// // import 'package:http/http.dart' as http;

// // class AuthService {

// //   // =========================
// //   // LOGIN
// //   // =========================
// //   Future<http.Response> login(LoginRequest request) async {
// //     final url = Uri.parse(
// //       "${ApiConstant.baseUrl}/auth/login",
// //     );

// //     return await http.post(
// //       url,
// //       headers: {
// //         "Content-Type": "application/json",
// //       },
// //       body: jsonEncode(request.toJson()),
// //     );
// //   }

// //   // =========================
// //   // REGISTER
// //   // =========================
// //   Future<http.Response> register(RegisterRequest request) async {
// //     final url = Uri.parse(
// //       "${ApiConstant.baseUrl}/auth/register",
// //     );

// //     return await http.post(
// //       url,
// //       headers: {
// //         "Content-Type": "application/json",
// //       },
// //       body: jsonEncode(request.toJson()),
// //     );
// //   }

// // // Reset Password
// // Future<http.Response> resetPassword(
// //   ResetPasswordRequest request,
// // ) async {
// //   final url = Uri.parse(
// //     "${ApiConstant.baseUrl}/auth/reset-password",
// //   );

// //   return await http.post(
// //     url,
// //     headers: {
// //       "Content-Type": "application/json",
// //     },
// //     body: jsonEncode(request.toJson()),
// //   );
// // }


// // }
// import 'dart:convert';

// import 'package:flutter_application_ecommerce/api/api_constant.dart';
// import 'package:flutter_application_ecommerce/api/request_service/login_request.dart';
// import 'package:flutter_application_ecommerce/api/request_service/register_request.dart';
// import 'package:flutter_application_ecommerce/api/request_service/reset_password_request.dart';
// import 'package:http/http.dart' as http;

// class AuthService {
//   // LOGIN
//   Future<http.Response> login(LoginRequest request) async {
//     final url = Uri.parse(
//       "${ApiConstant.baseUrl}/auth/login",
//     );

//     return await http.post(
//       url,
//       headers: {
//         "Content-Type": "application/json",
//       },
//       body: jsonEncode(request.toJson()),
//     );
//   }

//   // REGISTER
//   Future<http.Response> register(RegisterRequest request) async {
//     final url = Uri.parse(
//       "${ApiConstant.baseUrl}/auth/register",
//     );

//     return await http.post(
//       url,
//       headers: {
//         "Content-Type": "application/json",
//       },
//       body: jsonEncode(request.toJson()),
//     );
//   }

//   // SEND OTP
//   Future<http.Response> forgotPassword(String email) async {
//     final url = Uri.parse(
//       "${ApiConstant.baseUrl}/auth/forgot-password",
//     );

//     return await http.post(
//       url,
//       headers: {
//         "Content-Type": "application/json",
//       },
//       body: jsonEncode({
//         "email": email,
//       }),
//     );
//   }
//   ///////////////////app verify opt
  
// //   Future<http.Response> verifyOtp(String email, String otp) async {
// //   final url = Uri.parse(
// //     "${ApiConstant.baseUrl}/auth/change-password/verify-otp",
// //   );

// //   return await http.post(
// //     url,
// //     headers: {
// //       "Content-Type": "application/json",
// //     },
// //     body: jsonEncode({
// //       "email": email,
// //       "otp": otp,
// //     }),
// //   );
// // }
// Future<http.Response> verifyOtp(
//   String otp,
//   String email,
// ) async {
//   final url = Uri.parse(
//     "${ApiConstant.baseUrl}/auth/change-password/verify-otp",
//   );

//   final body = {
//     "email": email,
//     "otp": otp,
//   };

//   print("VERIFY OTP URL: $url");
//   print("VERIFY OTP BODY: ${jsonEncode(body)}");

//   return await http.post(
//     url,
//     headers: {
//       "Content-Type": "application/json",
//     },
//     body: jsonEncode(body),
//   );
// }

//   // RESET PASSWORD
//   Future<http.Response> resetPassword(
//     ResetPasswordRequest request,
//   ) async {
//     final url = Uri.parse(
//       "${ApiConstant.baseUrl}/auth/change-password/request-otp",
//     );

//     return await http.post(
//       url,
//       headers: {
//         "Content-Type": "application/json",
//       },
//       body: jsonEncode(request.toJson()),
//     );
//   }
// }




import 'dart:convert';

import 'package:flutter_application_ecommerce/api/api_constant.dart';
import 'package:flutter_application_ecommerce/api/request_service/login_request.dart';
import 'package:flutter_application_ecommerce/api/request_service/register_request.dart';
import 'package:flutter_application_ecommerce/api/request_service/reset_password_request.dart';
import 'package:http/http.dart' as http;

class AuthService {
  // ============================================================
  // LOGIN
  // ============================================================
  Future<http.Response> login(LoginRequest request) async {
    final url = Uri.parse(
      "${ApiConstant.baseUrl}/auth/login",
    );

    print("LOGIN URL: $url");
    print("LOGIN BODY: ${jsonEncode(request.toJson())}");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(request.toJson()),
    );

    print("LOGIN STATUS: ${response.statusCode}");
    print("LOGIN RESPONSE: ${response.body}");

    return response;
  }

  // ============================================================
  // REGISTER
  // ============================================================
  Future<http.Response> register(RegisterRequest request) async {
    final url = Uri.parse(
      "${ApiConstant.baseUrl}/auth/register",
    );

    print("REGISTER URL: $url");
    print("REGISTER BODY: ${jsonEncode(request.toJson())}");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(request.toJson()),
    );

    print("REGISTER STATUS: ${response.statusCode}");
    print("REGISTER RESPONSE: ${response.body}");

    return response;
  }

  // ============================================================
  // FORGOT PASSWORD - SEND OTP
  // ============================================================
  Future<http.Response> forgotPassword(String email) async {
    final url = Uri.parse(
      "${ApiConstant.baseUrl}/auth/forgot-password",
    );

    final body = {
      "email": email.trim(),
    };

    print("=================================");
    print("FORGOT PASSWORD - SEND OTP");
    print("URL: $url");
    print("BODY: ${jsonEncode(body)}");
    print("=================================");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    print("FORGOT PASSWORD STATUS: ${response.statusCode}");
    print("FORGOT PASSWORD RESPONSE: ${response.body}");

    return response;
  }

  // ============================================================
  // VERIFY OTP
  // ============================================================
  Future<http.Response> verifyOtp(
    String otp,
    String email,
  ) async {
    final url = Uri.parse(
      "${ApiConstant.baseUrl}/auth/change-password/verify-otp",
    );

    final body = {
      "email": email.trim(),
      "otp": otp.trim(),
    };

    print("=================================");
    print("VERIFY OTP");
    print("URL: $url");
    print("BODY: ${jsonEncode(body)}");
    print("=================================");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    print("VERIFY OTP STATUS: ${response.statusCode}");
    print("VERIFY OTP RESPONSE: ${response.body}");

    return response;
  }

  // ============================================================
  // RESEND OTP
  // ============================================================
  Future<http.Response> resendOtp(String email) async {
    return await forgotPassword(email);
  }

  // ============================================================
  // NORMAL CHANGE PASSWORD
  //
  // Used when the user is already logged in and knows
  // their current password.
  //
  // POST:
  // /auth/change-password
  //
  // Body:
  // {
  //   "currentPassword": "...",
  //   "newPassword": "...",
  //   "confirmPassword": "..."
  // }
  // ============================================================
  Future<http.Response> changePassword(
    String currentPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    final url = Uri.parse(
      "${ApiConstant.baseUrl}/auth/change-password",
    );

    final body = {
      "currentPassword": currentPassword,
      "newPassword": newPassword,
      "confirmPassword": confirmPassword,
    };

    print("=================================");
    print("NORMAL CHANGE PASSWORD");
    print("URL: $url");
    print("BODY: ${jsonEncode(body)}");
    print("=================================");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    print("CHANGE PASSWORD STATUS: ${response.statusCode}");
    print("CHANGE PASSWORD RESPONSE: ${response.body}");

    return response;
  }

  // ============================================================
  // FORGOT PASSWORD - COMPLETE RESET
  //
  // Used AFTER OTP verification.
  //
  // POST:
  // /auth/change-password/complete?email=xxx
  //
  // Body:
  // {
  //   "newPassword": "...",
  //   "confirmPassword": "..."
  // }
  //
  // IMPORTANT:
  // There is NO currentPassword here because the user
  // forgot their password.
  // ============================================================
  Future<http.Response> completeResetPassword(
    String email,
    String newPassword,
    String confirmPassword,
  ) async {
    final url = Uri.parse(
      "${ApiConstant.baseUrl}/auth/change-password/complete"
      "?email=${Uri.encodeComponent(email.trim())}",
    );

    final body = {
      "newPassword": newPassword,
      "confirmPassword": confirmPassword,
    };

    print("=================================");
    print("COMPLETE RESET PASSWORD");
    print("URL: $url");
    print("BODY: ${jsonEncode(body)}");
    print("=================================");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    print("RESET PASSWORD STATUS: ${response.statusCode}");
    print("RESET PASSWORD RESPONSE: ${response.body}");

    return response;
  }

  // ============================================================
  // OLD RESET PASSWORD METHOD
  //
  // Keep this only if your backend still uses this endpoint.
  // Otherwise you can remove it.
  // ============================================================
  Future<http.Response> resetPassword(
    ResetPasswordRequest request,
  ) async {
    final url = Uri.parse(
      "${ApiConstant.baseUrl}/auth/change-password/request-otp",
    );

    print("RESET PASSWORD REQUEST OTP URL: $url");
    print(
      "RESET PASSWORD REQUEST OTP BODY: "
      "${jsonEncode(request.toJson())}",
    );

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(request.toJson()),
    );

    print("RESET PASSWORD REQUEST STATUS: ${response.statusCode}");
    print("RESET PASSWORD REQUEST RESPONSE: ${response.body}");

    return response;
  }
}