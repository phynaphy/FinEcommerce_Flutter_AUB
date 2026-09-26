class CategoryModel {
  final int id;
  final String name;
  final String? mainImageUrl;
  final int totalProducts;

  CategoryModel({
    required this.id,
    required this.name,
    required this.mainImageUrl,
    required this.totalProducts,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      mainImageUrl: json['mainImageUrl'],
      totalProducts: json['totalProducts'] ?? 0,
    );
  }
}
