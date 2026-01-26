import 'package:get/get.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import '../../../constants/app_strings.dart';
import '../../../models/booking_model.dart';
import '../../../models/flight_model.dart';
import '../../../utils/booking_helper.dart';
import '../../../widgets/airport_search_dialog.dart';
import '../../../widgets/snackbar_helper.dart';
import '../../my_bookings/controllers/my_bookings_controller.dart';
import 'flight_search_controller.dart';

class FlightBookingController extends GetxController {

  // Trip type
  final selectedTripType = AppStrings.oneWay.obs;
  final tripTypes = [AppStrings.oneWay, AppStrings.roundWay, AppStrings.multiWay];

  // Departure Flight Locations
  final departureFromLocation = ''.obs;
  final departureFromCode = ''.obs;
  final departureToLocation = ''.obs;
  final departureToCode = ''.obs;
  var isLoading = false.obs;

  // Return Flight Locations
  final returnFromLocation = ''.obs;
  final returnFromCode = ''.obs;
  final returnToLocation = ''.obs;
  final returnToCode = ''.obs;

  // Dates
  final departureDate = Rx<DateTime?>(null);
  final returnDate = Rx<DateTime?>(null);

  // Passengers
  final adults = 1.obs;
  final children = 0.obs;
  final infants = 0.obs;
  final selectedTitle = 'MR.'.obs;

  // Class
  final selectedClass = 'Economy'.obs;

  // Dynamic class list getter
  List<String> get classes {
    try {
      final searchController = Get.find<FlightSearchController>();
      if (searchController.availableClasses.isEmpty) {
        return ['Economy', 'Business'];
      }
      return searchController.availableClasses
          .map((FlightClass c) => c.name)
          .toList();
    } catch (e) {
      return ['Economy', 'Business'];
    }
  }

  // Time preferences
  final timeOptions = ['Early morning', 'Morning', 'Afternoon', 'Evening'];
  final departurePreferredTimes = <String>[].obs;
  final returnPreferredTimes = <String>[].obs;
  final departureSelectedTimeSlots = <String>[].obs;
  final returnSelectedTimeSlots = <String>[].obs;

  // Passenger Details
  final passengers = <Passenger>[].obs;
  final contactEmail = ''.obs;
  final contactPhone = ''.obs;
  final RxMap<String, String> passengerData = <String, String>{}.obs;

  // Multi-way flights
  final multiWayFlights = <MultiWayFlight>[].obs;


  // Selected flight (from details page)
  final selectedFlight = Rxn<Flight>();
  var isFromSaved = false.obs;

  // Payment Methods
  final selectedPaymentMethod = ''.obs;
  final paymentMethods = [
    {'name': 'PayPal', 'icon': 'assets/images/paypal.png'},
    {'name': 'Stripe', 'icon': 'assets/images/stripe.png'},
    {'name': 'Paystack', 'icon': 'assets/images/paystack.png'},
    {'name': 'Coinbase Commerce', 'icon': 'assets/images/coinbase.png'},
  ];


  void proceedFromExplore() {
    if (isFromSaved.value && selectedFlight.value != null) {
      Get.toNamed('/flight-details', arguments: selectedFlight.value);
      isFromSaved.value = false;
    }
  }


  @override
  void onClose() {
    isFromSaved.value = false;
    super.onClose();
  }

  // Booking
  final currentBooking = Rxn<Booking>();

  @override
  void onInit() {
    super.onInit();
    departureDate.value = DateTime.now().add(const Duration(days: 1));


    // Multi-way initial flight
    multiWayFlights.add(MultiWayFlight(
      fromLocation: '',
      fromCode: '',
      toLocation: '',
      toCode: '',
      date: DateTime.now().add(const Duration(days: 7)),
      selectedTimeSlots: [],
    ));
  }

  // Multi-way flight management - UPDATED METHOD
  void updateMultiWayFlight(int index, {
    String? fromLocation,
    String? fromCode,
    String? toLocation,
    String? toCode,
    DateTime? date,
    String? preferredTime,
    List<String>? selectedTimeSlots,
  }) {
    if (index >= 0 && index < multiWayFlights.length) {
      final flight = multiWayFlights[index];
      multiWayFlights[index] = MultiWayFlight(
        fromLocation: fromLocation ?? flight.fromLocation,
        fromCode: fromCode ?? flight.fromCode,
        toLocation: toLocation ?? flight.toLocation,
        toCode: toCode ?? flight.toCode,
        date: date ?? flight.date,
        preferredTime: preferredTime ?? flight.preferredTime,
        selectedTimeSlots: selectedTimeSlots ?? flight.selectedTimeSlots,
      );
      multiWayFlights.refresh();
    }
  }

