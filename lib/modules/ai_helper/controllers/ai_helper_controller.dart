import 'package:get/get.dart';
import '../../../data/models/misc_models.dart';
import '../../../data/services/seed_data_service.dart';

class AiHelperController extends GetxController {
  final RxList<FaqModel> faqs = <FaqModel>[].obs;
  final RxList<Map<String, String>> chatHistory = <Map<String, String>>[].obs;
  final RxBool isTyping = false.obs;

  @override
  void onInit() {
    super.onInit();
    faqs.value = SeedDataService.faqs;
    // Add initial greeting
    chatHistory.add({
      'role': 'ai',
      'text': 'Hello! I am your Fandom Verse AI Helper. I can answer questions about the app, lore, or guide you. What can I help you with today?'
    });
  }

  void sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message
    chatHistory.add({'role': 'user', 'text': text});
    
    isTyping.value = true;
    
    // Simulate AI thinking delay
    await Future.delayed(const Duration(milliseconds: 1500));
    
    isTyping.value = false;

    // Very basic mock matching logic
    final lowercaseText = text.toLowerCase();
    final match = faqs.firstWhereOrNull((faq) {
      return lowercaseText.contains(faq.question.toLowerCase()) || 
             faq.tags.any((tag) => lowercaseText.contains(tag.toLowerCase()));
    });

    if (match != null) {
      chatHistory.add({
        'role': 'ai',
        'text': match.answer
      });
    } else {
      chatHistory.add({
        'role': 'ai',
        'text': "I'm still learning about the Fandom Verse. I couldn't find an exact answer to that, but you might find what you're looking for in the Deep Dive section!"
      });
    }
  }

  void askSuggestedQuestion(String question) {
    sendMessage(question);
  }
}
