import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/booking_model.dart';
import '../../../services/storage_service.dart';
import '../../../widgets/snackbar_helper.dart';
import '../controllers/cars_booking_controller.dart';

class CarTicketView extends StatelessWidget {
  const CarTicketView({super.key});

  @override
  Widget build(BuildContext context) {
    final ticketData = _extractTicketData();

    if (ticketData == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFFDFDFD),
        appBar: _buildAppBar(),
        body: _buildEmptyState(),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: _buildAppBar(),
      body: Column(
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
                    _buildBookingHeader(ticketData),
                    _buildCarInfo(ticketData),
                    _buildTripDetails(ticketData),
                    const Divider(color: Color(0xFFE0E0E0)),
                    _buildPassengerInfo(),
                    const Divider(color: Color(0xFFE0E0E0)),
                    _buildPriceDetails(ticketData),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
          _buildBottomActions(ticketData.isFromMyBookings),
        ],
      ),
    );
  }

  // Data Extraction

  CarTicketData? _extractTicketData() {
    final BookingSummary? bookingFromArgs = Get.arguments?['booking'];

    if (bookingFromArgs != null) {
      return bookingFromArgs.toCarTicketData();
    }

    return _extractFromController();
  }

  CarTicketData? _extractFromController() {
    try {
      final controller = Get.find<CarsBookingController>();
      final car = controller.selectedCar.value;

      if (car == null) return null;

      final breakdown = controller.getPriceBreakdown();
      final isRoundTrip = controller.selectedTripType.value == 'Round Way';

      // Generate proper booking reference
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final bookingRef = 'TB-$timestamp';

      return CarTicketData(
        bookingReference: bookingRef,
        status: 'Confirmed',
        carBrand: car.brand,
        carModel: car.model,
        carType: car.types,
        pickupLocation: controller.arrivingFromLocation.value,
        returnLocation: controller.arrivingToLocation.value,
        pickupDate: controller.arrivingDate.value ?? DateTime.now(),
        returnDate: controller.returnDate.value,
        pickupTime: _getTimeSlot(controller, isPickup: true),
        returnTime: isRoundTrip ? _getTimeSlot(controller, isPickup: false) : null,
        isRoundTrip: isRoundTrip,
        days: breakdown['days']?.toInt() ?? 1,
        baseFare: breakdown['baseFare'] ?? 0.0,
        tax: breakdown['tax'] ?? 0.0,
        aitVat: breakdown['aitVat'] ?? 0.0,
        total: breakdown['total'] ?? 0.0,
        paymentMethod: controller.selectedPaymentMethod.value,
        isFromMyBookings: false,
      );
    } catch (e) {
      return null;
    }
  }

  String _getTimeSlot(CarsBookingController controller, {required bool isPickup}) {
    if (isPickup) {
      if (controller.arrivingSelectedTimeSlots.isNotEmpty) {
        return controller.arrivingSelectedTimeSlots.first;
      } else if (controller.arrivingPreferredTimes.isNotEmpty) {
        return controller.getDefaultTimeFromPreference(controller.arrivingPreferredTimes.first);
      }
    } else {
      if (controller.returnSelectedTimeSlots.isNotEmpty) {
        return controller.returnSelectedTimeSlots.first;
      } else if (controller.returnPreferredTimes.isNotEmpty) {
        return controller.getDefaultTimeFromPreference(controller.returnPreferredTimes.first);
      }
    }
    return '10:00 am';
  }

  //  UI Sections

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
            style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Get.offAllNamed('/home'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFECD08),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

  Widget _buildBookingHeader(CarTicketData data) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1)),
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
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.bookingReference,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          _buildStatusBadge(data.status),
        ],
      ),
    );
  }

  Widget _buildCarInfo(CarTicketData data) {
    final hasCarInfo = data.carBrand.isNotEmpty && data.carModel.isNotEmpty;

    if (!hasCarInfo) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${data.carBrand} ${data.carModel}',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          if (data.carType.isNotEmpty)
            Text(
              data.carType,
              style: GoogleFonts.inter(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTripDetails(CarTicketData data) {
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
              Expanded(
                child: _buildLocationTimeCard(
                  isPickup: true,
                  location: data.pickupLocation.isNotEmpty
                      ? data.pickupLocation
                      : 'Not specified',
                  date: data.pickupDate,
                  time: data.pickupTime,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildLocationTimeCard(
                  isPickup: false,
                  location: data.isRoundTrip && data.returnLocation.isNotEmpty
                      ? data.returnLocation
                      : 'Not specified',
                  date: data.returnDate ?? data.pickupDate,
                  time: data.returnTime,
                  showDateTime: data.isRoundTrip,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationTimeCard({
    required bool isPickup,
    required String location,
    required DateTime date,
    String? time,
    bool showDateTime = true,
  }) {
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
            location,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (showDateTime) ...[
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
            if (time != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    time,
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
        ],
      ),
    );
  }

  Widget _buildPassengerInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Builder(
        builder: (context) {
          try {
            final storage = Get.find<StorageService>();
            final userEmail = storage.getUserEmail() ?? 'guest@tripbank.com';
            final userPhone = storage.getUserPhone() ?? '+880 1700-000000';

            return Column(
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
                _buildContactRow(Icons.email_outlined, userEmail),
                const SizedBox(height: 8),
                _buildContactRow(Icons.phone_outlined, userPhone),
              ],
            );
          } catch (e) {
            return Column(
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
                _buildContactRow(Icons.email_outlined, 'guest@tripbank.com'),
                const SizedBox(height: 8),
                _buildContactRow(Icons.phone_outlined, '+880 1700-000000'),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildPriceDetails(CarTicketData data) {
    double displayBaseFare = data.baseFare;
    double displayTax = data.tax;

    if (data.baseFare == 0 && data.tax == 0 && data.total > 0) {
      // Estimate: assume 15% tax
      displayBaseFare = data.total / 1.15;
      displayTax = data.total - displayBaseFare;
    }

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
              'Subtotal (${data.days} ${data.days > 1 ? "days" : "day"})',
              '\$${displayBaseFare.toStringAsFixed(2)}'
          ),
          _buildPriceRow('Taxes & fees', '\$${displayTax.toStringAsFixed(2)}'),
          if (data.aitVat > 0)
            _buildPriceRow('AIT & VAT', '\$${data.aitVat.toStringAsFixed(2)}'),
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
                '\$${data.total.toStringAsFixed(2)}',
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFFECD08),
                ),
              ),
            ],
          ),
          if (data.paymentMethod.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.payment, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  'Paid via ${data.paymentMethod}',
                  style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
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

  Widget _buildStatusBadge(String text) {
    final isCanceled = text == 'Canceled';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isCanceled ? const Color(0xFFFFEBEE) : Colors.green[50],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isCanceled ? const Color(0xFFC62828) : Colors.green[700],
        ),
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
            style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[700]),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[700])),
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

  Widget _buildBottomActions(bool isFromMyBookings) {
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
                onPressed: () {
                  SnackbarHelper.showSuccess(
                    'Ticket downloading...',
                    title: 'Download Started',
                  );
                },
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  if (isFromMyBookings) {
                    Get.back();
                  } else {
                    Get.offAllNamed('/my-bookings', arguments: {'fromTicket': true});
                  }
                },
                label: Text(
                  isFromMyBookings ? 'Back to Bookings' : 'View My Journey',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  side: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  if (!isFromMyBookings) {
                    try {
                      Get.find<CarsBookingController>().resetBooking();
                    } catch (e) {
                      // Controller not found
                    }
                  }
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

  //  Helper Methods

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}