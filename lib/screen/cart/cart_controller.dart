import 'package:get/get.dart';
import 'cart_item_model.dart';

class CartController extends GetxController {
  // បញ្ជីទំនិញគំរូក្នុង Cart
  var cartItems = <CartItem>[
    CartItem(
      id: '1',
      name: 'Tech Innovations Laptop',
      imageUrl: 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=500',
      price: 999.99,
      quantity: 1,
    ),
    CartItem(
      id: '2',
      name: 'Smart Watch Luxury',
      imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500',
      price: 249.50,
      quantity: 2,
    ),
  ].obs;

  // គណនាផលបូកសរុប (Subtotal)
  double get subtotal => cartItems.fold(
        0,
        (sum, item) => sum + (item.price * item.quantity),
      );

  // ថ្លៃដឹកជញ្ជូន
  double get shippingFee => cartItems.isEmpty ? 0.0 : 15.00;

  // តម្លៃសរុបចុងក្រោយ
  double get totalPrice => subtotal + shippingFee;

  // បន្ថែមចំនួនទំនិញ
  void incrementQuantity(int index) {
    cartItems[index].quantity++;
    cartItems.refresh();
  }

  // បន្ថយចំនួនទំនិញ
  void decrementQuantity(int index) {
    if (cartItems[index].quantity > 1) {
      cartItems[index].quantity--;
      cartItems.refresh();
    }
  }

  // លុបទំនិញចេញពី Cart
  void removeItem(int index) {
    cartItems.removeAt(index);
  }
}