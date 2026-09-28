import 'package:flutter_test/flutter_test.dart';
import 'package:fandom_verse/data/services/ai_service.dart';
import 'package:fandom_verse/data/services/seed_data_service.dart';

void main() {
  group('AI Service & NLP Knowledge Tests', () {
    late AiService aiService;

    setUp(() {
      aiService = AiService();
    });

    test('AI correctly answers Glossary question about Hashira', () async {
      final answer = await aiService.queryAi('What is a Hashira?');
      expect(answer, contains('Demon Slayer'));
      expect(answer.toLowerCase(), contains('hashira'));
    });

    test('AI correctly answers query about upcoming events', () async {
      final answer = await aiService.queryAi('Find upcoming events');
      expect(answer, contains('Upcoming Fandom Events'));
    });

    test('AI correctly answers badges query', () async {
      final answer = await aiService.queryAi('How do badges work?');
      expect(answer.toLowerCase(), contains('badges'));
    });

    test('AI correctly handles recommendations', () async {
      final answer = await aiService.queryAi('Recommend an anime for me');
      expect(answer.toLowerCase(), contains('recommendations'));
    });
  });

  group('SeedData & Model Consistency', () {
    test('Seed data collections are populated', () {
      expect(SeedDataService.fandoms.isNotEmpty, true);
      expect(SeedDataService.contentItems.isNotEmpty, true);
      expect(SeedDataService.events.isNotEmpty, true);
      expect(SeedDataService.products.isNotEmpty, true);
      expect(SeedDataService.glossaryTerms.isNotEmpty, true);
      expect(SeedDataService.faqs.isNotEmpty, true);
    });
  });
}
