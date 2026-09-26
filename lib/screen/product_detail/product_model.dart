class ProductModel {
  final int id;
  final String name;
  final double price;
  final double originalPrice;
  final double discountPercentage;
  final double rating;
  final int reviewCount;
  final bool isOfficialStore;
  final String mainImageUrl;
  final List<String> imageUrls;
  final String description;
  final int categoryId;
  final String categoryName;
  final List<ProductVariant> variants;
  final List<ProductFeature> features;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.originalPrice,
    required this.discountPercentage,
    required this.rating,
    required this.reviewCount,
    required this.isOfficialStore,
    required this.mainImageUrl,
    required this.imageUrls,
    required this.description,
    required this.categoryId,
    required this.categoryName,
    required this.variants,
    required this.features,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json, String baseUrl) {
    // Combine main image and gallery images into a single list
    List<String> combinedImages = [];
    if (json['mainImageUrl'] != null) {
      combinedImages.add('$baseUrl${json['mainImageUrl']}');
    }
    if (json['imageUrls'] != null) {
      for (var url in json['imageUrls']) {
        combinedImages.add('$baseUrl$url');
      }
    }

    return ProductModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (json['originalPrice'] as num?)?.toDouble() ?? 0.0,
      discountPercentage: json['discountPercentage'] ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] ?? 0,
      isOfficialStore: json['isOfficialStore'] ?? false,
      mainImageUrl: json['mainImageUrl'] != null ? '$baseUrl${json['mainImageUrl']}' : '',
      imageUrls: combinedImages,
      description: json['description'] ?? '',
      categoryId: json['categoryId'] ?? 0,
      categoryName: json['categoryName'] ?? '',
      variants: (json['variants'] as List<dynamic>?)
              ?.map((v) => ProductVariant.fromJson(v))
              .toList() ??
          [],
      features: (json['features'] as List<dynamic>?)
              ?.map((f) => ProductFeature.fromJson(f))
              .toList() ??
          [],
    );
  }
}

class ProductVariant {
  final int id;
  final String color;
  final String colorHex;
  final String storage;
  final double priceAdjustment;
  final int stockQuantity;

  ProductVariant({
    required this.id,
    required this.color,
    required this.colorHex,
    required this.storage,
    required this.priceAdjustment,
    required this.stockQuantity,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: json['id'] ?? 0,
      color: json['color'] ?? '',
      colorHex: json['colorHex'] ?? '#000000',
      storage: json['storage'] ?? '',
      priceAdjustment: (json['priceAdjustment'] as num?)?.toDouble() ?? 0.0,
      stockQuantity: json['stockQuantity'] ?? 0,
    );
  }
}

class ProductFeature {
  final int id;
  final String featureKey;
  final String featureValue;

  ProductFeature({
    required this.id,
    required this.featureKey,
    required this.featureValue,
  });

  factory ProductFeature.fromJson(Map<String, dynamic> json) {
    return ProductFeature(
      id: json['id'] ?? 0,
      featureKey: json['featureKey'] ?? '',
      featureValue: json['featureValue'] ?? '',
    );
  }
}