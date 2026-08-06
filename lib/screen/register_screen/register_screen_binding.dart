import 'package:flutter_application_ecommerce/screen/register_screen/register_screen_controller.dart';
import 'package:get/get.dart';


class RegisterScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterScreenController>(
      () =>   RegisterScreenController(),
    );
  }
}