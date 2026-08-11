import 'package:flutter_application_ecommerce/app/routes/approutes.dart';
import 'package:flutter_application_ecommerce/screen/category/category_binding.dart';
import 'package:flutter_application_ecommerce/screen/category/category_view.dart';
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
import 'package:flutter_application_ecommerce/screen/cart/cart_view.dart';

class AppPages {
  static final routes = [
    GetPage(name: AppRoutes.splash, page: () => SplashScreen()),
    GetPage(name: AppRoutes.splash2, page: () => SecondSplash()),
    GetPage(name: AppRoutes.login, page: () => LoginScreenView()),
    GetPage(name: AppRoutes.register, page: () => RegisterScreenView()),
    GetPage(name: AppRoutes.homescreen, page: () => HomescreenView()),
    GetPage(name: AppRoutes.profile, page: () => ProfileScreenView()),
    GetPage(
      name: AppRoutes.profileinformation,
      page: () => const ProfileInformationView(),
      binding: ProfileInformationBinding(),
    ),
    GetPage(
      name: AppRoutes.category,
      page: () => const CategoryView(),
      binding: CategoryBinding(),
    ),
    GetPage(
  name: AppRoutes.cart, // ឬឈ្មោះ route របស់អ្នក
  page: () => const CartView(),
  binding: CartBinding(),
),
  ];
}