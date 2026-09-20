import 'dart:convert';
import 'package:flutter_application_ecommerce/api/api_constant.dart';
import 'package:flutter_application_ecommerce/screen/category/category_model.dart';
import 'package:http/http.dart' as http;


class CategoryService {
  static const String baseUrl = ApiConstant.baseUrl;

  Future<List<CategoryModel>> getCategories() async {
    final Uri url = Uri.parse('$baseUrl/categories');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('CATEGORY API STATUS: ${response.statusCode}');
      print('CATEGORY API BODY: ${response.body}');

      if (response.statusCode == 200) {
        final dynamic decoded = jsonDecode(response.body);

        if (decoded is List) {
          return decoded
              .map(
                (item) => CategoryModel.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList();
        }

        throw Exception('Invalid category response format');
      }

      throw Exception(
        'Failed to load categories. Status: ${response.statusCode}',
      );
    } catch (e) {
      print('CATEGORY API ERROR: $e');
      rethrow;
    }
  }
}
