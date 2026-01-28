import '../models/booking_model.dart';

class BookingHelper {
  static BookingSummary createFlightBooking({
    required String destination,
    required String country,
    required DateTime startDate,
    required DateTime endDate,
    required double totalPrice,
    required int travelers,
    String? airline,
    String? flightClass,
    String? imageUrl,
    Map<String, dynamic>? flightDetails,
  }) {
    final days = endDate.difference(startDate).inDays;
    final subtitle = airline != null
        ? '$airline${flightClass != null ? " + $flightClass Class" : ""}'
        : '$destination, $country';

    return BookingSummary(
      bookingId: 'TB-${DateTime.now().millisecondsSinceEpoch}',
      type: 'Flight',
      title: '$destination ${_getTripType(days)}',
      subtitle: subtitle,
      dates: '${startDate.day}-${endDate.day} ${_getMonth(startDate.month)} ${startDate.year} • $days days',
      totalAmount: '\$${totalPrice.toStringAsFixed(0)}',
      status: 'Confirmed',
      imageUrl: imageUrl ?? getDefaultImage('Flight'),
      bookingDate: DateTime.now(),
      ticketData: {
        'services': ['Flight'],
        'travelers': travelers,
        'destination': destination,
        'country': country,
        if (airline != null) 'airline': airline,
        if (flightClass != null) 'class': flightClass,
        ...?flightDetails,
      },
    );
  }


  static BookingSummary createHotelBooking({
    required String hotelName,
    required String location,
    required String country,
    required DateTime checkIn,
    required DateTime checkOut,
    required double totalPrice,
    required int guests,
    String? imageUrl,
    Map<String, dynamic>? hotelDetails,
  }) {
    final nights = checkOut.difference(checkIn).inDays;

    return BookingSummary(
      bookingId: 'TB-${DateTime.now().millisecondsSinceEpoch}',
      type: 'Hotel',
      title: hotelName,
      subtitle: '$location, $country',
      dates: '${checkIn.day}-${checkOut.day} ${_getMonth(checkIn.month)} ${checkIn.year} • $nights nights',
      totalAmount: '\$${totalPrice.toStringAsFixed(0)}',
      status: 'Confirmed',
      imageUrl: imageUrl ?? getDefaultImage('Hotel'),
      bookingDate: DateTime.now(),
      ticketData: {
        'services': ['Hotel'],
        'travelers': guests,
        'location': location,
        'country': country,
        'nights': nights,
        ...?hotelDetails,
      },
    );
  }


  static BookingSummary createCarBooking({
    required String carModel,
    required String pickupLocation,
    required String country,
    required DateTime pickupDate,
    required DateTime returnDate,
    required double totalPrice,
    required int passengers,
    String? imageUrl,
    Map<String, dynamic>? carDetails,
  }) {
    final days = returnDate.difference(pickupDate).inDays;

    return BookingSummary(
      bookingId: 'TB-${DateTime.now().millisecondsSinceEpoch}',
      type: 'Car',
      title: '$carModel Rental',
      subtitle: '$pickupLocation, $country',
      dates: 'Pickup ${pickupDate.day} ${_getMonth(pickupDate.month)} • $days days',
      totalAmount: '\$${totalPrice.toStringAsFixed(0)}',
      status: 'Confirmed',
      imageUrl: imageUrl ?? getDefaultImage('Car'),
      bookingDate: DateTime.now(),
      ticketData: {
        'services': ['Car'],
        'travelers': passengers,
        'pickupLocation': pickupLocation,
        'country': country,
        'rentalDays': days,
        ...?carDetails,
      },
    );
  }


  static BookingSummary createTourBooking({
    required String tourName,
    required String destination,
    required String country,
    required DateTime startDate,
    required DateTime endDate,
    required double totalPrice,
    required int travelers,
    String? imageUrl,
    Map<String, dynamic>? tourDetails,
  }) {
    final days = endDate.difference(startDate).inDays;

    return BookingSummary(
      bookingId: 'TB-${DateTime.now().millisecondsSinceEpoch}',
      type: 'Tour',
      title: tourName,
      subtitle: '$destination, $country',
      dates: '${startDate.day}-${endDate.day} ${_getMonth(startDate.month)} ${startDate.year} • $days days',
      totalAmount: '\$${totalPrice.toStringAsFixed(0)}',
      status: 'Confirmed',
      imageUrl: imageUrl ?? getDefaultImage('Tour'),
      bookingDate: DateTime.now(),
      ticketData: {
        'services': ['Tour'],
        'travelers': travelers,
        'destination': destination,
        'country': country,
        ...?tourDetails,
      },
    );
  }

