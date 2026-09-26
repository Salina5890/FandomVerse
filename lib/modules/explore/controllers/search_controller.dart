import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/content_model.dart';
import '../../../data/models/fandom_model.dart';
import '../../../data/services/seed_data_service.dart';

class FVSearchController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = 'All'.obs;
  final RxString selectedContentType = 'All'.obs;
  final RxString selectedCreator = 'All'.obs;
  final RxString selectedTag = 'All'.obs;

  final RxList<ContentModel> contentResults = <ContentModel>[].obs;
  final RxList<FandomModel> fandomResults = <FandomModel>[].obs;

  final List<String> categories = ['All', ...SeedDataService.fandomCategories];
  List<String> get contentTypes => ['All', ...ContentType.values.map((e) => e.label)];
  List<String> get creators => ['All', ...{for (final c in SeedDataService.contentItems) c.author}];
  List<String> get tags => ['All', ...{for (final c in SeedDataService.contentItems) ...c.tags}];

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(() {
      searchQuery.value = searchController.text;
      _performSearch();
    });
    // Check if initial query passed via route
    if (Get.parameters['q'] != null) {
      searchController.text = Get.parameters['q']!;
    }
    _performSearch();
  }

  void setContentType(String value) { selectedContentType.value = value; _performSearch(); }
  void setCreator(String value) { selectedCreator.value = value; _performSearch(); }
  void setTag(String value) { selectedTag.value = value; _performSearch(); }

  void setCategory(String category) {
    selectedCategory.value = category;
    _performSearch();
  }

  void _performSearch() {
    final query = searchQuery.value.toLowerCase();
    final category = selectedCategory.value;

    List<FandomModel> filteredFandoms = SeedDataService.fandoms;
    if (category != 'All') {
      filteredFandoms = filteredFandoms.where((f) => f.category == category).toList();
    }
    if (query.isNotEmpty) {
      filteredFandoms = filteredFandoms
          .where((f) =>
              f.name.toLowerCase().contains(query) ||
              f.description.toLowerCase().contains(query))
          .toList();
    }
    fandomResults.assignAll(filteredFandoms);

    List<ContentModel> filteredContent = SeedDataService.contentItems;
    if (category != 'All') {
      final fandomsInCategory = SeedDataService.fandoms.where((f) => f.category == category).map((f) => f.id).toSet();
      filteredContent = filteredContent.where((c) => fandomsInCategory.contains(c.fandomId)).toList();
    }
    if (query.isNotEmpty) {
      filteredContent = filteredContent
          .where((c) =>
              c.title.toLowerCase().contains(query) ||
              c.description.toLowerCase().contains(query) ||
              c.tags.any((t) => t.toLowerCase().contains(query)))
          .toList();
    }
    if (selectedContentType.value != 'All') {
      filteredContent = filteredContent.where((c) => c.contentType.label == selectedContentType.value).toList();
    }
    if (selectedCreator.value != 'All') {
      filteredContent = filteredContent.where((c) => c.author == selectedCreator.value).toList();
    }
    if (selectedTag.value != 'All') {
      filteredContent = filteredContent.where((c) => c.tags.contains(selectedTag.value)).toList();
    }
    contentResults.assignAll(filteredContent);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
