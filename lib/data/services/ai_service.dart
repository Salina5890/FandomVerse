import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/misc_models.dart';
import 'seed_data_service.dart';

class AiService extends GetxService {
  static AiService get to => Get.find<AiService>();

  // Optional Gemini API Key (pass via --dart-define=GEMINI_API_KEY=... or set at runtime)
  static const String _defaultApiKey = String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');
  String apiKey = _defaultApiKey;

  Future<AiService> init() async {
    return this;
  }

  // Answer user query using Gemini API if key is available, or fallback to local knowledge base
  Future<String> queryAi(String userQuery) async {
    final clean = userQuery.trim();
    if (clean.isEmpty) {
      return "How can I help you explore the Fandom Verse?";
    }

    // Try Google AI Studio if API key is provided
    if (apiKey.isNotEmpty) {
      try {
        final onlineAnswer = await _fetchGeminiAnswer(clean);
        if (onlineAnswer != null && onlineAnswer.isNotEmpty) {
          return onlineAnswer;
        }
      } catch (e) {
        debugPrint('Gemini request notice: $e. Falling back to local helper.');
      }
    }

    // Use built-in fandom knowledge base
    return _answerWithLocalKnowledge(clean);
  }

  Future<String?> _fetchGeminiAnswer(String userText) async {
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey',
    );

    const promptContext = "You are the Fandom Verse companion. You help fans with quick and enthusiastic answers "
        "about anime (Demon Slayer, Attack on Titan), games (Cyberpunk, Halo), K-Pop (BTS, BLACKPINK), "
        "Marvel, conventions, cosplay, and official merchandise. Keep your answer brief and friendly.";

