import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/app/routes/approutes.dart';
import 'package:flutter_application_ecommerce/screen/button_navigation/nav_button.dart';
import 'package:flutter_application_ecommerce/screen/category/category_binding.dart';
import 'package:flutter_application_ecommerce/screen/category/category_view.dart';
import 'package:flutter_application_ecommerce/screen/home_screen/homescreen_view.dart';
import 'package:flutter_application_ecommerce/screen/home_screen/second_splash.dart';
import 'package:flutter_application_ecommerce/screen/login_screen/login_screen_view.dart';

import 'package:flutter_application_ecommerce/screen/profile_information/profile_information_view.dart';


import 'package:flutter_application_ecommerce/screen/profile_screen/profile_screen_view.dart';
import 'package:flutter_application_ecommerce/screen/register_screen/register_screen_view.dart';
import 'package:flutter_application_ecommerce/screen/splash_screen.dart';
import 'package:get/get.dart';

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
      page: () => ProfileInformationView(),
     
    ),

    GetPage(
      name: AppRoutes.category,
      page: () => const CategoryView(),
      // binding: CategoryBinding(),
      
    ),
//     GetPage(
//   name: AppRoutes.nav_button,
//   page: () => Scaffold(
//     body: Center(
//       child: Row(
//         children: [
//           NavButton(
//             onTap: (index) {
//               debugPrint('Tapped index: $index');
//             },
//             position: 0.0,
//             length: 5,
//             index: 0,
//             child: const Icon(
//               Icons.home,
//               size: 30,
//             ),
//           ),
//         ],
//       ),
//     ),
//   ),
// ),
  ];
}
