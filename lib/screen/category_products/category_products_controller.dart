import 'package:get/get.dart';

class ProductItem {
  final String title;
  final String price;
  final String imageUrl;
  final String rating;

  ProductItem({
    required this.title,
    required this.price,
    required this.imageUrl,
    this.rating = '0.5',
  });
}

class CategoryProductsController extends GetxController {
  // Title received dynamically (e.g., "Electronics")
  var categoryName = ''.obs;

  // Sample Products List
  final RxList<ProductItem> products = <ProductItem>[
    ProductItem(
      title: 'Wireless Headphones',
      price: '\$199.99',
      imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=400&q=80',
      rating: '4.8',
    ),
    ProductItem(
      title: 'Smart Watch Series',
      price: '\$299.00',
      imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=400&q=80',
    ),
    ProductItem(
      title: 'Retro Camera',
      price: '\$450.50',
      imageUrl: 'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?auto=format&fit=crop&w=400&q=80',
    ),
    ProductItem(
      title: 'Ultra Laptop',
      price: '\$1,120.00',
      imageUrl: 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?auto=format&fit=crop&w=400&q=80',
    ),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    
    // Safely extract arguments based on the object type passed
    final args = Get.arguments;
    if (args != null) {
      if (args is String) {
        categoryName.value = args;
      } else if (args is Map<String, dynamic>) {
        categoryName.value = args['title'] ?? args['name'] ?? 'Products';
      } else {
        // Reads object properties directly via dynamic access (CategoryItem or FeaturedCollection)
        try {
          categoryName.value = args.name;
        } catch (_) {
          try {
            categoryName.value = args.title;
          } catch (_) {
            categoryName.value = 'Products';
          }
        }
      }
    } else {
      categoryName.value = 'Products';
    }
  }
}