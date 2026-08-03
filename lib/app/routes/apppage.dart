import 'package:flutter_application_ecommerce/app/routes/approutes.dart';
import 'package:flutter_application_ecommerce/screen/home_screen/splash2.dart';
import 'package:flutter_application_ecommerce/screen/splash_screen.dart';
import 'package:get/get.dart';



class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () =>  SplashScreen(),
    ),
        GetPage(
      name: AppRoutes.splash2,
      page: () =>  Splash2(),
    ),
  ];
}