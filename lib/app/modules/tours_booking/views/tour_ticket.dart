import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../constants/app_strings.dart';
import '../../../models/booking_model.dart';
import '../../../services/storage_service.dart';
import '../controllers/tours_booking_controller.dart';

class TourTicketView extends StatelessWidget {
  const TourTicketView({super.key});

  @override
  Widget build(BuildContext context) {
    final ticketData = _extractTicketData();

    if (ticketData == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Tour Ticket')),
        body: Center(child: Text(AppStrings.noBookingFound)),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: _buildAppBar(),
      body: Column(
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
                    _buildBookingReference(ticketData),
                    _buildTourDetails(ticketData),
                    _buildPassengerInfo(),
                    _buildPaymentDetails(ticketData),
                  ],
                ),
              ),
            ),
          ),
          _buildBottomButtons(ticketData.isFromMyBookings),
        ],
      ),
    );
  }

  //  Data Extraction

  TicketData? _extractTicketData() {
    final BookingSummary? bookingFromArgs = Get.arguments?['booking'];

    if (bookingFromArgs != null) {
      return bookingFromArgs.toTicketData();
    }

    return _extractFromController();
  }

  TicketData? _extractFromController() {
    try {
      final controller = Get.find<ToursBookingController>();
      final tour = controller.bookedTour.value;

      if (tour == null) return null;

      return TicketData(
        bookingReference: controller.bookingReference.value.isNotEmpty
            ? controller.bookingReference.value
            : 'TB-${DateTime.now().millisecondsSinceEpoch}',
        status: AppStrings.confirmed,
        tourTitle: tour.title,
        fromLocation: tour.location,
        toLocation: tour.destination ??
            tour.visitingPlaces?.join(', ') ??
            AppStrings.tourDestinations,
        tourDate: controller.selectedDate.value ?? DateTime.now(),
        startTime: tour.startTime ?? '09:00 AM',
        guestsText: '${controller.adultsCount.value} ${AppStrings.adults}'
            '${controller.childrenCount.value > 0 ? ", ${controller.childrenCount.value} ${AppStrings.children}" : ""}',
        duration: tour.duration,
        subtotal: controller.calculateTotalAmount(),
        tax: controller.calculateTax(),
        grandTotal: controller.calculateGrandTotal(),
        isFromMyBookings: false,
      );
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('Error extracting TicketData from controller: $e');
        debugPrint('Stack trace: $stackTrace');
      }
      return null;
    }
  }

  // UI Sections

  Widget _buildBookingReference(TicketData data) {
    return _buildInfoSection(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.bookingReference, style: _labelStyle()),
              Text(data.bookingReference, style: _valueStyle()),
            ],
          ),
          _buildStatusBadge(data.status),
        ],
      ),
    );
  }

  Widget _buildTourDetails(TicketData data) {
    return _buildInfoSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(data.tourTitle, style: _valueStyle(fontSize: 20)),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildDetailItem(AppStrings.from, data.fromLocation, Icons.location_on_outlined),
              _buildDetailItem(AppStrings.to, data.toLocation, Icons.map_outlined),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildDetailItem(
                AppStrings.date,
                DateFormat('dd MMM, yyyy').format(data.tourDate),
                Icons.calendar_today_outlined,
              ),
              _buildDetailItem(AppStrings.time, data.startTime, Icons.access_time),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildDetailItem(AppStrings.guests, data.guestsText, Icons.people_outline),
              _buildDetailItem(AppStrings.duration, data.duration, Icons.timer_outlined),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerInfo() {
    return _buildInfoSection(
      child: Builder(
        builder: (context) {
          try {
            final storage = Get.find<StorageService>();
            final userName = storage.getUserName() ?? 'Guest User';
            final userEmail = storage.getUserEmail() ?? 'guest@tripbank.com';
            final userPhone = storage.getUserPhone() ?? '+880 1700-000000';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.passengerInformation, style: _valueStyle(fontSize: 14)),
                const SizedBox(height: 12),
                _buildIconText(Icons.person_outline, userName),
                const SizedBox(height: 8),
                _buildIconText(Icons.email_outlined, userEmail),
                const SizedBox(height: 8),
                _buildIconText(Icons.phone_outlined, userPhone),
              ],
            );
          } catch (e) {

            // Fallback UI
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.passengerInformation, style: _valueStyle(fontSize: 14)),
                const SizedBox(height: 12),
                _buildIconText(Icons.person_outline, 'Guest User'),
                const SizedBox(height: 8),
                _buildIconText(Icons.email_outlined, 'guest@tripbank.com'),
                const SizedBox(height: 8),
                _buildIconText(Icons.phone_outlined, '+880 1700-000000'),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildPaymentDetails(TicketData data) {
    return _buildInfoSection(
      isLast: true,
      child: Column(
        children: [
          _buildPriceRow(AppStrings.subtotal, '\$${data.subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          _buildPriceRow(AppStrings.taxesAndFees, '\$${data.tax.toStringAsFixed(2)}'),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppStrings.totalPaid, style: _valueStyle(fontSize: 16)),
              Text(
                '\$${data.grandTotal.toStringAsFixed(2)}',
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
    );
  }

  // UI Components

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
                  AppStrings.ticket,
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
            Text(
              '------------------------------------------',
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
    final isCanceled = text == 'Canceled';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isCanceled ? const Color(0xFFFFEBEE) : const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isCanceled ? const Color(0xFFC62828) : Colors.green,
        ),
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

  Widget _buildBottomButtons(bool isFromMyBookings) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(
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
              Get.snackbar(AppStrings.downloadTicket, AppStrings.preparingTicket);
            },
          ),
          const SizedBox(height: 12),
          _buildButton(
            text: isFromMyBookings ? 'Back to Bookings' : AppStrings.viewMyJourney,
            isOutlined: true,
            onPressed: () {
              if (isFromMyBookings) {
                Get.back();
              } else {
                Get.offAllNamed('/my-bookings', arguments: {'fromTicket': true});
              }
            },
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              if (!isFromMyBookings) {
                try {
                  Get.find<ToursBookingController>().resetBooking();
                } catch (e, stackTrace) {
                  if (kDebugMode) {
                    debugPrint('ToursBookingController not found or reset failed: $e');
                    debugPrint('Stack trace: $stackTrace');
                  }
                }
              }
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

  Widget _buildButton({
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

  // Text Styles

  TextStyle _labelStyle({Color color = Colors.grey}) =>
      GoogleFonts.inter(fontSize: 12, color: color);

  TextStyle _valueStyle({double fontSize = 16}) =>
      GoogleFonts.inter(fontSize: fontSize, fontWeight: FontWeight.w600, color: Colors.black);
}