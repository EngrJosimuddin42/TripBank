
// Flight Model

class Flight {
  final String id;
  final String airline;
  final String airlineLogo;
  final String flightNumber;
  final String from;
  final String to;
  final String fromCode;
  final String toCode;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final String duration;
  final int stops;
  final String? stopDetails;
  final double price;
  final String cabinClass;
  final int availableSeats;
  final bool isRefundable;
  final String baggageAllowance;
  final String currencySymbol;
  final double taxAmount;
  final double vatAmount;
  final double otherCharges;
  final String? fareRules;
  final DateTime? returnDepartureTime;
  final DateTime? returnArrivalTime;
  final String? returnDuration;
  final int? returnStops;
  final List<String> facilities;
  final String flightType;
  String get imageUrl => airlineLogo;
  String? preferredTime;

  Flight({
    required this.id,
    required this.airline,
    required this.airlineLogo,
    required this.flightNumber,
    required this.from,
    required this.to,
    required this.fromCode,
    required this.toCode,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.stops,
    this.stopDetails,
    required this.vatAmount,
    required this.price,
    required this.cabinClass,
    required this.availableSeats,
    required this.isRefundable,
    required this.baggageAllowance,
    this.currencySymbol = '\$',
    this.taxAmount = 0.0,
    this.otherCharges = 0.0,
    this.fareRules,
    this.returnDepartureTime,
    this.returnArrivalTime,
    this.returnDuration,
    this.returnStops,
    this.facilities = const [],
    required this.flightType,
    this.preferredTime,
  });

  // helper method to get flight type based on stops

  static String getFlightTypeLabel(int stops) {
    if (stops == 0) return 'Direct';
    if (stops == 1) return '1 Stop';
    return '$stops Stops';
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'airline': airline,
    'airlineLogo': airlineLogo,
    'flightNumber': flightNumber,
    'from': from,
    'to': to,
    'fromCode': fromCode,
    'toCode': toCode,
    'departureTime': departureTime.toIso8601String(),
    'arrivalTime': arrivalTime.toIso8601String(),
    'duration': duration,
    'stops': stops,
    'stopDetails': stopDetails,
    'price': price,
    'cabinClass': cabinClass,
    'availableSeats': availableSeats,
    'isRefundable': isRefundable,
    'baggageAllowance': baggageAllowance,
    'currency_symbol': currencySymbol,
    'tax_amount': taxAmount,
    'vat_amount': vatAmount,
    'other_charges': otherCharges,
    'fare_rules': fareRules,
    'return_departure_time': returnDepartureTime?.toIso8601String(),
    'return_arrival_time': returnArrivalTime?.toIso8601String(),
    'return_duration': returnDuration,
    'return_stops': returnStops,
    'facilities': facilities,
    'flightType': flightType,
    'preferredTime': preferredTime,
  };

  factory Flight.fromJson(Map<String, dynamic> json) {
    final int stopsCount = json['stops'] ?? 0;
    return Flight(
      id: json['id']?.toString() ?? '',
      airline: json['airline'] ?? '',
      airlineLogo: json['airlineLogo'] ?? json['logoUrl'] ?? 'assets/images/airplane.png',
      flightNumber: json['flightNumber'] ?? '',
      from: json['from'] ?? json['fromCity'] ?? '',
      to: json['to'] ?? json['toCity'] ?? '',
      fromCode: json['fromCode'] ?? '',
      toCode: json['toCode'] ?? '',
      departureTime: DateTime.tryParse(json['departureTime'] ?? '') ?? DateTime.now(),
      arrivalTime: DateTime.tryParse(json['arrivalTime'] ?? '') ?? DateTime.now(),
      duration: json['duration'] ?? '0h 0m',
      stops: stopsCount,
      stopDetails: json['stopDetails'],
      price: (json['price'] ?? 0).toDouble(),
      cabinClass: json['cabinClass'] ?? json['flightClass'] ?? 'Economy',
      availableSeats: json['availableSeats'] ?? 0,
      isRefundable: json['isRefundable'] ?? false,
      baggageAllowance: json['baggageAllowance'] ?? '20KG checked + 7KG cabin',
      currencySymbol: json['currency_symbol'] ?? '\$',
      taxAmount: (json['tax_amount'] ?? 0).toDouble(),
      vatAmount: (json['vat_amount'] ?? 0).toDouble(),
      otherCharges: (json['other_charges'] ?? 0).toDouble(),
      fareRules: json['fare_rules'],
      returnDepartureTime: DateTime.tryParse(json['return_departure_time'] ?? ''),
      returnArrivalTime: DateTime.tryParse(json['return_arrival_time'] ?? ''),
      returnDuration: json['return_duration'],
      returnStops: json['return_stops'],
      facilities: List<String>.from(json['facilities'] ?? []),
      flightType: json['flightType'] ?? getFlightTypeLabel(stopsCount),
      preferredTime: json['preferredTime'],
    );
  }
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
  final String? email;
  final String? phone;

