import 'package:get/get.dart';
import '../../../data/models/cart_models.dart';
import '../../../data/models/content_model.dart';
import '../../../data/services/seed_data_service.dart';
import '../../../core/storage/local_storage_service.dart';
import '../../../app/routes/app_routes.dart';

/// Content types stored on a [BookmarkModel] that route somewhere other
/// than the generic content-detail screen.
const _eventBookmarkType = 'event';

class BookmarksController extends GetxController {
  final RxList<BookmarkModel> bookmarks = <BookmarkModel>[].obs;
  final RxList<BookmarkModel> savedContent = <BookmarkModel>[].obs;
  final RxList<ContentModel> offlineContent = <ContentModel>[].obs;
  
  final RxBool isLoading = true.obs;
  final _storage = Get.find<LocalStorageService>();

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void loadData() {
    isLoading.value = true;
    bookmarks.value = _storage.getBookmarks();
    
    // Saved/offline content comes only from locally cached records.
    final cached = _storage.getSavedContent();
    offlineContent.value = cached.map(ContentModel.fromMap).toList();
    savedContent.value = bookmarks.toList();
    
    isLoading.value = false;
  }

  void removeBookmark(String id) {
    _storage.removeBookmark(id);
    bookmarks.removeWhere((b) => b.id == id);
    savedContent.removeWhere((b) => b.id == id);
    Get.snackbar('Removed', 'Bookmark removed',
        snackPosition: SnackPosition.BOTTOM);
  }

  void removeSavedContent(String id) {
    savedContent.removeWhere((b) => b.id == id);
    Get.snackbar('Removed', 'Saved content removed',
        snackPosition: SnackPosition.BOTTOM);
  }

  void openContent(String contentId) {
    Get.toNamed(
      AppRoutes.contentDetail.replaceFirst(':id', contentId),
    );
  }

  /// Bookmarks can point at different kinds of content (articles/lore vs.
  /// events), so route by the bookmark's own `contentType` rather than
  /// always assuming it's a content-detail item.
  void openBookmark(BookmarkModel bookmark) {
    if (bookmark.contentType == _eventBookmarkType) {
      Get.toNamed(
        AppRoutes.eventDetail.replaceFirst(':id', bookmark.contentId),
      );
    } else {
      openContent(bookmark.contentId);
    }
  }
}
