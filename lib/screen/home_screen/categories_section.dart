// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class CategoriesSection extends StatelessWidget {
//   const CategoriesSection({super.key});

//   static const List<Map<String, dynamic>> categories = [
//     {'icon': Icons.devices_rounded, 'label': 'Electronics'},
//     {'icon': Icons.checkroom_rounded, 'label': 'Fashion'},
//     {'icon': Icons.face_retouching_natural_rounded, 'label': 'Beauty'},
//     {'icon': Icons.home_outlined, 'label': 'Home'},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'Browse Categories',
//               style: GoogleFonts.spaceGrotesk(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: const Color(0xFF0F172A),
//               ),
//             ),
//             TextButton(
//               onPressed: () {},
//               child: Text(
//                 'See All >',
//                 style: GoogleFonts.spaceGrotesk(
//                   color: const Color(0xFF003D91),
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: categories.map((cat) {
//             return Column(
//               children: [
//                 Container(
//                   height: 64,
//                   width: 64,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.04),
//                         blurRadius: 10,
//                         offset: const Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: Icon(cat['icon'], color: const Color(0xFF0F172A), size: 26),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   cat['label'],
//                   style: GoogleFonts.spaceGrotesk(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500,
//                     color: const Color(0xFF64748B),
//                   ),
//                 ),
//               ],
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/screen/category/category_controller.dart';
import 'package:flutter_application_ecommerce/screen/category/categoryscreen.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../category/category_view.dart' hide CategoryController;

class CategoriesSection extends StatelessWidget {
  CategoriesSection({
    super.key,
    this.onElectronicsTap,
  });

  final VoidCallback? onElectronicsTap;

  final CategoryController controller =
      Get.isRegistered<CategoryController>()
          ? Get.find<CategoryController>()
          : Get.put(CategoryController());

  static const Color primaryBlue = Color(0xFF06499F);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section heading
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Browse Categories',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF101B3A),
                  ),
                ),
              ),
              
              TextButton(
                onPressed: () {
                  Get.to(() => CategoriesScreen());
                },
                child: const Text(
                  'See All',
                  style: TextStyle(
                    color: primaryBlue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Dynamic horizontal categories
        Obx(() {
          if (controller.isLoading.value &&
              controller.categories.isEmpty) {
            return const SizedBox(
              width: double.infinity,
              height: 130,
              child: Center(
                child: CircularProgressIndicator(
                  color: primaryBlue,
                  strokeWidth: 2,
                ),
              ),
            );
          }

          if (controller.errorMessage.value.isNotEmpty &&
              controller.categories.isEmpty) {
            return SizedBox(
              width: double.infinity,
              height: 130,
              child: Center(
                child: Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
            );
          }

          if (controller.categories.isEmpty) {
            return const SizedBox(
              width: double.infinity,
              height: 130,
              child: Center(
                child: Text('No categories available'),
              ),
            );
          }

          return SizedBox(
            width: double.infinity,
            height: 130,
            child: Scrollbar(
              thumbVisibility: true,
              thickness: 3,
              radius: const Radius.circular(10),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                primary: false,
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 8,
                ),
                itemCount: controller.categories.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 18);
                },
                itemBuilder: (context, index) {
                  final category = controller.categories[index];

                  final String? imageUrl = category.imageUrl;

                  final String? resolvedImageUrl =
                      imageUrl != null && imageUrl.isNotEmpty
                          ? imageUrl.startsWith('http')
                              ? imageUrl
                              : 'http://10.0.2.2:8080$imageUrl'
                          : null;

                  return SizedBox(
                    width: 78,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        Get.to(
                          () => Cat(
                            categoryId: category.id,
                            categoryName: category.name,
                          ),
                        );
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 68,
                            height: 68,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: const Color(0xFFE5E7EB),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: resolvedImageUrl != null
                                  ? Image.network(
                                      resolvedImageUrl,
                                      width: 68,
                                      height: 68,
                                      fit: BoxFit.cover,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return const Icon(
                                          Icons.category_rounded,
                                          color: primaryBlue,
                                          size: 30,
                                        );
                                      },
                                    )
                                  : const Icon(
                                      Icons.category_rounded,
                                      color: primaryBlue,
                                      size: 30,
                                    ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            category.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF14213D),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }),
      ],
    );
  }
}