  Passenger({
    required this.title,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.passportNumber,
    required this.type,
    this.nin,
    this.email,
    this.phone,
  });

  String get fullName => '$title $firstName $lastName';

  Map<String, dynamic> toJson() => {
    'title': title,
    'firstName': firstName,
    'lastName': lastName,
    'dateOfBirth': dateOfBirth.toIso8601String(),
    'passportNumber': passportNumber,
    'type': type,
    'nin': nin,
    'email': email,
    'phone': phone,
  };

  factory Passenger.fromJson(Map<String, dynamic> json) => Passenger(
    title: json['title'] ?? 'MR',
    firstName: json['firstName'] ?? '',
    lastName: json['lastName'] ?? '',
    dateOfBirth: DateTime.tryParse(json['dateOfBirth'] ?? '') ?? DateTime.now(),
    passportNumber: json['passportNumber'] ?? '',
    type: json['type'] ?? 'Adult',
    nin: json['nin'],
    email: json['email'],
    phone: json['phone'],
  );
}

// Flight Class Model

class FlightClass {
  final String name;
  final int availableSeats;
  final double price;

  FlightClass({
    required this.name,
    required this.availableSeats,
    required this.price,
  });

  factory FlightClass.fromJson(Map<String, dynamic> json) {
    return FlightClass(
      name: json['name'] ?? '',
      availableSeats: json['availableSeats'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
    );
  }
}

// Facility Model

class Facility {
  final String id;
  final String name;
  final double price;
  final bool isIncluded;

  Facility({
    required this.id,
    required this.name,
    required this.price,
    this.isIncluded = false,
  });

  factory Facility.fromJson(Map<String, dynamic> json) {
    return Facility(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      isIncluded: json['isIncluded'] ?? false,
    );
  }
}

// Booking Model

class Booking {
  final String bookingId;
  final Flight flight;
  final List<Passenger> passengers;
  final double totalPrice;
  final DateTime bookingDate;
  final String status;
  final String pnr;
  final String? paymentMethod;
  final double baseFare;
  final double taxes;
  final double otherCharges;

  Booking({
    required this.bookingId,
    required this.flight,
    required this.passengers,
    required this.totalPrice,
    required this.bookingDate,
    required this.status,
    required this.pnr,
    this.paymentMethod,
    this.baseFare = 0.0,
    this.taxes = 0.0,
    this.otherCharges = 0.0,
  });

  int get totalPassengers => passengers.length;

  Map<String, dynamic> toJson() => {
    'bookingId': bookingId,
    'flight': flight.toJson(),
    'passengers': passengers.map((p) => p.toJson()).toList(),
    'totalPrice': totalPrice,
    'bookingDate': bookingDate.toIso8601String(),
    'status': status,
    'pnr': pnr,
    'paymentMethod': paymentMethod,
    'base_fare': baseFare,
    'taxes': taxes,
    'other_charges': otherCharges,
  };

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    bookingId: json['bookingId'] ?? '',
    flight: Flight.fromJson(json['flight'] ?? {}),
    passengers: (json['passengers'] as List<dynamic>?)
        ?.map((p) => Passenger.fromJson(p as Map<String, dynamic>))
        .toList() ??
        [],
    totalPrice: (json['totalPrice'] ?? 0).toDouble(),
    bookingDate: DateTime.tryParse(json['bookingDate'] ?? '') ?? DateTime.now(),
    status: json['status'] ?? 'Pending',
    pnr: json['pnr'] ?? '',
    paymentMethod: json['paymentMethod'],
    baseFare: (json['base_fare'] ?? 0).toDouble(),
    taxes: (json['taxes'] ?? 0).toDouble(),
    otherCharges: (json['other_charges'] ?? 0).toDouble(),
  );
}

// MultiWayFlight model

class MultiWayFlight {
  String fromLocation;
  String fromCode;
  String toLocation;
  String toCode;
  DateTime date;
  String? preferredTime;
  List<String> selectedTimeSlots;

  MultiWayFlight({
    required this.fromLocation,
    required this.fromCode,
    required this.toLocation,
    required this.toCode,
    required this.date,
    this.preferredTime,
    List<String>? selectedTimeSlots,
  }) : selectedTimeSlots = selectedTimeSlots ?? [];
}


//AIRPORT MODEL

class Airport {
  final String id;
  final String code;
  final String name;
  final String city;
  final String country;

  Airport({
    required this.id,
    required this.code,
    required this.name,
    required this.city,
    required this.country,
  });

  factory Airport.fromJson(Map<String, dynamic> json) {
    return Airport(
      id: json['id']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'city': city,
      'country': country,
    };
  }
}