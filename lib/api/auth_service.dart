// import 'dart:convert';

// import 'package:flutter_application_ecommerce/api/api_constant.dart';
// import 'package:flutter_application_ecommerce/api/request_service/login_request.dart';
// import 'package:flutter_application_ecommerce/api/request_service/register_request.dart';
// import 'package:flutter_application_ecommerce/api/request_service/reset_password_request.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';


// class AuthService {
//   // ============================================================
//   // LOGIN
//   // ============================================================

//   Future<http.Response> login(LoginRequest request) async {
//     final url = Uri.parse(
//       "${ApiConstant.baseUrl}/auth/login",
//     );

//     print("=================================");
//     print("LOGIN");
//     print("URL: $url");
//     print("BODY: ${jsonEncode(request.toJson())}");
//     print("=================================");

//     final response = await http.post(
//       url,
//       headers: {
//         "Content-Type": "application/json",
//         "Accept": "application/json",
//       },
//       body: jsonEncode(request.toJson()),
//     );

//     print("LOGIN STATUS: ${response.statusCode}");
//     print("LOGIN RESPONSE: ${response.body}");

//     // Save token
//     if (response.statusCode == 200 ||
//         response.statusCode == 201) {
//       try {
//         final data = jsonDecode(response.body);

//         final token = data["token"];

//         if (token != null &&
//             token.toString().isNotEmpty) {
//           final prefs =
//               await SharedPreferences.getInstance();

//           await prefs.setString(
//             "token",
//             token.toString(),
//           );

//           print("TOKEN SAVED");
//         }
//       } catch (e) {
//         print("ERROR SAVING TOKEN: $e");
//       }
//     }

//     return response;
//   }

//   // ============================================================
//   // REGISTER
//   // ============================================================

//   Future<http.Response> register(
//     RegisterRequest request,
//   ) async {
//     final url = Uri.parse(
//       "${ApiConstant.baseUrl}/auth/register",
//     );

//     print("=================================");
//     print("REGISTER");
//     print("URL: $url");
//     print("BODY: ${jsonEncode(request.toJson())}");
//     print("=================================");

//     final response = await http.post(
//       url,
//       headers: {
//         "Content-Type": "application/json",
//         "Accept": "application/json",
//       },
//       body: jsonEncode(request.toJson()),
//     );

//     print("REGISTER STATUS: ${response.statusCode}");
//     print("REGISTER RESPONSE: ${response.body}");

//     return response;
//   }

//   // ============================================================
//   // LOGOUT
//   // ============================================================

//   Future<void> logout() async {
//     final prefs =
//         await SharedPreferences.getInstance();

//     await prefs.remove("token");

//     print("=================================");
//     print("LOGOUT");
//     print("TOKEN REMOVED");
//     print("=================================");
//   }

//   // ============================================================
//   // GET TOKEN
//   // ============================================================

//   Future<String?> getToken() async {
//     final prefs =
//         await SharedPreferences.getInstance();

//     final token = prefs.getString("token");

//     print("=================================");
//     print("GET TOKEN");
//     print(
//       "TOKEN EXISTS: "
//       "${token != null && token.isNotEmpty}",
//     );
//     print("=================================");

//     return token;
//   }

//   // ============================================================
//   // FORGOT PASSWORD - SEND OTP
//   //
//   // POST:
//   // /auth/forgot-password
//   //
//   // BODY:
//   // {
//   //   "email": "example@gmail.com"
//   // }
//   // ============================================================

//   Future<http.Response> forgotPassword(
//     String email,
//   ) async {
//     final url = Uri.parse(
//       "${ApiConstant.baseUrl}/auth/forgot-password",
//     );

//     final body = {
//       "email": email.trim(),
//     };

//     print("=================================");
//     print("FORGOT PASSWORD");
//     print("URL: $url");
//     print("BODY: ${jsonEncode(body)}");
//     print("=================================");

//     final response = await http.post(
//       url,
//       headers: {
//         "Content-Type": "application/json",
//         "Accept": "application/json",
//       },
//       body: jsonEncode(body),
//     );

//     print(
//       "FORGOT PASSWORD STATUS: "
//       "${response.statusCode}",
//     );

//     print(
//       "FORGOT PASSWORD RESPONSE: "
//       "${response.body}",
//     );

