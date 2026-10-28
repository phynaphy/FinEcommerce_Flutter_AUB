
import 'package:get/get.dart';
import '../category/category_controller.dart';

class FeaturedCollectionsController extends GetxController {
  final RxList<FeaturedCollection> collections =
      <FeaturedCollection>[
    FeaturedCollection(
      title: 'Tech Innovations',
      subtitle: 'Discover the future of technology',
      imageUrl:
          'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=1200&q=85',
    ),
    FeaturedCollection(
      title: 'Corporate Style',
      subtitle: 'Modern professional fashion',
      imageUrl:
          'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?auto=format&fit=crop&w=1200&q=85',
    ),
    FeaturedCollection(
      title: 'Elite Living',
      subtitle: 'Beautiful spaces and interiors',
      imageUrl:
          'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=1200&q=85',
    ),
    FeaturedCollection(
      title: 'Luxury Details',
      subtitle: 'Timeless accessories and watches',
      imageUrl:
          'https://images.unsplash.com/photo-1523170335258-f5ed11844a49?auto=format&fit=crop&w=1200&q=85',
    ),
  ].obs;

  @override
  void onInit() {
    super.onInit();

    for (final item in collections) {
      print(
        'FEATURED COLLECTION: ${item.title} | ${item.imageUrl}',
      );
    }
  }
}
