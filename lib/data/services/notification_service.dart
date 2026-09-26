import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../app/routes/app_routes.dart';
import '../../core/storage/local_storage_service.dart';
import '../models/notification_model.dart';
import '../services/seed_data_service.dart';

class NotificationService extends GetxService {
  final LocalStorageService _storage = Get.find<LocalStorageService>();
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;

  Future<NotificationService> init() async {
    notifications.assignAll(_storage.getNotifications());
    await checkWishlistPriceDrops();
    return this;
  }

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  bool hasKey(String key) => notifications.any((n) => n.arguments?['dedupeKey'] == key);

  Future<void> add({
    required String type,
    required String title,
    required String message,
    String? iconKey,
    String? route,
    Map<String, dynamic>? arguments,
  }) async {
    final item = NotificationModel(
      id: const Uuid().v4(),
      type: type,
      title: title,
      message: message,
      timestamp: DateTime.now(),
      iconKey: iconKey,
      route: route,
      arguments: arguments,
    );
    await _storage.saveNotification(item);
    notifications.insert(0, item);
  }

  Future<void> addIfMissing({
    required String dedupeKey,
    required String type,
    required String title,
    required String message,
    String? iconKey,
    String? route,
    Map<String, dynamic>? arguments,
  }) async {
    if (hasKey(dedupeKey)) return;
    await add(
      type: type, title: title, message: message, iconKey: iconKey, route: route,
      arguments: {...?arguments, 'dedupeKey': dedupeKey},
    );
  }

  Future<void> markRead(String id) async {
    await _storage.markNotificationRead(id);
    final index = notifications.indexWhere((n) => n.id == id);
    if (index >= 0) notifications[index] = notifications[index].copyWith(isRead: true);
  }

  Future<void> markAllRead() async {
    await _storage.markAllNotificationsRead();
    notifications.assignAll(notifications.map((n) => n.copyWith(isRead: true)));
  }

  Future<void> checkWishlistPriceDrops() async {
    final products = {for (final p in SeedDataService.products) p.id: p};
    for (final item in _storage.getWishlist()) {
      final current = products[item.productId];
      if (current == null || current.effectivePrice >= item.productPrice) continue;
      await addIfMissing(
        dedupeKey: 'price-drop:${item.productId}:${current.effectivePrice.toStringAsFixed(2)}',
        type: 'price_drop',
        title: 'Price Drop!',
        message: '${item.productName} is now Rs. ${current.effectivePrice.toStringAsFixed(2)} — down from Rs. ${item.productPrice.toStringAsFixed(2)}.',
        iconKey: 'tag',
        route: AppRoutes.productDetail.replaceFirst(':id', item.productId),
        arguments: {'productId': item.productId},
      );
    }
  }

  Future<void> seedWelcomeIfEmpty() async {
    if (notifications.isEmpty) {
      await add(
        type: 'system',
        title: 'Welcome to Fandom Verse',
        message: 'Your fan identity is ready. Start exploring your fandoms.',
        iconKey: 'star',
        route: AppRoutes.fanExplore,
      );
    }
  }
}
