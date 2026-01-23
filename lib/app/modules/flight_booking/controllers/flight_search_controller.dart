import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_config.dart';
import '../../../constants/app_strings.dart';
import '../../../models/flight_model.dart';
import 'flight_booking_controller.dart';

class FlightSearchController extends GetxController {

  final RxList<String> availableAirlines = <String>[].obs;
  final RxList<FlightClass> availableClasses = <FlightClass>[].obs;
  final RxList<Facility> availableFacilities = <Facility>[].obs;
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  // Search Results
  final searchResults = <Flight>[].obs;
  final allFlights = <Flight>[].obs;
  final isLoadingFlights = false.obs;

  // Filter Options
  final priceRange = RangeValues(
    AppConfig.minPrice,
    AppConfig.maxPrice,
  ).obs;
  final selectedAirlines = <String>[].obs;
  final selectedStops = <String>[].obs;
  final sortBy = 'Cheapest'.obs;
  final maxTravelTime = AppConfig.maxTravelTime.obs;
  final selectedFacilities = <String>[].obs;

  // Time preferences
  final timeOptions = ['Early morning', 'Morning', 'Afternoon', 'Evening'].obs;
  final departurePreferredTimes = <String>[].obs;
  final returnPreferredTimes = <String>[].obs;
  final departureSelectedTimeSlots = <String>[].obs;
  final returnSelectedTimeSlots = <String>[].obs;


  var selectedMaxTravelTime = 30.0.obs;
  var arrivalTimeFilter = ''.obs;

  @override
  void onInit() {
    super.onInit();

    // Load initial data
    loadInitialData();

    // Auto apply filters on sort change
    ever(sortBy, (_) {
      if (searchResults.isNotEmpty) {
        applyFilters();
      }
    });
  }

  // Load initial data (Airlines, Classes, Facilities)
  Future<void> loadInitialData() async {
    try {
      await Future.wait([
        loadAirlines(),
        loadFlightClasses(),
        loadFacilities(),
      ]);
    } catch (e) {
    }
  }

  // Load Airlines
  Future<void> loadAirlines() async {
    try {
      // Dummy data for now
      availableAirlines.value = AppConfig.defaultAirlines;
    } catch (e) {
      availableAirlines.value = AppConfig.defaultAirlines;
    }
  }

  // Load Flight Classes
  Future<void> loadFlightClasses() async {
    try {
      // Dummy:
      availableClasses.value = AppConfig.flightClasses
          .map((e) => FlightClass.fromJson(e))
          .toList();
    } catch (e) {
      availableClasses.value = AppConfig.flightClasses
          .map((e) => FlightClass.fromJson(e))
          .toList();
    }
  }

  // Load Facilities
  Future<void> loadFacilities() async {
    try {
      // Dummy:
      availableFacilities.value = AppConfig.facilities
          .map((e) => Facility.fromJson({...e, 'id': e['name']}))
          .toList();
    } catch (e) {
      availableFacilities.value = AppConfig.facilities
          .map((e) => Facility.fromJson({...e, 'id': e['name']}))
          .toList();
    }
  }

  // Time slot toggle methods
  void toggleDepartureTimeSlot(String timeSlot) {
    departureSelectedTimeSlots.clear();
    departureSelectedTimeSlots.add(timeSlot);

    final category = getTimeCategory(timeSlot);
    departurePreferredTimes.clear();
    departurePreferredTimes.add(category);
  }

  void toggleReturnTimeSlot(String timeSlot) {
    returnSelectedTimeSlots.clear();
    returnSelectedTimeSlots.add(timeSlot);

    final category = getTimeCategory(timeSlot);
    returnPreferredTimes.clear();
    returnPreferredTimes.add(category);
  }

  // Helper method
  String getTimeCategory(String timeSlot) {
    final parts = timeSlot.split(' ');
    final timePart = parts[0];
    final period = parts[1].toLowerCase();

    final hourMinute = timePart.split(':');
    int hour = int.parse(hourMinute[0]);

    if (period == 'pm' && hour != 12) hour += 12;
    if (period == 'am' && hour == 12) hour = 0;

    if (hour >= 0 && hour < 6) return AppStrings.earlyMorning;
    if (hour >= 6 && hour < 12) return AppStrings.morning;
    if (hour >= 12 && hour < 18) return AppStrings.afternoon;
    return AppStrings.evening;
  }

  // Search flights
  Future<void> searchFlights() async {
    isLoadingFlights.value = true;
    try {
      final bookingController = Get.find<FlightBookingController>();
      selectedDate.value = bookingController.departureDate.value;

      await Future.delayed(const Duration(seconds: 2));

      // Dummy data for now
      final flights = _generateDemoFlights();

      allFlights.assignAll(flights);
      searchResults.assignAll(flights);
      Get.toNamed('/search-all-flight');
    } catch (e) {
      Get.snackbar('Error', 'Failed to search flights');
    } finally {
      isLoadingFlights.value = false;
    }
  }