//     return response;
//   }

//   // ============================================================
//   // VERIFY OTP
//   //
//   // POST:
//   // /auth/change-password/verify-otp
//   //
//   // BODY:
//   // {
//   //   "email": "example@gmail.com",
//   //   "otp": "123456"
//   // }
//   // ============================================================

//   Future<http.Response> verifyOtp(
//     String otp,
//     String email,
//   ) async {
//     final url = Uri.parse(
//       "${ApiConstant.baseUrl}/auth/change-password/verify-otp",
//     );

//     final body = {
//       "email": email.trim(),
//       "otp": otp.trim(),
//     };

//     print("=================================");
//     print("VERIFY OTP");
//     print("URL: $url");
//     print("BODY: ${jsonEncode(body)}");
//     print("=================================");

//     final response = await http.post(
//       url,
//       headers: {
//         "Content-Type": "application/json",
//         "Accept": "application/json",
//       },
//       body: jsonEncode(body),
//     );

//     print(
//       "VERIFY OTP STATUS: "
//       "${response.statusCode}",
//     );

//     print(
//       "VERIFY OTP RESPONSE: "
//       "${response.body}",
//     );

//     return response;
//   }

//   // ============================================================
//   // RESEND OTP
//   // ============================================================

//   Future<http.Response> resendOtp(
//     String email,
//   ) async {
//     return await forgotPassword(email);
//   }

//   // ============================================================
//   // NORMAL CHANGE PASSWORD
//   //
//   // Used when user is already logged in.
//   //
//   // POST:
//   // /auth/change-password
//   // ============================================================

//   Future<http.Response> changePassword(
//     String currentPassword,
//     String newPassword,
//     String confirmPassword,
//   ) async {
//     final url = Uri.parse(
//       "${ApiConstant.baseUrl}/auth/change-password",
//     );

//     final body = {
//       "currentPassword": currentPassword,
//       "newPassword": newPassword,
//       "confirmPassword": confirmPassword,
//     };

//     final prefs =
//         await SharedPreferences.getInstance();

//     final token = prefs.getString("token");

//     if (token == null || token.isEmpty) {
//       return http.Response(
//         jsonEncode({
//           "message": "User is not logged in",
//         }),
//         401,
//       );
//     }

//     final response = await http.post(
//       url,
//       headers: {
//         "Content-Type": "application/json",
//         "Accept": "application/json",
//         "Authorization": "Bearer $token",
//       },
//       body: jsonEncode(body),
//     );

//     return response;
//   }

//   // ============================================================
//   // COMPLETE RESET PASSWORD
//   //
//   // POST:
//   // /auth/change-password/complete?id=12
//   //
//   // BODY:
//   // {
//   //   "currentPassword": "newPassword1234",
//   //   "newPassword": "newPassword12345",
//   //   "confirmPassword": "newPassword12345"
//   // }
//   // ============================================================

//   Future<http.Response> completeResetPassword(
//     int id,
//     String currentPassword,
//     String newPassword,
//     String confirmPassword,
//   ) async {
//     final url = Uri.parse(
//       "${ApiConstant.baseUrl}/auth/change-password/complete?id=$id",
//     );

//     final body = {
//       "currentPassword": currentPassword,
//       "newPassword": newPassword,
//       "confirmPassword": confirmPassword,
//     };

//     print("=================================");
//     print("COMPLETE RESET PASSWORD");
//     print("URL: $url");
//     print("ID: $id");
//     print("BODY: ${jsonEncode(body)}");
//     print("=================================");

//     final response = await http.post(
//       url,
//       headers: {
//         "Content-Type": "application/json",
//         "Accept": "application/json",
//       },
//       body: jsonEncode(body),
//     );

//     print("=================================");
//     print("RESET PASSWORD RESULT");
//     print("STATUS: ${response.statusCode}");
//     print("BODY: ${response.body}");
//     print("=================================");

//     return response;
//   }

//   // ============================================================
//   // OLD RESET PASSWORD
//   // ============================================================

//   Future<http.Response> resetPassword(
//     ResetPasswordRequest request,
//   ) async {
//     final url = Uri.parse(
//       "${ApiConstant.baseUrl}/auth/change-password/request-otp",
//     );