    final payload = jsonEncode({
      "contents": [
        {
          "role": "user",
          "parts": [
            {"text": "$promptContext\n\nQuestion: $userText"}
          ]
        }
      ],
      "generationConfig": {
        "temperature": 0.7,
        "maxOutputTokens": 250,
      }
    });

    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: payload,
    ).timeout(const Duration(seconds: 8));

    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      final candidateList = json['candidates'] as List?;
      if (candidateList != null && candidateList.isNotEmpty) {
        final content = candidateList[0]['content'];
        final parts = content['parts'] as List?;
        if (parts != null && parts.isNotEmpty) {
          return parts[0]['text']?.toString().trim();
        }
      }
    }
    return null;
  }

  // Local rule-based matching covering glossary, characters, events, store, and FAQs
  String _answerWithLocalKnowledge(String query) {
    final text = query.toLowerCase();

    // Greetings
    if (_hasKeyword(text, ['hello', 'hi ', 'hey', 'greetings', 'who are you', 'what can you do', 'help me'])) {
      return "Hello, fellow fan! ✨ I am your Fandom Verse AI Helper. You can ask me anything about:\n"
          "• Fandoms (Anime, Gaming, Marvel, K-Pop)\n"
          "• Lore & Terminology (e.g. 'What is a Hashira?', 'What is ARMY?')\n"
          "• Characters (e.g. 'Tell me about Tanjiro', 'Who is Eren?')\n"
          "• Upcoming Conventions & Events\n"
          "• Official Merchandise & App Features";
    }

    // App guides & features
    if (_hasKeyword(text, ['badge', 'badges', 'achievement', 'earn badge'])) {
      return "🏆 Badges represent your fandom milestones! You earn badges by exploring fandoms, attending conventions, reading lore, and participating in the community. You can view all your earned and locked badges in the Profile tab under 'Fan Identity'!";
    }

    if (_hasKeyword(text, ['bookmark', 'offline', 'save article', 'save for offline'])) {
      return "📑 Offline Bookmarking: You can save articles, lore, and interviews by tapping the bookmark icon on any content card. Access all your saved media anytime from the Bookmarks tab — even without an internet connection!";
    }

    if (_hasKeyword(text, ['buy', 'cart', 'checkout', 'shop', 'merchandise', 'store', 'order'])) {
      return "🛍️ Official Fan Merchandise: Browse apparel, collectibles, and accessories in the Store tab. You can add items to your Wishlist or Cart and proceed to simulated checkout to inspect your bill and discounts!";
    }

    if (_hasKeyword(text, ['event', 'convention', 'meetup', 'comic-con', 'anime expo', 'calendar', 'screening'])) {
      final events = SeedDataService.events.take(3).map((e) => "• ${e.title} (${e.city}) - ${e.eventDate.month}/${e.eventDate.day}/${e.eventDate.year}").join('\n');
      return "📅 Upcoming Fandom Events:\n$events\n\nVisit the Events Calendar tab to explore GPS-enabled discovery and view screening schedules!";
    }

    if (_hasKeyword(text, ['deep dive', 'lore', 'trivia', 'behind the scene', 'bts'])) {
      return "🔍 Deep Dive Section: Explore hidden trivia, advanced lore breakdowns, and exclusive behind-the-scenes interviews in the Fan Hub tab. It's built specially for expert fans!";
    }

    // Recommendations
    if (_hasKeyword(text, ['recommend', 'suggest', 'what to watch', 'what to play', 'recommendation'])) {
      return "🎯 Recommendations for you:\n"
          "• If you love dark fantasy: **Attack on Titan** or **Demon Slayer**\n"
          "• If you love sci-fi & open-world: **Cyberpunk 2077** or **Halo**\n"
          "• If you love music & community: **BTS Universe**\n"
          "• If you love superhero epics: **Marvel Cinematic Universe**\n"
          "Tap on Explore to discover all available universe hubs!";
    }

    // Glossary match
    for (final term in SeedDataService.glossaryTerms) {
      if (text.contains(term.term.toLowerCase())) {
        String answer = "📖 **${term.term}** (${term.fandomName ?? 'Fandom Universe'}):\n${term.definition}";
        if (term.example != null && term.example!.isNotEmpty) {
          answer += "\n*Example:* ${term.example}";
        }
        return answer;
      }
    }

    // Characters match
    for (final char in SeedDataService.characters) {
      if (text.contains(char.name.toLowerCase())) {
        return "⚡ **${char.name}** (${char.fandomName}):\n${char.description}\n"
            "• Role: ${char.role.capitalizeFirst}\n"
            "• Traits: ${char.traits.join(', ')}";
      }
    }

    // Specific fandom highlights
    if (text.contains('attack on titan') || text.contains('eren') || text.contains('titan')) {
      return "⚔️ Attack on Titan is Hajime Isayama's acclaimed masterpiece about humanity's battle for freedom against Titans. Key topics: Eren Yeager, Survey Corps, Wall Maria, and the Rumbling. Check out the Deep Dive tab for our detailed ending retrospective!";
    }

    if (text.contains('demon slayer') || text.contains('tanjiro') || text.contains('hashira')) {
      return "🗡️ Demon Slayer (Kimetsu no Yaiba) follows Tanjiro Kamado in his quest to cure his sister Nezuko and defeat Muzan Kibutsuji with the nine elite Hashira swordsmen. Official Demon Slayer katanas and figures are available in the Merchandise Store!";
    }

    if (text.contains('bts') || text.contains('army') || text.contains('k-pop') || text.contains('blackpink')) {
      return "💜 K-Pop Universe: Home to ARMY (BTS) and BLINK (BLACKPINK). Explore comeback news, photo galleries, and world tour calendars right here on Fandom Verse!";
    }

    if (text.contains('marvel') || text.contains('avengers') || text.contains('mcu') || text.contains('spider-man')) {
      return "🦸 Marvel Cinematic Universe: Spanning the Infinity Saga to the Multiverse. Check out upcoming convention panels and official Marvel collectible figures in the Store!";
    }

    if (text.contains('cyberpunk') || text.contains('night city') || text.contains('johnny silverhand')) {
      return "🌃 Cyberpunk Universe: Neon dystopias, netrunning, and the legend of Johnny Silverhand and Samurai. Check the glossary for Netrunner definitions!";
    }

    // FAQ scoring
    FaqModel? bestFaq;
    int topScore = 0;

    for (final faq in SeedDataService.faqs) {
      int score = 0;
      final qLower = faq.question.toLowerCase();
      final aLower = faq.answer.toLowerCase();

      final words = text.split(RegExp(r'\s+')).where((w) => w.length > 2);
      for (final w in words) {
        if (qLower.contains(w)) score += 3;
        if (faq.tags.any((t) => t.toLowerCase() == w)) score += 4;
        if (aLower.contains(w)) score += 1;
      }

      if (score > topScore) {
        topScore = score;
        bestFaq = faq;
      }
    }

    if (bestFaq != null && topScore >= 4) {
      return "💡 ${bestFaq.answer}";
    }

    // Generic fallback
    return "I'm your Fandom Verse companion! While I'm looking into that specific detail, you can explore the **Fan Hub** for lore and terminology, the **Events Calendar** for meetups, or the **Merch Store** for official gear. What else would you like to know?";
  }

  bool _hasKeyword(String text, List<String> keywords) {
    return keywords.any((k) => text.contains(k));
  }
}
