import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/snackbar_helper.dart';
import '../controllers/cars_booking_controller.dart';

class CarTicketView extends GetView<CarsBookingController> {
  const CarTicketView({super.key});

  @override
  Widget build(BuildContext context) {
    _loadBookingDataFromArguments();

    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: _buildAppBar(),
      body: Obx(() => _buildBody()),
    );
  }

  // Load data from navigation arguments

  void _loadBookingDataFromArguments() {
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey('booking')) {
      final booking = args['booking'];
    }
  }

  //APP BAR

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
                  'Ticket',
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

  // BODY

  Widget _buildBody() {
    final car = controller.selectedCar.value;

    if (car == null) {
      return _buildEmptyState();
    }

    final breakdown = controller.getPriceBreakdown();
    final bookingId = _generateBookingId();

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBookingHeader(bookingId),
                  _buildCarInfo(car),
                  _buildTripDetails(),
                  const Divider(color: Color(0xFFE0E0E0)),
                  _buildContactInfo(),
                  const Divider(color: Color(0xFFE0E0E0)),
                  _buildPriceDetails(breakdown),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
        _buildBottomActions(),
      ],
    );
  }

  //  EMPTY STATE

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No booking found',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please complete a booking first',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Get.offAllNamed('/home'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFECD08),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Back to Home',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //  BOOKING HEADER

  Widget _buildBookingHeader(String bookingId) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Booking Reference',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  bookingId,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Confirmed',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.green[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // CAR INFO

  Widget _buildCarInfo(car) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${car.brand} ${car.model}',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            car.types,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // TRIP DETAILS

  Widget _buildTripDetails() {
    final isRoundTrip = controller.selectedTripType.value == 'Round Way';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trip Details',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildLocationTimeCard(isPickup: true, showDateTime: true)),
              const SizedBox(width: 16),
              Expanded(child: _buildLocationTimeCard(isPickup: false, showDateTime: isRoundTrip)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationTimeCard({required bool isPickup, required bool showDateTime}) {
    final location = isPickup
        ? controller.ArrivingFromLocation.value
        : controller.ArrivingToLocation.value;
    final date = isPickup
        ? controller.ArrivingDate.value
        : (controller.returnDate.value ?? controller.ArrivingDate.value);

    // Get time - check both time slots and preferred times

    String timeSlot;
    if (isPickup) {
      if (controller.ArrivingSelectedTimeSlots.isNotEmpty) {
        timeSlot = controller.ArrivingSelectedTimeSlots.first;
      } else if (controller.ArrivingPreferredTimes.isNotEmpty) {
        // Use controller method to get default time from preference
        timeSlot = controller.getDefaultTimeFromPreference(controller.ArrivingPreferredTimes.first);
      } else {
        timeSlot = '10:00 am';
      }
    } else {
      if (controller.returnSelectedTimeSlots.isNotEmpty) {
        timeSlot = controller.returnSelectedTimeSlots.first;
      } else if (controller.returnPreferredTimes.isNotEmpty) {

        // Use controller method to get default time from preference

        timeSlot = controller.getDefaultTimeFromPreference(controller.returnPreferredTimes.first);
      } else {
        timeSlot = '10:00 am';
      }
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFAE6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFECD08).withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isPickup ? Icons.flight_takeoff : Icons.flight_land,
                size: 16,
                color: const Color(0xFFD4A017),
              ),
              const SizedBox(width: 4),
              Text(
                isPickup ? 'Pickup' : 'Return',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFD4A017),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            location.isEmpty ? 'Not specified' : location,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          if (showDateTime && date != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    _formatDate(date),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.access_time, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  timeSlot,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // CONTACT INFO

  Widget _buildContactInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Passenger Information',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          _buildContactRow(
            Icons.email_outlined,
            controller.contactEmail.value.isEmpty
                ? 'Not provided'
                : controller.contactEmail.value,
          ),
          const SizedBox(height: 8),
          _buildContactRow(
            Icons.phone_outlined,
            controller.contactPhone.value.isEmpty
                ? 'Not provided'
                : controller.contactPhone.value,
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }

  //PRICE DETAILS

  Widget _buildPriceDetails(Map<String, double> breakdown) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Details',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          _buildPriceRow(
            'Subtotal (${breakdown['days']?.toInt()} days)',
            '\$${breakdown['baseFare']?.toStringAsFixed(2)}',
          ),
          _buildPriceRow(
            'Taxes & fees',
            '\$${breakdown['tax']?.toStringAsFixed(2)}',
          ),
          if (breakdown['aitVat']! > 0)
            _buildPriceRow(
              'AIT & VAT',
              '\$${breakdown['aitVat']?.toStringAsFixed(2)}',
            ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFFE0E0E0)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Paid',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              Text(
                '\$${breakdown['total']?.toStringAsFixed(2)}',
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFFECD08),
                ),
              ),
            ],
          ),
          if (controller.selectedPaymentMethod.value.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.payment, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  'Paid via ${controller.selectedPaymentMethod.value}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[700],
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

  // BOTTOM ACTIONS

  Widget _buildBottomActions() {
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _downloadTicket,
                icon: const Icon(Icons.download, color: Color(0xFF8C7104), size: 20),
                label: Text(
                  'Download Ticket',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF8C7104),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFECD08),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  SnackbarHelper.showWarning(
                      'Journey view will be available soon',
                      title: 'Coming Soon'
                  );
                },
                icon: const Icon(Icons.map, color: Colors.black87, size: 20),
                label: Text(
                  'View My Journey',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  controller.resetBooking();
                  Get.offAllNamed('/home');
                },
                child: Text(
                  'Back to Home',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFFECD08),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //  HELPER METHODS

  void _downloadTicket() {
    SnackbarHelper.showSuccess(
        'Ticket downloading...',
        title: 'Download Started'
    );
  }

  String _generateBookingId() {
    return 'CB-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}