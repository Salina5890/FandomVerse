import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../core/storage/local_storage_service.dart';
import '../../../data/services/seed_data_service.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/cart_models.dart';
import '../../../data/services/notification_service.dart';
import '../../../app/routes/app_routes.dart';

class WishlistController extends GetxController {
  final LocalStorageService _localStorage = Get.find<LocalStorageService>();
  
  RxList<ProductModel> wishlistProducts = <ProductModel>[].obs;

  final NotificationService _notifications = Get.find<NotificationService>();

  @override
  void onInit() {
    super.onInit();
    loadWishlist();
    syncPriceDrops();
  }

  void loadWishlist() {
    final wishlistIds = _localStorage.getWishlist().map((w) => w.productId).toSet();
    wishlistProducts.value = SeedDataService.products
        .where((p) => wishlistIds.contains(p.id))
        .toList();
  }

  Future<void> syncPriceDrops() async {
    final currentProducts = {for (final p in SeedDataService.products) p.id: p};
    for (final item in _localStorage.getWishlist()) {
      final current = currentProducts[item.productId];
      if (current == null || current.effectivePrice >= item.productPrice) continue;
      final key = 'price-drop:${item.productId}:${current.effectivePrice.toStringAsFixed(2)}';
      await _notifications.addIfMissing(
        dedupeKey: key,
        type: 'price_drop',
        title: 'Price Drop!',
        message: '${item.productName} is now Rs. ${current.effectivePrice.toStringAsFixed(2)} — down from Rs. ${item.productPrice.toStringAsFixed(2)}.',
        iconKey: 'tag',
        route: AppRoutes.productDetail.replaceFirst(':id', item.productId),
        arguments: {'productId': item.productId},
      );
    }
  }

  void removeFromWishlist(String productId) async {
    await _localStorage.removeWishlistItem(productId);
    loadWishlist();
  }

  void addToCart(ProductModel product) async {
    final cartItem = CartItemModel(
      id: const Uuid().v4(),
      productId: product.id,
      productName: product.name,
      productImageUrl: product.imageUrl,
      productPrice: product.effectivePrice,
      quantity: 1,
      fandomId: product.fandomId,
      fandomName: product.fandomName,
    );
    
    await _localStorage.saveCartItem(cartItem);
    Get.snackbar(
      'Added to Cart',
      '${product.name} was added to your cart.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
