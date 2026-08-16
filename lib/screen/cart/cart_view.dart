// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'cart_controller.dart';
// import 'cart_item_model.dart';

// class CartView extends GetView<CartController> {
//   const CartView({super.key});

//   static const Color primaryBlue = Color(0xFF06499F);
//   static const Color backgroundColor = Color(0xFFF8F9FB);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         backgroundColor: backgroundColor,
//         elevation: 0,
//         leading: const Icon(Icons.arrow_back_ios_new, color: primaryBlue, size: 22),
//         title: const Text(
//           'My Cart',
//           style: TextStyle(
//             color: primaryBlue,
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Obx(() {
//         if (controller.cartItems.isEmpty) {
//           return const Center(
//             child: Text(
//               'Your cart is empty',
//               style: TextStyle(fontSize: 16, color: Colors.grey),
//             ),
//           );
//         }

//         return Column(
//           children: [
//             // List ទំនិញក្នុង Cart
//             Expanded(
//               child: ListView.builder(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 itemCount: controller.cartItems.length,
//                 itemBuilder: (context, index) {
//                   final item = controller.cartItems[index];
//                   return _buildCartCard(item, index);
//                 },
//               ),
//             ),

//             // ផ្នែកទូទាត់ប្រាក់ (Checkout Bottom Sheet)
//             _buildOrderSummarySection(),
//           ],
//         );
//       }),
//     );
//   }

//   // Widget បង្ហាញ Card ទំនិញនីមួយៗដែលមានរូបភាព
//   Widget _buildCartCard(CartItem item, int index) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: const Color(0xFFE5E7EB)),
//       ),
//       child: Row(
//         children: [
//           // 🖼️ រូបភាពទំនិញ (Product Image)
//           ClipRRect(
//             borderRadius: BorderRadius.circular(10),
//             child: Image.network(
//               item.imageUrl,
//               width: 80,
//               height: 80,
//               fit: BoxFit.cover,
//             ),
//           ),
//           const SizedBox(width: 14),

//           // ព័ត៌មានទំនិញ
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: Text(
//                         item.name,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black87,
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 22),
//                       onPressed: () => controller.removeItem(index),
//                       padding: EdgeInsets.zero,
//                       constraints: const BoxConstraints(),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 6),
//                 Text(
//                   '\$${item.price.toStringAsFixed(2)}',
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: primaryBlue,
//                   ),
//                 ),
//                 const SizedBox(height: 8),

//                 // ប៊ូតុង កើន/បន្ថយ ចំនួនទំនិញ
//                 Row(
//                   children: [
//                     _buildQuantityButton(
//                       icon: Icons.remove,
//                       onTap: () => controller.decrementQuantity(index),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 12),
//                       child: Text(
//                         '${item.quantity}',
//                         style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     _buildQuantityButton(
//                       icon: Icons.add,
//                       onTap: () => controller.incrementQuantity(index),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildQuantityButton({required IconData icon, required VoidCallback onTap}) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(6),
//       child: Container(
//         padding: const EdgeInsets.all(4),
//         decoration: BoxDecoration(
//           color: const Color(0xFFF3F4F6),
//           borderRadius: BorderRadius.circular(6),
//         ),
//         child: Icon(icon, size: 18, color: Colors.black87),
//       ),
//     );
//   }

//   // ផ្នែកគណនាតម្លៃ និងប៊ូតុង Checkout
//   Widget _buildOrderSummarySection() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 10,
//             offset: Offset(0, -3),
//           )
//         ],
//       ),
//       child: SafeArea(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text('Subtotal', style: TextStyle(color: Colors.grey, fontSize: 14)),
//                 Text('\$${controller.subtotal.toStringAsFixed(2)}',
//                     style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text('Shipping Fee', style: TextStyle(color: Colors.grey, fontSize: 14)),
//                 Text('\$${controller.shippingFee.toStringAsFixed(2)}',
//                     style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
//               ],
//             ),
//             const Divider(height: 24),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text('Total',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 Text(
//                   '\$${controller.totalPrice.toStringAsFixed(2)}',
//                   style: const TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: primaryBlue,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),

//             // ប៊ូតុង Checkout
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: primaryBlue,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 onPressed: () {},
//                 child: const Text(
//                   'Proceed to Checkout',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/app/routes/approutes.dart';
import 'package:flutter_application_ecommerce/screen/category/category_controller.dart';
import 'package:get/get.dart';


class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  static const Color primaryBlue = Color(0xFF06499F);
  static const Color backgroundColor = Color(0xFFF8F9FB);

  @override
  Widget build(BuildContext context) {
   
    final CategoryController controller = Get.put(CategoryController());

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: const Icon(Icons.menu, color: primaryBlue, size: 28),
        title: const Text(
          'Categories',
          style: TextStyle(
            color: primaryBlue,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.grey, size: 26),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.grey, size: 26),
            onPressed: () {
              Get.toNamed(AppRoutes.cart);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              style: const TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Search products in categories...',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
                prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 24),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Featured Collections',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'View All',
                    style: TextStyle(
                      color: primaryBlue,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Obx(() => Column(
                  children: controller.featuredCollections
                      .map((item) => _buildFeaturedCard(item))
                      .toList(),
                )),
            const SizedBox(height: 20),
            const Text(
              'All Categories',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Obx(() => Column(
                  children: controller.categories
                      .map((item) => _buildCategoryTile(item))
                      .toList(),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedCard(FeaturedCollection item) {
    return Container(
      height: 130,
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        image: DecorationImage(
          image: NetworkImage(item.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.8),
              Colors.transparent,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              item.subtitle,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTile(CategoryItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            item.imageUrl,
            width: 52,
            height: 52,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          item.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          item.productCount,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 13,
          ),
        ),
        trailing:
            const Icon(Icons.chevron_right, color: Colors.grey, size: 24),
        onTap: () {},
      ),
    );
  }
}