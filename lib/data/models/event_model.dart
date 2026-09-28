class EventModel {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final String city;

  String get startDateLabel => eventDate.toIso8601String();
  DateTime get startDate => eventDate;
  String get eventType => category;
  _EventLocationCompat get location => _EventLocationCompat(city: city, venueName: venue, country: '');
  final String venue;
  final String address;
  final DateTime eventDate;
  final DateTime? eventEndDate;
  final String category; // Convention, Cosplay, Screening, Meetup, Concert
  final String? ticketLink;
  final double? latitude;
  final double? longitude;
  final bool isFeatured;
  final String status; // upcoming, ongoing, past, cancelled
  final int? attendeeCount;
  final String fandomId;
  final String? fandomName;
  final DateTime createdAt;
  final DateTime updatedAt;

  const EventModel({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.city,
    required this.venue,
    required this.address,
    required this.eventDate,
    this.eventEndDate,
    required this.category,
    this.ticketLink,
    this.latitude,
    this.longitude,
    this.isFeatured = false,
    this.status = 'upcoming',
    this.attendeeCount,
    required this.fandomId,
    this.fandomName,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isUpcoming => eventDate.isAfter(DateTime.now());
  bool get isPast => eventDate.isBefore(DateTime.now());
  bool get hasTicketLink => ticketLink != null && ticketLink!.isNotEmpty;
  bool get hasLocation => latitude != null && longitude != null;

  EventModel copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    String? city,
    String? venue,
    String? address,
    DateTime? eventDate,
    DateTime? eventEndDate,
    String? category,
    String? ticketLink,
    double? latitude,
    double? longitude,
    bool? isFeatured,
    String? status,
    int? attendeeCount,
    String? fandomId,
    String? fandomName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      city: city ?? this.city,
      venue: venue ?? this.venue,
      address: address ?? this.address,
      eventDate: eventDate ?? this.eventDate,
      eventEndDate: eventEndDate ?? this.eventEndDate,
      category: category ?? this.category,
      ticketLink: ticketLink ?? this.ticketLink,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isFeatured: isFeatured ?? this.isFeatured,
      status: status ?? this.status,
      attendeeCount: attendeeCount ?? this.attendeeCount,
      fandomId: fandomId ?? this.fandomId,
      fandomName: fandomName ?? this.fandomName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
        'city': city,
        'venue': venue,
        'address': address,
        'eventDate': eventDate.toIso8601String(),
        'eventEndDate': eventEndDate?.toIso8601String(),
        'category': category,
        'ticketLink': ticketLink,
        'latitude': latitude,
        'longitude': longitude,
        'isFeatured': isFeatured,
        'status': status,
        'attendeeCount': attendeeCount,
        'fandomId': fandomId,
        'fandomName': fandomName,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory EventModel.fromMap(Map<String, dynamic> map) => EventModel(
        id: map['id'] as String,
        title: map['title'] as String,
        description: map['description'] as String,
        imageUrl: map['imageUrl'] as String?,
        city: map['city'] as String,
        venue: map['venue'] as String,
        address: map['address'] as String,
        eventDate: DateTime.parse(map['eventDate'] as String),
        eventEndDate: map['eventEndDate'] != null
            ? DateTime.parse(map['eventEndDate'] as String)
            : null,
        category: map['category'] as String,
        ticketLink: map['ticketLink'] as String?,
        latitude: (map['latitude'] as num?)?.toDouble(),
        longitude: (map['longitude'] as num?)?.toDouble(),
        isFeatured: map['isFeatured'] as bool? ?? false,
        status: map['status'] as String? ?? 'upcoming',
        attendeeCount: map['attendeeCount'] as int?,
        fandomId: map['fandomId'] as String,
        fandomName: map['fandomName'] as String?,
        createdAt: DateTime.parse(map['createdAt'] as String),
        updatedAt: DateTime.parse(map['updatedAt'] as String),
      );
}

class _EventLocationCompat {
  final String city;
  final String venueName;
  final String country;
  const _EventLocationCompat({required this.city, required this.venueName, required this.country});
}
