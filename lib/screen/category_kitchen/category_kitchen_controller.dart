import 'package:get/get.dart';

class KitchenProductItem {
  final String title;
  final String price;
  final String imageUrl;
  final String rating;

  KitchenProductItem({
    required this.title,
    required this.price,
    required this.imageUrl,
    this.rating = '4.5',
  });
}

class CategoryKitchenController extends GetxController {
  var categoryTitle = 'Home & Kitchen'.obs;

  // Home & Kitchen sample product data
  final RxList<KitchenProductItem> products = <KitchenProductItem>[
    KitchenProductItem(
      title: 'Air Fryer XL 5.5L',
      price: '\$89.99',
      imageUrl: 'https://images.unsplash.com/photo-1585515320310-259814833e62?auto=format&fit=crop&w=400&q=80',
      rating: '4.9',
    ),
    KitchenProductItem(
      title: 'Stainless Steel Cookware Set',
      price: '\$149.50',
      imageUrl: 'https://images.unsplash.com/photo-1584992236310-6edddc08acff?auto=format&fit=crop&w=400&q=80',
      rating: '4.7',
    ),
    KitchenProductItem(
      title: 'Electric Coffee Grinder',
      price: '\$35.00',
      imageUrl: 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?auto=format&fit=crop&w=400&q=80',
      rating: '4.6',
    ),
    KitchenProductItem(
      title: 'Ceramic Dinnerware Set',
      price: '\$65.00',
      imageUrl: 'https://images.unsplash.com/photo-1610701596007-11502861dcfa?auto=format&fit=crop&w=400&q=80',
      rating: '4.8',
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