  void updateMultiWayFlightTime(int index, String time) {
    if (index < multiWayFlights.length) {
      final flight = multiWayFlights[index];
      updateMultiWayFlight(index, preferredTime: time);
    }
  }

  void removeMultiWayFlight(int index) {
    if (multiWayFlights.length > 1) multiWayFlights.removeAt(index);
  }

  void addMultiWayFlight() {
    if (multiWayFlights.length < 6) {
      multiWayFlights.add(MultiWayFlight(
        fromLocation: '',
        fromCode: '',
        toLocation: '',
        toCode: '',
        date: DateTime.now().add(const Duration(days: 7)),
        selectedTimeSlots: [],
      ));
    }
  }

  void swapMultiWayLocations(int index) {
    final flight = multiWayFlights[index];
    multiWayFlights[index] = MultiWayFlight(
      fromLocation: flight.toLocation,
      fromCode: flight.toCode,
      toLocation: flight.fromLocation,
      toCode: flight.fromCode,
      date: flight.date,
      preferredTime: flight.preferredTime,
      selectedTimeSlots: flight.selectedTimeSlots,
    );
    multiWayFlights.refresh();
  }

  // Passenger management
  void addPassenger({
    required String title,
    required String firstName,
    required String lastName,
    required DateTime dateOfBirth,
    required String passportNumber,
    required String type,
    String? email,
    String? phone,
  }) {
    passengers.add(Passenger(
      title: title,
      firstName: firstName,
      lastName: lastName,
      dateOfBirth: dateOfBirth,
      passportNumber: passportNumber,
      type: type,
      email: email,
      phone: phone,
    ));
  }

  void clearPassengers() {
    passengers.clear();
  }

  int get totalPassengers => adults.value + children.value + infants.value;

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

    passengers.add(Passenger(
      title: title,
      firstName: firstName,
      lastName: lastName,
      dateOfBirth: DateTime.parse(dateOfBirth),
      passportNumber: passport,
      type: 'Adult',
      nin: nin,
      email: email,
      phone: mobile,
    ));

