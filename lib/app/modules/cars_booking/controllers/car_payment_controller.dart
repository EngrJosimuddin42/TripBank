import 'package:get/get.dart';
import '../../../models/car_model.dart';
import '../../../utils/booking_helper.dart';
import '../../../widgets/snackbar_helper.dart';
import '../../my_bookings/controllers/my_bookings_controller.dart';

class CarPaymentController extends GetxController {
  // Payment State
  final selectedPaymentMethod = ''.obs;
  final couponCode = ''.obs;
  final isCouponApplied = false.obs;
  final discountAmount = 0.0.obs;

  // Booking Data
  final selectedCar = Rx<Car?>(null);
  final pickupDate = Rx<DateTime?>(null);
  final returnDate = Rx<DateTime?>(null);
  final tripType = 'One Way'.obs;
  final priceBreakdown = <String, double>{}.obs;

  // Contact Info
  final contactEmail = ''.obs;
  final contactPhone = ''.obs;

  // Payment Methods with icons
  final paymentMethods = [
    {'name': 'PayPal', 'icon': 'assets/images/paypal.png'},
    {'name': 'Stripe', 'icon': 'assets/images/stripe.png'},
    {'name': 'Paystack', 'icon': 'assets/images/paystack.png'},
    {'name': 'Coinbase Commerce', 'icon': 'assets/images/coinbase.png'},
  ];

  @override
  void onInit() {
    super.onInit();
    _loadBookingData();
  }

  void _loadBookingData() {
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      selectedCar.value = args['car'] as Car?;
      pickupDate.value = args['pickupDate'] as DateTime?;
      returnDate.value = args['returnDate'] as DateTime?;
      tripType.value = args['tripType'] as String? ?? 'One Way';
      priceBreakdown.value = args['priceBreakdown'] as Map<String, double>? ?? {};
    }
  }

  void selectPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  Future<void> applyCoupon(String code) async {
    if (code.isEmpty) {
      SnackbarHelper.showWarning(
          'Please enter a coupon code to get a discount.',
          title: 'Empty Code'
      );
      return;
    }

    couponCode.value = code;
    isCouponApplied.value = true;
    discountAmount.value = calculateTotalAmount() * 0.1;

    SnackbarHelper.showSuccess(
        'Coupon applied! You saved \$${discountAmount.value.toStringAsFixed(2)}',
        title: 'Coupon Applied'
    );
  }

  void removeCoupon() {
    couponCode.value = '';
    isCouponApplied.value = false;
    discountAmount.value = 0.0;
  }

  double calculateTotalAmount() {
    final total = priceBreakdown['total'] ?? 0.0;
    return total - discountAmount.value;
  }

  Future<void> confirmPayment() async {
    if (selectedPaymentMethod.value.isEmpty) {
      SnackbarHelper.showWarning(
          'Please select how you would like to pay to continue.',
          title: 'Payment Method Required'
      );
      return;
    }

    if (selectedCar.value == null) {
      SnackbarHelper.showError(
          'Something went wrong. No car was selected for this booking.',
          title: 'Selection Error'
      );
      return;
    }

    final car = selectedCar.value!;
    final breakdown = priceBreakdown;
    final days = breakdown['days']?.toInt() ?? 1;
    final total = calculateTotalAmount();

    final dynamicImageUrl = car.imageUrl.isNotEmpty
        ? car.imageUrl
        : 'https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?w=400';

    //  USE BookingHelper
    final bookingToSave = BookingHelper.createCarBooking(
      carModel: '${car.brand} ${car.model}',
      pickupLocation: 'Abuja',
      country: 'Nigeria',
      pickupDate: pickupDate.value ?? DateTime.now(),
      returnDate: returnDate.value ?? DateTime.now().add(Duration(days: days)),
      totalPrice: total,
      passengers: 1,
      imageUrl: dynamicImageUrl,
      carDetails: {
        'carId': car.id,
        'brand': car.brand,
        'model': car.model,
        'year': car.year,
        'types': car.types,
        'seats': car.seats,
        'bags': car.bags,
        'doors': car.doors,
        'transmission': car.transmission,
        'rating': car.rating,
        'reviews': car.reviews,
        'pricePerDay': car.pricePerDay,
        'extras': car.extras,
        'days': days,
        'baseFare': breakdown['baseFare'] ?? 0.0,
        'tax': breakdown['tax'] ?? 0.0,
        'aitVat': breakdown['aitVat'] ?? 0.0,
        'otherCharges': breakdown['otherCharges'] ?? 0.0,
        'paymentMethod': selectedPaymentMethod.value,
        'contactEmail': contactEmail.value.isEmpty ? 'user@example.com' : contactEmail.value,
        'contactPhone': contactPhone.value.isEmpty ? '+1234567890' : contactPhone.value,
        'bookingId': 'CB-${DateTime.now().millisecondsSinceEpoch}',
        if (isCouponApplied.value) 'couponCode': couponCode.value,
        if (isCouponApplied.value) 'discount': discountAmount.value,
      },
    );

    // Save to My Bookings
    Get.find<MyBookingsController>().addBooking(bookingToSave);

    SnackbarHelper.showSuccess(
        'Your booking has been confirmed successfully!',
        title: 'Booking Confirmed'
    );

    // Navigate to ticket screen
    await Future.delayed(const Duration(milliseconds: 800));

    // Create local booking for ticket display
    final booking = _createLocalBooking();
    Get.offNamed('/car-ticket', arguments: {'booking': booking});
  }

  // Create local booking for ticket display
  CarBooking _createLocalBooking() {
    final car = selectedCar.value!;
    final breakdown = priceBreakdown;

    return CarBooking(
      bookingId: 'CB-${DateTime.now().millisecondsSinceEpoch}',
      car: car,
      pickupDate: pickupDate.value ?? DateTime.now(),
      returnDate: returnDate.value,
      pickupLocation: 'Abuja',
      pickupLocationCode: 'ABJ',
      dropoffLocation: 'London',
      dropoffLocationCode: 'LHR',
      tripType: tripType.value,
      totalDays: breakdown['days']?.toInt() ?? 1,
      baseFare: breakdown['baseFare'] ?? 0.0,
      tax: breakdown['tax'] ?? 0.0,
      aitVat: breakdown['aitVat'] ?? 0.0,
      otherCharges: breakdown['otherCharges'] ?? 0.0,
      totalAmount: calculateTotalAmount(),
      paymentMethod: selectedPaymentMethod.value,
      contactEmail: contactEmail.value.isEmpty ? 'user@example.com' : contactEmail.value,
      contactPhone: contactPhone.value.isEmpty ? '+1234567890' : contactPhone.value,
      status: 'Confirmed',
    );
  }
}