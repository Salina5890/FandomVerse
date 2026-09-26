import 'package:get/get.dart';
import '../../../core/storage/local_storage_service.dart';
import '../../../data/models/cart_models.dart';

class PurchaseHistoryController extends GetxController {
  final LocalStorageService _localStorage = Get.find<LocalStorageService>();
  
  RxList<OrderModel> orders = <OrderModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  void loadOrders() {
    final allOrders = _localStorage.getOrders();
    // Sort descending by date
    allOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    orders.value = allOrders;
  }
}
