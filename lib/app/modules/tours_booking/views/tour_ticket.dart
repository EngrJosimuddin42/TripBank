import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../constants/app_strings.dart';
import '../../profile/controllers/profile_controller.dart';
import '../controllers/tours_booking_controller.dart';

class TourTicketView extends GetView<ToursBookingController> {
  const TourTicketView({super.key});

  @override
  Widget build(BuildContext context) {

    final profileController = Get.find<ProfileController>();

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
                        AppStrings.ticket,
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
      body: Obx(() {
        final tour = controller.bookedTour.value;
        if (tour == null) {
          return Center(child: Text(AppStrings.noBookingFound));
        }

        final totalAmount = controller.calculateTotalAmount();
        final taxAmount = controller.calculateTax();
        final grandTotal = controller.calculateGrandTotal();
        final selectedDate = controller.selectedDate.value;

        // DYNAMIC user data from ProfileController

        final passengerName = profileController.userName.value ?? "Guest User";
        final passengerEmail = profileController.userEmail.value ?? "email@example.com";
        final passengerPhone = profileController.userPhone.value ?? "Not provided";

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [

                      // 1. Booking Reference

                      _buildInfoSection(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppStrings.bookingReference, style: _labelStyle()),
                                Text(
                                  controller.bookingReference.value.isNotEmpty
                                      ? controller.bookingReference.value
                                      : 'TB-${DateTime.now().millisecondsSinceEpoch}',
                                  style: _valueStyle(),
                                ),
                              ],
                            ),
                            _buildStatusBadge(AppStrings.confirmed),
                          ],
                        ),
                      ),

                      // 2. Tour Title & Details

                      _buildInfoSection(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tour.title, style: _valueStyle(fontSize: 20)),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                _buildDetailItem(
                                  AppStrings.from,
                                  tour.location,
                                  Icons.location_on_outlined,
                                ),
                                _buildDetailItem(
                                  AppStrings.to,
                                  tour.destination ??
                                      tour.visitingPlaces?.join(', ') ??
                                      AppStrings.tourDestinations,
                                  Icons.map_outlined,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                _buildDetailItem(
                                  AppStrings.date,
                                  selectedDate != null
                                      ? DateFormat('dd MMM, yyyy').format(selectedDate)
                                      : AppStrings.notSpecified,
                                  Icons.calendar_today_outlined,
                                ),
                                _buildDetailItem(
                                  AppStrings.time,
                                  tour.startTime ?? '09:00 AM',
                                  Icons.access_time,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                _buildDetailItem(
                                  AppStrings.guests,
                                  '${controller.adultsCount.value} ${AppStrings.adults}'
                                      '${controller.childrenCount.value > 0 ? ", ${controller.childrenCount.value} ${AppStrings.children}" : ""}',
                                  Icons.people_outline,
                                ),
                                _buildDetailItem(
                                  AppStrings.duration,
                                  tour.duration,
                                  Icons.timer_outlined,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // 3. Passenger Information

                      _buildInfoSection(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppStrings.passengerInformation, style: _valueStyle(fontSize: 14)),
                            const SizedBox(height: 12),
                            _buildIconText(Icons.person_outline, passengerName),
                            const SizedBox(height: 8),
                            _buildIconText(Icons.email_outlined, passengerEmail),
                            const SizedBox(height: 8),
                            _buildIconText(Icons.phone_outlined, passengerPhone),
                          ],
                        ),
                      ),

                      // 4. Payment Details

                      _buildInfoSection(
                        isLast: true,
                        child: Column(
                          children: [
                            _buildPriceRow(AppStrings.subtotal, '\$${totalAmount.toStringAsFixed(2)}'),
                            const SizedBox(height: 8),
                            _buildPriceRow(AppStrings.taxesAndFees, '\$${taxAmount.toStringAsFixed(2)}'),
                            const Divider(height: 32),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(AppStrings.totalPaid, style: _valueStyle(fontSize: 16)),
                                Text(
                                  '\$${grandTotal.toStringAsFixed(2)}',
                                  style: GoogleFonts.inter(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF0052FF),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Buttons

            _buildBottomButtons(),
          ],
        );
      }),
    );
  }

  Widget _buildInfoSection({required Widget child, bool isLast = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: isLast ? null : const Border(bottom: BorderSide(color: Color(0xFFE0E0E0))),
      ),
      child: Column(
        children: [
          child,
          if (!isLast) ...[
            const SizedBox(height: 20),
            Text('------------------------------------------',
              style: TextStyle(color: Colors.blue.shade100, letterSpacing: 2),
              overflow: TextOverflow.clip,
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: _labelStyle()),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(icon, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Flexible(child: Text(value, style: _valueStyle(fontSize: 13))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.green),
      ),
    );
  }

  Widget _buildIconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text(text, style: _labelStyle(color: Colors.black87)),
      ],
    );
  }

  Widget _buildPriceRow(String label, String price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: _labelStyle()),
        Text(price, style: _labelStyle(color: Colors.black)),
      ],
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _button(
            text: AppStrings.downloadTicket,
            iconWidget: SizedBox(
              width: 18,
              height: 18,
              child: Image.asset(
                'assets/images/download.png',
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.download,
                  size: 18,
                  color: Color(0xFF8C7104),
                ),
              ),
            ),
            color: const Color(0xFFFECD08),
            textColor: const Color(0xFF8C7104),
            onPressed: () {
              Get.snackbar(AppStrings.downloadTicket,
                AppStrings.preparingTicket,);
            },
          ),
          const SizedBox(height: 12),
          _button(
            text: AppStrings.viewMyJourney,
            isOutlined: true,
            onPressed: () {
              Get.snackbar(
                AppStrings.comingSoon,
                AppStrings.journeyNotImplemented,
              );
            },
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              controller.resetBooking();
              Get.offAllNamed('/home');
            },
            child: Text(
              AppStrings.backToHome,
              style: GoogleFonts.inter(color: const Color(0xFF8C7104)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _button({
    required String text,
    IconData? icon,
    Widget? iconWidget,
    Color? color,
    Color? textColor,
    bool isOutlined = false,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: isOutlined
          ? OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(
          text,
          style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.black),
        ),
      )
          : ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconWidget != null) ...[
              iconWidget,
              const SizedBox(width: 8),
            ] else if (icon != null) ...[
              Icon(icon, size: 18, color: textColor),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: textColor),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _labelStyle({Color color = Colors.grey}) =>
      GoogleFonts.inter(fontSize: 12, color: color);

  TextStyle _valueStyle({double fontSize = 16}) =>
      GoogleFonts.inter(fontSize: fontSize, fontWeight: FontWeight.w600, color: Colors.black);
}