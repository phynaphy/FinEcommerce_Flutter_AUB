// // import 'package:flutter/material.dart';



// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       title: 'E-Commerce App',
// //       theme: ThemeData(
// //         scaffoldBackgroundColor: const Color(0xFFF8FAFC),
// //       ),
// //       home: const ProductDetailScreen(),
// //     );
// //   }
// // }

// // class ProductDetailScreen extends StatefulWidget {
// //   final Map<String, dynamic>? product;

// //   const ProductDetailScreen({super.key, this.product});

// //   @override
// //   State<ProductDetailScreen> createState() =>
// //       _ProductDetailScreenState();
// // }

// // class _ProductDetailScreenState
// //     extends State<ProductDetailScreen> {
// //   late PageController _pageController;
// //   int _selectedImageIndex = 0;
// //   int _selectedColorIndex = 0;
// //   int _selectedStorageIndex = 0;

// //   final List<String> images = [
// //     'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?auto=format&fit=crop&w=800&q=80',
// //     'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
// //     'https://images.unsplash.com/photo-1592899677977-9c10ca588bbd?auto=format&fit=crop&w=800&q=80',
// //     'https://images.unsplash.com/photo-1580910051074-3eb694886505?auto=format&fit=crop&w=800&q=80',
// //   ];

// //   // Fixed 8-character Hex Color codes (FF + 6-digit RGB hex)
// //   final List<Map<String, String>> colors = [
// //     {'name': 'Titanium Gray', 'code': 'FF606870'},
// //     {'name': 'Phantom Black', 'code': 'FF2B2C2E'},
// //     {'name': 'Titanium Violet', 'code': 'FF58556A'},
// //   ];

// //   final List<String> storageOptions = ['256GB', '512GB', '1TB'];

// //   @override
// //   void initState() {
// //     super.initState();
// //     _pageController = PageController();
// //   }

// //   @override
// //   void dispose() {
// //     _pageController.dispose();
// //     super.dispose();
// //   }

// //   void _onThumbnailTapped(int index) {
// //     setState(() => _selectedImageIndex = index);
// //     _pageController.animateToPage(
// //       index,
// //       duration: const Duration(milliseconds: 350),
// //       curve: Curves.easeInOutCubic,
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     const primaryColor = Color(0xFF0052FF);

