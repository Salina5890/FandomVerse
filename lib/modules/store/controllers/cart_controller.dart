import 'package:get/get.dart';
import '../../../core/storage/local_storage_service.dart';
import '../../../data/services/seed_data_service.dart';
import '../../../data/models/cart_models.dart';
import '../../../data/models/product_model.dart';

class CartItemDetail {
  final CartItemModel cartItem;
  final ProductModel product;

  CartItemDetail(this.cartItem, this.product);
}

class CartController extends GetxController {
  final LocalStorageService _localStorage = Get.find<LocalStorageService>();
  
  RxList<CartItemDetail> cartItems = <CartItemDetail>[].obs;
  
  double get subtotal => cartItems.fold(0, (sum, item) => sum + (item.product.effectivePrice * item.cartItem.quantity));
  double get shipping => cartItems.isEmpty ? 0 : 5.99;
  double get total => subtotal + shipping;

  @override
  void onInit() {
    super.onInit();
    loadCart();
  }

  void loadCart() {
    final items = _localStorage.getCart();
    final List<CartItemDetail> detailedItems = [];
    
    for (var item in items) {
      final product = SeedDataService.products.firstWhereOrNull((p) => p.id == item.productId);
      if (product != null) {
        detailedItems.add(CartItemDetail(item, product));
      }
    }
    
    cartItems.value = detailedItems;
  }

  void updateQuantity(String cartItemId, int newQuantity) async {
    if (newQuantity < 1) return;
    
    final itemIndex = cartItems.indexWhere((item) => item.cartItem.id == cartItemId);
    if (itemIndex >= 0) {
      final updatedItem = cartItems[itemIndex].cartItem.copyWith(quantity: newQuantity);
      await _localStorage.saveCartItem(updatedItem);
      loadCart();
    }
  }

  void removeItem(String cartItemId) async {
    await _localStorage.removeCartItem(cartItemId);
    loadCart();
  }
}
