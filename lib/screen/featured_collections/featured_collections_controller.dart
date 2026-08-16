import 'package:get/get.dart';
import '../category/category_controller.dart'; // Import your existing FeaturedCollection model

class FeaturedCollectionsController extends GetxController {
  // Access existing controller or load collection items directly
  final RxList<FeaturedCollection> collections = <FeaturedCollection>[
    FeaturedCollection(
      title: 'Tech Innovations',
      subtitle: 'Latest electronics & gadgets',
      imageUrl: 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?auto=format&fit=crop&w=600&q=80',
    ),
    FeaturedCollection(
      title: 'Corporate Style',
      subtitle: 'Premium professional wear',
      imageUrl: 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?auto=format&fit=crop&w=600&q=80',
    ),
    FeaturedCollection(
      title: 'Elite Living',
      subtitle: 'Curated home & workspace',
      imageUrl: 'https://images.unsplash.com/photo-1524758631624-e2822e304c36?auto=format&fit=crop&w=600&q=80',
    ),
    FeaturedCollection(
      title: 'Luxury Details',
      subtitle: 'Watches, bags & more',
      imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=600&q=80',
    ),
  ].obs;
}