// //     return Scaffold(
// //       backgroundColor: const Color(0xFFF8FAFC),
// //       body: Stack(
// //         children: [
// //           CustomScrollView(
// //             slivers: [
// //               SliverAppBar(
// //                 expandedHeight: 400,
// //                 pinned: true,
// //                 backgroundColor: Colors.white,
// //                 elevation: 0,
// //                 leading: Padding(
// //                   padding: const EdgeInsets.all(8.0),
// //                   child: CircleAvatar(
// //                     backgroundColor: Colors.white.withOpacity(0.9),
// //                     child: IconButton(
// //                       icon: const Icon(Icons.arrow_back_ios_new_rounded,
// //                           color: Color(0xFF0F172A), size: 18),
// //                       onPressed: () {
// //                         if (Navigator.canPop(context)) {
// //                           Navigator.pop(context);
// //                         }
// //                       },
// //                     ),
// //                   ),
// //                 ),
// //                 actions: [
// //                   CircleAvatar(
// //                     backgroundColor: Colors.white.withOpacity(0.9),
// //                     child: IconButton(
// //                       icon: const Icon(Icons.share_outlined,
// //                           color: Color(0xFF0F172A), size: 20),
// //                       onPressed: () {},
// //                     ),
// //                   ),
// //                   const SizedBox(width: 8),
// //                   CircleAvatar(
// //                     backgroundColor: Colors.white.withOpacity(0.9),
// //                     child: IconButton(
// //                       icon: const Icon(Icons.favorite_border_rounded,
// //                           color: Color(0xFF0F172A), size: 20),
// //                       onPressed: () {},
// //                     ),
// //                   ),
// //                   const SizedBox(width: 16),
// //                 ],
// //                 flexibleSpace: FlexibleSpaceBar(
// //                   background: Stack(
// //                     alignment: Alignment.bottomCenter,
// //                     children: [
// //                       PageView.builder(
// //                         controller: _pageController,
// //                         itemCount: images.length,
// //                         onPageChanged: (index) {
// //                           setState(() => _selectedImageIndex = index);
// //                         },
// //                         itemBuilder: (context, index) {
// //                           return Image.network(
// //                             images[index],
// //                             fit: BoxFit.cover,
// //                             width: double.infinity,
// //                             errorBuilder: (context, error, stackTrace) =>
// //                                 Container(
// //                               color: Colors.grey[300],
// //                               child: const Icon(Icons.image_not_supported,
// //                                   size: 50, color: Colors.grey),
// //                             ),
// //                           );
// //                         },
// //                       ),
// //                       Positioned(
// //                         bottom: 16,
// //                         child: Row(
// //                           children: List.generate(
// //                             images.length,
// //                             (index) => AnimatedContainer(
// //                               duration: const Duration(milliseconds: 300),
// //                               curve: Curves.easeOutCubic,
// //                               margin: const EdgeInsets.symmetric(horizontal: 4),
// //                               width: _selectedImageIndex == index ? 24 : 8,
// //                               height: 8,
// //                               decoration: BoxDecoration(
// //                                 color: _selectedImageIndex == index
// //                                     ? primaryColor
// //                                     : Colors.white.withOpacity(0.6),
// //                                 borderRadius: BorderRadius.circular(12),
// //                               ),
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //               SliverToBoxAdapter(
// //                 child: Container(
// //                   decoration: const BoxDecoration(
// //                     color: Color(0xFFF8FAFC),
// //                     borderRadius:
// //                         BorderRadius.vertical(top: Radius.circular(24)),
// //                   ),
// //                   padding: const EdgeInsets.all(20),
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       SizedBox(
// //                         height: 64,
// //                         child: ListView.separated(
// //                           scrollDirection: Axis.horizontal,
// //                           itemCount: images.length,
// //                           separatorBuilder: (_, __) =>
// //                               const SizedBox(width: 12),
// //                           itemBuilder: (context, index) {
// //                             final isSelected = _selectedImageIndex == index;
// //                             return GestureDetector(
// //                               onTap: () => _onThumbnailTapped(index),
// //                               child: AnimatedContainer(
// //                                 duration: const Duration(milliseconds: 250),
// //                                 curve: Curves.easeOut,
// //                                 width: 64,
// //                                 decoration: BoxDecoration(
// //                                   borderRadius: BorderRadius.circular(12),
// //                                   border: Border.all(
// //                                     color: isSelected
// //                                         ? primaryColor
// //                                         : Colors.transparent,
// //                                     width: 2,
// //                                   ),
// //                                   boxShadow: isSelected
// //                                       ? [
// //                                           BoxShadow(
// //                                             color: primaryColor
// //                                                 .withOpacity(0.25),
// //                                             blurRadius: 8,
// //                                             offset: const Offset(0, 3),
// //                                           )
// //                                         ]
// //                                       : [],
// //                                   image: DecorationImage(
// //                                     image: NetworkImage(images[index]),
// //                                     fit: BoxFit.cover,
// //                                   ),
// //                                 ),
// //                               ),
// //                             );
// //                           },
// //                         ),
// //                       ),
// //                       const SizedBox(height: 20),
// //                       Container(
// //                         padding: const EdgeInsets.symmetric(
// //                             horizontal: 10, vertical: 4),
// //                         decoration: BoxDecoration(
// //                           color: primaryColor.withOpacity(0.1),
// //                           borderRadius: BorderRadius.circular(6),
// //                         ),
// //                         child: const Text(
// //                           'NEW RELEASE',
// //                           style: TextStyle(
// //                             color: primaryColor,
// //                             fontWeight: FontWeight.w800,
// //                             fontSize: 11,
// //                             letterSpacing: 0.8,
// //                           ),
// //                         ),
// //                       ),
// //                       const SizedBox(height: 8),
// //                       const Text(
// //                         'Samsung Galaxy S24 Ultra',
// //                         style: TextStyle(
// //                           fontSize: 24,
// //                           fontWeight: FontWeight.bold,
// //                           color: Color(0xFF0F172A),
// //                         ),
// //                       ),
// //                       const SizedBox(height: 8),
// //                       Row(
// //                         children: [
// //                           Container(
// //                             padding: const EdgeInsets.symmetric(
// //                                 horizontal: 8, vertical: 4),
// //                             decoration: BoxDecoration(
// //                               color: const Color(0xFF10B981).withOpacity(0.15),
// //                               borderRadius: BorderRadius.circular(8),
// //                             ),
// //                             child: const Row(
// //                               children: [
// //                                 Icon(Icons.star_rounded,
// //                                     color: Color(0xFF10B981), size: 16),
// //                                 SizedBox(width: 4),
// //                                 Text(
// //                                   '4.9',
// //                                   style: TextStyle(
// //                                     fontWeight: FontWeight.bold,
// //                                     color: Color(0xFF047857),
// //                                     fontSize: 12,
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                           const SizedBox(width: 8),
// //                           const Text(
// //                             '850 Reviews',
// //                             style: TextStyle(
// //                               color: Color(0xFF64748B),
// //                               fontSize: 13,
// //                               fontWeight: FontWeight.w500,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                       const SizedBox(height: 20),
// //                       Row(
// //                         crossAxisAlignment: CrossAxisAlignment.baseline,
// //                         textBaseline: TextBaseline.alphabetic,
// //                         children: [
// //                           const Text(
// //                             '\$1,199.00',
// //                             style: TextStyle(
// //                               fontSize: 30,
// //                               fontWeight: FontWeight.w900,
// //                               color: Color(0xFF0F172A),
// //                             ),
// //                           ),
// //                           const SizedBox(width: 8),
// //                           Text(
// //                             'Or \$49.95/mo. for 24 mos. at 0% APR',
// //                             style: TextStyle(
// //                               fontSize: 12,
// //                               color: Colors.grey[600],
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                       const SizedBox(height: 24),
// //                       Row(
// //                         children: [
// //                           const Text(
// //                             'Color: ',
// //                             style: TextStyle(
// //                                 fontWeight: FontWeight.w600, fontSize: 14),
// //                           ),
// //                           Text(
// //                             colors[_selectedColorIndex]['name']!,
// //                             style: const TextStyle(
// //                                 fontWeight: FontWeight.bold,
// //                                 fontSize: 14,
// //                                 color: Color(0xFF0F172A)),
// //                           ),
// //                         ],
// //                       ),
// //                       const SizedBox(height: 12),
// //                       Row(
// //                         children: List.generate(colors.length, (index) {
// //                           final isSelected = _selectedColorIndex == index;
// //                           return GestureDetector(
// //                             onTap: () =>
// //                                 setState(() => _selectedColorIndex = index),
// //                             child: AnimatedContainer(
// //                               duration: const Duration(milliseconds: 200),
// //                               margin: const EdgeInsets.only(right: 12),
// //                               padding: const EdgeInsets.all(3),
// //                               decoration: BoxDecoration(
// //                                 shape: BoxShape.circle,
// //                                 border: Border.all(
// //                                   color: isSelected
// //                                       ? primaryColor
// //                                       : Colors.transparent,
// //                                   width: 2,
// //                                 ),
// //                               ),
// //                               child: CircleAvatar(
// //                                 radius: 16,
// //                                 backgroundColor: Color(int.parse(
// //                                     colors[index]['code']!,
// //                                     radix: 16)),
// //                               ),
// //                             ),
// //                           );
// //                         }),
// //                       ),
// //                       const SizedBox(height: 24),
// //                       const Text(
// //                         'Storage',
// //                         style: TextStyle(
// //                             fontWeight: FontWeight.w600, fontSize: 14),
// //                       ),
// //                       const SizedBox(height: 12),
// //                       Row(
// //                         children: List.generate(storageOptions.length, (index) {
// //                           final isSelected = _selectedStorageIndex == index;
// //                           return Expanded(
// //                             child: GestureDetector(
// //                               onTap: () => setState(
// //                                   () => _selectedStorageIndex = index),
// //                               child: AnimatedContainer(
// //                                 duration: const Duration(milliseconds: 200),
// //                                 margin: EdgeInsets.only(
// //                                     right: index == storageOptions.length - 1
// //                                         ? 0
// //                                         : 12),
// //                                 padding:
// //                                     const EdgeInsets.symmetric(vertical: 12),
// //                                 decoration: BoxDecoration(
// //                                   color: isSelected
// //                                       ? primaryColor.withOpacity(0.08)
// //                                       : Colors.white,
// //                                   borderRadius: BorderRadius.circular(12),
// //                                   border: Border.all(
// //                                     color: isSelected
// //                                         ? primaryColor
// //                                         : const Color(0xFFE2E8F0),
// //                                     width: isSelected ? 2 : 1,
// //                                   ),
// //                                 ),
// //                                 child: Center(
// //                                   child: Text(
// //                                     storageOptions[index],
// //                                     style: TextStyle(
// //                                       fontWeight: FontWeight.bold,
// //                                       color: isSelected
// //                                           ? primaryColor
// //                                           : const Color(0xFF334155),
// //                                     ),
// //                                   ),
// //                                 ),
// //                               ),
// //                             ),
// //                           );
// //                         }),
// //                       ),
// //                       const SizedBox(height: 24),
// //                       _buildAccordionTile(
// //                         icon: Icons.info_outline_rounded,
// //                         title: 'Specifications',
// //                         content:
// //                             'Display: 6.8" Dynamic AMOLED 2X\nProcessor: Snapdragon 8 Gen 3\nCamera: 200MP Main + 50MP Periscope\nBattery: 5000 mAh',
// //                       ),
// //                       const SizedBox(height: 8),
// //                       _buildAccordionTile(
// //                         icon: Icons.rate_review_outlined,
// //                         title: 'Customer Reviews',
// //                         content:
// //                             '★★★★★ - "Best phone display and camera quality!"\n★★★★★ - "Battery life easily lasts 2 full days."',
// //                       ),
// //                       const SizedBox(height: 100),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //           Positioned(
// //             bottom: 0,
// //             left: 0,
// //             right: 0,
// //             child: Container(
// //               padding: const EdgeInsets.all(16),
// //               decoration: BoxDecoration(
// //                 color: Colors.white,
// //                 boxShadow: [
// //                   BoxShadow(
// //                     color: Colors.black.withOpacity(0.06),
// //                     blurRadius: 20,
// //                     offset: const Offset(0, -4),
// //                   ),
// //                 ],
// //               ),
// //               child: SafeArea(
// //                 top: false,
// //                 child: Row(
// //                   children: [
// //                     Expanded(
// //                       child: OutlinedButton(
// //                         onPressed: () {},
// //                         style: OutlinedButton.styleFrom(
// //                           padding: const EdgeInsets.symmetric(vertical: 16),
// //                           side: const BorderSide(
// //                               color: primaryColor, width: 1.5),
// //                           shape: RoundedRectangleBorder(
// //                             borderRadius: BorderRadius.circular(12),
// //                           ),
// //                         ),
// //                         child: const Text(
// //                           'Add to Cart',
// //                           style: TextStyle(
// //                             fontSize: 15,
// //                             fontWeight: FontWeight.bold,
// //                             color: primaryColor,
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                     const SizedBox(width: 12),
// //                     Expanded(
// //                       child: ElevatedButton(
// //                         onPressed: () {},
// //                         style: ElevatedButton.styleFrom(
// //                           backgroundColor: primaryColor,
// //                           padding: const EdgeInsets.symmetric(vertical: 16),
// //                           elevation: 0,
// //                           shape: RoundedRectangleBorder(
// //                             borderRadius: BorderRadius.circular(12),
// //                           ),
// //                         ),
// //                         child: const Text(
// //                           'Buy Now',
// //                           style: TextStyle(
// //                             fontSize: 15,
// //                             fontWeight: FontWeight.bold,
// //                             color: Colors.white,
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildAccordionTile({
// //     required IconData icon,
// //     required String title,
// //     required String content,
// //   }) {
// //     return Container(
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(12),
// //         border: Border.all(color: const Color(0xFFE2E8F0)),
// //       ),
// //       child: ExpansionTile(
// //         leading: Icon(icon, color: const Color(0xFF64748B)),
// //         title: Text(
// //           title,
// //           style: const TextStyle(
// //             fontWeight: FontWeight.w600,
// //             fontSize: 14,
// //             color: Color(0xFF0F172A),
// //           ),
// //         ),
// //         childrenPadding:
// //             const EdgeInsets.only(left: 16, right: 16, bottom: 16),
// //         expandedAlignment: Alignment.centerLeft,
// //         children: [
// //           Text(
// //             content,
// //             style: const TextStyle(
// //               color: Color(0xFF64748B),
// //               fontSize: 13,
// //               height: 1.5,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// import 'dart:ui';
// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'E-Commerce App',
//       theme: ThemeData(
//         fontFamily: 'Roboto', // Replace with your design system font
//         scaffoldBackgroundColor: const Color(0xFFF8FAFC),
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: const Color(0xFF0052FF),
//           surface: const Color(0xFFF8FAFC),
//         ),
//       ),
//       home: const ProductDetailScreen(),
//     );
//   }
// }

// class ProductDetailScreen extends StatefulWidget {
//   final Map<String, dynamic>? product;

//   const ProductDetailScreen({super.key, this.product});

//   @override
//   State<ProductDetailScreen> createState() => _ProductDetailScreenState();
// }

// class _ProductDetailScreenState extends State<ProductDetailScreen> {
//   late PageController _pageController;
//   int _selectedImageIndex = 0;
//   int _selectedColorIndex = 0;
//   int _selectedStorageIndex = 0;
//   int _quantity = 1;
//   bool _isFavorite = false;

//   final List<String> images = [
//     'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?auto=format&fit=crop&w=800&q=80',
//     'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
//     'https://images.unsplash.com/photo-1592899677977-9c10ca588bbd?auto=format&fit=crop&w=800&q=80',
//     'https://images.unsplash.com/photo-1580910051074-3eb694886505?auto=format&fit=crop&w=800&q=80',
//   ];

//   final List<Map<String, dynamic>> colors = [
//     {'name': 'Titanium Gray', 'color': const Color(0xFF606870)},
//     {'name': 'Phantom Black', 'color': const Color(0xFF2B2C2E)},
//     {'name': 'Titanium Violet', 'color': const Color(0xFF58556A)},
//   ];

//   final List<Map<String, dynamic>> storageOptions = [
//     {'size': '256GB', 'priceDiff': 'Base'},
//     {'size': '512GB', 'priceDiff': '+\$120'},
//     {'size': '1TB', 'priceDiff': '+\$300'},
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController();
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   void _onThumbnailTapped(int index) {
//     setState(() => _selectedImageIndex = index);
//     _pageController.animateToPage(
//       index,
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeOutCubic,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     const primaryColor = Color(0xFF0052FF);

//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       body: Stack(
//         children: [
//           CustomScrollView(
//             slivers: [
//               // --- APP BAR & HERO GALLERY ---
//               SliverAppBar(
//                 expandedHeight: 420,
//                 pinned: true,
//                 elevation: 0,
//                 backgroundColor: Colors.white,
//                 leading: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: _buildGlassIconButton(
//                     icon: Icons.arrow_back_ios_new_rounded,
//                     onPressed: () {
//                       if (Navigator.canPop(context)) Navigator.pop(context);
//                     },
//                   ),
//                 ),
//                 actions: [
//                   _buildGlassIconButton(
//                     icon: Icons.share_outlined,
//                     onPressed: () {},
//                   ),
//                   const SizedBox(width: 8),
//                   _buildGlassIconButton(
//                     icon: _isFavorite
//                         ? Icons.favorite_rounded
//                         : Icons.favorite_border_rounded,
//                     iconColor: _isFavorite ? Colors.redAccent : const Color(0xFF0F172A),
//                     onPressed: () => setState(() => _isFavorite = !_isFavorite),
//                   ),
//                   const SizedBox(width: 16),
//                 ],
//                 flexibleSpace: FlexibleSpaceBar(
//                   background: Stack(
//                     alignment: Alignment.bottomCenter,
//                     children: [
//                       PageView.builder(
//                         controller: _pageController,
//                         itemCount: images.length,
//                         onPageChanged: (index) {
//                           setState(() => _selectedImageIndex = index);
//                         },
//                         itemBuilder: (context, index) {
//                           return Image.network(
//                             images[index],
//                             fit: BoxFit.cover,
//                             width: double.infinity,
//                             errorBuilder: (context, error, stackTrace) =>
//                                 Container(
//                               color: Colors.grey[200],
//                               child: const Icon(Icons.image_not_supported_outlined,
//                                   size: 48, color: Colors.grey),
//                             ),
//                           );
//                         },
//                       ),
//                       // Gradient shadow for appbar button contrast
//                       Positioned(
//                         top: 0,
//                         left: 0,
//                         right: 0,
//                         height: 100,
//                         child: Container(
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               begin: Alignment.topCenter,
//                               end: Alignment.bottomCenter,
//                               colors: [
//                                 Colors.black.withOpacity(0.35),
//                                 Colors.transparent,
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       // Carousel Indicator Pill
//                       Positioned(
//                         bottom: 20,
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 10, vertical: 6),
//                           decoration: BoxDecoration(
//                             color: Colors.black.withOpacity(0.4),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: List.generate(
//                               images.length,
//                               (index) => AnimatedContainer(
//                                 duration: const Duration(milliseconds: 250),
//                                 margin: const EdgeInsets.symmetric(horizontal: 3),
//                                 width: _selectedImageIndex == index ? 18 : 6,
//                                 height: 6,
//                                 decoration: BoxDecoration(
//                                   color: _selectedImageIndex == index
//                                       ? Colors.white
//                                       : Colors.white.withOpacity(0.5),
//                                   borderRadius: BorderRadius.circular(4),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               // --- PRODUCT DETAILS CONTENT ---
//               SliverToBoxAdapter(
//                 child: Container(
//                   transform: Matrix4.translationValues(0, -16, 0),
//                   decoration: const BoxDecoration(
//                     color: Color(0xFFF8FAFC),
//                     borderRadius:
//                         BorderRadius.vertical(top: Radius.circular(24)),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Floating Image Thumbnails
//                         SizedBox(
//                           height: 64,
//                           child: ListView.separated(
//                             scrollDirection: Axis.horizontal,
//                             itemCount: images.length,
//                             separatorBuilder: (_, __) => const SizedBox(width: 12),
//                             itemBuilder: (context, index) {
//                               final isSelected = _selectedImageIndex == index;
//                               return GestureDetector(
//                                 onTap: () => _onThumbnailTapped(index),
//                                 child: AnimatedContainer(
//                                   duration: const Duration(milliseconds: 200),
//                                   width: 64,
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(14),
//                                     border: Border.all(
//                                       color: isSelected
//                                           ? primaryColor
//                                           : Colors.transparent,
//                                       width: 2,
//                                     ),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: isSelected
//                                             ? primaryColor.withOpacity(0.2)
//                                             : Colors.black.withOpacity(0.04),
//                                         blurRadius: 10,
//                                         offset: const Offset(0, 4),
//                                       ),
//                                     ],
//                                     image: DecorationImage(
//                                       image: NetworkImage(images[index]),
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                         const SizedBox(height: 20),

//                         // Release Tag & Rating Row
//                         Row(
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 10, vertical: 5),
//                               decoration: BoxDecoration(
//                                 color: primaryColor.withOpacity(0.1),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: const Text(
//                                 'OFFICIAL STORE',
//                                 style: TextStyle(
//                                   color: primaryColor,
//                                   fontWeight: FontWeight.w800,
//                                   fontSize: 10,
//                                   letterSpacing: 0.6,
//                                 ),
//                               ),
//                             ),
//                             const Spacer(),
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 8, vertical: 4),
//                               decoration: BoxDecoration(
//                                 color: const Color(0xFFFEF3C7),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: const Row(
//                                 children: [
//                                   Icon(Icons.star_rounded,
//                                       color: Color(0xFFD97706), size: 16),
//                                   SizedBox(width: 4),
//                                   Text(
//                                     '4.9',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       color: Color(0xFF92400E),
//                                       fontSize: 12,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(width: 6),
//                             const Text(
//                               '(850 reviews)',
//                               style: TextStyle(
//                                 color: Color(0xFF64748B),
//                                 fontSize: 13,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 12),

//                         // Title
//                         const Text(
//                           'Samsung Galaxy S24 Ultra',
//                           style: TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.w800,
//                             color: Color(0xFF0F172A),
//                             letterSpacing: -0.5,
//                           ),
//                         ),
//                         const SizedBox(height: 12),

//                         // Pricing & Offer Section
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.baseline,
//                           textBaseline: TextBaseline.alphabetic,
//                           children: [
//                             const Text(
//                               '\$1,199.00',
//                               style: TextStyle(
//                                 fontSize: 28,
//                                 fontWeight: FontWeight.w900,
//                                 color: Color(0xFF0F172A),
//                               ),
//                             ),
//                             const SizedBox(width: 8),
//                             Text(
//                               '\$1,299.00',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.grey[400],
//                                 decoration: TextDecoration.lineThrough,
//                               ),
//                             ),
//                             const SizedBox(width: 8),
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 6, vertical: 2),
//                               decoration: BoxDecoration(
//                                 color: const Color(0xFFEF4444).withOpacity(0.1),
//                                 borderRadius: BorderRadius.circular(4),
//                               ),
//                               child: const Text(
//                                 'SAVE 8%',
//                                 style: TextStyle(
//                                   color: Color(0xFFEF4444),
//                                   fontSize: 11,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 6),
//                         const Text(
//                           'Or \$49.95/mo. for 24 mos. at 0% APR',
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Color(0xFF64748B),
//                           ),
//                         ),
//                         const SizedBox(height: 24),

