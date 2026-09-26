// import 'package:get/get.dart';

// class FeaturedCollection {
//   final String title;
//   final String subtitle;
//   final String imageUrl;

//   FeaturedCollection({
//     required this.title,
//     required this.subtitle,
//     required this.imageUrl,
//   });
// }

// class CategoryItem {
//   final String name;
//   final String productCount;
//   final String imageUrl;

//   CategoryItem({
//     required this.name,
//     required this.productCount,
//     required this.imageUrl,
//   });
// }

// class CategoryController extends GetxController {
//   final RxList<FeaturedCollection> featuredCollections = <FeaturedCollection>[
//     FeaturedCollection(
//       title: 'Tech Innovations',
//       subtitle: 'Latest electronics & gadgets',
//       imageUrl: 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?auto=format&fit=crop&w=600&q=80',
//     ),
//     FeaturedCollection(
//       title: 'Corporate Style',
//       subtitle: 'Premium professional wear',
//       imageUrl: 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?auto=format&fit=crop&w=600&q=80',
//     ),
//     FeaturedCollection(
//       title: 'Elite Living',
//       subtitle: 'Curated home & workspace',
//       imageUrl: 'https://images.unsplash.com/photo-1524758631624-e2822e304c36?auto=format&fit=crop&w=600&q=80',
//     ),
//     FeaturedCollection(
//       title: 'Luxury Details',
//       subtitle: 'Watches, bags & more',
//       imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=600&q=80',
//     ),
//   ].obs;

//   final RxList<CategoryItem> categories = <CategoryItem>[
//     CategoryItem(
//       name: 'Electronics',
//       productCount: '1,200 Products',
//       imageUrl: 'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?auto=format&fit=crop&w=300&q=80',
//     ),
//     CategoryItem(
//       name: 'Fashion & Apparel',
//       productCount: '2,850 Products',
//       imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=300&q=80',
//     ),
//     CategoryItem(
//       name: 'Home & Kitchen',
//       productCount: '880 Products',
//       imageUrl: 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?auto=format&fit=crop&w=300&q=80',
//     ),
//     CategoryItem(
//       name: 'Beauty & Health',
//       productCount: '1,510 Products',
//       imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?auto=format&fit=crop&w=300&q=80',
//     ),
//     CategoryItem(
//       name: 'Sports & Outdoors',
//       productCount: '945 Products',
//       imageUrl: 'https://images.unsplash.com/photo-1517649763962-0c623266ddc0?auto=format&fit=crop&w=300&q=80',
//     ),
//   ].obs;
// }

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class FeaturedCollection {
  final String title;
  final String subtitle;
  final String imageUrl;

  FeaturedCollection({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });
}

class CategoryItem {
  final int id;
  final String name;
  final String? imageUrl;
  final int totalProducts;

  CategoryItem({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.totalProducts,
  });

  // Factory constructor matching your JSON payload fields:
  // id, name, imageUrl, totalProducts
  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      totalProducts: json['totalProducts'] as int? ?? 0,
    );
  }

  get mainImageUrl => null;
}

class CategoryController extends GetxController {
  final RxList<CategoryItem> categories = <CategoryItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // BASE URL SETUP:
  // - Android Emulator: 'http://10.0.2.2:8080/api/v1/mobile/categories'
  // - iOS Simulator: 'http://localhost:8080/api/v1/mobile/categories'
  // - Real Device: 'http://YOUR_COMPUTER_IP:8080/api/v1/mobile/categories'
  final String _apiUrl = 'http://192.168.56.1:8080/api/v1/mobile/categories';

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await http.get(Uri.parse(_apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> body = jsonDecode(response.body);
        categories.value = body.map((item) => CategoryItem.fromJson(item)).toList();
      } else {
        errorMessage.value = 'Failed to load categories: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
