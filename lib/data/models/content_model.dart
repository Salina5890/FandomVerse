enum ContentType {
  news('News', '📰'),
  story('Story', '📖'),
  video('Video', '🎬'),
  podcast('Podcast', '🎙️'),
  trivia('Trivia', '❓'),
  lore('Lore', '🔮'),
  behindScenes('Behind The Scenes', '🎭'),
  gallery('Gallery', '🖼️'),
  editorial('Editorial', '✍️'),
  character('Character', '👤'),
  glossary('Glossary', '📚');

  final String label;
  final String icon;

  const ContentType(this.label, this.icon);

  bool get isDeepDive {
    return this == ContentType.trivia ||
        this == ContentType.lore ||
        this == ContentType.behindScenes;
  }
}

class ContentModel {
  final String id;
  final String title;
  final String description;
  final String body;
  final String? imageUrl;
  final String? thumbnailUrl;
  final String? mediaUrl;
  final int? durationSeconds;
  final List<String> galleryUrls;
  final ContentType contentType;
  final String fandomId;
  final String? fandomName;
  final List<String> tags;
  final String author;
  final bool isFeatured;
  final bool isPublished;
  final bool isOfflineAvailable;
  final int readTimeMinutes;
  final int viewCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ContentModel({
    required this.id,
    required this.title,
    required this.description,
    required this.body,
    this.imageUrl,
    this.thumbnailUrl,
    this.mediaUrl,
    this.durationSeconds,
    this.galleryUrls = const [],
    required this.contentType,
    required this.fandomId,
    this.fandomName,
    this.tags = const [],
    required this.author,
    this.isFeatured = false,
    this.isPublished = true,
    this.isOfflineAvailable = false,
    this.readTimeMinutes = 3,
    this.viewCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  ContentModel copyWith({
    String? id,
    String? title,
    String? description,
    String? body,
    String? imageUrl,
    String? thumbnailUrl,
    String? mediaUrl,
    int? durationSeconds,
    List<String>? galleryUrls,
    ContentType? contentType,
    String? fandomId,
    String? fandomName,
    List<String>? tags,
    String? author,
    bool? isFeatured,
    bool? isPublished,
    bool? isOfflineAvailable,
    int? readTimeMinutes,
    int? viewCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ContentModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      body: body ?? this.body,
      imageUrl: imageUrl ?? this.imageUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      galleryUrls: galleryUrls ?? this.galleryUrls,
      contentType: contentType ?? this.contentType,
      fandomId: fandomId ?? this.fandomId,
      fandomName: fandomName ?? this.fandomName,
      tags: tags ?? this.tags,
      author: author ?? this.author,
      isFeatured: isFeatured ?? this.isFeatured,
      isPublished: isPublished ?? this.isPublished,
      isOfflineAvailable: isOfflineAvailable ?? this.isOfflineAvailable,
      readTimeMinutes: readTimeMinutes ?? this.readTimeMinutes,
      viewCount: viewCount ?? this.viewCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'body': body,
        'imageUrl': imageUrl,
        'thumbnailUrl': thumbnailUrl,
        'mediaUrl': mediaUrl,
        'durationSeconds': durationSeconds,
        'galleryUrls': galleryUrls,
        'contentType': contentType.name,
        'fandomId': fandomId,
        'fandomName': fandomName,
        'tags': tags,
        'author': author,
        'isFeatured': isFeatured,
        'isPublished': isPublished,
        'isOfflineAvailable': isOfflineAvailable,
        'readTimeMinutes': readTimeMinutes,
        'viewCount': viewCount,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory ContentModel.fromMap(Map<String, dynamic> map) => ContentModel(
        id: map['id'] as String,
        title: map['title'] as String,
        description: map['description'] as String,
        body: map['body'] as String? ?? '',
        imageUrl: map['imageUrl'] as String?,
        thumbnailUrl: map['thumbnailUrl'] as String?,
        mediaUrl: map['mediaUrl'] as String?,
        durationSeconds: map['durationSeconds'] as int?,
        galleryUrls: List<String>.from(map['galleryUrls'] as List? ?? []),
        contentType: ContentType.values.firstWhere(
          (e) => e.name == map['contentType'],
          orElse: () => ContentType.news,
        ),
        fandomId: map['fandomId'] as String,
        fandomName: map['fandomName'] as String?,
        tags: List<String>.from(map['tags'] as List? ?? []),
        author: map['author'] as String? ?? 'Fandom Verse',
        isFeatured: map['isFeatured'] as bool? ?? false,
        isPublished: map['isPublished'] as bool? ?? true,
        isOfflineAvailable: map['isOfflineAvailable'] as bool? ?? false,
        readTimeMinutes: map['readTimeMinutes'] as int? ?? 3,
        viewCount: map['viewCount'] as int? ?? 0,
        createdAt: DateTime.parse(map['createdAt'] as String),
        updatedAt: DateTime.parse(map['updatedAt'] as String),
      );
}
