import 'package:get/get.dart';
import '../../../data/models/misc_models.dart';
import '../../../data/services/seed_data_service.dart';

class CharacterController extends GetxController {
  final RxList<CharacterModel> characters = <CharacterModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    characters.assignAll(SeedDataService.characters);
  }

  CharacterModel? getCharacter(String id) {
    return characters.firstWhereOrNull((c) => c.id == id);
  }
}
