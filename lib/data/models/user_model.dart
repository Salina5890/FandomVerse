class UserModel {
  final String id;
  final String email;
  final String name;
  final String? avatarUrl;
  final String? bio;
  final String role; // 'fan' | 'admin'
  final List<String> selectedFandomIds;
  final List<String> badgeIds;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
    this.bio,
    required this.role,
    this.selectedFandomIds = const [],
    this.badgeIds = const [],
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isAdmin => role == 'admin';
  bool get isFan => role == 'fan';

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? avatarUrl,
    String? bio,
    String? role,
    List<String>? selectedFandomIds,
    List<String>? badgeIds,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      role: role ?? this.role,
      selectedFandomIds: selectedFandomIds ?? this.selectedFandomIds,
      badgeIds: badgeIds ?? this.badgeIds,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'email': email,
        'name': name,
        'avatarUrl': avatarUrl,
        'bio': bio,
        'role': role,
        'selectedFandomIds': selectedFandomIds,
        'badgeIds': badgeIds,
        'isActive': isActive,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        id: map['id'] as String,
        email: map['email'] as String,
        name: map['name'] as String,
        avatarUrl: map['avatarUrl'] as String?,
        bio: map['bio'] as String?,
        role: map['role'] as String? ?? 'fan',
        selectedFandomIds:
            List<String>.from(map['selectedFandomIds'] as List? ?? []),
        badgeIds: List<String>.from(map['badgeIds'] as List? ?? []),
        isActive: map['isActive'] as bool? ?? true,
        createdAt: DateTime.parse(map['createdAt'] as String),
        updatedAt: DateTime.parse(map['updatedAt'] as String),
      );

  static UserModel get empty => UserModel(
        id: '',
        email: '',
        name: '',
        role: 'fan',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
}
