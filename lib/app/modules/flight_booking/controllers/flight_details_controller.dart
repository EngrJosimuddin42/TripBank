import 'package:flutter/material.dart';
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

  // Passenger breakdown
  int _adults = 1;
  int _children = 0;
  int _infants = 0;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    if (args is Map) {
      selectedFlight.value = args['flight'] as Flight?;
      isRoundTrip.value = args['isRoundTrip'] ?? false;
      totalPassengers.value = args['totalPassengers'] ?? 1;

      //  Passenger breakdown
      _adults = args['adults'] ?? 1;
      _children = args['children'] ?? 0;
      _infants = args['infants'] ?? 0;
    } else if (args is Flight) {
      selectedFlight.value = args;
      isRoundTrip.value = false;

      try {
        final bookingController = Get.find<FlightBookingController>();
        totalPassengers.value = bookingController.totalPassengers;
        isRoundTrip.value = bookingController.selectedTripType.value == 'Round Way';

        // Breakdown
        _adults = bookingController.adults.value;
        _children = bookingController.children.value;
        _infants = bookingController.infants.value;

      } catch (e) {
        totalPassengers.value = 1;
        _adults = 1;
        _children = 0;
        _infants = 0;
      }
    }

    if (selectedFlight.value == null) {
      Future.delayed(Duration.zero, () {
        SnackbarHelper.showError(
            'No flight data found. Redirecting back...',
            title: 'Data Missing'
        );
        Get.back();
      });
    }
  }

  //  Book Flight Method
  void bookFlight() {
    if (selectedFlight.value == null) {
      SnackbarHelper.showError(
          'Please select a flight to proceed with the booking.',
          title: 'No Flight Selected'
      );
      return;
    }

    try {
      FlightBookingController bookingController;
      if (Get.isRegistered<FlightBookingController>()) {
        bookingController = Get.find<FlightBookingController>();
      } else {
        bookingController = Get.put(
          FlightBookingController(),
          permanent: true,
        );
      }

      // Flight data set
      bookingController.selectedFlight.value = selectedFlight.value;

      // breakdown set
      bookingController.adults.value = _adults;
      bookingController.children.value = _children;
      bookingController.infants.value = _infants;


      // Navigate with arguments
      Get.toNamed('/passenger-details', arguments: {
        'flight': selectedFlight.value,
        'isRoundTrip': isRoundTrip.value,
        'totalPassengers': totalPassengers.value,
      });

    } catch (e) {
      SnackbarHelper.showError(
          'Failed to proceed with booking. Please try again.',
          title: 'Booking Error'
      );
    }
  }

  // Calculate total (Round trip support )
  double calculateTotal() {
    final flight = selectedFlight.value;
    if (flight == null) return 0.0;
    final passengers = totalPassengers.value;

    // Departure flight
    double total = (flight.price + flight.taxAmount + flight.vatAmount + flight.otherCharges) * passengers;

    //  Return flight add  (if round trip)
    if (isRoundTrip.value && flight.returnDepartureTime != null) {
      total += (flight.price + flight.taxAmount + flight.vatAmount + flight.otherCharges) * passengers;
    }

    return total;
  }

  // Get breakdown details with Round Trip support
  Map<String, double> getPriceBreakdown() {
    final passengers = totalPassengers.value;
    final flight = selectedFlight.value;

    if (flight == null) {
      return {'baseFare': 0.0, 'taxes': 0.0, 'vat': 0.0, 'otherCharges': 0.0, 'total': 0.0};
    }

    double baseFare = flight.price * passengers;
    double taxes = flight.taxAmount * passengers;
    double vat = flight.vatAmount * passengers;
    double otherCharges = flight.otherCharges * passengers;

    // Round trip
    if (isRoundTrip.value && flight.returnDepartureTime != null) {
      baseFare *= 2;
      taxes *= 2;
      vat *= 2;
      otherCharges *= 2;
    }

    return {
      'baseFare': baseFare,
      'taxes': taxes,
      'vat': vat,
      'otherCharges': otherCharges,
      'total': baseFare + taxes + vat + otherCharges,
    };
  }

  void toggleFareDetails() => showFareDetails.toggle();

  String formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '$day ${months[date.month - 1]}, ${date.year}';
  }

  String formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  void reset() {
    selectedFlight.value = null;
    showFareDetails.value = false;
    isRoundTrip.value = false;
  }
}