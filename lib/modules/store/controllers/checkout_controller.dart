import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../core/storage/local_storage_service.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/notification_service.dart';
import '../../../data/models/cart_models.dart';
import '../../../app/routes/app_routes.dart';
import 'cart_controller.dart';

class CheckoutController extends GetxController {
  final LocalStorageService _localStorage = Get.find<LocalStorageService>();
  final AuthService _authService = Get.find<AuthService>();
  final NotificationService _notifications = Get.find<NotificationService>();
  
  final CartController cartController = Get.find<CartController>();

  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final zipController = TextEditingController();

  RxString selectedPaymentMethod = 'credit_card'.obs;

  @override
  void onInit() {
    super.onInit();
    final user = _authService.currentUser.value;
    if (user != null) {
      nameController.text = user.name;
    }
  }

  void placeOrder() async {
    if (nameController.text.isEmpty || addressController.text.isEmpty || cityController.text.isEmpty || zipController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all shipping details', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final cartItems = cartController.cartItems;
    if (cartItems.isEmpty) return;

    final items = cartItems.map((item) => item.cartItem).toList();
    final order = OrderModel(
      id: const Uuid().v4(),
      userId: _authService.currentUser.value?.id ?? 'guest',
      items: items,
      subtotal: cartController.total,
      shipping: 0,
      total: cartController.total,
      status: 'processing',
      shippingAddress: '${nameController.text}, ${addressController.text}, ${cityController.text}, ${zipController.text}',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _localStorage.saveOrder(order);
    await _notifications.add(
      type: 'order_confirmation',
      title: 'Order Confirmation',
      message: 'Your order has been saved successfully.',
      iconKey: 'shoppingCart',
      route: AppRoutes.purchaseHistory,
    );
    await _localStorage.clearCart();
    Get.offAllNamed(AppRoutes.orderConfirmation, arguments: {'orderId': order.id});
  }
  
  @override
  void onClose() {
    nameController.dispose();
    addressController.dispose();
    cityController.dispose();
    zipController.dispose();
    super.onClose();
  }
}
