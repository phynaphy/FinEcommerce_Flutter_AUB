import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/app/routes/approutes.dart';
import 'package:flutter_application_ecommerce/screen/button_navigation/nav_button.dart';
import 'package:flutter_application_ecommerce/screen/category/category_binding.dart';
import 'package:flutter_application_ecommerce/screen/category/category_view.dart';
import 'package:flutter_application_ecommerce/screen/category_beauty/category_beauty_binding.dart';
import 'package:flutter_application_ecommerce/screen/category_beauty/category_beauty_view.dart';
import 'package:flutter_application_ecommerce/screen/category_fashion/category_fashion_binding.dart';
import 'package:flutter_application_ecommerce/screen/category_fashion/category_fashion_view.dart';
import 'package:flutter_application_ecommerce/screen/category_kitchen/category_kitchen_binding.dart';
import 'package:flutter_application_ecommerce/screen/category_kitchen/category_kitchen_controller.dart';
import 'package:flutter_application_ecommerce/screen/category_kitchen/category_kitchen_view.dart';
import 'package:flutter_application_ecommerce/screen/category_products/category_products_controller.dart';
import 'package:flutter_application_ecommerce/screen/category_products/category_products_view.dart';
import 'package:flutter_application_ecommerce/screen/featured_collections/featured_collections_binding.dart';
import 'package:flutter_application_ecommerce/screen/featured_collections/featured_collections_view.dart';
import 'package:flutter_application_ecommerce/screen/home_screen/homescreen_view.dart';
import 'package:flutter_application_ecommerce/screen/home_screen/second_splash.dart';
import 'package:flutter_application_ecommerce/screen/login_screen/login_screen_view.dart';
import 'package:flutter_application_ecommerce/screen/profile_information/profile_information_binding.dart';

import 'package:flutter_application_ecommerce/screen/profile_information/profile_information_view.dart';
// import 'package:flutter_application_ecommerce/screen/profile_informations/profile_information_binding.dart';

import 'package:flutter_application_ecommerce/screen/profile_screen/profile_screen_view.dart';
import 'package:flutter_application_ecommerce/screen/register_screen/register_screen_view.dart';
import 'package:flutter_application_ecommerce/screen/splash_screen.dart';
import 'package:get/get.dart';
import 'package:flutter_application_ecommerce/screen/cart/cart_binding.dart';
import 'package:flutter_application_ecommerce/screen/cart/cart_view.dart' hide CategoryView;

class AppPages {
  static final routes = [
    GetPage(name: AppRoutes.splash, page: () => SplashScreen()),
    GetPage(name: AppRoutes.splash2, page: () => SecondSplash()),
    GetPage(name: AppRoutes.login, page: () => LoginScreenView()),
    GetPage(name: AppRoutes.register, page: () => RegisterScreenView()),
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
//     GetPage(
//   name: AppRoutes.cart, // ឬឈ្មោះ route របស់អ្នក
//   page: () => const Cartv
//   binding: CartBinding(),
// ),
  ];
}