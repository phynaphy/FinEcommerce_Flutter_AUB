import 'package:get/get.dart';

class BeautyProductItem {
  final String title;
  final String price;
  final String imageUrl;
  final String rating;

  BeautyProductItem({
    required this.title,
    required this.price,
    required this.imageUrl,
    this.rating = '4.5',
  });
}

class CategoryBeautyController extends GetxController {
  var categoryTitle = 'Beauty & Health'.obs;

  // Beauty & Health sample products
  final RxList<BeautyProductItem> products = <BeautyProductItem>[
    BeautyProductItem(
      title: 'Hydrating Face Serum',
      price: '\$29.99',
      imageUrl: 'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?auto=format&fit=crop&w=400&q=80',
      rating: '4.9',
    ),
    BeautyProductItem(
      title: 'Organic Body Lotion',
      price: '\$18.50',
      imageUrl: 'https://images.unsplash.com/photo-1556228720-195a672e8a03?auto=format&fit=crop&w=400&q=80',
      rating: '4.7',
    ),
    BeautyProductItem(
      title: 'Matte Lipstick Set',
      price: '\$24.00',
      imageUrl: 'https://images.unsplash.com/photo-1586495777744-4413f21062fa?auto=format&fit=crop&w=400&q=80',
      rating: '4.8',
    ),
    BeautyProductItem(
      title: 'Hair Repair Oil',
      price: '\$32.00',
      imageUrl: 'https://images.unsplash.com/photo-1608248597261-833257054452?auto=format&fit=crop&w=400&q=80',
      rating: '4.6',
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