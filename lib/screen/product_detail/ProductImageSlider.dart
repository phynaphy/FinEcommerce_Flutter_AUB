import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductImageSlider extends StatelessWidget {
  // 1. Define your image list
  final List<String> imageList = [
    'assets/images/phone1.jpg',
    'assets/images/phone2.jpg',
    'assets/images/phone3.jpg',
    'assets/images/phone4.jpg',
  ];

  // 2. Track the active index reactively using GetX
  final RxInt selectedIndex = 0.obs;

  ProductImageSlider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // STEP A: Swipable PageView Container
        SizedBox(
          height: 350,
          child: PageView.builder(
            itemCount: imageList.length,
            onPageChanged: (index) {
              // Update state when user slides to next image
              selectedIndex.value = index;
            },
            itemBuilder: (context, index) {
              return Image.asset(
                imageList[index],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  );
                },
              );
            },
          ),
        ),

        // STEP B: Floating Dot Indicator at Bottom
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                imageList.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  // Active index expands into a pill shape
                  width: selectedIndex.value == index ? 24 : 8,
                  decoration: BoxDecoration(
                    color: selectedIndex.value == index
                        ? Colors.blue
                        : Colors.white.withOpacity(0.6),
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