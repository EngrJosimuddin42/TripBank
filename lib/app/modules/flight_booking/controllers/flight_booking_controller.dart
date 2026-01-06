import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';
import '../../../models/flight_model.dart';

class FlightBookingController extends GetxController {
  // Trip type
  final selectedTripType = 'One Way'.obs;
  final tripTypes = ['One Way', 'Round Way', 'Multi Way'];

  // Departure Flight Locations
  final departureFromLocation = 'Abuja'.obs;
  final departureFromCode = 'ABJ'.obs;
  final departureToLocation = 'London'.obs;
  final departureToCode = 'LHR'.obs;

  // Return Flight Locations
  final returnFromLocation = 'London'.obs;
  final returnFromCode = 'LGW'.obs;
  final returnToLocation = 'Abuja'.obs;
  final returnToCode = 'ABJ'.obs;

  // Dates
  final departureDate = Rx<DateTime?>(null);
  final returnDate = Rx<DateTime?>(null);

  // Passengers
  final adults = 1.obs;
  final children = 0.obs;
  final infants = 0.obs;

  // Class
  final selectedClass = 'Economy'.obs;
  final classes = ['Economy', 'Premium Economy', 'Business', 'First Class'];

  // Time preferences
  final timeOptions = ['Early morning', 'Morning', 'Afternoon', 'Evening'];
  final departurePreferredTimes = <String>[].obs;
  final returnPreferredTimes = <String>[].obs;
  final departureSelectedTimeSlots = <String>[].obs;
  final returnSelectedTimeSlots = <String>[].obs;

  // Search Results
  final searchResults = <Flight>[].obs;
  final allFlights = <Flight>[].obs;
  final isLoadingFlights = false.obs;
  final selectedFlight = Rx<Flight?>(null);

  // Filter Options
  final priceRange = const RangeValues(0, 5000).obs;
  final selectedAirlines = <String>[].obs;
  final selectedStops = <String>[].obs;
  final sortBy = 'Cheapest'.obs;
  final maxTravelTime = 30.0.obs;
  final selectedFacilities = <String>[].obs;

  // Passenger Details
  final passengers = <Passenger>[].obs;
  final contactEmail = ''.obs;
  final contactPhone = ''.obs;
  final RxMap<String, String> passengerData = <String, String>{}.obs;
  final multiWayFlights = <MultiWayFlight>[].obs;

  // Payment
  final selectedPaymentMethod = ''.obs;
  final paymentMethods = [
    {'name': 'PayPal', 'icon': 'Credit Card'},
    {'name': 'Stripe', 'icon': 'Credit Card'},
    {'name': 'Payoneer', 'icon': 'Credit Card'},
    {'name': 'Coinbase Commerce', 'icon': 'Crypto'},
  ];

  // Booking
  final currentBooking = Rx<Booking?>(null);

