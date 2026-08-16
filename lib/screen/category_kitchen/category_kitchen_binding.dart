import 'package:get/get.dart';
import 'category_kitchen_controller.dart';

class CategoryKitchenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryKitchenController>(() => CategoryKitchenController());
  }
}