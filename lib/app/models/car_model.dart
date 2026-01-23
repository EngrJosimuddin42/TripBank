
// Main model

class CarBooking {
  final String bookingId;
  final Car car;
  final DateTime pickupDate;
  final DateTime? returnDate;
  final String pickupLocation;
  final String pickupLocationCode;
  final String dropoffLocation;
  final String dropoffLocationCode;
  final String tripType;
  final int totalDays;
  final double baseFare;
  final double tax;
  final double aitVat;
  final double otherCharges;
  final double totalAmount;
  final String? paymentMethod;
  final String? contactEmail;
  final String? contactPhone;
  final List<Passenger> passengers;
  final String status;
  final DateTime createdAt;

  CarBooking({
    required this.bookingId,
    required this.car,
    required this.pickupDate,
    this.returnDate,
    required this.pickupLocation,
    required this.pickupLocationCode,
    required this.dropoffLocation,
    required this.dropoffLocationCode,
    required this.tripType,
    required this.totalDays,
    required this.baseFare,
    required this.tax,
    required this.aitVat,
    required this.otherCharges,
    required this.totalAmount,
    this.paymentMethod,
    this.contactEmail,
    this.contactPhone,
    this.passengers = const [],
    this.status = 'Pending',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory CarBooking.fromJson(Map<String, dynamic> json) {
    return CarBooking(
      bookingId: json['bookingId'] as String? ?? '',
      car: Car.fromJson(json['car'] as Map<String, dynamic>? ?? {}),
      pickupDate: DateTime.tryParse(json['pickupDate']?.toString() ?? '') ?? DateTime.now(),
      returnDate: json['returnDate'] != null ? DateTime.tryParse(json['returnDate'].toString()) : null,
      pickupLocation: json['pickupLocation'] as String? ?? '',
      pickupLocationCode: json['pickupLocationCode'] as String? ?? '',
      dropoffLocation: json['dropoffLocation'] as String? ?? '',
      dropoffLocationCode: json['dropoffLocationCode'] as String? ?? '',
      tripType: json['tripType'] as String? ?? 'One Way',
      totalDays: json['totalDays'] as int? ?? 1,
      baseFare: (json['baseFare'] as num?)?.toDouble() ?? 0.0,
      tax: (json['tax'] as num?)?.toDouble() ?? 0.0,
      aitVat: (json['aitVat'] as num?)?.toDouble() ?? 0.0,
      otherCharges: (json['otherCharges'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: json['paymentMethod'] as String?,
      contactEmail: json['contactEmail'] as String?,
      contactPhone: json['contactPhone'] as String?,
      passengers: (json['passengers'] as List<dynamic>?)
          ?.map((p) => Passenger.fromJson(p as Map<String, dynamic>))
          .toList() ?? [],
      status: json['status'] as String? ?? 'Pending',
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'car': car.toJson(),
      'pickupDate': pickupDate.toIso8601String(),
      'returnDate': returnDate?.toIso8601String(),
      'pickupLocation': pickupLocation,
      'pickupLocationCode': pickupLocationCode,
      'dropoffLocation': dropoffLocation,
      'dropoffLocationCode': dropoffLocationCode,
      'tripType': tripType,
      'totalDays': totalDays,
      'baseFare': baseFare,
      'tax': tax,
      'aitVat': aitVat,
      'otherCharges': otherCharges,
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'contactEmail': contactEmail,
      'contactPhone': contactPhone,
      'passengers': passengers.map((p) => p.toJson()).toList(),
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

// Car Model

class Car {
  final String id;
  final String brand;
  final String model;
  final int year;
  final String types;
  final int seats;
  final int bags;
  final int doors;
  final int reviews;
  final String transmission;
  final double pricePerDay;
  final double rating;
  final String imageUrl;
  final bool available;
  final List<String> extras;

  Car({
    required this.id, required this.brand, required this.model, required this.year,
    required this.types, required this.seats, required this.bags, required this.doors,
    required this.transmission, required this.pricePerDay, required this.rating,
    required this.imageUrl, this.available = true,this.extras = const [],this.reviews = 0,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id']?.toString() ?? 'car_${DateTime.now().millisecondsSinceEpoch}',
      brand: json['brand']?.toString() ?? 'Unknown',
      model: json['model']?.toString() ?? 'Unknown',
      year: int.tryParse(json['year']?.toString() ?? '') ?? DateTime.now().year,
      types: json['type']?.toString() ?? 'Sedan',
      seats: int.tryParse(json['seats']?.toString() ?? '') ?? 4,
      bags: int.tryParse(json['bags']?.toString() ?? '') ?? 1,
      doors: int.tryParse(json['doors']?.toString() ?? '') ?? 4,
      transmission: json['transmission']?.toString() ?? 'Automatic',
      pricePerDay: (json['pricePerDay'] as num?)?.toDouble() ?? 0.0,
      rating: double.tryParse(json['rating']?.toString() ?? '4.0') ?? 4.0,
      imageUrl: json['image']?.toString() ?? '',
      available: json['available'] as bool? ?? true,
      extras: (json['extras'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      reviews: int.tryParse(json['reviews']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'brand': brand, 'model': model, 'year': year, 'type': types,
    'seats': seats, 'bags': bags, 'doors': doors, 'transmission': transmission,
    'pricePerDay': pricePerDay, 'rating': rating, 'imageUrl': imageUrl, 'available': available,'extras': extras,'reviews': reviews,
  };
}


// Passenger Model

class Passenger {
  final String title;
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final String passportNumber;
  final String type;
  final String? nin;

  Passenger({
    required this.title, required this.firstName, required this.lastName,
    required this.dateOfBirth, required this.passportNumber, required this.type, this.nin,
  });

  factory Passenger.fromJson(Map<String, dynamic> json) {
    return Passenger(
      title: json['title'] as String? ?? 'MR',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      dateOfBirth: DateTime.tryParse(json['dateOfBirth']?.toString() ?? '') ?? DateTime(1990),
      passportNumber: json['passportNumber'] as String? ?? '',
      type: json['type'] as String? ?? 'Adult',
      nin: json['nin'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title, 'firstName': firstName, 'lastName': lastName,
    'dateOfBirth': dateOfBirth.toIso8601String(), 'passportNumber': passportNumber,
    'type': type, 'nin': nin,
  };
}