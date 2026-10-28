import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/screen/add-to-cart/cart_controller.dart';
import 'package:flutter_application_ecommerce/screen/add-to-cart/cart_screen.dart';
import 'package:get/get.dart';

import 'product_controller.dart';
import 'product_model.dart';
import 'product_image_slider.dart';

class ProductDetailScreen extends StatelessWidget {
  final int productId;

  const ProductDetailScreen({
    super.key,
    required this.productId,
  });

  Color _hexToColor(String hex) {
    try {
      var value = hex.replaceAll('#', '').trim();

      if (value.length == 6) value = 'FF$value';
      if (value.length != 8) return Colors.grey;

      return Color(int.parse(value, radix: 16));
    } catch (_) {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      ProductDetailController(productId: productId),
      tag: 'product_$productId',
    );

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Product Details'),
      //   actions: [
      //     IconButton(
      //       tooltip: 'Refresh',
      //       onPressed: controller.retry,
      //       icon: const Icon(Icons.refresh),
      //     ),
      //   ],
      // ),
      appBar: AppBar(
  title: const Text('Product Details'),
  actions: [
    IconButton(
      tooltip: 'Refresh',
      onPressed: controller.retry,
      icon: const Icon(Icons.refresh),
    ),
    IconButton(
      tooltip: 'My Cart',
      icon: const Icon(Icons.shopping_cart_outlined),
      onPressed: () {
        final cartController = Get.isRegistered<CartController>()
            ? Get.find<CartController>()
            : Get.put(CartController());

        cartController.fetchCart();
        Get.to(() => CartScreen());
      },
    ),
  ],
),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: controller.retry,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try Again'),
                  ),
                ],
              ),
            ),
          );
        }

        final product = controller.product.value;

        if (product == null) {
          return const Center(
            child: Text('No product found'),
          );
        }

        return _buildProductContent(
          context,
          controller,
          product,
        );
      }),
    );
  }

  Widget _buildProductContent(
    BuildContext context,
    ProductDetailController controller,
    ProductModel product,
  ) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductImageSlider(
                imageUrls: product.imageUrls,
                controller: controller,
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        if (product.categoryName.isNotEmpty)
                          Chip(
                            label: Text(product.categoryName),
                            backgroundColor:
                                theme.primaryColor.withOpacity(0.1),
                            labelStyle: TextStyle(
                              color: theme.primaryColor,
                            ),
                          ),
                        if (product.isOfficialStore)
                          const Chip(
                            label: Text('Official Store'),
                            backgroundColor: Colors.greenAccent,
                          ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          product.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(' (${product.reviewCount} reviews)'),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Dynamic price and discount
                    Obx(() {
                      final currentPrice = controller.unitPrice;

                      return Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 10,
                        runSpacing: 6,
                        children: [
                          Text(
                            '\$${currentPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor,
                            ),
                          ),
                          if (product.originalPrice > currentPrice)
                            Text(
                              '\$${product.originalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                decoration:
                                    TextDecoration.lineThrough,
                              ),
                            ),
                          if (product.discountPercentage > 0)
                            Text(
                              '-${product.discountPercentage.toStringAsFixed(0)}%',
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      );
                    }),

                    const Divider(height: 32),

                    // Dynamic variants
                    if (product.variants.isNotEmpty) ...[
                      const Text(
                        'Select Variant',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Obx(
                        () => Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: List.generate(
                            product.variants.length,
                            (index) {
                              final variant =
                                  product.variants[index];

                              final selected = controller
                                      .selectedVariantIndex.value ==
                                  index;

                              final label = [
                                if (variant.color.isNotEmpty)
                                  variant.color,
                                if (variant.storage.isNotEmpty)
                                  variant.storage.toLowerCase().contains(
                                        'gb',
                                      )
                                      ? variant.storage
                                      : '${variant.storage} GB',
                              ].join(' · ');

                              return ChoiceChip(
                                selected: selected,
                                avatar: CircleAvatar(
                                  radius: 7,
                                  backgroundColor:
                                      _hexToColor(variant.colorHex),
                                ),
                                label: Text(
                                  label.isEmpty
                                      ? 'Variant ${index + 1}'
                                      : label,
                                ),
                                onSelected: (_) {
                                  controller.selectVariant(index);
                                },
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Obx(() {
                        final variant = controller.selectedVariant;

                        if (variant == null) {
                          return const SizedBox.shrink();
                        }

                        return Text(
                          variant.stockQuantity > 0
                              ? 'In stock: ${variant.stockQuantity}'
                              : 'Out of stock',
                          style: TextStyle(
                            color: variant.stockQuantity > 0
                                ? Colors.green
                                : Colors.red,
                          ),
                        );
                      }),

                      const SizedBox(height: 16),
                    ],

                    // Quantity
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Quantity',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.shade300,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Obx(
                            () => Row(
                              children: [
                                IconButton(
                                  onPressed:
                                      controller.decrementQuantity,
                                  icon: const Icon(Icons.remove),
                                ),
                                Text(
                                  '${controller.quantity.value}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  onPressed:
                                      controller.incrementQuantity,
                                  icon: const Icon(Icons.add),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const Divider(height: 32),

                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      product.description.isEmpty
                          ? 'No description available.'
                          : product.description,
                      style: const TextStyle(height: 1.5),
                    ),

                    if (product.features.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      const Text(
                        'Specifications',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      ...product.features.map(
                        (feature) => Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 6,
                          ),
                          child: Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  feature.featureKey,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(feature.featureValue),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),

        // Bottom price and cart button
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Price',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Obx(
                          () => Text(
                            '\$${controller.totalPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Obx(() {
  final cartController =
      Get.isRegistered<CartController>()
          ? Get.find<CartController>()
          : Get.put(CartController());

  final isAdding =
      cartController.isUpdating.value;

  return ElevatedButton.icon(
    onPressed:
        controller.canAddToCart && !isAdding
            ? () async {
                final variant =
                    controller.selectedVariant;

                await cartController.addToCart(
                  productId: product.id,
                  variantId: variant?.id,
                  quantity:
                      controller.quantity.value,
                );
              }
            : null,

    icon: isAdding
        ? const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
        : const Icon(
            Icons.shopping_cart,
          ),

    label: Text(
      isAdding
          ? 'Adding...'
          : 'Add to Cart',
    ),
  );
}),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}