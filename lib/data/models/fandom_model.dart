class FandomModel {
  final String id;
  final String name;
  final String description;
  final String category; // Anime, Gaming, Sci-Fi, Comics, Movies, TV, K-Pop
  final String coverImageUrl;

  String get imageUrl => coverImageUrl;
  String get bannerUrl => coverImageUrl;
  final String? logoUrl;
  final List<String> tags;
  final bool isFeatured;
  final int memberCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FandomModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.coverImageUrl,
    this.logoUrl,
    this.tags = const [],
    this.isFeatured = false,
    this.memberCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  FandomModel copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    String? coverImageUrl,
    String? logoUrl,
    List<String>? tags,
    bool? isFeatured,
    int? memberCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FandomModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      logoUrl: logoUrl ?? this.logoUrl,
      tags: tags ?? this.tags,
      isFeatured: isFeatured ?? this.isFeatured,
      memberCount: memberCount ?? this.memberCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'category': category,
        'coverImageUrl': coverImageUrl,
        'logoUrl': logoUrl,
        'tags': tags,
        'isFeatured': isFeatured,
        'memberCount': memberCount,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory FandomModel.fromMap(Map<String, dynamic> map) => FandomModel(
        id: map['id'] as String,
        name: map['name'] as String,
        description: map['description'] as String,
        category: map['category'] as String,
        coverImageUrl: map['coverImageUrl'] as String,
        logoUrl: map['logoUrl'] as String?,
        tags: List<String>.from(map['tags'] as List? ?? []),
        isFeatured: map['isFeatured'] as bool? ?? false,
        memberCount: map['memberCount'] as int? ?? 0,
        createdAt: DateTime.parse(map['createdAt'] as String),
        updatedAt: DateTime.parse(map['updatedAt'] as String),
      );
}
