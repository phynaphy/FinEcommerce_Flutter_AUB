class ProcessCheckoutModel {
  final String shippingAddress;
  final String phoneNumber;
  final String notes;

  final List<CheckoutItem> items;

  final double subtotal;
  final double shippingFee;
  final double total;

  ProcessCheckoutModel({
    required this.shippingAddress,
    required this.phoneNumber,
    required this.notes,
    required this.items,
    required this.subtotal,
    required this.shippingFee,
    required this.total,
  });

  factory ProcessCheckoutModel.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List? ?? [];

    return ProcessCheckoutModel(
      shippingAddress:
          json['shippingAddress']?.toString() ?? '',

      phoneNumber:
          json['phoneNumber']?.toString() ?? '',

      notes:
          json['notes']?.toString() ?? '',

      items: itemsJson
          .map(
            (item) => CheckoutItem.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList(),

      subtotal: _toDouble(json['subtotal']),

      shippingFee: _toDouble(json['shippingFee']),

      total: _toDouble(json['total']),
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) {
      return 0.0;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString()) ?? 0.0;
  }
}

class CheckoutItem {
  final int productId;
  final String name;
  final int quantity;
  final double price;

  CheckoutItem({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.price,
  });

  factory CheckoutItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return CheckoutItem(
      productId: _toInt(json['productId']),
      name: json['name']?.toString() ?? '',
      quantity: _toInt(json['quantity']),
      price: _toDouble(json['price']),
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) {
      return 0;
    }

    if (value is int) {
      return value;
    }

    return int.tryParse(value.toString()) ?? 0;
  }

  static double _toDouble(dynamic value) {
    if (value == null) {
      return 0.0;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString()) ?? 0.0;
  }
}