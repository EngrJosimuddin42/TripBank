import 'package:flutter/foundation.dart';

class BookingSummary {
  final String type;
  final String title;
  final String subtitle;
  final String dates;
  final String imageUrl;
  final String bookingId;
  String status;
  final String totalAmount;
  final Map<String, dynamic> ticketData;
  final DateTime bookingDate;

  BookingSummary({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.dates,
    required this.imageUrl,
    required this.bookingId,
    required this.status,
    required this.totalAmount,
    required this.ticketData,
    DateTime? bookingDate,
  }) : bookingDate = bookingDate ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'type': type,
    'title': title,
    'subtitle': subtitle,
    'dates': dates,
    'imageUrl': imageUrl,
    'bookingId': bookingId,
    'status': status,
    'totalAmount': totalAmount,
    'ticketData': ticketData,
    'bookingDate': bookingDate.toIso8601String(),
  };

  factory BookingSummary.fromJson(Map<String, dynamic> json) => BookingSummary(
    type: json['type'] ?? '',
    title: json['title'] ?? '',
    subtitle: json['subtitle'] ?? '',
    dates: json['dates'] ?? '',
    imageUrl: json['imageUrl'] ?? '',
    bookingId: json['bookingId'] ?? '',
    status: json['status'] ?? 'Confirmed',
    totalAmount: json['totalAmount'] ?? '\$0',
    ticketData: json['ticketData'] ?? {},
    bookingDate: json['bookingDate'] != null
        ? DateTime.parse(json['bookingDate'])
        : DateTime.now(),
  );

  String get displayLocation {
    final sub = subtitle.trim();
    if (sub.contains('Airlines') ||
        sub.contains('Airline') ||
        sub.contains('Flight') ||
        sub.toLowerCase().contains('class')) {
      final parts = sub.split('+');
      if (parts.isNotEmpty) {
        String airlinePart = parts.first.trim();
        String city = _guessCityFromAirline(airlinePart);
        return '$airlinePart, $city';
      }
    }
    final commaParts = sub.split(',');
    if (commaParts.length > 1) {
      return commaParts.first.trim();
    }
    return sub.split(RegExp(r'[•+−]')).first.trim();
  }

  String _guessCityFromAirline(String airline) {
    final lower = airline.toLowerCase();
    if (lower.contains('singapore')) return 'Singapore';
    if (lower.contains('emirates')) return 'Dubai';
    if (lower.contains('qatar')) return 'Doha';
    if (lower.contains('biman')) return 'Bangladesh';
    if (lower.contains('indigo')) return 'India';
    if (lower.contains('air india')) return 'India';
    if (lower.contains('sparrow')) return 'Bangladesh';
    return 'Destination';
  }

  // Convert to TicketData for Tour Ticket Display
  TicketData toTicketData() {
    final adults = ticketData['adults'] ?? 1;
    final children = ticketData['children'] ?? 0;
    final selectedDate = ticketData['selectedDate'] != null
        ? DateTime.parse(ticketData['selectedDate'])
        : bookingDate;
    final subtotal = (ticketData['subtotal'] ?? 0.0).toDouble();
    final tax = (ticketData['tax'] ?? 0.0).toDouble();
    final grandTotal = double.tryParse(
        totalAmount.replaceAll(RegExp(r'[^\d.]'), '')
    ) ?? 0.0;

    return TicketData(
      bookingReference: ticketData['bookingReference'] ?? bookingId,
      status: status,
      tourTitle: title,
      fromLocation: subtitle,
      toLocation: ticketData['destination'] ?? subtitle,
      tourDate: selectedDate,
      startTime: ticketData['startTime'] ?? '09:00 AM',
      guestsText: '$adults Adults${children > 0 ? ", $children Children" : ""}',
      duration: ticketData['duration'] ?? 'Full Day',
      subtotal: subtotal,
      tax: tax,
      grandTotal: grandTotal,
      isFromMyBookings: true,
    );
  }

  // Convert to HotelTicketData for Hotel Ticket Display
  HotelTicketData toHotelTicketData() {
    final hotelDetails = ticketData;

    final totalPaid = double.tryParse(
        totalAmount.replaceAll(RegExp(r'[^\d.]'), '')
    ) ?? 0.0;

    double basePrice = (hotelDetails['basePrice'] ?? 0.0).toDouble();
    double discount = (hotelDetails['discount'] ?? 0.0).toDouble();
    double tax = (hotelDetails['tax'] ?? 0.0).toDouble();
    double serviceFee = (hotelDetails['serviceFee'] ?? 0.0).toDouble();

    if (basePrice == 0 && totalPaid > 0) {
      serviceFee = 5.0;
      final netAmount = totalPaid - serviceFee;
      basePrice = netAmount / 1.10;
      tax = netAmount - basePrice;
    }

    DateTime checkIn = bookingDate;
    DateTime checkOut = bookingDate.add(const Duration(days: 1));

    if (hotelDetails['checkIn'] != null) {
      try {
        checkIn = DateTime.parse(hotelDetails['checkIn']);
      } catch (e) {
        if (kDebugMode) {
          print('Invalid checkIn format:$e');
        }
      }
    }

    if (hotelDetails['checkOut'] != null) {
      try {
        checkOut = DateTime.parse(hotelDetails['checkOut']);
      } catch (e) {
        final nights = hotelDetails['nights'] ?? 1;
        checkOut = checkIn.add(Duration(days: nights));
      }
    }

    final nights = hotelDetails['nights'] ?? checkOut.difference(checkIn).inDays;

    List<String> amenities = [];
    if (hotelDetails['amenities'] != null) {
      amenities = List<String>.from(hotelDetails['amenities']);
    } else {
      amenities = ['Free Wi-Fi', 'Room Service', 'Cafe', 'Parking Service'];
    }

    return HotelTicketData(
      bookingReference: hotelDetails['bookingReference'] ??
          hotelDetails['bookingId'] ??
          bookingId,
      status: status,
      hotelName: title,
      location: subtitle.split(',').map((e) => e.trim()).join(', '),
      address: hotelDetails['address'] ?? '',
      imageUrl: imageUrl,
      rating: (hotelDetails['rating'] ?? 4.5).toDouble(),
      reviews: hotelDetails['reviews'] ?? 0,
      checkInDate: checkIn,
      checkOutDate: checkOut,
      nights: nights,
      rooms: hotelDetails['rooms'] ?? 1,
      guests: hotelDetails['guests'] ?? hotelDetails['travelers'] ?? 1,
      roomClass: hotelDetails['roomClass'] ?? 'Standard',
      basePrice: basePrice,
      discount: discount,
      tax: tax,
      serviceFee: serviceFee,
      totalPrice: totalPaid,
      paymentMethod: hotelDetails['paymentMethod'] ?? '',
      amenities: amenities,
      isFromMyBookings: true,
    );
  }

  // Convert to CarTicketData for Car Ticket Display
  CarTicketData toCarTicketData() {
    final carDetails = ticketData;

    final totalPaid = double.tryParse(
        totalAmount.replaceAll(RegExp(r'[^\d.]'), '')
    ) ?? 0.0;

    double baseFare = (carDetails['baseFare'] ?? 0.0).toDouble();
    double tax = (carDetails['tax'] ?? 0.0).toDouble();
    double aitVat = (carDetails['aitVat'] ?? 0.0).toDouble();

    if (baseFare == 0 && totalPaid > 0) {
      baseFare = totalPaid / 1.15;
      tax = totalPaid - baseFare;
    }

    String carBrand = carDetails['carBrand'] ?? carDetails['brand'] ?? '';
    String carModel = carDetails['carModel'] ?? carDetails['model'] ?? '';
    String carType = carDetails['carType'] ?? carDetails['types'] ?? '';

    if (carBrand.isEmpty && title.contains(' ')) {
      final titleParts = title.replaceAll(' Rental', '').split(' ');
      if (titleParts.length >= 2) {
        carBrand = titleParts[0];
        carModel = titleParts.sublist(1).join(' ');
      }
    }

    return CarTicketData(
      bookingReference: carDetails['bookingReference'] ?? bookingId,
      status: status,
      carBrand: carBrand,
      carModel: carModel,
      carType: carType,
      pickupLocation: carDetails['pickupLocation'] ?? subtitle.split(',').first.trim(),
      returnLocation: carDetails['returnLocation'] ?? '',
      pickupDate: carDetails['pickupDate'] != null
          ? DateTime.parse(carDetails['pickupDate'])
          : bookingDate,
      returnDate: carDetails['returnDate'] != null
          ? DateTime.parse(carDetails['returnDate'])
          : null,
      pickupTime: carDetails['pickupTime'] ?? '10:00 am',
      returnTime: carDetails['returnTime'],
      isRoundTrip: carDetails['isRoundTrip'] ?? false,
      days: carDetails['days'] ?? 1,
      baseFare: baseFare,
      tax: tax,
      aitVat: aitVat,
      total: totalPaid,
      paymentMethod: carDetails['paymentMethod'] ?? '',
      isFromMyBookings: true,
    );
  }

  // Convert to FlightTicketData for Flight Ticket Display
  FlightTicketData toFlightTicketData() {
    final flightDetails = ticketData;

    final totalPaid = double.tryParse(
        totalAmount.replaceAll(RegExp(r'[^\d.]'), '')
    ) ?? 0.0;

    double baseFare = (flightDetails['baseFare'] ?? 0.0).toDouble();
    double taxes = (flightDetails['taxes'] ?? 0.0).toDouble();
    double otherCharges = (flightDetails['otherCharges'] ?? 0.0).toDouble();

    if (baseFare == 0 && totalPaid > 0) {
      baseFare = totalPaid / 1.15;
      taxes = (totalPaid - baseFare) * 0.8;
      otherCharges = (totalPaid - baseFare) * 0.2;
    }

    DateTime departureDate = bookingDate;
    DateTime arrivalDate = bookingDate.add(const Duration(hours: 2));

    try {
      if (flightDetails['departureTime'] != null) {
        departureDate = DateTime.parse(flightDetails['departureTime']);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Invalid departureTime format: $e');
      }

    }

    try {
      if (flightDetails['arrivalTime'] != null) {
        arrivalDate = DateTime.parse(flightDetails['arrivalTime']);
      }
    } catch (e) {
      arrivalDate = departureDate.add(const Duration(hours: 2));
    }

    String passengerBreakdown = '1 Adult';
    if (flightDetails['passengers'] != null && flightDetails['passengers'] is List) {
      final passengers = flightDetails['passengers'] as List;
      passengerBreakdown = '${passengers.length} Passenger${passengers.length > 1 ? "s" : ""}';
    } else if (flightDetails['travelers'] != null) {
      final travelers = flightDetails['travelers'];
      passengerBreakdown = '$travelers Passenger${travelers > 1 ? "s" : ""}';
    }

    return FlightTicketData(
      bookingReference: flightDetails['bookingReference'] ??
          flightDetails['bookingId'] ??
          bookingId,
      pnr: flightDetails['pnr'] ?? '',
      status: status,
      airline: flightDetails['airline'] ?? subtitle.split('+').first.trim(),
      flightNumber: flightDetails['flightNumber'] ?? 'N/A',
      from: flightDetails['from'] ?? subtitle.split(',').first.trim(),
      fromCode: flightDetails['fromCode'] ?? '',
      to: flightDetails['to'] ?? title.split(' ').first,
      toCode: flightDetails['toCode'] ?? '',
      departureDate: departureDate,
      departureTime: flightDetails['departureTime']?.split(' ').last ?? '00:00',
      arrivalDate: arrivalDate,
      arrivalTime: flightDetails['arrivalTime']?.split(' ').last ?? '00:00',
      duration: flightDetails['duration'] ?? '2h 0m',
      stops: flightDetails['stops'] ?? 0,
      cabinClass: flightDetails['class'] ?? 'Economy',
      passengerBreakdown: passengerBreakdown,
      contactEmail: flightDetails['contactEmail'],
      contactPhone: flightDetails['contactPhone'],
      baseFare: baseFare,
      taxes: taxes,
      otherCharges: otherCharges,
      totalPrice: totalPaid,
      paymentMethod: flightDetails['paymentMethod'] ?? '',
      currencySymbol: flightDetails['currencySymbol'] ?? '\$',
      isFromMyBookings: true,
    );
  }
}

