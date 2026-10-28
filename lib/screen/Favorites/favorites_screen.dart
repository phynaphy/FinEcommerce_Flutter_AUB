import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'favorites_controller.dart'; // Adjust path based on your project structure

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FavoritesController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.favorites.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.favorites.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  'No favorites yet!',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => controller.loadFavorites(),
                  child: const Text('Refresh'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.loadFavorites,
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: controller.favorites.length,
            itemBuilder: (context, index) {
              final favorite = controller.favorites[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      // Product Image
                      ClipRRect(
  borderRadius: BorderRadius.circular(8),
  child: favorite.mainImageUrl != null && favorite.mainImageUrl!.isNotEmpty
      ? Image.network(
          favorite.mainImageUrl!,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: 80,
              height: 80,
              color: Colors.grey[200],
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            debugPrint('Failed to load image: ${favorite.mainImageUrl}');
            return Container(
              width: 80,
              height: 80,
              color: Colors.grey[200],
              child: const Icon(Icons.image_not_supported, color: Colors.grey),
            );
          },
        )
      : Container(
          width: 80,
          height: 80,
          color: Colors.grey[200],
          child: const Icon(Icons.shopping_bag, color: Colors.grey),
        ),
),
                      const SizedBox(width: 12),
                      // Product Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              favorite.productName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '\$${favorite.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (favorite.rating != null) ...[
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.star,
                                      size: 16, color: Colors.amber),
                                  const SizedBox(width: 4),
                                  Text(
                                    favorite.rating.toString(),
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      // Remove Button
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          // Confirm deletion
                          Get.defaultDialog(
                            title: 'Remove Favorite',
                            middleText:
                                'Are you sure you want to remove this item from your favorites?',
                            textConfirm: 'Remove',
                            textCancel: 'Cancel',
                            confirmTextColor: Colors.white,
                            onConfirm: () {
                              Get.back();
                              controller.removeFavorite(favorite.productId);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}