import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../app/constants/app_constants.dart';
import '../../data/models/user_model.dart';
import '../../data/models/cart_models.dart';
import '../../data/models/notification_model.dart';

/// Local persistent storage using Hive.
/// Abstracts all box operations behind clean typed methods.
class LocalStorageService extends GetxService {
  // ── Preferences / Settings ─────────────────────────────────
  late Box _settingsBox;

  // ── Data Boxes ─────────────────────────────────────────────
  late Box _bookmarksBox;
  late Box _savedBox;
  late Box _cartBox;
  late Box _ordersBox;
  late Box _wishlistBox;
  late Box _userBox;
  late Box _notificationBox;
  late Box _inquiryBox;

  Future<LocalStorageService> init() async {
    await Hive.initFlutter();
    _settingsBox = await Hive.openBox(AppConstants.boxSettings);
    _bookmarksBox = await Hive.openBox(AppConstants.boxBookmarks);
    _savedBox = await Hive.openBox(AppConstants.boxSaved);
    _cartBox = await Hive.openBox(AppConstants.boxCart);
    _ordersBox = await Hive.openBox(AppConstants.boxOrders);
    _wishlistBox = await Hive.openBox(AppConstants.boxWishlist);
    _userBox = await Hive.openBox(AppConstants.boxUsers);
    _notificationBox = await Hive.openBox(AppConstants.boxNotifications);
    _inquiryBox = await Hive.openBox(AppConstants.boxInquiries);
    return this;
  }

  // ── Settings ───────────────────────────────────────────────
  void setString(String key, String value) =>
      _settingsBox.put(key, value);
  String? getString(String key) => _settingsBox.get(key) as String?;

  void setBool(String key, bool value) => _settingsBox.put(key, value);
  bool getBool(String key, {bool defaultValue = false}) =>
      _settingsBox.get(key, defaultValue: defaultValue) as bool;

  void setStringList(String key, List<String> value) =>
      _settingsBox.put(key, value);
  List<String> getStringList(String key) {
    final val = _settingsBox.get(key);
    if (val == null) return [];
    return List<String>.from(val as List);
  }

  void remove(String key) => _settingsBox.delete(key);
  void clearSettings() => _settingsBox.clear();

  // ── Auth State ─────────────────────────────────────────────
  bool get isLoggedIn => getBool(AppConstants.keyIsLoggedIn);
  String? get userId => getString(AppConstants.keyUserId);
  String? get userRole => getString(AppConstants.keyUserRole);
  bool get onboardingDone => getBool(AppConstants.keyOnboardingDone);
  List<String> get selectedFandomIds =>
      getStringList(AppConstants.keySelectedFandoms);

  void saveAuthState({
    required String userId,
    required String role,
    required String email,
  }) {
    setString(AppConstants.keyUserId, userId);
    setString(AppConstants.keyUserRole, role);
    setString(AppConstants.keyUserEmail, email);
    setBool(AppConstants.keyIsLoggedIn, true);
  }

  void clearAuthState() {
    remove(AppConstants.keyUserId);
    remove(AppConstants.keyUserRole);
    remove(AppConstants.keyUserEmail);
    setBool(AppConstants.keyIsLoggedIn, false);
  }

  // ── User Profile ───────────────────────────────────────────
  Future<void> saveUser(UserModel user) =>
      _userBox.put(user.id, user.toMap());

  UserModel? findUserByEmail(String email) {
    for (final value in _userBox.values) {
      final user = UserModel.fromMap(Map<String, dynamic>.from(value as Map));
      if (user.email.toLowerCase() == email.toLowerCase()) return user;
    }
    return null;
  }

  UserModel? getUser(String id) {
    final data = _userBox.get(id);
    if (data == null) return null;
    return UserModel.fromMap(Map<String, dynamic>.from(data as Map));
  }


  // ── Notifications ────────────────────────────────────────
  List<NotificationModel> getNotifications() => _notificationBox.values
      .map((e) => NotificationModel.fromMap(Map<String, dynamic>.from(e as Map)))
      .toList()
    ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

