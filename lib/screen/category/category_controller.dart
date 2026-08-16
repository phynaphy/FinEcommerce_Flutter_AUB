import 'package:get/get.dart';

class FeaturedCollection {
  final String title;
  final String subtitle;
  final String imageUrl;

  FeaturedCollection({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });
}

class CategoryItem {
  final String name;
  final String productCount;
  final String imageUrl;

  CategoryItem({
    required this.name,
    required this.productCount,
    required this.imageUrl,
  });
}

class CategoryController extends GetxController {
  final RxList<FeaturedCollection> featuredCollections = <FeaturedCollection>[
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

  final RxList<CategoryItem> categories = <CategoryItem>[
    CategoryItem(
      name: 'Electronics',
      productCount: '1,200 Products',
      imageUrl: 'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?auto=format&fit=crop&w=300&q=80',
    ),
    CategoryItem(
      name: 'Fashion & Apparel',
      productCount: '2,850 Products',
      imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=300&q=80',
    ),
    CategoryItem(
      name: 'Home & Kitchen',
      productCount: '880 Products',
      imageUrl: 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?auto=format&fit=crop&w=300&q=80',
    ),
    CategoryItem(
      name: 'Beauty & Health',
      productCount: '1,510 Products',
      imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?auto=format&fit=crop&w=300&q=80',
    ),
    CategoryItem(
      name: 'Sports & Outdoors',
      productCount: '945 Products',
      imageUrl: 'https://images.unsplash.com/photo-1517649763962-0c623266ddc0?auto=format&fit=crop&w=300&q=80',
    ),
  ].obs;
}