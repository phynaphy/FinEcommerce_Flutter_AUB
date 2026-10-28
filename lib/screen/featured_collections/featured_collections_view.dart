
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'featured_collections_controller.dart';
import '../category/category_controller.dart';

class FeaturedCollectionsView
    extends GetView<FeaturedCollectionsController> {
  const FeaturedCollectionsView({super.key});

  static const Color primaryBlue = Color(0xFF06499F);
  static const Color backgroundColor = Color(0xFFF8F9FB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: primaryBlue,
            size: 21,
          ),
        ),
        title: const Text(
          'Featured Collections',
          style: TextStyle(
            color: primaryBlue,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          final items = controller.collections;

          if (items.isEmpty) {
            return const Center(
              child: Text('No featured collections available'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            itemCount: items.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: 18),
            itemBuilder: (context, index) {
              final item = items[index];

              return _buildCollectionCard(item);
            },
          );
        }),
      ),
    );
  }

  Widget _buildCollectionCard(FeaturedCollection item) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              item.imageUrl,
              key: ValueKey(
                '${item.title}_${item.imageUrl}',
              ),
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) {
                  return child;
                }

                return Container(
                  color: const Color(0xFFE9EEF5),
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(
                    color: primaryBlue,
                    strokeWidth: 2,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                debugPrint(
                  'FAILED IMAGE: ${item.imageUrl}',
                );
                debugPrint('ERROR: $error');

                return Container(
                  color: const Color(0xFFE9EEF5),
                  alignment: Alignment.center,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.broken_image_outlined,
                        size: 38,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Unable to load image',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              },
            ),

            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Color(0x33000000),
                    Color(0xE6000000),
                  ],
                  stops: [0.2, 0.55, 1.0],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              top: 14,
              right: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.94),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: primaryBlue,
                      size: 14,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Featured',
                      style: TextStyle(
                        color: primaryBlue,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
