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
      imageUrl: imageUrl ?? 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=400',
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
      imageUrl: imageUrl ?? 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400',
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
      imageUrl: imageUrl ?? 'https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?w=400',
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
      imageUrl: imageUrl ?? 'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=400',
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
      imageUrl: imageUrl ?? 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=400',
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

  /// Default images based on booking type
  static String getDefaultImage(String type) {
    switch (type.toLowerCase()) {
      case 'flight':
        return 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=400';
      case 'hotel':
        return 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400';
      case 'car':
        return 'https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?w=400';
      case 'tour':
        return 'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=400';
      default:
        return 'https://images.unsplash.com/photo-1488646953014-85cb44e25888?w=400';
    }
  }
}