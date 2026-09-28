import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../data/services/seed_data_service.dart';
import '../../../core/storage/local_storage_service.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/cart_models.dart';
import '../../../app/routes/app_routes.dart';

class ProductDetailController extends GetxController {
  final LocalStorageService _localStorage = Get.find<LocalStorageService>();
  
  Rx<ProductModel?> product = Rx<ProductModel?>(null);
  RxBool isInWishlist = false.obs;
  RxInt quantity = 1.obs;

  @override
  void onInit() {
    super.onInit();
    final productId = Get.parameters['id'];
    if (productId != null) {
      product.value = SeedDataService.products.firstWhereOrNull((p) => p.id == productId);
      if (product.value != null) {
        isInWishlist.value = _localStorage.isInWishlist(product.value!.id);
      }
    }
  }

  void incrementQuantity() {
    final maxStock = product.value?.stockQuantity ?? 1;
    if (quantity.value < maxStock) {
      quantity.value++;
    }
  }

  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  void toggleWishlist() async {
    if (product.value == null) return;
    
    if (isInWishlist.value) {
      await _localStorage.removeWishlistItem(product.value!.id);
      isInWishlist.value = false;
    } else {
      await _localStorage.saveWishlistItem(WishlistItemModel(id: product.value!.id, productId: product.value!.id, userId: _localStorage.userId ?? 'guest', productName: product.value!.name, productImageUrl: product.value!.imageUrl, productPrice: product.value!.effectivePrice, addedAt: DateTime.now()));
      isInWishlist.value = true;
    }
  }

  void addToCart() async {
    if (product.value == null) return;
    
    final p = product.value!;
    final cartItem = CartItemModel(
      id: const Uuid().v4(),
      productId: p.id,
      productName: p.name,
      productImageUrl: p.imageUrl,
      productPrice: p.effectivePrice,
      quantity: quantity.value,
      fandomId: p.fandomId,
      fandomName: p.fandomName,
    );
    
    await _localStorage.saveCartItem(cartItem);
    Get.snackbar(
      'Added to Cart',
      '${quantity.value} × ${p.name} added to your cart.',
      snackPosition: SnackPosition.BOTTOM,
    );
    quantity.value = 1;
  }
}
