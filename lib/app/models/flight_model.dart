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
    required this.price,
    required this.cabinClass,
    required this.availableSeats,
    required this.isRefundable,
    required this.baggageAllowance,
  });

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
  };

  factory Flight.fromJson(Map<String, dynamic> json) => Flight(
    id: json['id'],
    airline: json['airline'],
    airlineLogo: json['airlineLogo'],
    flightNumber: json['flightNumber'],
    from: json['from'],
    to: json['to'],
    fromCode: json['fromCode'],
    toCode: json['toCode'],
    departureTime: DateTime.parse(json['departureTime']),
    arrivalTime: DateTime.parse(json['arrivalTime']),
    duration: json['duration'],
    stops: json['stops'],
    stopDetails: json['stopDetails'],
    price: json['price'].toDouble(),
    cabinClass: json['cabinClass'],
    availableSeats: json['availableSeats'],
    isRefundable: json['isRefundable'],
    baggageAllowance: json['baggageAllowance'],
  );
}

class Passenger {
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final String passportNumber;
  final String type; // Adult, Child, or Infant

  Passenger({
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.passportNumber,
    required this.type,
  });

  String get fullName => '$firstName $lastName';

  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    'dateOfBirth': dateOfBirth.toIso8601String(),
    'passportNumber': passportNumber,
    'type': type,
  };

  factory Passenger.fromJson(Map<String, dynamic> json) => Passenger(
    firstName: json['firstName'],
    lastName: json['lastName'],
    dateOfBirth: DateTime.parse(json['dateOfBirth']),
    passportNumber: json['passportNumber'],
    type: json['type'],
  );
}

class Booking {
  final String bookingId;
  final Flight flight;
  final List<Passenger> passengers;
  final double totalPrice;
  final DateTime bookingDate;
  final String status; // Confirmed, Cancelled, Pending
  final String pnr; // Passenger Name Record

  Booking({
    required this.bookingId,
    required this.flight,
    required this.passengers,
    required this.totalPrice,
    required this.bookingDate,
    required this.status,
    required this.pnr,
  });

  Map<String, dynamic> toJson() => {
    'bookingId': bookingId,
    'flight': flight.toJson(),
    'passengers': passengers.map((p) => p.toJson()).toList(),
    'totalPrice': totalPrice,
    'bookingDate': bookingDate.toIso8601String(),
    'status': status,
    'pnr': pnr,
  };

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    bookingId: json['bookingId'],
    flight: Flight.fromJson(json['flight']),
    passengers: (json['passengers'] as List)
        .map((p) => Passenger.fromJson(p))
        .toList(),
    totalPrice: json['totalPrice'].toDouble(),
    bookingDate: DateTime.parse(json['bookingDate']),
    status: json['status'],
    pnr: json['pnr'],
  );
}