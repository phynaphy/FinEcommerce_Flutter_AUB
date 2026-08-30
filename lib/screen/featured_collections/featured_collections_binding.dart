import 'package:get/get.dart';
import 'featured_collections_controller.dart';

class FeaturedCollectionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FeaturedCollectionsController>(
      () => FeaturedCollectionsController(),
    );
  }
}