// Tour Ticket Data Model
class TicketData {
  final String bookingReference;
  final String status;
  final String tourTitle;
  final String fromLocation;
  final String toLocation;
  final DateTime tourDate;
  final String startTime;
  final String guestsText;
  final String duration;
  final double subtotal;
  final double tax;
  final double grandTotal;
  final bool isFromMyBookings;

  TicketData({
    required this.bookingReference,
    required this.status,
    required this.tourTitle,
    required this.fromLocation,
    required this.toLocation,
    required this.tourDate,
    required this.startTime,
    required this.guestsText,
    required this.duration,
    required this.subtotal,
    required this.tax,
    required this.grandTotal,
    required this.isFromMyBookings,
  });
}

// Car Ticket Data Model
class CarTicketData {
  final String bookingReference;
  final String status;
  final String carBrand;
  final String carModel;
  final String carType;
  final String pickupLocation;
  final String returnLocation;
  final DateTime pickupDate;
  final DateTime? returnDate;
  final String pickupTime;
  final String? returnTime;
  final bool isRoundTrip;
  final int days;
  final double baseFare;
  final double tax;
  final double aitVat;
  final double total;
  final String paymentMethod;
  final bool isFromMyBookings;

  CarTicketData({
    required this.bookingReference,
    required this.status,
    required this.carBrand,
    required this.carModel,
    required this.carType,
    required this.pickupLocation,
    required this.returnLocation,
    required this.pickupDate,
    this.returnDate,
    required this.pickupTime,
    this.returnTime,
    required this.isRoundTrip,
    required this.days,
    required this.baseFare,
    required this.tax,
    required this.aitVat,
    required this.total,
    required this.paymentMethod,
    required this.isFromMyBookings,
  });
}

