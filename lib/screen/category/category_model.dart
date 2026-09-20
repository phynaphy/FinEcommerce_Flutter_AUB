class CategoryModel {
  final int id;
  final String name;
  final String? imageUrl;
  final int totalProducts;

  CategoryModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.totalProducts,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'],
      totalProducts: json['totalProducts'] ?? 0,
    );
  }
}
