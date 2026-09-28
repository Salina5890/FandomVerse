import 'package:get/get.dart';
import '../../../data/models/misc_models.dart';
import '../../../data/services/seed_data_service.dart';
import '../../../data/services/ai_service.dart';

class AiHelperController extends GetxController {
  final RxList<FaqModel> faqs = <FaqModel>[].obs;
  final RxList<Map<String, String>> chatHistory = <Map<String, String>>[].obs;
  final RxBool isTyping = false.obs;

  @override
  void onInit() {
    super.onInit();
    faqs.value = SeedDataService.faqs;
    chatHistory.add({
      'role': 'ai',
      'text': 'Hello! I am your Fandom Verse AI Helper. What can I help you explore today?'
    });
  }

  void sendMessage(String text) async {
    final cleanText = text.trim();
    if (cleanText.isEmpty) return;

    if (RegExp(r'^[\W_]+$').hasMatch(cleanText)) {
      chatHistory.add({'role': 'user', 'text': cleanText});
      chatHistory.add({
        'role': 'ai',
        'text': "I noticed your message consists only of punctuation or symbols. How can I assist you? You can ask me about account registration, lore, characters, or upcoming conventions!",
      });
      return;
    }

    chatHistory.add({'role': 'user', 'text': cleanText});
    isTyping.value = true;
    
    try {
      final aiService = Get.isRegistered<AiService>() ? Get.find<AiService>() : AiService();
      final reply = await aiService.queryAi(cleanText);
      chatHistory.add({
        'role': 'ai',
        'text': reply,
      });
    } catch (_) {
      chatHistory.add({
        'role': 'ai',
        'text': "I'm here to help with any fandom questions! Feel free to ask about events, characters, or lore.",
      });
    } finally {
      isTyping.value = false;
    }
  }

  void askSuggestedQuestion(String question) {
    sendMessage(question);
  }
}
