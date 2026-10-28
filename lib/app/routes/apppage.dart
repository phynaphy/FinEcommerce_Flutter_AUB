// import 'package:flutter/material.dart';
// import 'package:flutter_application_ecommerce/app/routes/approutes.dart';
// import 'package:flutter_application_ecommerce/screen/button_navigation/nav_button.dart';
// import 'package:flutter_application_ecommerce/screen/category/category_binding.dart';
// import 'package:flutter_application_ecommerce/screen/category/category_view.dart';
// import 'package:flutter_application_ecommerce/screen/category/categoryscreen.dart';
// import 'package:flutter_application_ecommerce/screen/category_products/category_products_view.dart';
// import 'package:flutter_application_ecommerce/screen/electronic_screen/eletronic_view.dart';
// import 'package:flutter_application_ecommerce/screen/home_screen/homescreen_view.dart';
// import 'package:flutter_application_ecommerce/screen/home_screen/second_splash.dart';
// import 'package:flutter_application_ecommerce/screen/login_screen/login_screen_view.dart';
// import 'package:flutter_application_ecommerce/screen/product_detail/product_detail_screen.dart';
// import 'package:flutter_application_ecommerce/screen/profile_information/profile_information_binding.dart';

// import 'package:flutter_application_ecommerce/screen/profile_information/profile_information_view.dart';
// // import 'package:flutter_application_ecommerce/screen/profile_informations/profile_information_binding.dart';

// import 'package:flutter_application_ecommerce/screen/profile_screen/profile_screen_view.dart';
// import 'package:flutter_application_ecommerce/screen/register_screen/register_screen_view.dart';
// import 'package:flutter_application_ecommerce/screen/splash_screen.dart';
// import 'package:get/get.dart';
// import 'package:flutter_application_ecommerce/screen/cart/cart_binding.dart';
// import 'package:flutter_application_ecommerce/screen/cart/cart_view.dart' hide CategoryView;

// class AppPages {
//   static final routes = [
//     GetPage(name: AppRoutes.splash, page: () => SplashScreen()),
//     GetPage(name: AppRoutes.splash2, page: () => SecondSplash()),
//     GetPage(name: AppRoutes.login, page: () => LoginScreenView()),
//     GetPage(name: AppRoutes.register, page: () => RegisterScreenView()),
//      GetPage(
//       name: AppRoutes.homescreen,
//       page: () => HomeScreenView(
//         email: Get.arguments ?? '',
//       ),
//     ),
//     GetPage(
//   name: AppRoutes.profile,
//   page: () => ProfileScreenView(
//     email: Get.arguments ?? '',
//   ),
// ),
//     GetPage(
//       name: AppRoutes.profileinformation,
//       page: () => const ProfileInformationView(),
//       binding: ProfileInformationBinding(),
//     ),
//     GetPage(
//       name: AppRoutes.category,
//       page: () => CategoriesScreen(),
//       binding: CategoryBinding(),
//     ),
//     GetPage(name: AppRoutes.eletronic, page: ()=>EletronicView()),
//     GetPage(name: AppRoutes.Category, page: ()=>CategoriesScreen()),
//     GetPage(name: AppRoutes.Category_all_product, page: ()=>CategoryProductsView()),
//     GetPage(name: AppRoutes.Product_detail_view, page: ()=>ProductDetailScreen(product: {},))
// //     GetPage(
// //   name: AppRoutes.cart, // ឬឈ្មោះ route របស់អ្នក
// //   page: () => const Cartv
// //   binding: CartBinding(),
// // ),
//   ];
// }


