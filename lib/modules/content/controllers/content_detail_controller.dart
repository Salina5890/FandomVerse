import 'package:get/get.dart';
import '../../../data/models/content_model.dart';
import '../../../data/services/seed_data_service.dart';
import '../../../core/storage/local_storage_service.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/models/cart_models.dart';
import 'package:uuid/uuid.dart';

class ContentDetailController extends GetxController {
  final String contentId;
  final Rx<ContentModel?> content = Rx<ContentModel?>(null);
  final RxBool isBookmarked = false.obs;
  final RxBool isLoading = true.obs;
  final RxBool isOfflineSaved = false.obs;

  final _storage = Get.find<LocalStorageService>();

  ContentDetailController(this.contentId);

  @override
  void onInit() {
    super.onInit();
    _loadContent();
  }

  void _loadContent() {
    isLoading.value = true;
    try {
      content.value = SeedDataService.contentItems.firstWhere(
        (c) => c.id == contentId,
      );
      isBookmarked.value = _storage.isBookmarked(contentId);
      isOfflineSaved.value = _storage.isSavedOffline(contentId);
    } catch (_) {
      content.value = null;
    }
    isLoading.value = false;
  }

  void toggleOffline() {
    final c = content.value;
    if (c == null) return;
    if (isOfflineSaved.value) {
      _storage.removeSavedContent(c.id);
      isOfflineSaved.value = false;
      Get.snackbar('Offline', 'Removed from offline content.', snackPosition: SnackPosition.BOTTOM);
    } else {
      _storage.saveContentOffline(c.toMap());
      isOfflineSaved.value = true;
      Get.snackbar('Offline', 'Text content saved for offline access.', snackPosition: SnackPosition.BOTTOM);
    }
  }

  void toggleBookmark() {
    if (content.value == null) return;
    final c = content.value!;

    if (isBookmarked.value) {
      final bookmarkId = _storage.getBookmarkId(contentId);
      if (bookmarkId != null) {
        _storage.removeBookmark(bookmarkId);
      }
      isBookmarked.value = false;
      Get.snackbar('Removed', 'Bookmark removed',
          snackPosition: SnackPosition.BOTTOM);
    } else {
      final userId = Get.find<AuthService>().currentUser.value?.id ?? 'guest';
      final bookmark = BookmarkModel(
        id: const Uuid().v4(),
        userId: userId,
        contentId: c.id,
        contentTitle: c.title,
        contentImageUrl: c.imageUrl,
        contentType: c.contentType.name,
        fandomId: c.fandomId,
        createdAt: DateTime.now(),
      );
      _storage.saveBookmark(bookmark);
      isBookmarked.value = true;
      Get.snackbar('Bookmarked', '${c.title} saved',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
