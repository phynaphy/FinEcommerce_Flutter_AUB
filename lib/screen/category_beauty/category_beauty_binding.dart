import 'package:get/get.dart';
import 'category_beauty_controller.dart';

class CategoryBeautyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryBeautyController>(() => CategoryBeautyController());
  }
}