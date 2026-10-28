


import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/app/routes/approutes.dart';
import 'package:flutter_application_ecommerce/payment/process_checkout.dart';
import 'package:flutter_application_ecommerce/screen/add-to-cart/cart_controller.dart';
import 'package:flutter_application_ecommerce/screen/add-to-cart/cart_model.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  static const Color primaryBlue = Color(0xFF06499F);
  static const Color backgroundColor = Color(0xFFF8F9FB);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late CartController controller;

  @override
  void initState() {
    super.initState();

    controller = Get.isRegistered<CartController>()
        ? Get.find<CartController>()
        : Get.put(CartController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchCart();
    });
  }

  // ============================================================
  // IMAGE URL
  // ============================================================

  String? _getImageUrl(String? imagePath) {
    if (imagePath == null) {
      debugPrint('IMAGE PATH = NULL');
      return null;
    }

    final path = imagePath.trim();

    if (path.isEmpty || path.toLowerCase() == 'null') {
      debugPrint('IMAGE PATH = EMPTY');
      return null;
    }

    // Already full URL
    if (path.startsWith('http://') ||
        path.startsWith('https://')) {
      debugPrint('IMAGE FULL URL: $path');
      return path;
    }

    // Backend server
    const String imageBaseUrl = 'http://192.168.56.1:8080';

    final String finalUrl =
        '$imageBaseUrl'
        '${path.startsWith('/') ? '' : '/'}'
        '$path';

    debugPrint('');
    debugPrint('========================================');
    debugPrint('CART IMAGE URL');
    debugPrint('ORIGINAL: $imagePath');
    debugPrint('FINAL: $finalUrl');
    debugPrint('========================================');

    return finalUrl;
  }

  // ============================================================
  // IMAGE PLACEHOLDER
  // ============================================================

  Widget _imagePlaceholder() {
    return Container(
      width: 90,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        Icons.image_outlined,
        size: 38,
        color: Colors.grey.shade400,
      ),
    );
  }

  // ============================================================
  // CART ITEM IMAGE
  // ============================================================

  Widget _buildProductImage(CartItemModel item) {
    final String? imageUrl = _getImageUrl(item.mainImageUrl);

    debugPrint('');
    debugPrint('========================================');
    debugPrint('BUILD CART IMAGE');
    debugPrint('PRODUCT: ${item.productName}');
    debugPrint('PRODUCT ID: ${item.productId}');
    debugPrint('MODEL IMAGE: ${item.mainImageUrl}');
    debugPrint('IMAGE URL: $imageUrl');
    debugPrint('========================================');

    if (imageUrl == null) {
      debugPrint('NO IMAGE URL FOR ${item.productName}');

      return _imagePlaceholder();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 90,
        height: 100,
        child: Image.network(
          imageUrl,

          width: 90,
          height: 100,

          fit: BoxFit.contain,

          // Don't use cacheWidth/cacheHeight while debugging.
          // This makes it easier to identify image loading issues.

          loadingBuilder:
              (
                BuildContext context,
                Widget child,
                ImageChunkEvent? loadingProgress,
              ) {
                if (loadingProgress == null) {
                  debugPrint('');
                  debugPrint('IMAGE LOADED SUCCESSFULLY');
                  debugPrint('PRODUCT: ${item.productName}');
                  debugPrint('URL: $imageUrl');

                  return child;
                }

                return Container(
                  width: 90,
                  height: 100,
                  color: Colors.grey.shade50,
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        value: loadingProgress
                                    .expectedTotalBytes !=
                                null
                            ? loadingProgress
                                    .cumulativeBytesLoaded /
                                loadingProgress
                                    .expectedTotalBytes!
                            : null,
                        color: CartScreen.primaryBlue,
                      ),
                    ),
                  ),
                );
              },

          errorBuilder:
              (
                BuildContext context,
                Object error,
                StackTrace? stackTrace,
              ) {
                debugPrint('');
                debugPrint('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
                debugPrint('IMAGE FAILED');
                debugPrint('PRODUCT: ${item.productName}');
                debugPrint('IMAGE URL: $imageUrl');
                debugPrint('ERROR: $error');
                debugPrint('STACK TRACE: $stackTrace');
                debugPrint('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');

                return Container(
                  width: 90,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.broken_image_outlined,
                        size: 32,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'No Image',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 10,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                );
              },
        ),
      ),
    );
  }

  // ============================================================
  // CART ITEM
  // ============================================================


