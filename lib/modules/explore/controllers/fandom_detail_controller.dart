import 'package:get/get.dart';
import '../../../data/models/fandom_model.dart';
import '../../../data/models/content_model.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/event_model.dart';
import '../../../data/services/seed_data_service.dart';

class FandomDetailController extends GetxController {
  final String fandomId;
  FandomDetailController(this.fandomId);

  late FandomModel fandom;
  final RxList<ContentModel> relatedContent = <ContentModel>[].obs;
  final RxList<ProductModel> relatedProducts = <ProductModel>[].obs;
  final RxList<EventModel> relatedEvents = <EventModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    final found = SeedDataService.fandoms.firstWhereOrNull((f) => f.id == fandomId);
    if (found != null) {
      fandom = found;
      relatedContent.assignAll(SeedDataService.getContentByFandom(fandomId));
      relatedProducts.assignAll(SeedDataService.getProductsByFandom(fandomId));
      relatedEvents.assignAll(SeedDataService.events.where((e) => e.fandomId == fandomId).toList());
    } else {
      Get.back();
    }
  }
}
