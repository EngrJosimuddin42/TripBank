import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/snackbar_helper.dart';
import '../controllers/cars_booking_controller.dart';
import '../../../constants/app_strings.dart';

class MakePaymentView extends GetView<CarsBookingController> {
  MakePaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Trip Summary Card
                  _buildTripSummaryCard(),
                  const SizedBox(height: 20),

                  // Payment Methods Section
                  _buildPaymentMethodsSection(),
                  const SizedBox(height: 20),

                  // Coupon Code Section
                  _buildCouponSection(),
                  const SizedBox(height: 20),

                  // Price Breakdown
                  _buildPriceBreakdown(),
                ],
              ),
            ),
          ),

          // Bottom Section (Total + Buttons)
          _buildBottomSection(),
        ],
      ),
    );
  }

  // APP BAR

  PreferredSize _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(103),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFEDE5A),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                ),
                Text(
                  'Make Payment',
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // TRIP SUMMARY

  Widget _buildTripSummaryCard() {
    return Obx(() {
      final car = controller.selectedCar.value;
      if (car == null) return const SizedBox.shrink();

      final days = controller.calculateBookingDays();
      final isRoundTrip = controller.selectedTripType.value == 'Round Way';

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFFECD08).withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Booking Summary',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),

            // Car Details

            Row(
              children: [
                Icon(Icons.directions_car, size: 20, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${car.brand} ${car.model}',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Rental Duration

            Row(
              children: [
                Icon(Icons.calendar_today, size: 18, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  '$days ${days > 1 ? "days" : "day"} rental',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Trip Type Badge

            Row(
              children: [
                Icon(Icons.swap_horiz, size: 18, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isRoundTrip
                        ? const Color(0xFFE3F2FD)
                        : const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    isRoundTrip ? 'Round Trip' : 'One Way',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isRoundTrip
                          ? const Color(0xFF1976D2)
                          : const Color(0xFFE65100),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // From Location

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.trip_origin, size: 18, color: Colors.green[600]),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'From',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        controller.ArrivingFromLocation.value.isNotEmpty
                            ? controller.ArrivingFromLocation.value
                            : 'Not selected',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (controller.ArrivingDate.value != null)
                        Text(
                          _formatDate(controller.ArrivingDate.value!),
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),

            // Divider arrow

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  const SizedBox(width: 26),
                  Icon(
                    isRoundTrip ? Icons.sync_alt : Icons.arrow_downward,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ),

            // To Location

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on, size: 18, color: Colors.red[600]),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'To',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        controller.ArrivingToLocation.value.isNotEmpty
                            ? controller.ArrivingToLocation.value
                            : 'Not selected',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (isRoundTrip && controller.returnDate.value != null)
                        Text(
                          _formatDate(controller.returnDate.value!),
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),

            // Return Trip Details (Only for Round Trip)

            if (isRoundTrip) ...[
              const SizedBox(height: 12),
              Divider(color: Colors.grey[300]),
              const SizedBox(height: 8),

              // Return Pickup
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.trip_origin, size: 18, color: Colors.green[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Return Pickup',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          controller.ArrivingToLocation.value.isNotEmpty
                              ? controller.ArrivingToLocation.value
                              : 'Same as drop-off',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Divider arrow
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    const SizedBox(width: 26),
                    Icon(
                      Icons.arrow_downward,
                      size: 16,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
              ),

              // Return Drop off
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.location_on, size: 18, color: Colors.red[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Return Drop-off',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          controller.ArrivingFromLocation.value.isNotEmpty
                              ? controller.ArrivingFromLocation.value
                              : 'Same as pickup',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      );
    });
  }

  // Helper method to format date

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }

  //PAYMENT METHODS

  Widget _buildPaymentMethodsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Method',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),

          ...controller.paymentMethods.map((method) {
            return _buildPaymentOption(
              method['name'] as String,
              method['icon'] as String,
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String title, String imagePath) {
    return Obx(() {
      final isSelected = controller.selectedPaymentMethod.value == title;

      return GestureDetector(
        onTap: () {
          controller.selectedPaymentMethod.value = title;
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFFFAE6) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? const Color(0xFFFECD08) : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              // Payment method logo
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.payment,
                      color: _getPaymentColor(title),
                      size: 24,
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              Icon(
                isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                color: isSelected ? const Color(0xFFFECD08) : Colors.grey[400],
                size: 24,
              ),
            ],
          ),
        ),
      );
    });
  }

  Color _getPaymentColor(String name) {
    switch (name) {
      case 'PayPal':
        return const Color(0xFF003087);
      case 'Stripe':
        return const Color(0xFF635BFF);
      case 'Paystack':
        return const Color(0xFF00C3F7);
      case 'Coinbase Commerce':
        return const Color(0xFF0052FF);
      default:
        return Colors.grey;
    }
  }

  // COUPON SECTION

  final _couponController = TextEditingController();

  Widget _buildCouponSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0B2),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.discount,
                    color: Color(0xFFFECD08),
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _couponController,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                      ),
                      decoration: InputDecoration(
                        hintText: AppStrings.enterCouponCode,
                        hintStyle: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w400,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              if (_couponController.text.isEmpty) {
                SnackbarHelper.showWarning(
                    'Please enter a coupon code to receive a discount.',
                    title: 'Input Required'
                );
                return;
              }
              SnackbarHelper.showSuccess(
                  AppStrings.couponAppliedSuccess,
                  title: AppStrings.coupon
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFECD08),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              AppStrings.apply.toUpperCase(),
              style: GoogleFonts.inter(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 13,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // PRICE BREAKDOWN

  Widget _buildPriceBreakdown() {
    return Obx(() {
      final breakdown = controller.getPriceBreakdown();

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Price Breakdown',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),

            _buildPriceRow(
              '${breakdown['days']?.toInt()} x Base fare (\$${breakdown['pricePerDay']?.toStringAsFixed(0)}/day)',
              '\$${breakdown['baseFare']?.toStringAsFixed(2)}',
            ),
            _buildPriceRow(
              'Tax (15%)',
              '\$${breakdown['tax']?.toStringAsFixed(2)}',
            ),

            if (breakdown['aitVat']! > 0)
              _buildPriceRow(
                'AIT & VAT',
                '\$${breakdown['aitVat']?.toStringAsFixed(2)}',
              ),

            if (breakdown['otherCharges']! > 0)
              _buildPriceRow(
                'Other charges',
                '\$${breakdown['otherCharges']?.toStringAsFixed(2)}',
              ),
          ],
        ),
      );
    });
  }

  Widget _buildPriceRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // BOTTOM SECTION

  Widget _buildBottomSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Obx(() {
          final totalAmount = controller.getPriceBreakdown()['total'] ?? 0.0;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '\$${totalAmount.toStringAsFixed(2)}',
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFB49100),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFFECD08)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Back',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF6B5603),
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _confirmPayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFECD08),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Confirm Payment',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF6B5603),
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }

  // PAYMENT CONFIRMATION

  void _confirmPayment() {
    if (controller.selectedPaymentMethod.value.isEmpty) {
      SnackbarHelper.showWarning(
          'Please select a payment method to proceed with your booking.',
          title: 'Payment Method Required'
      );
      return;
    }

    // Validate car selection
    if (controller.selectedCar.value == null) {
      SnackbarHelper.showError(
          'Something went wrong. No car was found in your selection.',
          title: 'Selection Error'
      );
      return;
    }

    // Show success message
    SnackbarHelper.showSuccess(
        'Payment confirmed successfully! Your car is now reserved.',
        title: 'Success'
    );

    // Save booking
    controller.bookCar();

    // Navigate to ticket screen

    Future.delayed(const Duration(milliseconds: 800), () {
      Get.offNamed('/car-ticket');
    });
  }
}