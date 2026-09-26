class BadgeModel {
  final String id;
  final String name;
  final String description;
  final String iconEmoji;

  String get iconUrl => iconEmoji;
  final String? imageUrl;
  final String rarity; // common, rare, epic, legendary
  final String fandomCategory; // which fandom type this badge is for
  final DateTime createdAt;

  const BadgeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.iconEmoji,
    this.imageUrl,
    required this.rarity,
    required this.fandomCategory,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'iconEmoji': iconEmoji,
        'imageUrl': imageUrl,
        'rarity': rarity,
        'fandomCategory': fandomCategory,
        'createdAt': createdAt.toIso8601String(),
      };

  factory BadgeModel.fromMap(Map<String, dynamic> map) => BadgeModel(
        id: map['id'] as String,
        name: map['name'] as String,
        description: map['description'] as String,
        iconEmoji: map['iconEmoji'] as String,
        imageUrl: map['imageUrl'] as String?,
        rarity: map['rarity'] as String,
        fandomCategory: map['fandomCategory'] as String,
        createdAt: DateTime.parse(map['createdAt'] as String),
      );
}

class FaqModel {
  final String id;
  final String question;
  final String answer;
  final String category;
  final List<String> tags;
  final int helpfulCount;
  final DateTime createdAt;

  const FaqModel({
    required this.id,
    required this.question,
    required this.answer,
    required this.category,
    this.tags = const [],
    this.helpfulCount = 0,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'question': question,
        'answer': answer,
        'category': category,
        'tags': tags,
        'helpfulCount': helpfulCount,
        'createdAt': createdAt.toIso8601String(),
      };

  factory FaqModel.fromMap(Map<String, dynamic> map) => FaqModel(
        id: map['id'] as String,
        question: map['question'] as String,
        answer: map['answer'] as String,
        category: map['category'] as String,
        tags: List<String>.from(map['tags'] as List? ?? []),
        helpfulCount: map['helpfulCount'] as int? ?? 0,
        createdAt: DateTime.parse(map['createdAt'] as String),
      );
}

class GlossaryModel {
  final String id;
  final String term;
  final String definition;
  final String? example;
  final String fandomId;
  final String? fandomName;
  final List<String> relatedTerms;
  final String difficulty; // beginner, intermediate, advanced
  final DateTime createdAt;

  const GlossaryModel({
    required this.id,
    required this.term,
    required this.definition,
    this.example,
    required this.fandomId,
    this.fandomName,
    this.relatedTerms = const [],
    this.difficulty = 'beginner',
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'term': term,
        'definition': definition,
        'example': example,
        'fandomId': fandomId,
        'fandomName': fandomName,
        'relatedTerms': relatedTerms,
        'difficulty': difficulty,
        'createdAt': createdAt.toIso8601String(),
      };

  factory GlossaryModel.fromMap(Map<String, dynamic> map) => GlossaryModel(
        id: map['id'] as String,
        term: map['term'] as String,
        definition: map['definition'] as String,
        example: map['example'] as String?,
        fandomId: map['fandomId'] as String,
        fandomName: map['fandomName'] as String?,
        relatedTerms: List<String>.from(map['relatedTerms'] as List? ?? []),
        difficulty: map['difficulty'] as String? ?? 'beginner',
        createdAt: DateTime.parse(map['createdAt'] as String),
      );
}

class InquiryModel {
  final String id;
  final String name;
  final String email;
  final String subject;
  final String message;
  final String status; // pending, reviewed, resolved
  final DateTime createdAt;

  const InquiryModel({
    required this.id,
    required this.name,
    required this.email,
    required this.subject,
    required this.message,
    this.status = 'pending',
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'subject': subject,
        'message': message,
        'status': status,
        'createdAt': createdAt.toIso8601String(),
      };

  factory InquiryModel.fromMap(Map<String, dynamic> map) => InquiryModel(
        id: map['id'] as String,
        name: map['name'] as String,
        email: map['email'] as String,
        subject: map['subject'] as String,
        message: map['message'] as String,
        status: map['status'] as String? ?? 'pending',
        createdAt: DateTime.parse(map['createdAt'] as String),
      );
}

class CharacterModel {
  final String id;
  final String name;
  final String fandomId;
  final String? fandomName;
  final String description;
  final String? imageUrl;
  final List<String> traits;
  final String role; // protagonist, antagonist, supporting
  final DateTime createdAt;

  const CharacterModel({
    required this.id,
    required this.name,
    required this.fandomId,
    this.fandomName,
    required this.description,
    this.imageUrl,
    this.traits = const [],
    required this.role,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'fandomId': fandomId,
        'fandomName': fandomName,
        'description': description,
        'imageUrl': imageUrl,
        'traits': traits,
        'role': role,
        'createdAt': createdAt.toIso8601String(),
      };

  factory CharacterModel.fromMap(Map<String, dynamic> map) => CharacterModel(
        id: map['id'] as String,
        name: map['name'] as String,
        fandomId: map['fandomId'] as String,
        fandomName: map['fandomName'] as String?,
        description: map['description'] as String,
        imageUrl: map['imageUrl'] as String?,
        traits: List<String>.from(map['traits'] as List? ?? []),
        role: map['role'] as String,
        createdAt: DateTime.parse(map['createdAt'] as String),
      );
}
