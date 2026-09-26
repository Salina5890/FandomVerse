import 'package:get/get.dart';
import '../../../data/models/content_model.dart';
import '../../../data/services/seed_data_service.dart';

class DeepDiveController extends GetxController {
  final RxList<ContentModel> triviaContent = <ContentModel>[].obs;
  final RxList<ContentModel> loreContent = <ContentModel>[].obs;
  final RxList<ContentModel> btsContent = <ContentModel>[].obs;
  final RxList<ContentModel> editorialContent = <ContentModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    triviaContent.assignAll(SeedDataService.getContentByType(ContentType.trivia));
    loreContent.assignAll(SeedDataService.getContentByType(ContentType.lore));
    btsContent.assignAll(SeedDataService.getContentByType(ContentType.behindScenes));
    editorialContent.assignAll(SeedDataService.getContentByType(ContentType.editorial));
  }
}