import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/app/routes/approutes.dart';
import 'package:flutter_application_ecommerce/payment/process_checkout.dart';
import 'package:flutter_application_ecommerce/screen/add-to-cart/card_screen_view.dart';
import 'package:flutter_application_ecommerce/screen/button_navigation/nav_button.dart';
import 'package:flutter_application_ecommerce/screen/category/category_binding.dart';
import 'package:flutter_application_ecommerce/screen/category/category_view.dart';
import 'package:flutter_application_ecommerce/screen/category/categoryscreen.dart';
import 'package:flutter_application_ecommerce/screen/category_products/category_products_view.dart';
import 'package:flutter_application_ecommerce/screen/electronic_screen/eletronic_view.dart';
import 'package:flutter_application_ecommerce/screen/featured_collections/featured_collections_controller.dart';
import 'package:flutter_application_ecommerce/screen/featured_collections/featured_collections_view.dart';
import 'package:flutter_application_ecommerce/screen/home_screen/homescreen_view.dart';
import 'package:flutter_application_ecommerce/screen/home_screen/second_splash.dart';
import 'package:flutter_application_ecommerce/screen/login_screen/login_screen_view.dart';
import 'package:flutter_application_ecommerce/screen/product_detail/product_detail_screen.dart';
import 'package:flutter_application_ecommerce/screen/profile_information/profile_information_binding.dart';
import 'package:flutter_application_ecommerce/screen/profile_information/profile_information_view.dart';
import 'package:flutter_application_ecommerce/screen/profile_screen/profile_screen_view.dart';
import 'package:flutter_application_ecommerce/screen/register_screen/register_screen_view.dart';
import 'package:flutter_application_ecommerce/screen/splash_screen.dart';
import 'package:get/get.dart';
import 'package:flutter_application_ecommerce/screen/cart/cart_binding.dart';
import 'package:flutter_application_ecommerce/screen/cart/cart_view.dart' hide CategoryView;

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.splash, 
      page: () => SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.splash2, 
      page: () => SecondSplash(),
    ),
    GetPage(
      name: AppRoutes.login, 
      page: () => LoginScreenView(),
    ),
    GetPage(
      name: AppRoutes.register, 
      page: () => RegisterScreenView(),
    ),
    GetPage(
      name: AppRoutes.homescreen,
      page: () => HomeScreenView(
        email: Get.arguments ?? '',
      ),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => ProfileScreenView(
        email: Get.arguments ?? '',
      ),
    ),
    GetPage(
      name: AppRoutes.profileinformation,
      page: () => const ProfileInformationView(),
      binding: ProfileInformationBinding(),
    ),
    GetPage(
      name: AppRoutes.category,
      page: () => CategoriesScreen(),
      binding: CategoryBinding(),
    ),
    GetPage(
      name: AppRoutes.eletronic, 
      page: () => EletronicView(),
    ),
    GetPage(
      name: AppRoutes.Category, 
      page: () => CategoriesScreen(),
    ),
    GetPage(
      name: AppRoutes.Category_all_product, 
      page: () => CategoryProductsView(),
    ),

    // Product Detail Route with dynamic parameter parsing
    GetPage(
      name: AppRoutes.Product_detail_view,
      page: () {
        // Accepts either integer via arguments or URL parameter string
        final int id = Get.arguments is int 
            ? Get.arguments 
            : int.tryParse(Get.parameters['id'] ?? '') ?? 0;
            
        return ProductDetailScreen(productId: id);
      },
    ),
     GetPage(
      name: AppRoutes.Card_Screen_View,
      page: () =>CardScreenView(),
        // Accepts either integer via arguments or URL parameter string
        
      
    ),
    GetPage(
  name: '/featured-collections',
  page: () => const FeaturedCollectionsView(),
  binding: BindingsBuilder(() {
    Get.lazyPut<FeaturedCollectionsController>(
      () => FeaturedCollectionsController(),
    );
  }),
),
    GetPage(name: AppRoutes.payment_screenview, page: ()=>PaymentScreen())

    // Cart Route
    // GetPage(
    //   name: AppRoutes.cart,
    //   page: () => const CartView(),
    //   binding: CartBinding(),
    // ),
  ];
}