//                         // Color Options
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text(
//                               'Color',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 15,
//                                 color: Color(0xFF0F172A),
//                               ),
//                             ),
//                             Text(
//                               colors[_selectedColorIndex]['name'],
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 13,
//                                 color: Color(0xFF64748B),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 12),
//                         Row(
//                           children: List.generate(colors.length, (index) {
//                             final isSelected = _selectedColorIndex == index;
//                             return GestureDetector(
//                               onTap: () =>
//                                   setState(() => _selectedColorIndex = index),
//                               child: AnimatedContainer(
//                                 duration: const Duration(milliseconds: 200),
//                                 margin: const EdgeInsets.only(right: 14),
//                                 padding: const EdgeInsets.all(3),
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   border: Border.all(
//                                     color: isSelected
//                                         ? primaryColor
//                                         : Colors.transparent,
//                                     width: 2,
//                                   ),
//                                 ),
//                                 child: CircleAvatar(
//                                   radius: 16,
//                                   backgroundColor: colors[index]['color'],
//                                 ),
//                               ),
//                             );
//                           }),
//                         ),
//                         const SizedBox(height: 24),

//                         // Storage Options
//                         const Text(
//                           'Storage',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 15,
//                             color: Color(0xFF0F172A),
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//                         Row(
//                           children: List.generate(storageOptions.length, (index) {
//                             final isSelected = _selectedStorageIndex == index;
//                             final option = storageOptions[index];
//                             return Expanded(
//                               child: GestureDetector(
//                                 onTap: () => setState(
//                                     () => _selectedStorageIndex = index),
//                                 child: AnimatedContainer(
//                                   duration: const Duration(milliseconds: 200),
//                                   margin: EdgeInsets.only(
//                                       right: index == storageOptions.length - 1
//                                           ? 0
//                                           : 10),
//                                   padding: const EdgeInsets.symmetric(
//                                       vertical: 12, horizontal: 8),
//                                   decoration: BoxDecoration(
//                                     color: isSelected
//                                         ? primaryColor.withOpacity(0.06)
//                                         : Colors.white,
//                                     borderRadius: BorderRadius.circular(14),
//                                     border: Border.all(
//                                       color: isSelected
//                                           ? primaryColor
//                                           : const Color(0xFFE2E8F0),
//                                       width: isSelected ? 2 : 1,
//                                     ),
//                                   ),
//                                   child: Column(
//                                     children: [
//                                       Text(
//                                         option['size'],
//                                         style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 14,
//                                           color: isSelected
//                                               ? primaryColor
//                                               : const Color(0xFF0F172A),
//                                         ),
//                                       ),
//                                       const SizedBox(height: 2),
//                                       Text(
//                                         option['priceDiff'],
//                                         style: TextStyle(
//                                           fontSize: 11,
//                                           color: isSelected
//                                               ? primaryColor.withOpacity(0.8)
//                                               : const Color(0xFF94A3B8),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             );
//                           }),
//                         ),
//                         const SizedBox(height: 28),

//                         // Key Specifications Cards (Grid)
//                         const Text(
//                           'Key Features',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 15,
//                             color: Color(0xFF0F172A),
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//                         GridView.count(
//                           crossAxisCount: 2,
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           mainAxisSpacing: 10,
//                           crossAxisSpacing: 10,
//                           childAspectRatio: 2.6,
//                           children: const [
//                             _SpecCard(
//                               icon: Icons.aspect_ratio_rounded,
//                               title: 'Display',
//                               subtitle: '6.8" AMOLED 2X',
//                             ),
//                             _SpecCard(
//                               icon: Icons.memory_rounded,
//                               title: 'Processor',
//                               subtitle: 'Snapdragon 8 Gen 3',
//                             ),
//                             _SpecCard(
//                               icon: Icons.camera_alt_outlined,
//                               title: 'Camera',
//                               subtitle: '200 MP Main',
//                             ),
//                             _SpecCard(
//                               icon: Icons.battery_charging_full_rounded,
//                               title: 'Battery',
//                               subtitle: '5000 mAh',
//                             ),
//                           ],
//                         ),

//                         const SizedBox(height: 20),
//                         _buildAccordionTile(
//                           icon: Icons.rate_review_outlined,
//                           title: 'Customer Reviews',
//                           content:
//                               '★★★★★ - "Best phone display and camera quality!"\n★★★★★ - "Battery life easily lasts 2 full days."',
//                         ),
//                         const SizedBox(height: 110), // Padding for sticky bottom bar
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),

//           // --- STICKY BOTTOM ACTION BAR ---
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.06),
//                     blurRadius: 20,
//                     offset: const Offset(0, -6),
//                   ),
//                 ],
//               ),
//               child: SafeArea(
//                 top: false,
//                 child: Row(
//                   children: [
//                     // Quantity Counter
//                     Container(
//                       height: 52,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFF1F5F9),
//                         borderRadius: BorderRadius.circular(14),
//                       ),
//                       child: Row(
//                         children: [
//                           IconButton(
//                             icon: const Icon(Icons.remove, size: 18),
//                             onPressed: () {
//                               if (_quantity > 1) {
//                                 setState(() => _quantity--);
//                               }
//                             },
//                           ),
//                           Text(
//                             '$_quantity',
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 15,
//                             ),
//                           ),
//                           IconButton(
//                             icon: const Icon(Icons.add, size: 18),
//                             onPressed: () {
//                               setState(() => _quantity++);
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(width: 12),

