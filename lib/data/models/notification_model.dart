class NotificationModel {
  final String id;
  final String type;
  final String title;
  final String message;
  final DateTime timestamp;
  final String? iconKey;
  final String? route;
  final Map<String, dynamic>? arguments;
  final bool isRead;

  const NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.timestamp,
    this.iconKey,
    this.route,
    this.arguments,
    this.isRead = false,
  });

  NotificationModel copyWith({bool? isRead}) => NotificationModel(
        id: id,
        type: type,
        title: title,
        message: message,
        timestamp: timestamp,
        iconKey: iconKey,
        route: route,
        arguments: arguments,
        isRead: isRead ?? this.isRead,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'type': type,
        'title': title,
        'message': message,
        'timestamp': timestamp.toIso8601String(),
        'iconKey': iconKey,
        'route': route,
        'arguments': arguments,
        'isRead': isRead,
      };

  factory NotificationModel.fromMap(Map<String, dynamic> map) => NotificationModel(
        id: map['id'] as String,
        type: map['type'] as String,
        title: map['title'] as String,
        message: map['message'] as String,
        timestamp: DateTime.parse(map['timestamp'] as String),
        iconKey: map['iconKey'] as String?,
        route: map['route'] as String?,
        arguments: map['arguments'] == null
            ? null
            : Map<String, dynamic>.from(map['arguments'] as Map),
        isRead: map['isRead'] as bool? ?? false,
      );
}
