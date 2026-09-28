import 'package:get/get.dart';

import '../../../data/services/auth_service.dart';
import '../../../data/services/seed_data_service.dart';
import '../../../data/services/firestore_service.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/content_model.dart';
import '../../../data/models/event_model.dart';
import '../../../data/models/product_model.dart';

class AdminDashboardController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  FirestoreService? get _firestore => Get.isRegistered<FirestoreService>()
      ? Get.find<FirestoreService>()
      : null;

  // Selected tab index for moderation screen (0 = Posts, 1 = Events, 2 = Merchandise)
  final RxInt moderationTabIndex = 0.obs;

  // Data lists
  final RxList<UserModel> users = <UserModel>[].obs;
  final RxList<ContentModel> posts = <ContentModel>[].obs;
  final RxList<EventModel> events = <EventModel>[].obs;
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;
  final RxList<String> recentActivity = <String>[].obs;

  // Search filter for User Management
  final RxString userSearchQuery = ''.obs;

  // Summary counts
  int get totalUsersCount => users.length;
  int get totalPostsCount => posts.length;
  int get totalEventsCount => events.length;
  int get totalProductsCount => products.length;

  List<UserModel> get filteredUsers {
    final query = userSearchQuery.value.trim().toLowerCase();
    if (query.isEmpty) return users;
    return users.where((u) {
      return u.name.toLowerCase().contains(query) ||
          u.email.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    // Initial users from seed
    users.assignAll([
      SeedDataService.demoAdmin,
      SeedDataService.demoFan,
      UserModel(
        id: 'u3',
        name: 'Ayesha Khan',
        email: 'ayesha@fandomverse.app',
        role: 'fan',
        selectedFandomIds: ['f1', 'f4'],
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
        updatedAt: DateTime.now(),
      ),
      UserModel(
        id: 'u4',
        name: 'Sana Tariq',
        email: 'sana@fandomverse.app',
        role: 'fan',
        selectedFandomIds: ['f2', 'f6'],
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        updatedAt: DateTime.now(),
      ),
      UserModel(
        id: 'u5',
        name: 'Ahmed Raza',
        email: 'ahmed@fandomverse.app',
        role: 'fan',
        selectedFandomIds: ['f3', 'f5'],
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        updatedAt: DateTime.now(),
      ),
    ]);

    posts.assignAll(SeedDataService.contentItems);
    events.assignAll(SeedDataService.events);
    products.assignAll(SeedDataService.products);
    categories.assignAll(
      SeedDataService.categories
          .map((c) => Map<String, dynamic>.from(c as Map))
          .toList(),
    );

    recentActivity.assignAll([
      'New fan registered: Sakura Kim',
      'Event published: Tokyo Anime Expo 2026',
      'Product updated: Demon Slayer Katana Replica',
      'Post published: Attack on Titan Finale Analysis',
    ]);

    // Fetch live data from Firestore in parallel — one slow/unreachable
    // collection no longer blocks the others or freezes the dashboard.
    try {
      final results = await Future.wait([
        _firestore?.getAllUsers() ?? Future.value(<UserModel>[]),
        _firestore?.getAllContent() ?? Future.value(<ContentModel>[]),
        _firestore?.getAllEvents() ?? Future.value(<EventModel>[]),
        _firestore?.getAllProducts() ?? Future.value(<ProductModel>[]),
        _firestore?.getAllCategories() ??
            Future.value(<Map<String, dynamic>>[]),
      ]);

      final remoteUsers = results[0] as List<UserModel>;
      final remotePosts = results[1] as List<ContentModel>;
      final remoteEvents = results[2] as List<EventModel>;
      final remoteProducts = results[3] as List<ProductModel>;
      final remoteCats = results[4] as List<Map<String, dynamic>>;

      if (remoteUsers.isNotEmpty) {
        for (final u in remoteUsers) {
          if (!users.any((x) => x.id == u.id)) {
            users.add(u);
          }
        }
      }
      if (remotePosts.isNotEmpty) posts.assignAll(remotePosts);
      if (remoteEvents.isNotEmpty) events.assignAll(remoteEvents);
      if (remoteProducts.isNotEmpty) products.assignAll(remoteProducts);
      if (remoteCats.isNotEmpty) categories.assignAll(remoteCats);
    } catch (_) {}
  }

  // --- Content / Posts Moderation ---

  Future<void> addPost({
    required String title,
    required String fandomCategory,
    required String body,
    String? imageUrl,
  }) async {
    final newId = 'post_${DateTime.now().millisecondsSinceEpoch}';
    final newPost = ContentModel(
      id: newId,
      title: title.trim(),
      description: body.length > 80 ? '${body.substring(0, 80)}...' : body,
      body: body.trim(),
      imageUrl: imageUrl?.trim().isNotEmpty == true ? imageUrl!.trim() : 'https://images.unsplash.com/photo-1578632767115-351597cf2477?w=800&q=80',
      contentType: ContentType.news,
      fandomId: 'f1',
      fandomName: fandomCategory,
      author: 'Admin',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    posts.insert(0, newPost);
    recentActivity.insert(0, 'Added post: "$title"');
    await _firestore?.saveContent(newPost);
  }

  Future<void> editPost({
    required String id,
    required String title,
    required String fandomCategory,
    required String body,
    String? imageUrl,
  }) async {
    final index = posts.indexWhere((p) => p.id == id);
    if (index == -1) return;

    final existing = posts[index];
    final updated = existing.copyWith(
      title: title.trim(),
      fandomName: fandomCategory.trim(),
      body: body.trim(),
      imageUrl: imageUrl?.trim().isNotEmpty == true
          ? imageUrl!.trim()
          : existing.imageUrl,
      updatedAt: DateTime.now(),
    );

    posts[index] = updated;
    recentActivity.insert(0, 'Updated post: "$title"');
    await _firestore?.saveContent(updated);
  }

  Future<void> deletePost(String id) async {
    final item = posts.firstWhereOrNull((p) => p.id == id);
    posts.removeWhere((p) => p.id == id);
    if (item != null) {
      recentActivity.insert(0, 'Deleted post: "${item.title}"');
    }
    await _firestore?.deleteContent(id);
  }

  // --- Events Moderation ---

  Future<void> addEvent({
    required String title,
    required String city,
    required DateTime date,
    String? ticketLink,
    String? venue,
  }) async {
    final newId = 'event_${DateTime.now().millisecondsSinceEpoch}';
    final newEvent = EventModel(
      id: newId,
      title: title.trim(),
      description: 'Official fan event and gathering in $city.',
      city: city.trim(),
      venue: venue?.trim().isNotEmpty == true
          ? venue!.trim()
          : 'Convention Arena',
      address: '$city Center',
      eventDate: date,
      ticketLink: ticketLink?.trim(),
      category: 'Conventions',
      fandomId: 'f1',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    events.insert(0, newEvent);
    recentActivity.insert(0, 'Added event: "$title"');
    await _firestore?.saveEvent(newEvent);
  }

  Future<void> editEvent({
    required String id,
    required String title,
    required String city,
    required DateTime date,
    String? ticketLink,
    String? venue,
  }) async {
    final index = events.indexWhere((e) => e.id == id);
    if (index == -1) return;

    final existing = events[index];
    final updated = existing.copyWith(
      title: title.trim(),
      city: city.trim(),
      venue: venue?.trim().isNotEmpty == true ? venue!.trim() : existing.venue,
      eventDate: date,
      ticketLink: ticketLink?.trim().isNotEmpty == true
          ? ticketLink!.trim()
          : existing.ticketLink,
      updatedAt: DateTime.now(),
    );

    events[index] = updated;
    recentActivity.insert(0, 'Updated event: "$title"');
    await _firestore?.saveEvent(updated);
  }

  Future<void> deleteEvent(String id) async {
    final item = events.firstWhereOrNull((e) => e.id == id);
    events.removeWhere((e) => e.id == id);
    if (item != null) {
      recentActivity.insert(0, 'Deleted event: "${item.title}"');
    }
    await _firestore?.deleteEvent(id);
  }

  // --- Merchandise Products Moderation ---

  Future<void> addProduct({
    required String name,
    required double price,
    required String category,
    String? imageUrl,
  }) async {
    final newId = 'prod_${DateTime.now().millisecondsSinceEpoch}';
    final newProduct = ProductModel(
      id: newId,
      name: name.trim(),
      description: 'Official premium fan merchandise item.',
      price: price,
      categoryName: category.trim(),
      categoryId: category.toLowerCase().replaceAll(' ', '_'),
      fandomId: 'f1',
      imageUrl: imageUrl?.trim().isNotEmpty == true ? imageUrl!.trim() : 'https://images.unsplash.com/photo-1614680376573-df3480f0c6ff?w=400&q=80',
      stock: 25,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    products.insert(0, newProduct);
    recentActivity.insert(0, 'Added product: "$name"');
    await _firestore?.saveProduct(newProduct);
  }

  Future<void> editProduct({
    required String id,
    required String name,
    required double price,
    required String category,
    String? imageUrl,
  }) async {
    final index = products.indexWhere((p) => p.id == id);
    if (index == -1) return;

    final existing = products[index];
    final updated = existing.copyWith(
      name: name.trim(),
      price: price,
      categoryName: category.trim(),
      categoryId: category.toLowerCase().replaceAll(' ', '_'),
      imageUrl: imageUrl?.trim().isNotEmpty == true
          ? imageUrl!.trim()
          : existing.imageUrl,
      updatedAt: DateTime.now(),
    );

    products[index] = updated;
    recentActivity.insert(0, 'Updated product: "$name"');
    await _firestore?.saveProduct(updated);
  }

  Future<void> deleteProduct(String id) async {
    final item = products.firstWhereOrNull((p) => p.id == id);
    products.removeWhere((p) => p.id == id);
    if (item != null) {
      recentActivity.insert(0, 'Deleted product: "${item.name}"');
    }
    await _firestore?.deleteProduct(id);
  }

  // --- User Management ---

  Future<void> addUser({
    required String name,
    required String email,
    String role = 'fan',
    List<String> fandoms = const ['f1', 'f4'],
  }) async {
    final newId = 'user_${DateTime.now().millisecondsSinceEpoch}';
    final newUser = UserModel(
      id: newId,
      name: name.trim(),
      email: email.trim(),
      role: role,
      selectedFandomIds: fandoms,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    users.insert(0, newUser);
    recentActivity.insert(0, 'Added user: "$name"');
    await _firestore?.saveUser(newUser);
  }

  Future<void> editUser({
    required String id,
    required String name,
    required String email,
  }) async {
    final index = users.indexWhere((u) => u.id == id);
    if (index == -1) return;

    final existing = users[index];
    final updated = existing.copyWith(
      name: name.trim(),
      email: email.trim(),
      updatedAt: DateTime.now(),
    );

    users[index] = updated;
    recentActivity.insert(0, 'Updated user: "$name"');
    await _firestore?.saveUser(updated);
  }

  Future<void> deleteUser(String id) async {
    final item = users.firstWhereOrNull((u) => u.id == id);
    users.removeWhere((u) => u.id == id);
    if (item != null) {
      recentActivity.insert(0, 'Deleted user: "${item.name}"');
    }
    await _firestore?.deleteUser(id);
  }

  // --- Category Management ---

  Future<void> addCategory({
    required String name,
    String? description,
    String? icon,
  }) async {
    final newId = 'cat_${DateTime.now().millisecondsSinceEpoch}';
    final newCat = {
      'id': newId,
      'name': name.trim(),
      'description': description?.trim() ?? 'Fandom category',
      'icon': icon?.trim() ?? 'tag',
      'type': 'fandom',
      'display_order': categories.length + 1,
      'created_at': DateTime.now().toIso8601String(),
    };

    categories.add(newCat);
    recentActivity.insert(0, 'Added category: "$name"');
    await _firestore?.saveCategory(newCat);
  }

  Future<void> editCategory({
    required String id,
    required String name,
    String? description,
    String? icon,
  }) async {
    final index = categories.indexWhere((c) => c['id'].toString() == id);
    if (index == -1) return;

    final existing = categories[index];
    final updated = Map<String, dynamic>.from(existing);
    updated['name'] = name.trim();
    if (description != null) updated['description'] = description.trim();
    if (icon != null) updated['icon'] = icon.trim();
    updated['updated_at'] = DateTime.now().toIso8601String();

    categories[index] = updated;
    recentActivity.insert(0, 'Updated category: "$name"');
    await _firestore?.saveCategory(updated);
  }

  Future<void> deleteCategory(String id) async {
    final item = categories.firstWhereOrNull((c) => c['id'].toString() == id);
    categories.removeWhere((c) => c['id'].toString() == id);
    if (item != null) {
      recentActivity.insert(0, 'Deleted category: "${item['name']}"');
    }
    await _firestore?.deleteCategory(id);
  }

  void logout() => _authService.logout();
}
