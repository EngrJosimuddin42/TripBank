import 'package:get/get.dart';
import '../../../models/booking_model.dart';
import '../../../models/car_model.dart';
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

  // Load booking data from navigation arguments

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

  // PAYMENT METHODS

  void selectPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  // Apply coupon code

  Future<void> applyCoupon(String code) async {
    if (code.isEmpty) {
      SnackbarHelper.showWarning(
          'Please enter a coupon code to get a discount.',
          title: 'Empty Code'
      );      return;
    }

    // Demo: 10% discount

    couponCode.value = code;
    isCouponApplied.value = true;
    discountAmount.value = calculateTotalAmount() * 0.1;

    SnackbarHelper.showSuccess(
        'Coupon applied! You saved \$${discountAmount.value.toStringAsFixed(2)}',
        title: 'Coupon Applied'
    );
  }

  // Remove applied coupon

  void removeCoupon() {
    couponCode.value = '';
    isCouponApplied.value = false;
    discountAmount.value = 0.0;
  }


  // Calculate total amount (with discount if applied)

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
      );      return;
    }
    final booking = _createLocalBooking();

    // Save to My Bookings

    _saveToMyBookings(booking);

    // Show success message

    SnackbarHelper.showSuccess(
        'Your booking for has been confirmed successfully!',
        title: 'Booking Confirmed'
    );

    // Navigate to ticket screen

    await Future.delayed(const Duration(milliseconds: 800));
    Get.offNamed('/car-ticket', arguments: {'booking': booking});
  }

  // Create local booking (Demo)

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

  //Save booking to My Bookings controller

  void _saveToMyBookings(CarBooking booking) {
    final summary = BookingSummary(
      type: 'Car',
      title: '${booking.car.brand} ${booking.car.model} Rental',
      subtitle: '${booking.car.types} • ${booking.car.transmission} • ${booking.car.seats} Seats',
      dates: '${_formatDate(booking.pickupDate)} • ${booking.totalDays} days',
      imageUrl: booking.car.imageUrl ?? 'https://via.placeholder.com/400x300',
      bookingId: booking.bookingId,
      status: booking.status,
      totalAmount: '\$${booking.totalAmount.toStringAsFixed(0)}',
      ticketData: booking.toJson(),
    );

    Get.find<MyBookingsController>().addBooking(summary);
  }

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]}, ${date.year}';
  }
}