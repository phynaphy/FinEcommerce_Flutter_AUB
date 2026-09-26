// product_image_slider.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/screen/product_detail/product_controller.dart';
import 'package:get/get.dart';

class ProductImageSlider extends StatelessWidget {
  final List<String> imageUrls;
  final PageController pageController = PageController();

  ProductImageSlider({Key? key, required this.imageUrls}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductDetailController controller = Get.find<ProductDetailController>();

    if (imageUrls.isEmpty) {
      return Container(
        height: 350,
        color: Colors.grey[200],
        child: const Center(
          child: Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
        ),
      );
    }

    return Stack(
      children: [
        // Swipable PageView Container
        SizedBox(
          height: 350,
          child: PageView.builder(
            controller: pageController,
            itemCount: imageUrls.length,
            onPageChanged: (index) {
              controller.updateImageIndex(index);
            },
            itemBuilder: (context, index) {
              return Image.network(
                imageUrls[index],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
              );
            },
          ),
        ),

        // Floating Dot Indicator
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                imageUrls.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: controller.selectedImageIndex.value == index ? 24 : 8,
                  decoration: BoxDecoration(
                    color: controller.selectedImageIndex.value == index
                        ? Theme.of(context).primaryColor
                        : Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}