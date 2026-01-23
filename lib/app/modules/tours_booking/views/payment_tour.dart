import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/app_strings.dart';
import '../controllers/tours_booking_controller.dart';

class PaymentTourView extends GetView<ToursBookingController> {
  const PaymentTourView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: PreferredSize(
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                      ),
                      Text(
                        AppStrings.makePayment,
                        style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
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
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [

                  // Payment Methods Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Payment Methods List
                        _buildPaymentOption('PayPal', 'assets/images/paypal.png'),
                        _buildPaymentOption('Stripe', 'assets/images/stripe.png'),
                        _buildPaymentOption('Paystack', 'assets/images/paystack.png'),
                        _buildPaymentOption('Coinbase Commerce', 'assets/images/coinbase.png'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Coupon Code Section
                  Center(
                    child: Container(
                      width: 360,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0B2),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
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

                          // Apply Button
                          ElevatedButton(
                            onPressed: () {
                              Get.snackbar(
                                AppStrings.coupon,
                                AppStrings.couponAppliedSuccess,
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
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          //  Bottom Fixed Section (Total + Buttons)
          Container(
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
            child: Obx(() {
              final totalAmount = controller.calculateTotalAmount();

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.total,
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
                          onPressed: () {
                            controller.resetPaymentSelection();
                            Get.back();
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFFECD08)),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            AppStrings.back,
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
                          onPressed: () {
                            if (controller.selectedPaymentMethod.value.isEmpty) {
                              Get.snackbar(
                                AppStrings.error,
                                AppStrings.pleaseSelectPaymentMethod,
                                backgroundColor: Colors.red[100],
                                colorText: Colors.red[800],
                                snackPosition: SnackPosition.BOTTOM,
                              );
                              return;
                            }

                            controller.confirmBooking();

                            Future.delayed(const Duration(milliseconds: 800), () {
                              _showSuccessDialog();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFECD08),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            AppStrings.confirm,
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
                  const SizedBox(height: 80),
                ],
              );
            }),
          ),
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

  void _showSuccessDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: const Color(0xFFFFFFFF),
        child: SizedBox(
          width: 400,
          height: 500,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFFED739).withValues(alpha: 0.6),
                        const Color(0xFFFED739).withValues(alpha: 0.3),
                      ],
                      stops: const [0.0, 0.3],
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFED739),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                Text(
                  AppStrings.congratulations,
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),

                Text(
                  AppStrings.bookingSuccessTourMessage,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      Get.toNamed('/tour-ticket');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFECD08),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: Text(
                      AppStrings.viewETicket,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Get.back();
                      Get.offAllNamed('/home');
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      side: const BorderSide(color: Color(0xFFFECD08), width: 2),
                    ),
                    child: Text(
                      AppStrings.goToHome,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}