//                     // Add to Cart Button
//                     Expanded(
//                       child: SizedBox(
//                         height: 52,
//                         child: OutlinedButton(
//                           onPressed: () {},
//                           style: OutlinedButton.styleFrom(
//                             side: const BorderSide(color: primaryColor, width: 1.5),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(14),
//                             ),
//                           ),
//                           child: const Text(
//                             'Add to Cart',
//                             style: TextStyle(
//                               fontSize: 15,
//                               fontWeight: FontWeight.bold,
//                               color: primaryColor,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 10),

//                     // Buy Now Button
//                     Expanded(
//                       child: SizedBox(
//                         height: 52,
//                         child: ElevatedButton(
//                           onPressed: () {},
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: primaryColor,
//                             elevation: 0,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(14),
//                             ),
//                           ),
//                           child: const Text(
//                             'Buy Now',
//                             style: TextStyle(
//                               fontSize: 15,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Helper Widget: Glassmorphic Floating Top Buttons
//   Widget _buildGlassIconButton({
//     required IconData icon,
//     required VoidCallback onPressed,
//     Color iconColor = const Color(0xFF0F172A),
//   }) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(30),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//         child: Container(
//           width: 40,
//           height: 40,
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.7),
//             shape: BoxShape.circle,
//           ),
//           child: IconButton(
//             padding: EdgeInsets.zero,
//             icon: Icon(icon, color: iconColor, size: 18),
//             onPressed: onPressed,
//           ),
//         ),
//       ),
//     );
//   }