  @override
  void onInit() {
    super.onInit();
    departureDate.value = DateTime.now().add(const Duration(days: 1));

    // Initialize with one multi-way flight
    multiWayFlights.add(MultiWayFlight(
      fromLocation: 'Abuja',
      fromCode: 'ABJ',
      toLocation: 'London',
      toCode: 'LHR',
      date: DateTime.now().add(const Duration(days: 1)),
    ));

    // Set up reactive listener for sortBy changes
    ever(sortBy, (_) {
      if (searchResults.isNotEmpty) {
        applyFilters();
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
  }

  // Multi-way flight management
  void addMultiWayFlight() {
    if (multiWayFlights.length < 5) {
      multiWayFlights.add(MultiWayFlight(
        fromLocation: multiWayFlights.last.toLocation,
        fromCode: multiWayFlights.last.toCode,
        toLocation: 'Dubai',
        toCode: 'DXB',
        date: multiWayFlights.last.date.add(const Duration(days: 1)),
      ));
    }
  }

  void removeMultiWayFlight(int index) {
    if (multiWayFlights.length > 1) {
      multiWayFlights.removeAt(index);
    }
  }

  void updateMultiWayFlight(int index, {
    String? fromLocation,
    String? fromCode,
    String? toLocation,
    String? toCode,
    DateTime? date,
  }) {
    final flight = multiWayFlights[index];
    multiWayFlights[index] = MultiWayFlight(
      fromLocation: fromLocation ?? flight.fromLocation,
      fromCode: fromCode ?? flight.fromCode,
      toLocation: toLocation ?? flight.toLocation,
      toCode: toCode ?? flight.toCode,
      date: date ?? flight.date,
    );
  }

  void swapMultiWayLocations(int index) {
    final flight = multiWayFlights[index];
    multiWayFlights[index] = MultiWayFlight(
      fromLocation: flight.toLocation,
      fromCode: flight.toCode,
      toLocation: flight.fromLocation,
      toCode: flight.fromCode,
      date: flight.date,
    );
  }

  // Save passenger data
  void savePassengerData({
    required String title,
    required String firstName,
    required String lastName,
    required String dateOfBirth,
    required String mobile,
    required String email,
    required String nin,
    required String passport,
  }) {
    passengerData.value = {
      'name': '$title $firstName $lastName',
      'dateOfBirth': dateOfBirth,
      'mobile': mobile,
      'email': email,
      'nin': nin,
      'passport': passport,
    };
  }

  // Swap departure locations
  void swapDepartureLocations() {
    final tempLocation = departureFromLocation.value;
    final tempCode = departureFromCode.value;
    departureFromLocation.value = departureToLocation.value;
    departureFromCode.value = departureToCode.value;
    departureToLocation.value = tempLocation;
    departureToCode.value = tempCode;
  }

  // Swap return locations
  void swapReturnLocations() {
    final tempLocation = returnFromLocation.value;
    final tempCode = returnFromCode.value;
    returnFromLocation.value = returnToLocation.value;
    returnFromCode.value = returnToCode.value;
    returnToLocation.value = tempLocation;
    returnToCode.value = tempCode;
  }

  // Update trip type
  void updateTripType(String type) {
    selectedTripType.value = type;
    if (type == 'One Way' || type == 'Multi Way') {
      returnDate.value = null;
    }
  }

  // Passenger controls
  void incrementAdults() => adults.value < 9 ? adults.value++ : null;
  void decrementAdults() => adults.value > 1 ? adults.value-- : null;
  void incrementChildren() => children.value < 9 ? children.value++ : null;
  void decrementChildren() => children.value > 0 ? children.value-- : null;
  void incrementInfants() => infants.value < adults.value ? infants.value++ : null;
  void decrementInfants() => infants.value > 0 ? infants.value-- : null;

  // Total passengers
  int get totalPassengers => adults.value + children.value + infants.value;

  // Search flights
  Future<void> searchFlights() async {
    if (departureFromCode.value == departureToCode.value) {
      Get.snackbar('Invalid Route', 'From and To cannot be the same');
      return;
    }
    if (departureDate.value == null) {
      Get.snackbar('Date Required', 'Please select departure date');
      return;
    }
    if (selectedTripType.value == 'Round Way' &&
        (returnDate.value == null || returnDate.value!.isBefore(departureDate.value!))) {
      Get.snackbar('Invalid Return Date', 'Return date must be after departure');
      return;
    }

    isLoadingFlights.value = true;
    try {
      await Future.delayed(const Duration(seconds: 2));
      final flights = _generateDemoFlights();
      allFlights.assignAll(flights);
      searchResults.assignAll(flights);
      Get.toNamed('/flight-results');
    } catch (e) {
      Get.snackbar('Error', 'Failed to search flights');
    } finally {
      isLoadingFlights.value = false;
    }
  }

  String _getTimeCategory(String timeSlot) {
    final parts = timeSlot.split(' ');
    final timePart = parts[0];
    final period = parts[1];

    final hourMinute = timePart.split(':');
    int hour = int.parse(hourMinute[0]);

    if (period == 'pm' && hour != 12) hour += 12;
    if (period == 'am' && hour == 12) hour = 0;

    if (hour >= 0 && hour < 6) {
      return 'Early morning';
    } else if (hour >= 6 && hour < 12) {
      return 'Morning';
    } else if (hour >= 12 && hour < 18) {
      return 'Afternoon';
    } else {
      return 'Evening';
    }
  }

  void toggleDepartureTimeSlot(String timeSlot) {
    departureSelectedTimeSlots.clear();
    departureSelectedTimeSlots.add(timeSlot);

    final category = _getTimeCategory(timeSlot);
    departurePreferredTimes.clear();
    departurePreferredTimes.add(category);
  }

  void toggleReturnTimeSlot(String timeSlot) {
    returnSelectedTimeSlots.clear();
    returnSelectedTimeSlots.add(timeSlot);

    final category = _getTimeCategory(timeSlot);
    returnPreferredTimes.clear();
    returnPreferredTimes.add(category);
  }

  // Generate demo flights
  List<Flight> _generateDemoFlights() {
    final airlines = [
      {'name': 'Singapore Airlines', 'code': 'SQ'},
      {'name': 'Emirates', 'code': 'EK'},
      {'name': 'Qatar Airways', 'code': 'QR'},
      {'name': 'British Airways', 'code': 'BA'},
      {'name': 'Turkish Airlines', 'code': 'TK'},
    ];

    final List<Flight> flights = [];
    for (int i = 0; i < 12; i++) {
      final airline = airlines[i % airlines.length];
      final basePrice = 800 + (i * 120);
      final stops = i % 4;
      final durationHours = 12 + stops * 3 + (i % 3);

      flights.add(Flight(
        id: 'FL${2000 + i}',
        airline: airline['name']!,
        airlineLogo: 'Airplane',
        flightNumber: '${airline['code']}${400 + i}',
        from: departureFromLocation.value,
        to: departureToLocation.value,
        fromCode: departureFromCode.value,
        toCode: departureToCode.value,
        departureTime: departureDate.value!.add(Duration(hours: 2 + i)),
        arrivalTime: departureDate.value!.add(Duration(hours: durationHours)),
        duration: '${durationHours}h ${(i % 60)}m',
        stops: stops,
        stopDetails: stops > 0 ? ['DXB', 'DOH'][i % 2] : null,
        price: basePrice.toDouble(),
        cabinClass: selectedClass.value,
        availableSeats: 15 - i,
        isRefundable: i % 3 != 0,
        baggageAllowance: '30kg checked + 7kg carry-on',
      ));
    }
    return flights;
  }

  // Select flight
  void selectFlight(Flight flight) {
    selectedFlight.value = flight;
    Get.toNamed('/flight-details');
  }

  // Book flight
  void bookFlight() {
    if (selectedFlight.value == null) {
      Get.snackbar('Error', 'No flight selected');
      return;
    }
    Get.toNamed('/passenger-details');
  }

  // Continue to payment
  void continueToPayment() {
    if (passengers.length != totalPassengers) {
      Get.snackbar('Incomplete', 'Please fill details for all passengers');
      return;
    }
    if (contactEmail.value.isEmpty || !GetUtils.isEmail(contactEmail.value)) {
      Get.snackbar('Invalid Email', 'Enter a valid email');
      return;
    }
    if (contactPhone.value.isEmpty || contactPhone.value.length < 10) {
      Get.snackbar('Invalid Phone', 'Enter a valid phone number');
      return;
    }
    Get.toNamed('/payment');
  }

  // Make payment
  Future<void> makePayment() async {
    if (selectedPaymentMethod.value.isEmpty) {
      Get.snackbar('Required', 'Please select payment method');
      return;
    }

    Get.dialog(
      const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: Color(0xFFFECD08)),
                SizedBox(height: 24),
                Text('Processing Payment...', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );

    await Future.delayed(const Duration(seconds: 3));

    final flight = selectedFlight.value;
    if (flight == null) {
      Get.back();
      Get.snackbar('Error', 'Flight not found');
      return;
    }

    final totalPrice = flight.price * totalPassengers * 1.15;

    currentBooking.value = Booking(
      bookingId: 'BK${DateTime.now().millisecondsSinceEpoch}',
      flight: flight,
      passengers: passengers.toList(),
      totalPrice: totalPrice,
      bookingDate: DateTime.now(),
      status: 'Confirmed',
      pnr: 'TP${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
    );

    Get.back();
    Get.snackbar('Success!', 'Booking confirmed!');
    Get.offAllNamed('/booking-success');
  }

  // Apply filters
  void applyFilters() {
    var filtered = allFlights.where((flight) {
      final inPrice = flight.price >= priceRange.value.start &&
          flight.price <= priceRange.value.end;

      bool matchesStops = true;
      if (selectedStops.isNotEmpty) {
        final stopFilter = selectedStops.first;
        if (stopFilter == '0') {
          matchesStops = flight.stops == 0;
        } else if (stopFilter == '1') {
          matchesStops = flight.stops >= 1;
        } else {
          matchesStops = flight.stops >= 2;
        }
      }

      final matchesAirline = selectedAirlines.isEmpty ||
          selectedAirlines.contains(flight.airline);

      final durationParts = flight.duration.split('h');
      final hours = int.tryParse(durationParts[0].trim()) ?? 0;
      final matchesTravelTime = hours <= maxTravelTime.value;

      return inPrice && matchesStops && matchesAirline && matchesTravelTime;
    }).toList();

    _sortFlights(filtered);
    searchResults.assignAll(filtered);
    Get.back();
  }

  // Reset filters
  void resetFilters() {
    priceRange.value = const RangeValues(0, 5000);
    selectedAirlines.clear();
    selectedStops.clear();
    sortBy.value = 'Cheapest';
    maxTravelTime.value = 30.0;
    selectedFacilities.clear();
    searchResults.assignAll(allFlights);
    Get.back();
  }

  // Sort flights
  void _sortFlights(List<Flight> flights) {
    switch (sortBy.value) {
      case 'Cheapest':
        flights.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Fastest':
        flights.sort((a, b) => a.duration.compareTo(b.duration));
        break;
      case 'Earliest':
        flights.sort((a, b) => a.departureTime.compareTo(b.departureTime));
        break;
      case 'Latest':
        flights.sort((a, b) => b.departureTime.compareTo(a.departureTime));
        break;
    }
  }

  // Format helpers
  String formatDate(DateTime? date) {
    if (date == null) return '------';
    final day = date.day.toString().padLeft(2, '0');
    final month = _getMonthName(date.month);
    final year = date.year;
    final weekday = _getWeekdayName(date.weekday);
    return '$day $month $year • $weekday';
  }

  String formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  String _getWeekdayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  // Reset booking
  void resetBooking() {
    selectedFlight.value = null;
    passengers.clear();
    contactEmail.value = '';
    contactPhone.value = '';
    selectedPaymentMethod.value = '';
    currentBooking.value = null;
  }
}

// MultiWayFlight model class
class MultiWayFlight {
  final String fromLocation;
  final String fromCode;
  final String toLocation;
  final String toCode;
  final DateTime date;

  MultiWayFlight({
    required this.fromLocation,
    required this.fromCode,
    required this.toLocation,
    required this.toCode,
    required this.date,
  });
}