import 'package:get/get.dart';
import '../../../models/flight_model.dart';
import '../../../widgets/snackbar_helper.dart';
import 'flight_booking_controller.dart';
import 'flight_search_controller.dart';

class FlightDetailsController extends GetxController {
  final FlightSearchController searchController = Get.find<FlightSearchController>();

  final selectedFlight = Rxn<Flight>();
  final isRoundTrip = false.obs;
  final totalPassengers = 1.obs;
  final showFareDetails = false.obs;
  final selectedClass = 'Economy'.obs;
  String get passengerSummary => "$_adults Adults, $_children Children, $_infants Infants";

  // Private passenger breakdown
  int _adults = 1;
  int _children = 0;
  int _infants = 0;

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  void _initializeData() {
    final args = Get.arguments;

    if (Get.isRegistered<FlightBookingController>()) {
      final booking = Get.find<FlightBookingController>();
      selectedClass.value = booking.selectedClass.value;
      totalPassengers.value = booking.totalPassengers;
      isRoundTrip.value = booking.selectedTripType.value.contains('Round');
      _adults = booking.adults.value;
      _children = booking.children.value;
      _infants = booking.infants.value;
    }

    if (args != null) {
      if (args is Map) {
        selectedFlight.value = args['flight'];
        isRoundTrip.value = args['isRoundTrip'] ?? isRoundTrip.value;
        totalPassengers.value = args['totalPassengers'] ?? totalPassengers.value;
        if (args['cabinClass'] != null) selectedClass.value = args['cabinClass'];
      } else if (args is Flight) {
        selectedFlight.value = args;
        if (args.cabinClass.isNotEmpty) selectedClass.value = args.cabinClass;
      }
    }

    if (selectedFlight.value == null) {
      _handleMissingData();
    }
  }

  void _handleMissingData() {
    Future.delayed(Duration.zero, () {
      SnackbarHelper.showError('No flight details available.');
      if (Get.key.currentState?.canPop() ?? false) {
        Get.back();
      } else {
        Get.offAllNamed('/home');
      }
    });
  }

  double get classMultiplier {
    final String c = selectedClass.value.toLowerCase();
    if (c.contains('business')) return 2.5;
    if (c.contains('first')) return 4.0;
    if (c.contains('premium')) return 1.5;
    return 1.0;
  }

  Map<String, double> getPriceBreakdown() {
    final flight = selectedFlight.value;
    if (flight == null) return {'total': 0.0};
    final int tripFactor = (isRoundTrip.value && flight.returnDepartureTime != null) ? 2 : 1;
    final int pCount = totalPassengers.value;


    double baseFare = (flight.price * classMultiplier) * pCount * tripFactor;
    double taxes = flight.taxAmount * pCount * tripFactor;
    double vat = flight.vatAmount * pCount * tripFactor;
    double other = flight.otherCharges * pCount * tripFactor;

    return {
      'baseFare': baseFare,
      'taxes': taxes,
      'vat': vat,
      'otherCharges': other,
      'total': baseFare + taxes + vat + other,
    };
  }

  void bookFlight() {
    final flight = selectedFlight.value;
    if (flight == null) return;

    final bookingController = Get.isRegistered<FlightBookingController>()
        ? Get.find<FlightBookingController>()
        : Get.put(FlightBookingController(), permanent: true);
    bookingController.selectedFlight.value = flight;
    bookingController.selectedClass.value = selectedClass.value;

    bookingController.adults.value = _adults;
    bookingController.children.value = _children;
    bookingController.infants.value = _infants;

    Get.toNamed('/passenger-details', arguments: {
      'flight': flight,
      'isRoundTrip': isRoundTrip.value,
      'totalPassengers': totalPassengers.value,
      'cabinClass': selectedClass.value,
      'adults': _adults,
      'children': _children,
      'infants': _infants,
    });
  }

  void toggleFareDetails() => showFareDetails.toggle();

  String formatDate(DateTime date) =>
      "${date.day.toString().padLeft(2, '0')} ${_getMonth(date.month)}, ${date.year}";

  String _getMonth(int m) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    if (m < 1 || m > 12) return 'Jan';
    return months[m - 1];
  }

  String formatTime(DateTime time) {
    final String hour = (time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour)).toString();
    final String min = time.minute.toString().padLeft(2, '0');
    final String period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$min $period';
  }
}