Widget _buildCartItem(CartItemModel item) {
  return Container(
    margin: const EdgeInsets.only(bottom: 14),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.grey.shade200),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product image
        _buildProductImage(item),

        const SizedBox(width: 14),

        // Product information and actions
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product name + cancel button at top right
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        item.productName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
Container(
  width: 34,
  height: 34,
  decoration: const BoxDecoration(
    color: CartScreen.primaryBlue,
    shape: BoxShape.circle,
  ),
  child: IconButton(
    tooltip: 'Remove item',
    visualDensity: VisualDensity.compact,
    padding: EdgeInsets.zero,
    constraints: const BoxConstraints(
      minWidth: 34,
      minHeight: 34,
    ),
    onPressed: controller.isUpdating.value
        ? null
        : () async {
            final confirmed = await Get.dialog<bool>(
              AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: Text(
                  'Remove item?',
                  style: GoogleFonts.spaceGrotesk(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                content: Text(
                  'Remove "${item.productName}" from your cart?',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Get.back(result: false),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.spaceGrotesk(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Get.back(result: true),
                    child: Text(
                      'Remove',
                      style: GoogleFonts.spaceGrotesk(
                        color: CartScreen.primaryBlue,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            );

            if (confirmed == true) {
              await controller.removeItem(item.id);
            }
          },
    icon: const Icon(
      Icons.close_rounded,
      color: Colors.white,
      size: 19,
    ),
  ),
)
                ],
              ),

              const SizedBox(height: 4),

              // Color
              if (item.color != null && item.color!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    'Color: ${item.color}',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),

              // Storage
              if (item.storage != null && item.storage!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    'Storage: ${item.storage}',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),

              const SizedBox(height: 5),

              // Unit price
              Text(
                '\$${item.unitPrice.toStringAsFixed(2)}',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: CartScreen.primaryBlue,
                ),
              ),

              const SizedBox(height: 10),

              // Minus, quantity, plus + subtotal
              Row(
                children: [
                  // Decrease quantity
                  _quantityButton(
                    icon: Icons.remove_rounded,
                    onPressed: controller.isUpdating.value
                        ? null
                        : () async {
                            await controller.updateQuantity(
                              item.id,
                              item.quantity - 1,
                            );
                          },
                  ),

                  Container(
                    constraints: const BoxConstraints(
                      minWidth: 36,
                    ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                    ),
                    child: Text(
                      '${item.quantity}',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: CartScreen.primaryBlue,
                      ),
                    ),
                  ),

                  // Increase quantity
                  _quantityButton(
                    icon: Icons.add_rounded,
                    onPressed: controller.isUpdating.value
                        ? null
                        : () async {
                            await controller.updateQuantity(
                              item.id,
                              item.quantity + 1,
                            );
                          },
                  ),

                  const Spacer(),

                  Flexible(
                    child: Text(
                      '\$${item.subtotal.toStringAsFixed(2)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// Small styled quantity buttons
Widget _quantityButton({
  required IconData icon,
  required VoidCallback? onPressed,
}) {
  return SizedBox(
    width: 30,
    height: 30,
    child: Material(
      color: CartScreen.primaryBlue.withOpacity(0.08),
      borderRadius: BorderRadius.circular(8),
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 17,
          color: onPressed == null
              ? Colors.grey
              : CartScreen.primaryBlue,
        ),
      ),
    ),
  );
}


  // ============================================================
  // EMPTY CART
  // ============================================================

  Widget _buildEmptyCart() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: CartScreen.primaryBlue
                    .withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_cart_outlined,
                size: 48,
                color: CartScreen.primaryBlue,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Your Cart is Empty',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Add some products to your cart',
              textAlign: TextAlign.center,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () {
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    CartScreen.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 13,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Continue Shopping',
                style: GoogleFonts.spaceGrotesk(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CART LIST
  // ============================================================

  Widget _buildCartList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(
            color: CartScreen.primaryBlue,
          ),
        );
      }

      if (controller.errorMessage.value.isNotEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 50,
                  color: Colors.red.shade400,
                ),

                const SizedBox(height: 12),

                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: () {
                    controller.fetchCart();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        CartScreen.primaryBlue,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    'Retry',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      final cart = controller.cart.value;

      if (cart == null || cart.items.isEmpty) {
        return _buildEmptyCart();
      }

      return RefreshIndicator(
        color: CartScreen.primaryBlue,
        onRefresh: () async {
          await controller.fetchCart();
        },
        child: ListView.builder(
          physics:
              const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: const EdgeInsets.fromLTRB(
            16,
            16,
            16,
            180,
          ),
          itemCount: cart.items.length,
          itemBuilder: (context, index) {
            final item = cart.items[index];

            return _buildCartItem(item);
          },
        ),
      );
    });
  }

  // ============================================================
  // BOTTOM SUMMARY
  // ============================================================

  Widget _buildBottomSummary() {
    return Obx(() {
      final cart = controller.cart.value;

      if (cart == null || cart.items.isEmpty) {
        return const SizedBox.shrink();
      }

      return Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            18,
            16,
            18,
            20,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(22),
              topRight: Radius.circular(22),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Total Items',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),

                    const Spacer(),

                    Text(
                      '${cart.totalItems}',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Text(
                      'Total',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const Spacer(),

                    Text(
                      '\$${cart.totalPrice.toStringAsFixed(2)}',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: CartScreen.primaryBlue,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
  Get.to(() => const PaymentScreen());
},
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          CartScreen.primaryBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'Proceed to Checkout',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  // ============================================================
  // SCREEN
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          CartScreen.backgroundColor,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        title: Text(
          'My Cart',
          style: GoogleFonts.spaceGrotesk(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),

        iconTheme: const IconThemeData(
          color: Colors.black87,
        ),

        actions: [
          Obx(() {
            final cart = controller.cart.value;

            if (cart == null ||
                cart.items.isEmpty) {
              return const SizedBox.shrink();
            }

            return Padding(
              padding:
                  const EdgeInsets.only(right: 16),
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: CartScreen.primaryBlue,
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${cart.totalItems}',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),

      body: Stack(
        children: [
          _buildCartList(),
          _buildBottomSummary(),
        ],
      ),
    );
  }
}