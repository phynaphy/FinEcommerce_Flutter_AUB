import 'package:flutter_application_ecommerce/screen/product_detail/product_model.dart';

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

  factory ProductModel.fromJson(
    Map<String, dynamic> json,
    String baseUrl,
  ) {
    return ProductModel(
      id: json['id'] ?? 0,

      name: json['name']?.toString() ?? '',

      price: _toDouble(json['price']),

      originalPrice: _toDouble(
        json['originalPrice'],
      ),

      discountPercentage: _toDouble(
        json['discountPercentage'],
      ),

      rating: _toDouble(
        json['rating'],
      ),

      reviewCount: json['reviewCount'] ?? 0,

      isOfficialStore:
          json['isOfficialStore'] ?? false,

      mainImageUrl: _buildImageUrl(
        json['mainImageUrl'],
        baseUrl,
      ),

      imageUrls:
          (json['imageUrls'] as List? ?? [])
              .map(
                (image) => _buildImageUrl(
                  image.toString(),
                  baseUrl,
                ),
              )
              .toList(),

      description:
          json['description']?.toString() ?? '',

      categoryId:
          json['categoryId'] ?? 0,

      categoryName:
          json['categoryName']?.toString() ?? '',

      variants:
          (json['variants'] as List? ?? [])
              .map(
                (variant) =>
                    ProductVariant.fromJson(variant),
              )
              .toList(),

      features:
          (json['features'] as List? ?? [])
              .map(
                (feature) =>
                    ProductFeature.fromJson(feature),
              )
              .toList(),
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) {
      return 0.0;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
          value.toString(),
        ) ??
        0.0;
  }

  static String _buildImageUrl(
    String? imageUrl,
    String baseUrl,
  ) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return '';
    }

    if (imageUrl.startsWith('http')) {
      return imageUrl;
    }

    return '$baseUrl$imageUrl';
  }
}