  // Generate demo flights (Development only)
  List<Flight> _generateDemoFlights() {
    final bookingController = Get.find<FlightBookingController>();
    final isRoundTrip = bookingController.selectedTripType.value == 'Round Way';

    final airlines = [
      {'name': 'Singapore Airlines', 'code': 'SQ'},
      {'name': 'Emirates', 'code': 'EK'},
      {'name': 'Qatar Airways', 'code': 'QR'},
      {'name': 'British Airways', 'code': 'BA'},
      {'name': 'Turkish Airlines', 'code': 'TK'},
    ];

    //  Baggage allowance options
    final baggageOptions = [
      '23kg checked + 7kg carry-on',   // Economy
      '30kg checked + 10kg carry-on',  // Premium Economy
      '40kg checked + 12kg carry-on',  // Business
      '50kg checked + 15kg carry-on',  // First Class
    ];

    final List<Flight> flights = [];
    for (int i = 0; i < 12; i++) {
      final airline = airlines[i % airlines.length];
      final basePrice = 800 + (i * 120);
      final stops = i % 4;
      final durationHours = 12 + stops * 3 + (i % 3);

      final departure = selectedDate.value != null
          ? selectedDate.value!.add(Duration(hours: 2 + i))
          : DateTime.now().add(Duration(days: 1, hours: 2 + i));

      final arrival = departure.add(Duration(hours: durationHours));

      final baggageIndex = i % baggageOptions.length;
      final baggage = baggageOptions[baggageIndex];

      //  Return flight data if Round Trip
      DateTime? returnDeparture;
      DateTime? returnArrival;
      String? returnDuration;
      int? returnStops;

      if (isRoundTrip && bookingController.returnDate.value != null) {
        returnDeparture = bookingController.returnDate.value!.add(Duration(hours: 2 + i));
        returnArrival = returnDeparture.add(Duration(hours: durationHours));
        returnDuration = '${durationHours}h ${(i % 60)}m';
        returnStops = stops;
      }


      flights.add(Flight(
        id: 'FL${2000 + i}',
        airline: airline['name']!,
        airlineLogo: 'assets/images/air_france.png',
        flightNumber: '${airline['code']}${400 + i}',
        from: bookingController.departureFromLocation.value.isNotEmpty
            ? bookingController.departureFromLocation.value
            : 'Abuja',
        to: bookingController.departureToLocation.value.isNotEmpty
            ? bookingController.departureToLocation.value
            : 'London',
        fromCode: bookingController.departureFromCode.value.isNotEmpty
            ? bookingController.departureFromCode.value
            : 'ABJ',
        toCode: bookingController.departureToCode.value.isNotEmpty
            ? bookingController.departureToCode.value
            : 'LHR',
        departureTime: departure,
        arrivalTime: arrival,
        duration: '${durationHours}h ${(i % 60)}m',
        stops: stops,
        stopDetails: stops > 0 ? (i % 2 == 0 ? 'DXB' : 'DOH') : null,
        price: basePrice.toDouble(),
        vatAmount: (basePrice * 0.05),
        cabinClass: 'Economy',
        availableSeats: 15 - i,
        isRefundable: i % 3 != 0,
        baggageAllowance: baggage,
        flightType: Flight.getFlightTypeLabel(stops),
        facilities: ['WiFi', 'Meal', 'Entertainment'],

        // Return flight fields
        returnDepartureTime: returnDeparture,
        returnArrivalTime: returnArrival,
        returnDuration: returnDuration,
        returnStops: returnStops,
      ));
    }
    return flights;
  }


  // Apply filters
  void applyFilters() {
    var filtered = allFlights.where((flight) {
      // Price filter
      final inPrice = flight.price >= priceRange.value.start &&
          flight.price <= priceRange.value.end;

      // Stops filter
      bool matchesStops = true;
      if (selectedStops.isNotEmpty) {
        final stopFilter = selectedStops.first;
        if (stopFilter == '0') {
          matchesStops = flight.stops == 0;
        } else if (stopFilter == '1') {
          matchesStops = flight.stops == 1;
        } else {
          matchesStops = flight.stops >= 2;
        }
      }

      // Airline filter
      final matchesAirline = selectedAirlines.isEmpty ||
          selectedAirlines.contains('All') ||
          selectedAirlines.contains(flight.airline);

      // Travel time filter
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
    priceRange.value = RangeValues(AppConfig.minPrice, AppConfig.maxPrice);
    selectedAirlines.clear();
    selectedStops.clear();
    sortBy.value = 'Cheapest';
    maxTravelTime.value = AppConfig.maxTravelTime;
    selectedFacilities.clear();
    searchResults.assignAll(allFlights);
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
}