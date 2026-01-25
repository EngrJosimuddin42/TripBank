import 'package:get/get.dart';
import '../../../models/car_model.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/snackbar_helper.dart';

class CarDetailsController extends GetxController {

  // UI State

  final isFareDetailsExpanded = true.obs;
  final selectedCar = Rx<Car?>(null);
  final pickupDate = Rx<DateTime?>(null);
  final returnDate = Rx<DateTime?>(null);
  final tripType = 'One Way'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCarFromArguments();
  }

  // Load car and trip details from navigation arguments

  void _loadCarFromArguments() {
    final args = Get.arguments;
    if (args == null) return;
    if (args is Car) {
      selectedCar.value = args;
      pickupDate.value = DateTime.now();
    }
    else if (args is Map<String, dynamic>) {
      selectedCar.value = args['car'] as Car?;
      pickupDate.value = args['pickupDate'] as DateTime?;
      returnDate.value = args['returnDate'] as DateTime?;
      tripType.value = args['tripType'] as String? ?? 'One Way';
    }
  }


  // Calculate total booking days

  int calculateBookingDays() {
    if (pickupDate.value == null) return 1;
    if (tripType.value == 'Round Way' && returnDate.value != null) {
      int days = returnDate.value!.difference(pickupDate.value!).inDays;
      return days <= 0 ? 1 : days + 1;
    }
    return 1;
  }

  // Calculate total amount

  double calculateTotalAmount() {
    final breakdown = getPriceBreakdown();
    return breakdown['total']!;
  }

  // Get complete price breakdown

  Map<String, double> getPriceBreakdown() {
    if (selectedCar.value == null) {
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

    final days = calculateBookingDays();
    final pricePerDay = selectedCar.value!.pricePerDay;
    final baseFare = pricePerDay * days;
    final tax = baseFare * 0.15;
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

  // Navigate to payment screen

  void proceedToPayment() {
    if (selectedCar.value == null) {
      SnackbarHelper.showWarning(
          'Please choose a car before proceeding to payment.',
          title: 'No Car Selected'
      );
      return;
    }
    Get.toNamed(Routes.MAKE_PAYMENT, arguments: {
      'car': selectedCar.value,
      'pickupDate': pickupDate.value,
      'returnDate': returnDate.value,
      'tripType': tripType.value,
      'totalAmount': getPriceBreakdown()['total'],
    });
  }

  // Toggle fare details expansion

  void toggleFareDetails() {
    isFareDetailsExpanded.toggle();
  }
}