//   // Helper Widget: Accordion Tile
//   Widget _buildAccordionTile({
//     required IconData icon,
//     required String title,
//     required String content,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: const Color(0xFFE2E8F0)),
//       ),
//       child: ExpansionTile(
//         shape: Border.all(color: Colors.transparent),
//         leading: Icon(icon, color: const Color(0xFF64748B)),
//         title: Text(
//           title,
//           style: const TextStyle(
//             fontWeight: FontWeight.w600,
//             fontSize: 14,
//             color: Color(0xFF0F172A),
//           ),
//         ),
//         childrenPadding:
//             const EdgeInsets.only(left: 16, right: 16, bottom: 16),
//         expandedAlignment: Alignment.centerLeft,
//         children: [
//           Text(
//             content,
//             style: const TextStyle(
//               color: Color(0xFF64748B),
//               fontSize: 13,
//               height: 1.5,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Helper Widget: Specification Grid Card
// class _SpecCard extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String subtitle;

//   const _SpecCard({
//     required this.icon,
//     required this.title,
//     required this.subtitle,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: const Color(0xFFE2E8F0)),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: const Color(0xFFF1F5F9),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(icon, size: 20, color: const Color(0xFF0052FF)),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 11,
//                     color: Color(0xFF94A3B8),
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 Text(
//                   subtitle,
//                   style: const TextStyle(
//                     fontSize: 12,
//                     color: Color(0xFF0F172A),
//                     fontWeight: FontWeight.bold,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// product_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/screen/product_detail/product_controller.dart';
import 'package:get/get.dart';
import 'product_image_slider.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({Key? key, required Map<String, dynamic> product}) : super(key: key);

  // Convert Hex string (e.g. #f63b92) to Flutter Color
  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductDetailController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              controller.errorMessage.value,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          );
        }

        final product = controller.product.value;
        if (product == null) {
          return const Center(child: Text('No product found'));
        }

        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Swipable Image Slider Component
                  ProductImageSlider(imageUrls: product.imageUrls),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category & Official Store Badge
                        Row(
                          children: [
                            Chip(
                              label: Text(product.categoryName),
                              backgroundColor: Colors.blue.withOpacity(0.1),
                              labelStyle: const TextStyle(color: Colors.blue),
                            ),
                            if (product.isOfficialStore) ...[
                              const SizedBox(width: 8),
                              const Chip(
                                label: Text('Official Store'),
                                backgroundColor: Colors.greenAccent,
                              ),
                            ]
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Title
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Ratings & Reviews
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 20),
                            const SizedBox(width: 4),
                            Text(
                              '${product.rating}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(' (${product.reviewCount} reviews)'),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Price Row
                        Row(
                          children: [
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(width: 10),
                            if (product.originalPrice > product.price) ...[
                              Text(
                                '\$${product.originalPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '-${product.discountPercentage}%',
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const Divider(height: 32),

                        // Variant Selector (Color / Storage)
                        if (product.variants.isNotEmpty) ...[
                          const Text(
                            'Select Variant',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Obx(
                            () => Wrap(
                              spacing: 8,
                              children: List.generate(
                                product.variants.length,
                                (index) {
                                  final variant = product.variants[index];
                                  final isSelected =
                                      controller.selectedVariantIndex.value == index;

                                  return ChoiceChip(
                                    label: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CircleAvatar(
                                          radius: 6,
                                          backgroundColor: _hexToColor(variant.colorHex),
                                        ),
                                        const SizedBox(width: 6),
                                        Text('${variant.color} (${variant.storage}GB)'),
                                      ],
                                    ),
                                    selected: isSelected,
                                    onSelected: (selected) {
                                      if (selected) controller.selectVariant(index);
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Quantity Selector
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Quantity',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: controller.decrementQuantity,
                                  ),
                                  Obx(() => Text(
                                        '${controller.quantity.value}',
                                        style: const TextStyle(
                                            fontSize: 16, fontWeight: FontWeight.bold),
                                      )),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: controller.incrementQuantity,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 32),

                        // Product Description
                        const Text(
                          'Description',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.description,
                          style: const TextStyle(color: Colors.black87, height: 1.4),
                        ),

                        // Features Specifications
                        if (product.features.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          const Text(
                            'Specifications',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          ...product.features.map(
                            (feature) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Text(
                                    '${feature.featureKey}: ',
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Text(feature.featureValue),
                                ],
                              ),
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Fixed Bottom Action Bar
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total Price', style: TextStyle(color: Colors.grey)),
                          Obx(
                            () => Text(
                              '\$${controller.totalPrice.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        // Action for adding item to cart
                      },
                      icon: const Icon(Icons.shopping_cart),
                      label: const Text('Add to Cart'),
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}