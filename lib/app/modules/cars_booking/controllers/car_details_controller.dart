import 'package:get/get.dart';
import '../../../models/car_model.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/snackbar_helper.dart';

class CarDetailsController extends GetxController {
  // UI State
  final isFareDetailsExpanded = true.obs;

  // Car and Trip Details
  final selectedCar = Rx<Car?>(null);
  final pickupDate = Rx<DateTime?>(null);
  final returnDate = Rx<DateTime?>(null);
  final tripType = 'One Way'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCarFromArguments();
  }

  /// Load car and trip details from navigation arguments
  void _loadCarFromArguments() {
    final args = Get.arguments;
    if (args == null) {
      _handleMissingArguments();
      return;
    }

    if (args is Car) {
      selectedCar.value = args;
      pickupDate.value = DateTime.now();
    } else if (args is Map<String, dynamic>) {
      selectedCar.value = args['car'] as Car?;
      pickupDate.value = args['pickupDate'] as DateTime?;
      returnDate.value = args['returnDate'] as DateTime?;
      tripType.value = args['tripType'] as String? ?? 'One Way';
    }

    // Validate loaded data
    if (selectedCar.value == null) {
      _handleMissingArguments();
    }
  }

  /// Handle missing or invalid arguments
  void _handleMissingArguments() {
    SnackbarHelper.showError(
        'Car details not found. Please select a car again.',
        title: 'Missing Information'
    );
    Future.delayed(const Duration(milliseconds: 500), () {
      Get.back();
    });
  }

  /// Calculate total booking days
  int calculateBookingDays() {
    if (pickupDate.value == null) return 1;

    if (tripType.value == 'Round Way' && returnDate.value != null) {
      final days = returnDate.value!.difference(pickupDate.value!).inDays;
      return days <= 0 ? 1 : days + 1;
    }

    return 1;
  }

  /// Calculate total amount
  double calculateTotalAmount() => getPriceBreakdown()['total'] ?? 0.0;

  /// Get complete price breakdown
  Map<String, double> getPriceBreakdown() {
    final car = selectedCar.value;

    if (car == null) {
      return _getEmptyBreakdown();
    }

    final days = calculateBookingDays();
    final pricePerDay = car.pricePerDay;
    final baseFare = pricePerDay * days;
    final tax = baseFare * 0.15; // 15% tax
    final aitVat = 0.0;
    final otherCharges = 0.0;
    final total = baseFare + tax + aitVat + otherCharges;

    return {
      'baseFare': baseFare,
      'tax': tax,
      'aitVat': aitVat,
      'otherCharges': otherCharges,
      'total': total,
      'days': days.toDouble(),
      'pricePerDay': pricePerDay,
    };
  }

  /// Get empty price breakdown
  Map<String, double> _getEmptyBreakdown() {
    return {
      'baseFare': 0.0,
      'tax': 0.0,
      'aitVat': 0.0,
      'otherCharges': 0.0,
      'total': 0.0,
      'days': 1.0,
      'pricePerDay': 0.0,
    };
  }

  /// Navigate to payment screen
  void proceedToPayment() {
    final car = selectedCar.value;

    if (car == null) {
      SnackbarHelper.showWarning(
          'Please choose a car before proceeding to payment.',
          title: 'No Car Selected'
      );
      return;
    }

    final breakdown = getPriceBreakdown();

    Get.toNamed(
      Routes.makePayment,
      arguments: {
        'car': car,
        'pickupDate': pickupDate.value,
        'returnDate': returnDate.value,
        'tripType': tripType.value,
        'priceBreakdown': breakdown,
      },
    );
  }

  /// Toggle fare details expansion
  void toggleFareDetails() => isFareDetailsExpanded.toggle();
}