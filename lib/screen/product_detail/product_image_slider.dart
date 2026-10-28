// // product_image_slider.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_application_ecommerce/screen/product_detail/product_controller.dart';
// import 'package:get/get.dart';

// class ProductImageSlider extends StatelessWidget {
//   final List<String> imageUrls;
//   final PageController pageController = PageController();

//   ProductImageSlider({Key? key, required this.imageUrls}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final ProductDetailController controller = Get.find<ProductDetailController>();

//     if (imageUrls.isEmpty) {
//       return Container(
//         height: 350,
//         color: Colors.grey[200],
//         child: const Center(
//           child: Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
//         ),
//       );
//     }

//     return Stack(
//       children: [
//         // Swipable PageView Container
//         SizedBox(
//           height: 350,
//           child: PageView.builder(
//             controller: pageController,
//             itemCount: imageUrls.length,
//             onPageChanged: (index) {
//               controller.updateImageIndex(index);
//             },
//             itemBuilder: (context, index) {
//               return Image.network(
//                 imageUrls[index],
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) {
//                   return Container(
//                     color: Colors.grey[200],
//                     child: const Center(
//                       child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
//                     ),
//                   );
//                 },
//                 loadingBuilder: (context, child, loadingProgress) {
//                   if (loadingProgress == null) return child;
//                   return const Center(child: CircularProgressIndicator());
//                 },
//               );
//             },
//           ),
//         ),

//         // Floating Dot Indicator
//         Positioned(
//           bottom: 16,
//           left: 0,
//           right: 0,
//           child: Obx(
//             () => Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(
//                 imageUrls.length,
//                 (index) => AnimatedContainer(
//                   duration: const Duration(milliseconds: 300),
//                   margin: const EdgeInsets.symmetric(horizontal: 4),
//                   height: 8,
//                   width: controller.selectedImageIndex.value == index ? 24 : 8,
//                   decoration: BoxDecoration(
//                     color: controller.selectedImageIndex.value == index
//                         ? Theme.of(context).primaryColor
//                         : Colors.white.withOpacity(0.7),
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_application_ecommerce/screen/product_detail/product_controller.dart';

class ProductImageSlider extends StatefulWidget {
  final List<String> imageUrls;
  final ProductDetailController controller;

  const ProductImageSlider({
    super.key,
    required this.imageUrls,
    required this.controller,
  });

  @override
  State<ProductImageSlider> createState() =>
      _ProductImageSliderState();
}

class _ProductImageSliderState extends State<ProductImageSlider> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(
      initialPage: widget.controller.selectedImageIndex.value,
    );
  }

  @override
  void didUpdateWidget(covariant ProductImageSlider oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Reset the slider if the image list changes.
    if (oldWidget.imageUrls != widget.imageUrls &&
        _pageController.hasClients) {
      _pageController.jumpToPage(0);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.imageUrls;
    final theme = Theme.of(context);

    if (images.isEmpty) {
      return Container(
        height: 350,
        width: double.infinity,
        color: Colors.grey.shade100,
        child: const Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            size: 60,
            color: Colors.grey,
          ),
        ),
      );
    }

    return Stack(
      children: [
        // Main image slider
        SizedBox(
          height: 350,
          width: double.infinity,
          child: PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            onPageChanged: widget.controller.updateImageIndex,
            itemBuilder: (context, index) {
              return Container(
                color: Colors.white,
                padding: const EdgeInsets.all(12),
                child: Image.network(
                  images[index],
                  fit: BoxFit.contain,
                  width: double.infinity,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) {
                      return child;
                    }

                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade100,
                      child: const Center(
                        child: Icon(
                          Icons.broken_image_outlined,
                          size: 55,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),

        // Previous image button
        if (images.length > 1)
          Positioned(
            left: 8,
            top: 0,
            bottom: 0,
            child: Center(
              child: _NavigationButton(
                icon: Icons.chevron_left,
                onTap: () {
                  final current =
                      widget.controller.selectedImageIndex.value;

                  final previous =
                      (current - 1 + images.length) % images.length;

                  _pageController.animateToPage(
                    previous,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
          ),

        // Next image button
        if (images.length > 1)
          Positioned(
            right: 8,
            top: 0,
            bottom: 0,
            child: Center(
              child: _NavigationButton(
                icon: Icons.chevron_right,
                onTap: () {
                  final current =
                      widget.controller.selectedImageIndex.value;

                  final next = (current + 1) % images.length;

                  _pageController.animateToPage(
                    next,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
          ),

        // Animated image indicators
        if (images.length > 1)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  images.length,
                  (index) => GestureDetector(
                    onTap: () {
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 4,
                      ),
                      height: 8,
                      width: widget.controller
                                  .selectedImageIndex.value ==
                              index
                          ? 24
                          : 8,
                      decoration: BoxDecoration(
                        color: widget.controller
                                    .selectedImageIndex.value ==
                                index
                            ? theme.primaryColor
                            : Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(8),
                      ),
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

class _NavigationButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _NavigationButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.35),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(
            icon,
            color: Colors.white,
            size: 26,
          ),
        ),
      ),
    );
  }
}