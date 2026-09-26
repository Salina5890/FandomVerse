class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String? imageUrl;
  final List<String> imageUrls;
  final String categoryId;
  final String? categoryName;
  final String fandomId;
  final String? fandomName;
  final int stock;

  int get stockQuantity => stock;
  String? get category => categoryName;
  final bool isFeatured;
  final bool isAvailable;
  final double? discountPercent;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
    this.imageUrls = const [],
    required this.categoryId,
    this.categoryName,
    required this.fandomId,
    this.fandomName,
    required this.stock,
    this.isFeatured = false,
    this.isAvailable = true,
    this.discountPercent,
    this.tags = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  double get effectivePrice {
    if (discountPercent != null && discountPercent! > 0) {
      return price * (1 - discountPercent! / 100);
    }
    return price;
  }

  bool get hasDiscount =>
      discountPercent != null && discountPercent! > 0;
  bool get isInStock => stock > 0 && isAvailable;

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    List<String>? imageUrls,
    String? categoryId,
    String? categoryName,
    String? fandomId,
    String? fandomName,
    int? stock,
    bool? isFeatured,
    bool? isAvailable,
    double? discountPercent,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      imageUrls: imageUrls ?? this.imageUrls,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      fandomId: fandomId ?? this.fandomId,
      fandomName: fandomName ?? this.fandomName,
      stock: stock ?? this.stock,
      isFeatured: isFeatured ?? this.isFeatured,
      isAvailable: isAvailable ?? this.isAvailable,
      discountPercent: discountPercent ?? this.discountPercent,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
        'imageUrls': imageUrls,
        'categoryId': categoryId,
        'categoryName': categoryName,
        'fandomId': fandomId,
        'fandomName': fandomName,
        'stock': stock,
        'isFeatured': isFeatured,
        'isAvailable': isAvailable,
        'discountPercent': discountPercent,
        'tags': tags,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory ProductModel.fromMap(Map<String, dynamic> map) => ProductModel(
        id: map['id'] as String,
        name: map['name'] as String,
        description: map['description'] as String,
        price: (map['price'] as num).toDouble(),
        imageUrl: map['imageUrl'] as String?,
        imageUrls: List<String>.from(map['imageUrls'] as List? ?? []),
        categoryId: map['categoryId'] as String,
        categoryName: map['categoryName'] as String?,
        fandomId: map['fandomId'] as String,
        fandomName: map['fandomName'] as String?,
        stock: map['stock'] as int? ?? 0,
        isFeatured: map['isFeatured'] as bool? ?? false,
        isAvailable: map['isAvailable'] as bool? ?? true,
        discountPercent: (map['discountPercent'] as num?)?.toDouble(),
        tags: List<String>.from(map['tags'] as List? ?? []),
        createdAt: DateTime.parse(map['createdAt'] as String),
        updatedAt: DateTime.parse(map['updatedAt'] as String),
      );
}

class CategoryModel {
  final String id;
  final String name;
  final String? description;
  final String? iconName;
  final String? imageUrl;
  final String type; // 'content' | 'product' | 'event'
  final int displayOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CategoryModel({
    required this.id,
    required this.name,
    this.description,
    this.iconName,
    this.imageUrl,
    required this.type,
    this.displayOrder = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  CategoryModel copyWith({
    String? id,
    String? name,
    String? description,
    String? iconName,
    String? imageUrl,
    String? type,
    int? displayOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconName: iconName ?? this.iconName,
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type,
      displayOrder: displayOrder ?? this.displayOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'iconName': iconName,
        'imageUrl': imageUrl,
        'type': type,
        'displayOrder': displayOrder,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory CategoryModel.fromMap(Map<String, dynamic> map) => CategoryModel(
        id: map['id'] as String,
        name: map['name'] as String,
        description: map['description'] as String?,
        iconName: map['iconName'] as String?,
        imageUrl: map['imageUrl'] as String?,
        type: map['type'] as String,
        displayOrder: map['displayOrder'] as int? ?? 0,
        createdAt: DateTime.parse(map['createdAt'] as String),
        updatedAt: DateTime.parse(map['updatedAt'] as String),
      );
}
