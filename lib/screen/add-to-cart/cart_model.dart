// class CartModel {
//   final int? cartId;
//   final List<CartItemModel> items;
//   final int totalItems;
//   final double totalPrice;

//   const CartModel({
//     this.cartId,
//     this.items = const [],
//     this.totalItems = 0,
//     this.totalPrice = 0,
//   });

//   factory CartModel.fromJson(Map<String, dynamic> json) {
//     final rawItems = json['items'] as List? ?? [];

//     return CartModel(
//       cartId: (json['cartId'] as num?)?.toInt(),
//       items: rawItems
//           .whereType<Map>()
//           .map(
//             (item) => CartItemModel.fromJson(
//               Map<String, dynamic>.from(item),
//             ),
//           )
//           .toList(),
//       totalItems: (json['totalItems'] as num?)?.toInt() ?? 0,
//       totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0,
//     );
//   }
// }

// class CartItemModel {
//   final int id;
//   final int productId;
//   final String productName;
//   final String? mainImageUrl;
//   final int? variantId;
//   final String? color;
//   final String? colorHex;
//   final String? storage;
//   final int quantity;
//   final double unitPrice;
//   final double subtotal;

//   const CartItemModel({
//     required this.id,
//     required this.productId,
//     required this.productName,
//     this.mainImageUrl,
//     this.variantId,
//     this.color,
//     this.colorHex,
//     this.storage,
//     required this.quantity,
//     required this.unitPrice,
//     required this.subtotal,
//   });

//   factory CartItemModel.fromJson(Map<String, dynamic> json) {
//     final quantity = (json['quantity'] as num?)?.toInt() ?? 0;
//     final unitPrice = (json['unitPrice'] as num?)?.toDouble() ?? 0;

//     return CartItemModel(
//       id: (json['id'] as num?)?.toInt() ?? 0,
//       productId: (json['productId'] as num?)?.toInt() ?? 0,
//       productName: json['productName']?.toString() ?? 'Product',
//       mainImageUrl: json['mainImageUrl']?.toString(),
//       variantId: (json['variantId'] as num?)?.toInt(),
//       color: json['color']?.toString(),
//       colorHex: json['colorHex']?.toString(),
//       storage: json['storage']?.toString(),
//       quantity: quantity,
//       unitPrice: unitPrice,
//       subtotal:
//           (json['subtotal'] as num?)?.toDouble() ?? unitPrice * quantity,
//     );
//   }
// }

import 'package:flutter/foundation.dart';

class CartModel {
  final int? cartId;
  final List<CartItemModel> items;
  final int totalItems;
  final double totalPrice;

