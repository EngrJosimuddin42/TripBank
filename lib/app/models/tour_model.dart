class Tour {
  final String id;
  final String title;
  final String location;
  final String imageUrl;
  final String category;
  final String duration;
  final int maxPeople;
  final double price;
  final double rating;
  final int reviewsCount;
  final String description;
  final bool isFullDay;
  final String buttonText;
  final List<String> keyHighlights;
  final List<String> included;
  final List<String> notIncluded;
  final List<ItineraryDay> itinerary;
  final MeetingPoint? meetingPoint;
  final List<String> whatToBring;
  final String? startTime;
  final String? destination;
  final List<String>? visitingPlaces;
  final double? taxRate;
  final String? cancellationPolicy;

  Tour({
    required this.id,
    required this.title,
    required this.location,
    required this.imageUrl,
    required this.category,
    required this.duration,
    required this.maxPeople,
    required this.price,
    required this.rating,
    required this.reviewsCount,
    required this.description,
    this.isFullDay = false,
    this.buttonText = 'Book Tour',
    this.keyHighlights = const [],
    this.included = const [],
    this.notIncluded = const [],
    this.itinerary = const [],
    this.meetingPoint,
    this.whatToBring = const [],
    this.startTime,
    this.destination,
    this.visitingPlaces,
    this.taxRate,
    this.cancellationPolicy,
  });


  factory Tour.fromMap(Map<String, dynamic> map) {
    return Tour(
      id: map['id'] ?? '',
      title: map['name'] ?? map['title'] ?? '',
      location: map['location'] ?? '',
      imageUrl: map['image'] ?? map['imageUrl'] ?? '',
      category: map['category'] ?? 'Adventure',
      duration: map['duration'] ?? '1 Day',
      maxPeople: map['maxPeople'] ?? map['max_people'] ?? 10,
      price: _parsePrice(map['price']),
      rating: (map['rating'] as num?)?.toDouble() ?? 4.5,
      reviewsCount: map['reviewsCount'] ?? map['reviews_count'] ?? 0,
      description: map['description'] ?? '',
      isFullDay: map['isFullDay'] ?? map['is_full_day'] ?? false,
      buttonText: map['buttonText'] ?? map['button_text'] ?? 'View Details',
      keyHighlights: List<String>.from(map['keyHighlights'] ?? map['key_highlights'] ?? []),
      included: List<String>.from(map['included'] ?? []),
      notIncluded: List<String>.from(map['notIncluded'] ?? map['not_included'] ?? []),
      itinerary: (map['itinerary'] as List<dynamic>?)
          ?.map((day) => ItineraryDay.fromMap(day as Map<String, dynamic>))
          .toList() ??
          [],
      meetingPoint: (map['meetingPoint'] != null)
          ? MeetingPoint.fromMap(map['meetingPoint'])
          : (map['meeting_point'] != null)
          ? MeetingPoint.fromMap(map['meeting_point'])
          : null,
      whatToBring: List<String>.from(map['whatToBring'] ?? map['what_to_bring'] ?? []),

      startTime: map['start_time'] ?? map['startTime'],
      destination: map['destination'],
      visitingPlaces: map['visiting_places'] != null
          ? List<String>.from(map['visiting_places'])
          : null,
      taxRate: (map['tax_rate'] as num?)?.toDouble(),
      cancellationPolicy: map['cancellation_policy'] ?? map['cancellationPolicy'],
    );
  }

  // Helper method to parse price string (e.g., "$899" -> 899.0)

  static double _parsePrice(dynamic price) {
    if (price == null) return 0.0;
    if (price is num) return price.toDouble();
    if (price is String) {
      final cleaned = price.replaceAll(RegExp(r'[^\d.]'), '');
      return double.tryParse(cleaned) ?? 0.0;
    }
    return 0.0;
  }


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': title,
      'location': location,
      'image': imageUrl,
      'category': category,
      'duration': duration,
      'maxPeople': maxPeople,
      'price': '\$$price',
      'rating': rating,
      'reviewsCount': reviewsCount,
      'description': description,
      'isFullDay': isFullDay,
      'buttonText': buttonText,
      'keyHighlights': keyHighlights,
      'included': included,
      'notIncluded': notIncluded,
      'itinerary': itinerary.map((day) => day.toMap()).toList(),
      'meetingPoint': meetingPoint?.toMap(),
      'whatToBring': whatToBring,
      'start_time': startTime,
      'destination': destination,
      'visiting_places': visitingPlaces,
      'tax_rate': taxRate,
      'cancellation_policy': cancellationPolicy,
    };
  }
}

class MeetingPoint {
  final String address;
  final String? description;
  final String? mapImageUrl;

  MeetingPoint({
    required this.address,
    this.description,
    this.mapImageUrl,
  });

  factory MeetingPoint.fromMap(Map<String, dynamic> map) {
    return MeetingPoint(
      address: map['address'] ?? '',
      description: map['description'],
      mapImageUrl: map['mapImageUrl'] ?? map['map_image_url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'description': description,
      'mapImageUrl': mapImageUrl,
    };
  }
}

class ItineraryDay {
  final String day;
  final String title;
  final List<String> activities;

  ItineraryDay({
    required this.day,
    required this.title,
    this.activities = const [],
  });

  factory ItineraryDay.fromMap(Map<String, dynamic> map) {
    return ItineraryDay(
      day: map['day'] ?? '',
      title: map['title'] ?? '',
      activities: List<String>.from(map['activities'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'title': title,
      'activities': activities,
    };
  }
}