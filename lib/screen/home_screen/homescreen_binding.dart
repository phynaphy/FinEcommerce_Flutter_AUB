import 'package:flutter_application_ecommerce/screen/login_screen/login_screen_controller.dart';
import 'package:get/get.dart';


class HomescreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomescreenBinding>(
      () => HomescreenBinding(),
    );
  }
}