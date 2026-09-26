import 'package:get/get.dart';
import '../../../data/models/content_model.dart';
import '../../../data/models/misc_models.dart';
import '../../../data/services/seed_data_service.dart';

class FanHubController extends GetxController {
  final RxList<ContentModel> featuredContent = <ContentModel>[].obs;
  final RxList<GlossaryModel> teaserGlossary = <GlossaryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    featuredContent.assignAll(SeedDataService.featuredContent);
    teaserGlossary.assignAll(SeedDataService.glossaryTerms.take(3).toList());
  }
}
