import 'package:get/get.dart';
import '../../../data/models/content_model.dart';
import '../../../data/services/seed_data_service.dart';

class ExploreController extends GetxController {
  final RxInt selectedTabIndex = 0.obs;

  // News State
  final RxList<ContentModel> allNews = <ContentModel>[].obs;
  final RxString selectedNewsCategory = 'All'.obs;
  final RxString newsSearchQuery = ''.obs;

  // Gallery State
  final RxList<ContentModel> allGalleries = <ContentModel>[].obs;
  final RxString selectedGalleryCategory = 'All'.obs;
  final RxString gallerySearchQuery = ''.obs;

  // Videos & Podcasts State
  final RxList<ContentModel> allVideos = <ContentModel>[].obs;
  final RxList<ContentModel> allPodcasts = <ContentModel>[].obs;

  // Bookmarks and Offline Save State
  final RxSet<String> bookmarkedIds = <String>{}.obs;
  final RxSet<String> offlineSavedIds = <String>{}.obs;

  final RxBool isLoading = true.obs;

  // News categories filter list
  final List<String> newsCategories = const [
    'All',
    'Anime',
    'Gaming',
    'Movies',
    'K-Pop',
    'Sci-Fi',
  ];

  // Gallery categories filter list
  final List<String> galleryCategories = const [
    'All',
    'Gaming',
    'Sci-Fi',
    'Anime',
    'Superheroes',
    'Cyberpunk',
    'Fantasy',
  ];

  @override
  void onInit() {
    super.onInit();
    loadExploreData();
  }

  void loadExploreData() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 300));

    allNews.assignAll(SeedDataService.getContentByType(ContentType.news));
    allGalleries.assignAll(SeedDataService.getContentByType(ContentType.gallery));
    allVideos.assignAll(SeedDataService.getContentByType(ContentType.video));
    allPodcasts.assignAll(SeedDataService.getContentByType(ContentType.podcast));

    isLoading.value = false;
  }

  // Filtered News Getter
  List<ContentModel> get filteredNews {
    var list = allNews.toList();
    if (selectedNewsCategory.value != 'All') {
      list = list.where((item) {
        final cat = selectedNewsCategory.value.toLowerCase();
        return item.tags.any((t) => t.toLowerCase().contains(cat)) ||
            (item.fandomName?.toLowerCase().contains(cat) ?? false);
      }).toList();
    }
    if (newsSearchQuery.value.trim().isNotEmpty) {
      final q = newsSearchQuery.value.toLowerCase().trim();
      list = list.where((item) =>
          item.title.toLowerCase().contains(q) ||
          item.description.toLowerCase().contains(q) ||
          item.tags.any((t) => t.toLowerCase().contains(q))).toList();
    }
    return list;
  }

  // Filtered Gallery Getter
  List<ContentModel> get filteredGalleries {
    var list = allGalleries.toList();
    if (selectedGalleryCategory.value != 'All') {
      list = list.where((item) {
        final cat = selectedGalleryCategory.value.toLowerCase();
        return item.tags.any((t) => t.toLowerCase().contains(cat)) ||
            (item.fandomName?.toLowerCase().contains(cat) ?? false);
      }).toList();
    }
    if (gallerySearchQuery.value.trim().isNotEmpty) {
      final q = gallerySearchQuery.value.toLowerCase().trim();
      list = list.where((item) =>
          item.title.toLowerCase().contains(q) ||
          item.description.toLowerCase().contains(q) ||
          (item.fandomName?.toLowerCase().contains(q) ?? false) ||
          item.tags.any((t) => t.toLowerCase().contains(q))).toList();
    }
    return list;
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  void filterNewsCategory(String category) {
    selectedNewsCategory.value = category;
  }

  void filterGalleryCategory(String category) {
    selectedGalleryCategory.value = category;
  }

  void toggleBookmark(String contentId) {
    if (bookmarkedIds.contains(contentId)) {
      bookmarkedIds.remove(contentId);
    } else {
      bookmarkedIds.add(contentId);
    }
  }

  void toggleOfflineSave(String contentId) {
    if (offlineSavedIds.contains(contentId)) {
      offlineSavedIds.remove(contentId);
    } else {
      offlineSavedIds.add(contentId);
    }
  }

  bool isBookmarked(String contentId) => bookmarkedIds.contains(contentId);
  bool isOfflineSaved(String contentId) => offlineSavedIds.contains(contentId);
}