// Hotel Ticket Data Model
class HotelTicketData {
  final String bookingReference;
  final String status;
  final String hotelName;
  final String location;
  final String address;
  final String imageUrl;
  final double rating;
  final int reviews;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int nights;
  final int rooms;
  final int guests;
  final String roomClass;
  final double basePrice;
  final double discount;
  final double tax;
  final double serviceFee;
  final double totalPrice;
  final String paymentMethod;
  final List<String> amenities;
  final bool isFromMyBookings;

  HotelTicketData({
    required this.bookingReference,
    required this.status,
    required this.hotelName,
    required this.location,
    required this.address,
    required this.imageUrl,
    required this.rating,
    required this.reviews,
    required this.checkInDate,
    required this.checkOutDate,
    required this.nights,
    required this.rooms,
    required this.guests,
    required this.roomClass,
    required this.basePrice,
    required this.discount,
    required this.tax,
    required this.serviceFee,
    required this.totalPrice,
    required this.paymentMethod,
    required this.amenities,
    required this.isFromMyBookings,
  });
}

// Flight Ticket Data Model
class FlightTicketData {
  final String bookingReference;
  final String pnr;
  final String status;
  final String airline;
  final String flightNumber;
  final String from;
  final String fromCode;
  final String to;
  final String toCode;
  final DateTime departureDate;
  final String departureTime;
  final DateTime arrivalDate;
  final String arrivalTime;
  final String duration;
  final int stops;
  final String cabinClass;
  final String passengerBreakdown;
  final String? contactEmail;
  final String? contactPhone;
  final double baseFare;
  final double taxes;
  final double otherCharges;
  final double totalPrice;
  final String paymentMethod;
  final String currencySymbol;
  final bool isFromMyBookings;

  FlightTicketData({
    required this.bookingReference,
    required this.pnr,
    required this.status,
    required this.airline,
    required this.flightNumber,
    required this.from,
    required this.fromCode,
    required this.to,
    required this.toCode,
    required this.departureDate,
    required this.departureTime,
    required this.arrivalDate,
    required this.arrivalTime,
    required this.duration,
    required this.stops,
    required this.cabinClass,
    required this.passengerBreakdown,
    this.contactEmail,
    this.contactPhone,
    required this.baseFare,
    required this.taxes,
    required this.otherCharges,
    required this.totalPrice,
    required this.paymentMethod,
    required this.currencySymbol,
    required this.isFromMyBookings,
  });
}