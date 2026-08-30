import 'package:get/get.dart';

class FashionProductItem {
  final String title;
  final String price;
  final String imageUrl;
  final String rating;

  FashionProductItem({
    required this.title,
    required this.price,
    required this.imageUrl,
    this.rating = '4.5',
  });
}

class CategoryFashionController extends GetxController {
  var categoryTitle = 'Fashion & Apparel'.obs;

  // Fashion & Apparel sample products
  final RxList<FashionProductItem> products = <FashionProductItem>[
    FashionProductItem(
      title: 'Nike Running Shoes',
      price: '\$120.00',
      imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=400&q=80',
      rating: '4.8',
    ),
    FashionProductItem(
      title: 'Classic Denim Jacket',
      price: '\$79.99',
      imageUrl: 'https://images.unsplash.com/photo-1551028719-00167b16eac5?auto=format&fit=crop&w=400&q=80',
      rating: '4.6',
    ),
    FashionProductItem(
      title: 'Casual Cotton T-Shirt',
      price: '\$25.00',
      imageUrl: 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?auto=format&fit=crop&w=400&q=80',
      rating: '4.5',
    ),
    FashionProductItem(
      title: 'Leather Street Sneakers',
      price: '\$110.50',
      imageUrl: 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?auto=format&fit=crop&w=400&q=80',
      rating: '4.7',
    ),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['title'] != null) {
      categoryTitle.value = Get.arguments['title'];
    }
  }
}