  const CartModel({
    this.cartId,
    this.items = const [],
    this.totalItems = 0,
    this.totalPrice = 0,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    debugPrint('');
    debugPrint('========================================');
    debugPrint('CART MODEL FROM JSON');
    debugPrint('FULL JSON: $json');
    debugPrint('========================================');

    dynamic rawItems;

    // Normal:
    // {
    //   "items": [...]
    // }
    if (json['items'] is List) {
      rawItems = json['items'];
    }

    // Also support:
    // {
    //   "data": {
    //      "items": [...]
    //   }
    // }
    else if (json['data'] is Map &&
        (json['data'] as Map)['items'] is List) {
      rawItems = (json['data'] as Map)['items'];
    }

    // Also support:
    // {
    //   "data": [...]
    // }
    else if (json['data'] is List) {
      rawItems = json['data'];
    }

    rawItems ??= [];

    final List itemsList = rawItems is List ? rawItems : [];

    debugPrint('RAW ITEMS COUNT: ${itemsList.length}');

    final items = itemsList
        .whereType<Map>()
        .map(
          (item) => CartItemModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();

    debugPrint('PARSED ITEMS COUNT: ${items.length}');

    return CartModel(
      cartId: (json['cartId'] as num?)?.toInt(),

      items: items,

      totalItems:
          (json['totalItems'] as num?)?.toInt() ??
              items.fold<int>(
                0,
                (sum, item) => sum + item.quantity,
              ),

      totalPrice:
          (json['totalPrice'] as num?)?.toDouble() ??
              items.fold<double>(
                0,
                (sum, item) => sum + item.subtotal,
              ),
    );
  }
}

class CartItemModel {
  final int id;
  final int productId;
  final String productName;
  final String? mainImageUrl;

  final int? variantId;
  final String? color;
  final String? colorHex;
  final String? storage;

  final int quantity;
  final double unitPrice;
  final double subtotal;

  const CartItemModel({
    required this.id,
    required this.productId,
    required this.productName,
    this.mainImageUrl,
    this.variantId,
    this.color,
    this.colorHex,
    this.storage,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
  });

  factory CartItemModel.fromJson(
    Map<String, dynamic> json,
  ) {
    // ============================================================
    // DEBUG FULL ITEM
    // ============================================================

    debugPrint('');
    debugPrint('----------------------------------------');
    debugPrint('CART ITEM JSON');
    debugPrint('$json');
    debugPrint('----------------------------------------');

    // ============================================================
    // IMAGE
    // ============================================================

    String? imageUrl;

    // 1. Main expected field
    imageUrl = _readImage(json['mainImageUrl']);

    // 2. Other possible field names
    imageUrl ??= _readImage(json['imageUrl']);

    imageUrl ??= _readImage(json['image']);

    imageUrl ??= _readImage(json['mainImage']);

    // 3. If image is inside product object
    if (imageUrl == null && json['product'] is Map) {
      final product =
          Map<String, dynamic>.from(
        json['product'] as Map,
      );

      debugPrint(
        'PRODUCT OBJECT FOUND: $product',
      );

      imageUrl =
          _readImage(product['mainImageUrl']);

      imageUrl ??=
          _readImage(product['imageUrl']);

      imageUrl ??=
          _readImage(product['image']);

      imageUrl ??=
          _readImage(product['mainImage']);
    }

    // 4. If imageUrls is a List
    if (imageUrl == null &&
        json['imageUrls'] is List) {
      final imageList =
          json['imageUrls'] as List;

      if (imageList.isNotEmpty) {
        imageUrl =
            _readImage(imageList.first);
      }
    }

    // ============================================================
    // DEBUG IMAGE
    // ============================================================

    debugPrint('');
    debugPrint('========================================');
    debugPrint('CART ITEM IMAGE RESULT');
    debugPrint(
      'PRODUCT: ${json['productName']}',
    );
    debugPrint(
      'PRODUCT ID: ${json['productId']}',
    );
    debugPrint(
      'RAW mainImageUrl: ${json['mainImageUrl']}',
    );
    debugPrint(
      'FINAL IMAGE URL: $imageUrl',
    );
    debugPrint('========================================');

    // ============================================================
    // OTHER DATA
    // ============================================================

    final int quantity =
        (json['quantity'] as num?)?.toInt() ?? 0;

    final double unitPrice =
        (json['unitPrice'] as num?)?.toDouble() ?? 0;

    final double subtotal =
        (json['subtotal'] as num?)?.toDouble() ??
            unitPrice * quantity;

    return CartItemModel(
      id:
          (json['id'] as num?)?.toInt() ?? 0,

      productId:
          (json['productId'] as num?)?.toInt() ?? 0,

      productName:
          json['productName']?.toString() ??
              'Product',

      mainImageUrl: imageUrl,

      variantId:
          (json['variantId'] as num?)?.toInt(),

      color:
          json['color']?.toString(),

      colorHex:
          json['colorHex']?.toString(),

      storage:
          json['storage']?.toString(),

      quantity: quantity,

      unitPrice: unitPrice,

      subtotal: subtotal,
    );
  }

  // ============================================================
  // READ IMAGE SAFELY
  // ============================================================

  static String? _readImage(dynamic value) {
    if (value == null) {
      return null;
    }

    final String text =
        value.toString().trim();

    if (text.isEmpty ||
        text.toLowerCase() == 'null') {
      return null;
    }

    return text;
  }
}