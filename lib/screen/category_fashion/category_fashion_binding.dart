import 'package:get/get.dart';
import 'category_fashion_controller.dart';

class CategoryFashionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryFashionController>(() => CategoryFashionController());
  }
}