import 'package:get/get.dart';
import 'package:flutter_application_ecommerce/screen/profile_information/profile_information_controller.dart';

class ProfileInformationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileInformationController>(
      () => ProfileInformationController(),
    );
  }
}