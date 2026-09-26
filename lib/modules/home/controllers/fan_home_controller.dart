import 'package:get/get.dart';
import '../../../data/models/content_model.dart';
import '../../../data/models/event_model.dart';
import '../../../data/models/fandom_model.dart';
import '../../../data/services/seed_data_service.dart';

class FanHomeController extends GetxController {
  final RxList<FandomModel> featuredFandoms = <FandomModel>[].obs;
  final RxList<ContentModel> featuredContent = <ContentModel>[].obs;
  final RxList<EventModel> upcomingEvents = <EventModel>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadHomeData();
  }

  void _loadHomeData() async {
    isLoading.value = true;
    
    featuredFandoms.value = SeedDataService.featuredFandoms;
    featuredContent.value = SeedDataService.featuredContent.take(5).toList();
    upcomingEvents.value = SeedDataService.upcomingEvents.take(3).toList();
    
    isLoading.value = false;
  }
}
