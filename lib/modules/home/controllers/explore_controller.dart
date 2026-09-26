import 'package:get/get.dart';
import '../../../data/models/content_model.dart';
import '../../../data/services/seed_data_service.dart';

class ExploreController extends GetxController {
  final RxList<ContentModel> latestNews = <ContentModel>[].obs;
  final RxList<ContentModel> beginnerHub = <ContentModel>[].obs;
  final RxList<ContentModel> deepDives = <ContentModel>[].obs;
  
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadExploreData();
  }

  void _loadExploreData() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 800));

    // Get different types of content
    latestNews.value = SeedDataService.getContentByType(ContentType.news);
    
    beginnerHub.value = [
      ...SeedDataService.getContentByType(ContentType.character),
      ...SeedDataService.getContentByType(ContentType.glossary)
    ];

    deepDives.value = [
      ...SeedDataService.getContentByType(ContentType.lore),
      ...SeedDataService.getContentByType(ContentType.trivia),
      ...SeedDataService.getContentByType(ContentType.behindScenes)
    ];
    
    isLoading.value = false;
  }
}
