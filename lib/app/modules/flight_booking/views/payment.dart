import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/flight_booking_controller.dart';
import '../../../models/flight_model.dart';

class PaymentView extends GetView<FlightBookingController> {
  const PaymentView({super.key});

  void _handlePayment() async {

    // Validate payment method
    if (controller.selectedPaymentMethod.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select a payment method',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Loading dialog
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
    await controller.makePayment();
    Get.back();
    Get.toNamed('/payment-confirm', arguments: {
      'flight': controller.selectedFlight.value,
      'passengers': controller.passengers,
      'contactEmail': controller.contactEmail.value,
      'contactPhone': controller.contactPhone.value,
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.arguments != null && Get.arguments is Map) {
        final args = Get.arguments as Map;

        if (args['flight'] != null && controller.selectedFlight.value == null) {
          controller.selectedFlight.value = args['flight'] as Flight;
        }

        if (args['passengers'] != null && controller.passengers.isEmpty) {
          controller.passengers.value = List<Passenger>.from(args['passengers']);
        }

        if (args['contactEmail'] != null) {
          controller.contactEmail.value = args['contactEmail'];
        }

        if (args['contactPhone'] != null) {
          controller.contactPhone.value = args['contactPhone'];
        }
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFFFFAE6),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
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
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                  ),
                  Expanded(
                    child: Text(
                      'Make Payment',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Passenger Summary Section
                  _buildPassengerSummary(),

                  const SizedBox(height: 16),

                  // Payment Methods
                  _buildPaymentMethods(),

                  const SizedBox(height: 16),

                  // Coupon Code Section
                  _buildCouponSection(),

                  const SizedBox(height: 16),

                  // Please Note Section
                  _buildPleaseNoteSection(),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),

          // Bottom Button
          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildPassengerSummary() {
    return Obx(() {
      if (controller.passengers.isEmpty) {
        return const SizedBox.shrink();
      }

      final passenger = controller.passengers.first;
      final isExpanded = false.obs;

      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF9E6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFE6E6E6),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => isExpanded.value = !isExpanded.value,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Account Summary',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Obx(() => Icon(
                    isExpanded.value
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.black,
                    size: 20,
                  )),
                ],
              ),
            ),
            Obx(() {
              if (!isExpanded.value) return const SizedBox.shrink();

              // Format the date (DD-MM-YYYY format)

              final dob = passenger.dateOfBirth;
              final formattedDate = '${dob.day.toString().padLeft(2, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.year}';

              return Column(
                children: [
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    'Name',
                    '${passenger.title} ${passenger.firstName} ${passenger.lastName}',
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow('Date of Birth', formattedDate),
                  const SizedBox(height: 12),
                  _buildInfoRow('Passport Number', passenger.passportNumber),
                  const SizedBox(height: 12),
                  _buildInfoRow('NIN Number', passenger.nin ?? 'N/A'),
                ],
              );
            }),
          ],
        ),
      );
    });
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Payment Method',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),

          // Payment Methods with Assets

          _buildPaymentOption('PayPal', 'assets/images/paypal.png'),
          _buildPaymentOption('Stripe', 'assets/images/stripe.png'),
          _buildPaymentOption('Paystack', 'assets/images/paystack.png'),
          _buildPaymentOption('Coinbase Commerce', 'assets/images/coinbase.png'),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String name, String imagePath) {
    return Obx(() {
      final isSelected = controller.selectedPaymentMethod.value == name;

      return GestureDetector(
        onTap: () => controller.selectedPaymentMethod.value = name,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFFFAE6) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? const Color(0xFFFECD08) : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [

              // Payment method logo from assets

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

                    // Fallback icon if image not load

                    return Icon(
                      Icons.payment,
                      color: _getPaymentColor(name),
                      size: 24,
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  name,
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

  // Coupon Code Section

  Widget _buildCouponSection() {
    final couponController = TextEditingController();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF0B2),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Input Card
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    // Coupon Icon
                    Image.asset(
                      'assets/images/coupon.png',
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback icon
                        return const Icon(
                          Icons.discount,
                          color: Color(0xFFFECD08),
                          size: 24,
                        );
                      },
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter coupon code',
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
            // Apply Button
            ElevatedButton(
              onPressed: () {
                Get.snackbar(
                  'Coupon',
                  'Coupon code applied successfully!',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green[100],
                  colorText: Colors.green[800],
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
                'APPLY',
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
      ),
    );
  }

  Widget _buildPleaseNoteSection() {
    final notes = [
      'The Processing Fee is non-refundable.',
      'In case of flight cancellation & refund policy in case of cancellation, refund policy will be given accordingly.',
      'After the payment is completed, your e-ticket confirmation will be sent via email.',
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFFECD08),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Please Note',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          ...notes.map((note) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      note,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(16),
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
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _handlePayment,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFECD08),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              'Proceed to Payment',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}