  static BookingSummary createPackageBooking({
    required String packageName,
    required String destination,
    required String country,
    required DateTime startDate,
    required DateTime endDate,
    required double totalPrice,
    required int travelers,
    required List<String> services,
    String? imageUrl,
    String? tag,
    Map<String, dynamic>? packageDetails,
  }) {
    final days = endDate.difference(startDate).inDays;

    return BookingSummary(
      bookingId: 'TB-${DateTime.now().millisecondsSinceEpoch}',
      type: services.first,
      title: packageName,
      subtitle: '$destination, $country',
      dates: '${startDate.day}-${endDate.day} ${_getMonth(startDate.month)} ${startDate.year} • $days days',
      totalAmount: '\$${totalPrice.toStringAsFixed(0)}',
      status: 'Confirmed',
      imageUrl: imageUrl ?? getDefaultImage(services.first),
      bookingDate: DateTime.now(),
      ticketData: {
        'services': services,
        'travelers': travelers,
        if (tag != null) 'tag': tag,
        'destination': destination,
        'country': country,
        ...?packageDetails,
      },
    );
  }

  //  Helper Methods

  static String _getMonth(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  static String _getTripType(int days) {
    if (days <= 3) return 'Weekend Trip';
    if (days <= 7) return 'Short Trip';
    if (days <= 14) return 'Vacation';
    return 'Extended Trip';
  }

  /// Default images based on booking type - High quality Unsplash images
  static String getDefaultImage(String type) {
    switch (type.toLowerCase()) {
      case 'flight':
        return 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=800&q=80';
      case 'hotel':
        return 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800&q=80';
      case 'car':
        return 'https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?w=800&q=80';
      case 'tour':
        return 'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=800&q=80';
      default:
        return 'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=800&q=80';
    }
  }

  /// Get destination-specific images (City landmarks)
  static String getDestinationImage(String destination) {
    final destinations = {
      'Dubai': 'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?w=800&q=80',
      'Tokyo': 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=800&q=80',
      'Paris': 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=800&q=80',
      'New York': 'https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=800&q=80',
      'Bali': 'https://images.unsplash.com/photo-1537996194471-e657df975ab4?w=800&q=80',
      'London': 'https://images.unsplash.com/photo-1513635269975-59663e0ac1ad?w=800&q=80',
      'Singapore': 'https://images.unsplash.com/photo-1525625293386-3f8f99389edd?w=800&q=80',
      'Bangkok': 'https://images.unsplash.com/photo-1508009603885-50cf7c579365?w=800&q=80',
    };

    return destinations[destination] ?? getDefaultImage('flight');
  }

  /// Get Flight-specific images (Airplanes)
  static String getFlightImage(String destination) {
    final normalizedDest = destination.trim();
    final flightImages = {
      'Dubai': 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=800&q=80',
      'Tokyo': 'https://images.unsplash.com/photo-1464037866556-6812c9d1c72e?w=800&q=80',
      'Paris': 'https://images.unsplash.com/photo-1583939003579-730e3918a45a?w=800&q=80',
      'New York': 'https://images.unsplash.com/photo-1569629743817-70d8db6c323b?w=800&q=80',
      'Bali': 'https://images.unsplash.com/photo-1474302770737-173ee21bab63?w=800&q=80',
      'London': 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=800&q=80',
      'Singapore': 'https://images.unsplash.com/photo-1464037866556-6812c9d1c72e?w=800&q=80',
      'Bangkok': 'https://images.unsplash.com/photo-1583939003579-730e3918a45a?w=800&q=80',
      'Dhaka': 'https://images.unsplash.com/photo-1569629743817-70d8db6c323b?w=800&q=80',
      'Delhi': 'https://images.unsplash.com/photo-1474302770737-173ee21bab63?w=800&q=80',
      'Mumbai': 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=800&q=80',
      'Abuja': 'https://images.unsplash.com/photo-1464037866556-6812c9d1c72e?w=800&q=80',
      'Lagos': 'https://images.unsplash.com/photo-1583939003579-730e3918a45a?w=800&q=80',
    };

    // Try exact match first
    if (flightImages.containsKey(normalizedDest)) {
      return flightImages[normalizedDest]!;
    }
    for (var key in flightImages.keys) {
      if (normalizedDest.contains(key)) {
        return flightImages[key]!;
      }
    }
    return getDefaultImage('flight');
  }

  /// Get Hotel-specific images (Luxury hotels)
  static String getHotelImage(String location) {
    final hotelImages = {
      'Dubai': 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=800&q=80',
      'Tokyo': 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=800&q=80',
      'Paris': 'https://images.unsplash.com/photo-1596394516093-501ba68a0ba6?w=800&q=80',
      'New York': 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?w=800&q=80',
      'Bali': 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=800&q=80',
    };

    return hotelImages[location] ?? getDefaultImage('hotel');
  }
}