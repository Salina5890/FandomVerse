import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/seed_data_service.dart';

/// One row in any admin list (user, content, product or category).
class AdminEntry {
  final String id;
  String title;
  String subtitle;
  String tag;
  AdminEntry(this.id, this.title, this.subtitle, this.tag);
}

class AdminDashboardController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final RxInt selectedMenuIndex = 0.obs;

  final RxList<AdminEntry> users = <AdminEntry>[].obs;
  final RxList<AdminEntry> content = <AdminEntry>[].obs;
  final RxList<AdminEntry> events = <AdminEntry>[].obs;
  final RxList<AdminEntry> products = <AdminEntry>[].obs;
  final RxList<AdminEntry> categories = <AdminEntry>[].obs;
  final RxList<String> activity = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    users.assignAll([
      AdminEntry('u1', 'Ayesha Khan', 'ayesha@fandomverse.app', 'Fan'),
      AdminEntry('u2', 'Sakura Kim', 'demo@fandomverse.app', 'Fan'),
      AdminEntry('u3', 'Sana Tariq', 'sana@fandomverse.app', 'Fan'),
      AdminEntry('u4', 'Ahmed Raza', 'ahmed@fandomverse.app', 'Fan'),
      AdminEntry('u5', 'Alex Verse', 'admin@fandomverse.app', 'Admin'),
    ]);
    content.assignAll(SeedDataService.contentItems
        .map((c) => AdminEntry(c.id, c.title, c.contentType.label, c.isPublished ? 'Live' : 'Draft'))
        .toList());
    events.assignAll(SeedDataService.events
        .map((e) => AdminEntry(e.id, e.title, '${e.city} • ${e.venue}', e.status))
        .toList());
    products.assignAll(SeedDataService.products
        .map((p) => AdminEntry(p.id, p.name, '\$${p.price.toStringAsFixed(2)}', '${p.stock} in stock'))
        .toList());
    categories.assignAll(SeedDataService.categories
        .map((c) => AdminEntry('${c['id']}', '${c['name']}', '${c['description'] ?? ''}', '${c['type'] ?? ''}'))
        .toList());
    activity.assignAll([
      'New user registered',
      'Event added',
      'Product updated',
      'Content published',
    ]);
  }

  RxList<AdminEntry> listFor(int menu) {
    switch (menu) {
      case 1:
        return users;
      case 2:
        return content;
      case 3:
        return events;
      case 4:
        return products;
      default:
        return categories;
    }
  }

  void changeMenu(int index) => selectedMenuIndex.value = index;

  void add(int menu, String title, String subtitle) {
    if (title.trim().isEmpty) return;
    final id = '${menu}_${DateTime.now().millisecondsSinceEpoch}';
    listFor(menu).insert(0, AdminEntry(id, title.trim(), subtitle.trim(), 'New'));
    activity.insert(0, 'Added "${title.trim()}"');
  }

  void edit(int menu, AdminEntry e, String title, String subtitle) {
    if (title.trim().isEmpty) return;
    e.title = title.trim();
    e.subtitle = subtitle.trim();
    listFor(menu).refresh();
    activity.insert(0, 'Updated "${e.title}"');
  }

  void remove(int menu, AdminEntry e) {
    listFor(menu).remove(e);
    activity.insert(0, 'Removed "${e.title}"');
  }

  void logout() => _authService.logout();
}
