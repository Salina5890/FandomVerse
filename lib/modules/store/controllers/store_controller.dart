import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/cart_models.dart';
import '../../../data/services/seed_data_service.dart';
import '../../../core/storage/local_storage_service.dart';

enum ProductSort { featured, priceLowHigh, priceHighLow, newest }

class StoreController extends GetxController {
  final LocalStorageService _localStorage = Get.find<LocalStorageService>();

  final RxList<ProductModel> featuredProducts = <ProductModel>[].obs;
  final RxList<ProductModel> allProducts = <ProductModel>[].obs;
  final RxList<ProductModel> filteredProducts = <ProductModel>[].obs;
  final RxList<dynamic> categories = <dynamic>[].obs;
  final RxString selectedCategory = 'All'.obs;
  final Rx<ProductSort> sort = ProductSort.featured.obs;
  final RxString query = ''.obs;
  final RxBool isLoading = true.obs;

  /// Product IDs currently in the wishlist, kept in sync with Hive so the
  /// heart icon on every product card updates instantly and survives
  /// navigation.
  final RxSet<String> wishlistedProductIds = <String>{}.obs;

  @override
  void onInit() { super.onInit(); _loadStoreData(); refreshWishlistState(); }

  void refreshWishlistState() {
    wishlistedProductIds.assignAll(
      _localStorage.getWishlist().map((w) => w.productId),
    );
  }

  bool isWishlisted(String productId) => wishlistedProductIds.contains(productId);

  Future<void> toggleWishlist(ProductModel product) async {
    if (wishlistedProductIds.contains(product.id)) {
      await _localStorage.removeWishlistItem(product.id);
      wishlistedProductIds.remove(product.id);
    } else {
      await _localStorage.saveWishlistItem(WishlistItemModel(
        id: product.id,
        productId: product.id,
        userId: _localStorage.userId ?? 'guest',
        productName: product.name,
        productImageUrl: product.imageUrl,
        productPrice: product.effectivePrice,
        addedAt: DateTime.now(),
      ));
      wishlistedProductIds.add(product.id);
    }
  }

  Future<void> _loadStoreData() async {
    isLoading.value = true;
    await Future<void>.delayed(const Duration(milliseconds: 300));
    categories.assignAll(SeedDataService.categories);
    allProducts.assignAll(SeedDataService.products);
    featuredProducts.assignAll(SeedDataService.featuredProducts);
    applyFilters();
    isLoading.value = false;
  }

  List<String> get categoryNames => ['All', ...categories.map((c) => c['name'] as String)];

  void setCategory(String value) { selectedCategory.value = value; applyFilters(); }
  void setSort(ProductSort value) { sort.value = value; applyFilters(); }
  void setQuery(String value) { query.value = value; applyFilters(); }

  void applyFilters() {
    var result = allProducts.where((p) {
      final categoryOk = selectedCategory.value == 'All' || p.categoryName == selectedCategory.value || p.categoryId == selectedCategory.value;
      final q = query.value.trim().toLowerCase();
      final queryOk = q.isEmpty || p.name.toLowerCase().contains(q) || (p.fandomName ?? '').toLowerCase().contains(q) || p.tags.any((t) => t.toLowerCase().contains(q));
      return categoryOk && queryOk;
    }).toList();
    switch (sort.value) {
      case ProductSort.featured:
        result.sort((a, b) { final f = (b.isFeatured ? 1 : 0).compareTo(a.isFeatured ? 1 : 0); return f != 0 ? f : b.createdAt.compareTo(a.createdAt); });
      case ProductSort.priceLowHigh: result.sort((a, b) => a.effectivePrice.compareTo(b.effectivePrice));
      case ProductSort.priceHighLow: result.sort((a, b) => b.effectivePrice.compareTo(a.effectivePrice));
      case ProductSort.newest: result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
    filteredProducts.assignAll(result);
  }
}
