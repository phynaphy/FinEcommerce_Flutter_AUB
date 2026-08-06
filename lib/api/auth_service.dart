import 'dart:convert';
import 'package:flutter_application_ecommerce/api/api_constant.dart';
import 'package:flutter_application_ecommerce/api/login_request.dart';
import 'package:http/http.dart' as http;



class AuthService {

  Future<http.Response> login(LoginRequest request) async {

    final url = Uri.parse("${ApiConstant.baseUrl}/auth/login");

    return await http.post(
      url,
      headers: {
        "Content-Type":"application/json"
      },
      body: jsonEncode(request.toJson()),
    );

  }

}