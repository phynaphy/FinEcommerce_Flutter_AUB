import 'package:get/get.dart';
import 'package:flutter_application_ecommerce/screen/category/category_controller.dart';

class CategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CategoryController());
  }
}