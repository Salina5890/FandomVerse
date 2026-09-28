class CartItemModel {
  final String id;
  final String productId;
  final String productName;
  final String? productImageUrl;
  final double productPrice;
  final int quantity;
  final String fandomId;
  final String? fandomName;

  const CartItemModel({
    required this.id,
    required this.productId,
    required this.productName,
    this.productImageUrl,
    required this.productPrice,
    required this.quantity,
    required this.fandomId,
    this.fandomName,
  });

  double get subtotal => productPrice * quantity;

  CartItemModel copyWith({
    String? id,
    String? productId,
    String? productName,
    String? productImageUrl,
    double? productPrice,
    int? quantity,
    String? fandomId,
    String? fandomName,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImageUrl: productImageUrl ?? this.productImageUrl,
      productPrice: productPrice ?? this.productPrice,
      quantity: quantity ?? this.quantity,
      fandomId: fandomId ?? this.fandomId,
      fandomName: fandomName ?? this.fandomName,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'productId': productId,
        'productName': productName,
        'productImageUrl': productImageUrl,
        'productPrice': productPrice,
        'quantity': quantity,
        'fandomId': fandomId,
        'fandomName': fandomName,
      };

  factory CartItemModel.fromMap(Map<String, dynamic> map) => CartItemModel(
        id: map['id'] as String,
        productId: map['productId'] as String,
        productName: map['productName'] as String,
        productImageUrl: map['productImageUrl'] as String?,
        productPrice: (map['productPrice'] as num).toDouble(),
        quantity: map['quantity'] as int,
        fandomId: map['fandomId'] as String,
        fandomName: map['fandomName'] as String?,
      );
}

class OrderModel {
  final String id;
  final String userId;
  final List<CartItemModel> items;
  final double subtotal;
  final double shipping;
  final double total;
  final String status; // pending, confirmed, processing, shipped, delivered
  final String? shippingAddress;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.shipping,
    required this.total,
    required this.status,
    this.shippingAddress,
    required this.createdAt,
    required this.updatedAt,
  });

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  Map<String, dynamic> toMap() => {
        'id': id,
        'userId': userId,
        'items': items.map((e) => e.toMap()).toList(),
        'subtotal': subtotal,
        'shipping': shipping,
        'total': total,
        'status': status,
        'shippingAddress': shippingAddress,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory OrderModel.fromMap(Map<String, dynamic> map) => OrderModel(
        id: map['id'] as String,
        userId: map['userId'] as String,
        items: (map['items'] as List)
            .map((e) => CartItemModel.fromMap(e as Map<String, dynamic>))
            .toList(),
        subtotal: (map['subtotal'] as num).toDouble(),
        shipping: (map['shipping'] as num).toDouble(),
        total: (map['total'] as num).toDouble(),
        status: map['status'] as String,
        shippingAddress: map['shippingAddress'] as String?,
        createdAt: DateTime.parse(map['createdAt'] as String),
        updatedAt: DateTime.parse(map['updatedAt'] as String),
      );
}

class WishlistItemModel {
  final String id;
  final String productId;
  final String userId;
  final String productName;
  final String? productImageUrl;
  final double productPrice;
  final DateTime addedAt;

  const WishlistItemModel({
    required this.id,
    required this.productId,
    required this.userId,
    required this.productName,
    this.productImageUrl,
    required this.productPrice,
    required this.addedAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'productId': productId,
        'userId': userId,
        'productName': productName,
        'productImageUrl': productImageUrl,
        'productPrice': productPrice,
        'addedAt': addedAt.toIso8601String(),
      };

  factory WishlistItemModel.fromMap(Map<String, dynamic> map) =>
      WishlistItemModel(
        id: map['id'] as String,
        productId: map['productId'] as String,
        userId: map['userId'] as String,
        productName: map['productName'] as String,
        productImageUrl: map['productImageUrl'] as String?,
        productPrice: (map['productPrice'] as num).toDouble(),
        addedAt: DateTime.parse(map['addedAt'] as String),
      );
}

class BookmarkModel {
  final String id;
  final String userId;
  final String contentId;
  final String contentTitle;
  final String? contentImageUrl;
  final String contentType;
  final String fandomId;
  final DateTime createdAt;

  const BookmarkModel({
    required this.id,
    required this.userId,
    required this.contentId,
    required this.contentTitle,
    this.contentImageUrl,
    required this.contentType,
    required this.fandomId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'userId': userId,
        'contentId': contentId,
        'contentTitle': contentTitle,
        'contentImageUrl': contentImageUrl,
        'contentType': contentType,
        'fandomId': fandomId,
        'createdAt': createdAt.toIso8601String(),
      };

  factory BookmarkModel.fromMap(Map<String, dynamic> map) => BookmarkModel(
        id: map['id'] as String,
        userId: map['userId'] as String,
        contentId: map['contentId'] as String,
        contentTitle: map['contentTitle'] as String,
        contentImageUrl: map['contentImageUrl'] as String?,
        contentType: map['contentType'] as String,
        fandomId: map['fandomId'] as String,
        createdAt: DateTime.parse(map['createdAt'] as String),
      );
}
