import 'dart:convert';

class FavoriteResponse {
  final int id;
  final int productId;
  final String productName;
  final double price;
  final double? originalPrice;
  final String? mainImageUrl;
  final double? rating;
  final String? createdAt;

  FavoriteResponse({
    required this.id,
    required this.productId,
    required this.productName,
    required this.price,
    this.originalPrice,
    this.mainImageUrl,
    this.rating,
    this.createdAt,
  });

  // Base URL for image resolution
  // Use 'http://10.0.2.2:8080' for Android Emulator
  // Use 'http://localhost:8080' for iOS Simulator / Web
  static const String serverOrigin = 'http://192.168.56.1:8080';

  static String? resolveImageUrl(String? url) {
    if (url == null || url.trim().isEmpty) return null;
    final path = url.trim();
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path; // Already a full URL
    }
    return path.startsWith('/')
        ? '$serverOrigin$path'
        : '$serverOrigin/$path';
  }

  factory FavoriteResponse.fromJson(Map<String, dynamic> json) {
    return FavoriteResponse(
      id: json['id'] ?? 0,
      productId: json['productId'] ?? 0,
      productName: json['productName'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (json['originalPrice'] as num?)?.toDouble(),
      mainImageUrl: resolveImageUrl(json['mainImageUrl']), // Resolved full URL
      rating: (json['rating'] as num?)?.toDouble(),
      createdAt: json['createdAt'],
    );
  }
}