//     final response = await http.post(
//       url,
//       headers: {
//         "Content-Type": "application/json",
//         "Accept": "application/json",
//       },
//       body: jsonEncode(
//         request.toJson(),
//       ),
//     );

//     return response;
//   }
// }
import 'dart:convert';

import 'package:flutter_application_ecommerce/api/api_constant.dart';
import 'package:flutter_application_ecommerce/api/request_service/login_request.dart';
import 'package:flutter_application_ecommerce/api/request_service/register_request.dart';
import 'package:flutter_application_ecommerce/api/request_service/reset_password_request.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // ============================================================
  // BASE URL
  // ============================================================

  static const String baseUrl = ApiConstant.baseUrl;

  // ============================================================
  // LOGIN
  // ============================================================

  Future<http.Response> login(
    LoginRequest request,
  ) async {
    final Uri url = Uri.parse(
      "$baseUrl/auth/login",
    );

    final String requestBody =
        jsonEncode(request.toJson());

    print("");
    print("========================================");
    print("LOGIN START");
    print("========================================");
    print("URL: $url");
    print("BODY: $requestBody");
    print("========================================");

    try {
      print("LOGIN: Sending request...");

      final http.Response response = await http
          .post(
            url,
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
            },
            body: requestBody,
          )
          .timeout(
            const Duration(seconds: 30),
          );

      print("");
      print("========================================");
      print("LOGIN RESPONSE");
      print("========================================");
      print("STATUS CODE: ${response.statusCode}");
      print("BODY: ${response.body}");
      print("========================================");

      // Save token
      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        try {
          final dynamic decoded =
              jsonDecode(response.body);

          if (decoded is Map<String, dynamic>) {
            final token = decoded["token"];

            if (token != null &&
                token.toString().isNotEmpty) {
              final prefs =
                  await SharedPreferences
                      .getInstance();

              await prefs.setString(
                "token",
                token.toString(),
              );

              print("TOKEN SAVED SUCCESSFULLY");
            }
          }
        } catch (e) {
          print(
            "ERROR SAVING LOGIN TOKEN: $e",
          );
        }
      }

      return response;
    } catch (e, stackTrace) {
      print("");
      print("========================================");
      print("LOGIN ERROR");
      print("========================================");
      print("ERROR: $e");
      print("STACK TRACE:");
      print(stackTrace);
      print("========================================");

      rethrow;
    }
  }

  // ============================================================
  // REGISTER
  // ============================================================

  Future<http.Response> register(
    RegisterRequest request,
  ) async {
    final Uri url = Uri.parse(
      "$baseUrl/auth/register",
    );

    final String requestBody =
        jsonEncode(request.toJson());

    print("");
    print("========================================");
    print("REGISTER START");
    print("========================================");
    print("URL: $url");
    print("BODY: $requestBody");
    print("========================================");

    try {
      print("REGISTER: Sending HTTP POST...");

      final http.Response response = await http
          .post(
            url,
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
            },
            body: requestBody,
          )
          .timeout(
            const Duration(seconds: 30),
          );

      print("");
      print("========================================");
      print("REGISTER RESPONSE");
      print("========================================");
      print("STATUS CODE: ${response.statusCode}");
      print("BODY: ${response.body}");
      print("========================================");

      // Save token if backend returns one
      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        try {
          final dynamic decoded =
              jsonDecode(response.body);

          if (decoded is Map<String, dynamic>) {
            final token = decoded["token"];

            if (token != null &&
                token.toString().isNotEmpty) {
              final prefs =
                  await SharedPreferences
                      .getInstance();

              await prefs.setString(
                "token",
                token.toString(),
              );

              print(
                "REGISTER TOKEN SAVED SUCCESSFULLY",
              );
            }
          }
        } catch (e) {
          print(
            "ERROR SAVING REGISTER TOKEN: $e",
          );
        }
      }

      return response;
    } catch (e, stackTrace) {
      print("");
      print("========================================");
      print("REGISTER ERROR");
      print("========================================");
      print("ERROR: $e");
      print("STACK TRACE:");
      print(stackTrace);
      print("========================================");

      rethrow;
    }
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Future<void> logout() async {
    try {
      final prefs =
          await SharedPreferences.getInstance();

      await prefs.remove("token");

      print("");
      print("========================================");
      print("LOGOUT");
      print("TOKEN REMOVED");
      print("========================================");
    } catch (e) {
      print("LOGOUT ERROR: $e");
    }
  }

  // ============================================================
  // GET TOKEN
  // ============================================================

  Future<String?> getToken() async {
    try {
      final prefs =
          await SharedPreferences.getInstance();

      final String? token =
          prefs.getString("token");

      print("");
      print("========================================");
      print("GET TOKEN");
      print(
        "TOKEN EXISTS: "
        "${token != null && token.isNotEmpty}",
      );
      print("========================================");

      return token;
    } catch (e) {
      print("GET TOKEN ERROR: $e");
      return null;
    }
  }

  // ============================================================
  // FORGOT PASSWORD
  // SEND OTP
  //
  // POST:
  // /auth/forgot-password
  //
  // BODY:
  // {
  //   "email": "example@gmail.com"
  // }
  // ============================================================

  Future<http.Response> forgotPassword(
    String email,
  ) async {
    final Uri url = Uri.parse(
      "$baseUrl/auth/forgot-password",
    );

    final Map<String, dynamic> body = {
      "email": email.trim(),
    };

    final String requestBody =
        jsonEncode(body);

    print("");
    print("========================================");
    print("FORGOT PASSWORD");
    print("========================================");
    print("URL: $url");
    print("BODY: $requestBody");
    print("========================================");

    try {
      final http.Response response = await http
          .post(
            url,
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
            },
            body: requestBody,
          )
          .timeout(
            const Duration(seconds: 30),
          );

      print("");
      print("========================================");
      print("FORGOT PASSWORD RESPONSE");
      print("========================================");
      print(
        "STATUS: ${response.statusCode}",
      );
      print("BODY: ${response.body}");
      print("========================================");

      return response;
    } catch (e, stackTrace) {
      print("");
      print("========================================");
      print("FORGOT PASSWORD ERROR");
      print("========================================");
      print("ERROR: $e");
      print("STACK TRACE:");
      print(stackTrace);
      print("========================================");

      rethrow;
    }
  }

  // ============================================================
  // VERIFY OTP
  //
  // POST:
  // /auth/change-password/verify-otp
  //
  // BODY:
  // {
  //   "email": "example@gmail.com",
  //   "otp": "123456"
  // }
  // ============================================================

  Future<http.Response> verifyOtp(
    String otp,
    String email,
  ) async {
    final Uri url = Uri.parse(
      "$baseUrl/auth/change-password/verify-otp",
    );

    final Map<String, dynamic> body = {
      "email": email.trim(),
      "otp": otp.trim(),
    };

    final String requestBody =
        jsonEncode(body);

    print("");
    print("========================================");
    print("VERIFY OTP");
    print("========================================");
    print("URL: $url");
    print("BODY: $requestBody");
    print("========================================");

    try {
      final http.Response response = await http
          .post(
            url,
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
            },
            body: requestBody,
          )
          .timeout(
            const Duration(seconds: 30),
          );

      print("");
      print("========================================");
      print("VERIFY OTP RESPONSE");
      print("========================================");
      print(
        "STATUS: ${response.statusCode}",
      );
      print("BODY: ${response.body}");
      print("========================================");

      return response;
    } catch (e, stackTrace) {
      print("");
      print("========================================");
      print("VERIFY OTP ERROR");
      print("========================================");
      print("ERROR: $e");
      print("STACK TRACE:");
      print(stackTrace);
      print("========================================");

      rethrow;
    }
  }

  // ============================================================
  // RESEND OTP
  // ============================================================

  Future<http.Response> resendOtp(
    String email,
  ) async {
    return forgotPassword(email);
  }

  // ============================================================
  // NORMAL CHANGE PASSWORD
  //
  // User must already be logged in.
  //
  // POST:
  // /auth/change-password
  // ============================================================

  Future<http.Response> changePassword(
    String currentPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    final Uri url = Uri.parse(
      "$baseUrl/auth/change-password",
    );

    final Map<String, dynamic> body = {
      "currentPassword": currentPassword,
      "newPassword": newPassword,
      "confirmPassword": confirmPassword,
    };

    final String requestBody =
        jsonEncode(body);

    final prefs =
        await SharedPreferences.getInstance();

    final String? token =
        prefs.getString("token");

    print("");
    print("========================================");
    print("CHANGE PASSWORD");
    print("========================================");
    print("URL: $url");
    print("TOKEN EXISTS: "
        "${token != null && token.isNotEmpty}");
    print("BODY: $requestBody");
    print("========================================");

    if (token == null || token.isEmpty) {
      return http.Response(
        jsonEncode({
          "message": "User is not logged in",
        }),
        401,
      );
    }

    try {
      final http.Response response =
          await http
              .post(
                url,
                headers: {
                  "Content-Type":
                      "application/json",
                  "Accept":
                      "application/json",
                  "Authorization":
                      "Bearer $token",
                },
                body: requestBody,
              )
              .timeout(
                const Duration(seconds: 30),
              );

      print("");
      print("========================================");
      print("CHANGE PASSWORD RESPONSE");
      print("========================================");
      print(
        "STATUS: ${response.statusCode}",
      );
      print("BODY: ${response.body}");
      print("========================================");

      return response;
    } catch (e, stackTrace) {
      print("");
      print("========================================");
      print("CHANGE PASSWORD ERROR");
      print("========================================");
      print("ERROR: $e");
      print("STACK TRACE:");
      print(stackTrace);
      print("========================================");

      rethrow;
    }
  }

  // ============================================================
  // COMPLETE RESET PASSWORD
  //
  // POST:
  // /auth/change-password/complete?email=email
  //
  // BODY:
  // {
  //   "currentPassword": "currentPassword",
  //   "newPassword": "newPassword",
  //   "confirmPassword": "newPassword"
  // }
  // ============================================================

  Future<http.Response> completeResetPassword({
    required String email,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final Uri url = Uri.parse(
      "$baseUrl/auth/change-password/complete"
      "?email=${Uri.encodeComponent(email.trim())}",
    );

    final Map<String, dynamic> body = {
      "currentPassword": currentPassword,
      "newPassword": newPassword,
      "confirmPassword": confirmPassword,
    };

    final String requestBody =
        jsonEncode(body);

    print("");
    print("========================================");
    print("COMPLETE RESET PASSWORD");
    print("========================================");
    print("URL: $url");
    print("EMAIL: $email");
    print("BODY: $requestBody");
    print("========================================");

    try {
      final http.Response response =
          await http
              .post(
                url,
                headers: {
                  "Content-Type":
                      "application/json",
                  "Accept":
                      "application/json",
                },
                body: requestBody,
              )
              .timeout(
                const Duration(seconds: 30),
              );

      print("");
      print("========================================");
      print("RESET PASSWORD RESPONSE");
      print("========================================");
      print(
        "STATUS: ${response.statusCode}",
      );
      print("BODY: ${response.body}");
      print("========================================");

      return response;
    } catch (e, stackTrace) {
      print("");
      print("========================================");
      print("RESET PASSWORD ERROR");
      print("========================================");
      print("ERROR: $e");
      print("STACK TRACE:");
      print(stackTrace);
      print("========================================");

      rethrow;
    }
  }

  // ============================================================
  // OLD RESET PASSWORD
  //
  // POST:
  // /auth/change-password/request-otp
  // ============================================================

  Future<http.Response> resetPassword(
    ResetPasswordRequest request,
  ) async {
    final Uri url = Uri.parse(
      "$baseUrl/auth/change-password/request-otp",
    );

    final String requestBody =
        jsonEncode(request.toJson());

    print("");
    print("========================================");
    print("RESET PASSWORD REQUEST OTP");
    print("========================================");
    print("URL: $url");
    print("BODY: $requestBody");
    print("========================================");

    try {
      final http.Response response =
          await http
              .post(
                url,
                headers: {
                  "Content-Type":
                      "application/json",
                  "Accept":
                      "application/json",
                },
                body: requestBody,
              )
              .timeout(
                const Duration(seconds: 30),
              );

      print("");
      print("========================================");
      print("RESET PASSWORD OTP RESPONSE");
      print("========================================");
      print(
        "STATUS: ${response.statusCode}",
      );
      print("BODY: ${response.body}");
      print("========================================");

      return response;
    } catch (e, stackTrace) {
      print("");
      print("========================================");
      print("RESET PASSWORD OTP ERROR");
      print("========================================");
      print("ERROR: $e");
      print("STACK TRACE:");
      print(stackTrace);
      print("========================================");

      rethrow;
    }
  }
}