    contactEmail.value = email;
    contactPhone.value = mobile;
  }

  String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }


  //  Swap Departure Locations

  void swapDepartureLocations() {
    final temp = departureFromLocation.value;
    departureFromLocation.value = departureToLocation.value;
    departureToLocation.value = temp;
    final tempCode = departureFromCode.value;
    departureFromCode.value = departureToCode.value;
    departureToCode.value = tempCode;
    if (selectedTripType.value == 'Round Way') {
      final tempReturn = returnFromLocation.value;
      returnFromLocation.value = returnToLocation.value;
      returnToLocation.value = tempReturn;

      final tempReturnCode = returnFromCode.value;
      returnFromCode.value = returnToCode.value;
      returnToCode.value = tempReturnCode;
    }
  }

  void swapReturnLocations() {
    final temp = returnFromLocation.value;
    returnFromLocation.value = returnToLocation.value;
    returnToLocation.value = temp;
    final tempCode = returnFromCode.value;
    returnFromCode.value = returnToCode.value;
    returnToCode.value = tempCode;
  }

  // Trip type
  void updateTripType(String type) {
    selectedTripType.value = type;

    if (type == AppStrings.oneWay || type == AppStrings.multiWay) {
      returnDate.value = null;
    } else if (type == AppStrings.roundWay) {
      // Round Way select  automatically return locations fill
      if (departureFromLocation.value.isNotEmpty && departureToLocation.value.isNotEmpty) {
        returnFromLocation.value = departureToLocation.value;
        returnFromCode.value = departureToCode.value;
        returnToLocation.value = departureFromLocation.value;
        returnToCode.value = departureFromCode.value;
      }
    }
  }

  // Passenger counters
  void incrementAdults() => adults.value < 9 ? adults.value++ : null;
  void decrementAdults() => adults.value > 1 ? adults.value-- : null;
  void incrementChildren() => children.value < 9 ? children.value++ : null;
  void decrementChildren() => children.value > 0 ? children.value-- : null;
  void incrementInfants() => infants.value < adults.value ? infants.value++ : null;
  void decrementInfants() => infants.value > 0 ? infants.value-- : null;

  void bookFlight(Flight flight) {
    selectedFlight.value = flight;
    Get.toNamed('/passenger-details', arguments: {'flight': flight});
  }

  void continueToPayment() {
    if (passengers.isEmpty) {
      SnackbarHelper.showWarning(
          'Please add at least one passenger detail to continue.',
          title: 'Missing Details'
      );
      return;
    }
    Get.toNamed('/payment', arguments: {
      'flight': selectedFlight.value,
      'passengers': passengers.toList(),
      'contactEmail': contactEmail.value,
      'contactPhone': contactPhone.value,
    });
  }



  Future<void> makePayment() async {
    if (selectedPaymentMethod.value.isEmpty) {
      if (Get.isDialogOpen ?? false) Get.back();
      SnackbarHelper.showWarning(
          'Please select a payment method to complete your booking.',
          title: 'Payment Method Required'
      );
      return;
    }

    if (selectedFlight.value == null && Get.arguments != null) {
      if (Get.arguments is Map) {
        final args = Get.arguments as Map;
        if (args['flight'] != null) {
          selectedFlight.value = args['flight'] as Flight;
        }
        if (args['passengers'] != null && passengers.isEmpty) {
          passengers.value = List<Passenger>.from(args['passengers']);
        }
      }
    }

    final flight = selectedFlight.value;
    if (flight == null) {
      if (Get.isDialogOpen ?? false) Get.back();
      SnackbarHelper.showError(
          'Flight data lost. Please search again.',
          title: 'Data Unavailable'
      );
      return;
    }

    // Processing Simulation
    await Future.delayed(const Duration(seconds: 3));

    try {
      final totalPrice = calculateTotalPrice();
      final pnr = _generatePNR();

      // Create Booking object
      currentBooking.value = Booking(
        bookingId: 'BK${DateTime.now().millisecondsSinceEpoch}',
        flight: flight,
        passengers: passengers.toList(),
        totalPrice: totalPrice,
        bookingDate: DateTime.now(),
        status: 'Confirmed',
        pnr: pnr,
        paymentMethod: selectedPaymentMethod.value,
        baseFare: flight.price * totalPassengers,
        taxes: flight.taxAmount * totalPassengers,
        otherCharges: flight.otherCharges * totalPassengers,
      );

      // Dynamic imageUrl
      String dynamicImageUrl = (flight.imageUrl != null && flight.imageUrl!.isNotEmpty)
          ? flight.imageUrl!
          : 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=400';

      // MyBookingsController check
      MyBookingsController myBookingsController;
      if (Get.isRegistered<MyBookingsController>()) {
        myBookingsController = Get.find<MyBookingsController>();
      } else {
        myBookingsController = Get.put(
          MyBookingsController(),
          permanent: true,
        );
      }

      // Use BookingHelper
      final bookingToSave = BookingHelper.createFlightBooking(
        destination: flight.to,
        country: _extractCountry(flight.to),
        startDate: flight.departureTime,
        endDate: flight.arrivalTime,
        totalPrice: totalPrice,
        travelers: totalPassengers,
        airline: flight.airline,
        flightClass: flight.cabinClass,
        imageUrl: dynamicImageUrl,
        flightDetails: {
          'flightNumber': flight.flightNumber,
          'from': flight.from,
          'fromCode': flight.fromCode,
          'to': flight.to,
          'toCode': flight.toCode,
          'departureTime': formatTime(flight.departureTime),
          'arrivalTime': formatTime(flight.arrivalTime),
          'duration': flight.duration,
          'stops': flight.stops,
          'stopDetails': flight.stopDetails,
          'baggageAllowance': flight.baggageAllowance,
          'isRefundable': flight.isRefundable,
          'availableSeats': flight.availableSeats,
          'facilities': flight.facilities,
          'pnr': pnr,
          'paymentMethod': selectedPaymentMethod.value,
          'passengers': passengers.map((p) => p.toJson()).toList(),
          'bookingId': currentBooking.value!.bookingId,
          'currencySymbol': flight.currencySymbol,

          // Round trip data
          if (flight.returnDepartureTime != null)
            'returnDepartureTime': formatTime(flight.returnDepartureTime!),
          if (flight.returnArrivalTime != null)
            'returnArrivalTime': formatTime(flight.returnArrivalTime!),
          if (flight.returnDuration != null)
            'returnDuration': flight.returnDuration,
          if (flight.returnStops != null)
            'returnStops': flight.returnStops,
        },
      );

      myBookingsController.addBooking(bookingToSave);
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      await Future.delayed(const Duration(milliseconds: 500));
      Get.offAllNamed('/ticket');
    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      await Future.delayed(const Duration(milliseconds: 300));
      SnackbarHelper.showError(
          'We couldn\'t complete your booking at this moment. Please try again or contact support.',
          title: 'Booking Failed'
      );
    }
  }

  // Calculate total price (Dynamic based)
  double calculateTotalPrice() {
    final flight = selectedFlight.value;
    if (flight == null) return 0.0;

    // Base fare for all passengers
    final baseFare = flight.price * totalPassengers;

    // Taxes for all passengers
    final taxes = flight.taxAmount * totalPassengers;

    // VAT for all passengers
    final vat = flight.vatAmount * totalPassengers;

    // Other charges for all passengers
    final otherCharges = flight.otherCharges * totalPassengers;

    return baseFare + taxes + vat + otherCharges;
  }


  String getPassengerBreakdown() {
    List<String> parts = [];

    if (adults.value > 0) {
      parts.add('${adults.value} Adult${adults.value > 1 ? 's' : ''}');
    }

    if (children.value > 0) {
      parts.add('${children.value} Child${children.value > 1 ? 'ren' : ''}');
    }

    if (infants.value > 0) {
      parts.add('${infants.value} Infant${infants.value > 1 ? 's' : ''}');
    }

    return parts.join(', ');
  }


  String _generatePNR() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(6, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
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

  // LOCATION SELECTION
  Future<void> selectLocation({
    required bool isFrom,
    required bool isMultiWay,
    bool? isDeparture,
    int? flightIndex,
  }) async {
    final Airport? selectedAirport = await Get.dialog<Airport>(
      const AirportSearchDialog(),
      barrierDismissible: true,
    );
    if (selectedAirport == null) {
      return;
    }

    // Update location based on trip type
    if (isMultiWay) {
      // Multi-way flight
      if (flightIndex != null) {
        if (isFrom) {
          updateMultiWayFlight(
            flightIndex,
            fromLocation: selectedAirport.city,
            fromCode: selectedAirport.code,
          );
        } else {
          updateMultiWayFlight(
            flightIndex,
            toLocation: selectedAirport.city,
            toCode: selectedAirport.code,
          );
        }
      }
    } else {
      // One Way or Round Way
      if (isDeparture == true) {
        // Departure flight
        if (isFrom) {
          departureFromLocation.value = selectedAirport.city;
          departureFromCode.value = selectedAirport.code;

          //  Round Trip automatically Return
          if (selectedTripType.value == 'Round Way') {
            returnToLocation.value = selectedAirport.city;
            returnToCode.value = selectedAirport.code;
          }
        } else {
          departureToLocation.value = selectedAirport.city;
          departureToCode.value = selectedAirport.code;

          //  Round Trip  automatically Return FROM
          if (selectedTripType.value == 'Round Way') {
            returnFromLocation.value = selectedAirport.city;
            returnFromCode.value = selectedAirport.code;
          }
        }
      } else {
        // Return flight
        if (isFrom) {
          returnFromLocation.value = selectedAirport.city;
          returnFromCode.value = selectedAirport.code;
        } else {
          returnToLocation.value = selectedAirport.city;
          returnToCode.value = selectedAirport.code;
        }
      }
    }
  }

  String _extractCountry(String location) {
    // Common city to country mapping
    final cityCountryMap = {
      'Dubai': 'UAE',
      'London': 'UK',
      'New York': 'USA',
      'Paris': 'France',
      'Tokyo': 'Japan',
      'Singapore': 'Singapore',
      'Bangkok': 'Thailand',
      'Istanbul': 'Turkey',
      'Doha': 'Qatar',
      'Abuja': 'Nigeria',
      'Lagos': 'Nigeria',
      'Dhaka': 'Bangladesh',
      'Delhi': 'India',
      'Mumbai': 'India',
    };

    return cityCountryMap[location] ?? 'International';
  }

}

