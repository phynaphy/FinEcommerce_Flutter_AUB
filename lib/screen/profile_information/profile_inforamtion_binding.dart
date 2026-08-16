import 'package:flutter_application_ecommerce/screen/profile_information/profile_information_controller.dart';
import 'package:get/get.dart';
// Use the full package import path:
import 'package:flutter_application_ecommerce/screen/category/category_controller.dart';

class ProfileInforamtionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() =>ProfileInformationController());
  }
}