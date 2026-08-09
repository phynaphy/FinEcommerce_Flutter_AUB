// import 'package:flutter/material.dart';
// import 'package:flutter_application_ecommerce/app/routes/apppage.dart';
// import 'package:flutter_application_ecommerce/app/routes/approutes.dart';
// import 'package:get/get.dart';

// void main() {
//   runApp(const MainApp());
// }

// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return  GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       initialRoute: AppRoutes.splash,
      
//       getPages: AppPages.routes,
      
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/app/routes/apppage.dart';
import 'package:flutter_application_ecommerce/app/routes/approutes.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,
    );
  }
}