  Future<void> saveNotification(NotificationModel notification) =>
      _notificationBox.put(notification.id, notification.toMap());

  Future<void> markNotificationRead(String id) async {
    final raw = _notificationBox.get(id);
    if (raw == null) return;
    final notification = NotificationModel.fromMap(Map<String, dynamic>.from(raw as Map));
    await saveNotification(notification.copyWith(isRead: true));
  }

  Future<void> markAllNotificationsRead() async {
    for (final notification in getNotifications()) {
      await saveNotification(notification.copyWith(isRead: true));
    }
  }

  // ── Contact inquiries ─────────────────────────────────────
  Future<void> saveInquiry(Map<String, dynamic> inquiry) =>
      _inquiryBox.put(inquiry['id'], inquiry);

  List<Map<String, dynamic>> getInquiries() => _inquiryBox.values
      .map((e) => Map<String, dynamic>.from(e as Map))
      .toList();

  // ── Cart ───────────────────────────────────────────────────
  List<CartItemModel> getCart() {
    return _cartBox.values
        .map((e) =>
            CartItemModel.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> saveCartItem(CartItemModel item) =>
      _cartBox.put(item.id, item.toMap());

  Future<void> removeCartItem(String id) => _cartBox.delete(id);
  Future<void> clearCart() => _cartBox.clear();

  // ── Wishlist ───────────────────────────────────────────────
  List<WishlistItemModel> getWishlist() {
    return _wishlistBox.values
        .map((e) =>
            WishlistItemModel.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> saveWishlistItem(WishlistItemModel item) =>
      _wishlistBox.put(item.id, item.toMap());

  Future<void> removeWishlistItem(String id) => _wishlistBox.delete(id);

  bool isInWishlist(String productId) {
    return _wishlistBox.values.any((e) {
      final map = Map<String, dynamic>.from(e as Map);
      return map['productId'] == productId;
    });
  }

  // ── Bookmarks ──────────────────────────────────────────────
  List<BookmarkModel> getBookmarks() {
    return _bookmarksBox.values
        .map((e) =>
            BookmarkModel.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  void saveBookmark(BookmarkModel bookmark) =>
      _bookmarksBox.put(bookmark.id, bookmark.toMap());

  void removeBookmark(String id) => _bookmarksBox.delete(id);

  bool isBookmarked(String contentId) {
    return _bookmarksBox.values.any((e) {
      final map = Map<String, dynamic>.from(e as Map);
      return map['contentId'] == contentId;
    });
  }

  String? getBookmarkId(String contentId) {
    for (final e in _bookmarksBox.values) {
      final map = Map<String, dynamic>.from(e as Map);
      if (map['contentId'] == contentId) return map['id'] as String?;
    }
    return null;
  }

  // ── Orders ─────────────────────────────────────────────────
  List<OrderModel> getOrders() {
    return _ordersBox.values
        .map((e) =>
            OrderModel.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> saveOrder(OrderModel order) =>
      _ordersBox.put(order.id, order.toMap());

  // ── Saved Content (offline) ────────────────────────────────
  List<Map<String, dynamic>> getSavedContent() {
    return _savedBox.values
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  void saveContentOffline(Map<String, dynamic> contentMap) =>
      _savedBox.put(contentMap['id'], contentMap);

  void removeSavedContent(String id) => _savedBox.delete(id);

  bool isSavedOffline(String contentId) =>
      _savedBox.containsKey(contentId);

  // ── Account deletion ───────────────────────────────────────
  /// Wipes every locally-stored box for the current user (cart, wishlist,
  /// bookmarks, orders, offline content) and clears the session. Used by
  /// the "Delete Account" flow in Edit Profile.
  Future<void> clearAllUserData(String userId) async {
    await _cartBox.clear();
    await _wishlistBox.clear();
    await _bookmarksBox.clear();
    await _ordersBox.clear();
    await _savedBox.clear();
    await _userBox.delete(userId);
    clearAuthState();
  }
}
