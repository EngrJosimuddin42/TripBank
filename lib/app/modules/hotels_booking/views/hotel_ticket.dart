import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../models/booking_model.dart';
import '../../../services/storage_service.dart';
import '../../../widgets/snackbar_helper.dart';
import '../controllers/hotels_booking_controller.dart';

class HotelTicketView extends StatelessWidget {
  const HotelTicketView({super.key});

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildBookingHeader(ticketData),
            const SizedBox(height: 16),
            _buildHotelDetailsCard(ticketData),
            const SizedBox(height: 16),
            _buildBookingDetailsCard(ticketData),
            const SizedBox(height: 16),
            _buildGuestInfo(),
            const SizedBox(height: 16),
            _buildPricingSummaryCard(ticketData),
            const SizedBox(height: 16),
            _buildActionButtons(ticketData.isFromMyBookings),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // DATA EXTRACTION

  HotelTicketData? _extractTicketData() {
    final BookingSummary? bookingFromArgs = Get.arguments?['booking'];

    if (bookingFromArgs != null) {
      return bookingFromArgs.toHotelTicketData();
    }

    // Otherwise, extract from controller (direct booking)
    return _extractFromController();
  }

  HotelTicketData? _extractFromController() {
    try {
      final controller = Get.find<HotelsBookingController>();
      final hotel = controller.selectedHotel.value;

      if (hotel == null) return null;

      // Generate booking reference
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final bookingRef = 'HB-$timestamp';

      return HotelTicketData(
        bookingReference: bookingRef,
        status: 'Confirmed',
        hotelName: hotel.name,
        location: controller.location.value,
        address: hotel.address,
        imageUrl: hotel.image,
        rating: hotel.rating,
        reviews: hotel.reviews,
        checkInDate: controller.checkInDate.value,
        checkOutDate: controller.checkOutDate.value,
        nights: controller.nights.value,
        rooms: controller.roomCount.value,
        guests: controller.guestCount.value,
        roomClass: controller.preferredClass.value,
        basePrice: controller.totalBasePrice,
        discount: controller.totalDiscountAmount,
        tax: controller.totalTaxAmount,
        serviceFee: controller.totalServiceFee,
        totalPrice: controller.finalAmount,
        paymentMethod: controller.selectedPaymentMethod.value,
        amenities: [
          'Free Wi-Fi',
          'Room Service',
          'Cafe',
          'Parking Service',
        ],
        isFromMyBookings: false,
      );
    } catch (e) {
      return null;
    }
  }

  // UI SECTIONS

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

  Widget _buildBookingHeader(HotelTicketData data) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
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

  Widget _buildHotelDetailsCard(HotelTicketData data) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          if (data.imageUrl.isNotEmpty) _buildHotelImage(data.imageUrl),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.hotelName,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                _buildRatingStars(data.rating),
                const SizedBox(height: 8),
                _buildAddress(data.address, data.location),
                const SizedBox(height: 12),
                _buildReviewsBadge(data.reviews),
                if (data.amenities.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildAmenitiesGrid(data.amenities),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotelImage(String imageUrl) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        height: 220,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.grey[300],
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => Container(
          height: 220,
          color: Colors.grey[300],
          child: const Icon(Icons.hotel, size: 80, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildRatingStars(double rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating.floor() ? Icons.star : Icons.star_border,
          color: Colors.orange,
          size: 14,
        );
      }),
    );
  }

  Widget _buildAddress(String address, String location) {
    final displayAddress = address.isNotEmpty ? '$address, $location' : location;
    return Row(
      children: [
        Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            displayAddress,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsBadge(int reviews) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '$reviews Reviews',
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildAmenitiesGrid(List<String> amenities) {
    final amenityIcons = {
      'Free Wi-Fi': Icons.wifi,
      'Room Service': Icons.spa,
      'Cafe': Icons.local_cafe,
      'Parking Service': Icons.local_parking,
      'Pool': Icons.pool,
      'Gym': Icons.fitness_center,
      'Restaurant': Icons.restaurant,
      'Spa': Icons.spa,
    };

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: amenities.map((amenity) {
        return _buildAmenityIcon(
          amenityIcons[amenity] ?? Icons.check_circle,
          amenity,
        );
      }).toList(),
    );
  }

  Widget _buildAmenityIcon(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.black),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 11, color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildBookingDetailsCard(HotelTicketData data) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
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
          Text(
            'Your booking details',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDateColumn(
                  'Check-in',
                  DateFormat('EEE, dd MMM, yyyy').format(data.checkInDate),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  height: 40,
                  child: VerticalDivider(
                    color: const Color(0xFFC2C1C1),
                    thickness: 1,
                    width: 1,
                  ),
                ),
              ),
              Expanded(
                child: _buildDateColumn(
                  'Check-out',
                  DateFormat('EEE, dd MMM, yyyy').format(data.checkOutDate),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildRoomNightsInfo(data),
        ],
      ),
    );
  }

  Widget _buildDateColumn(String label, String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600]),
        ),
        const SizedBox(height: 4),
        Text(
          date,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildRoomNightsInfo(HotelTicketData data) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${data.roomClass} Room',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
              Text(
                '${data.nights} Night${data.nights > 1 ? "s" : ""}',
                style: GoogleFonts.inter(color: Colors.grey[600]),
              ),
            ],
          ),
          const Divider(height: 20, thickness: 0.5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSmallInfoChip(
                Icons.people_outline,
                '${data.rooms} Room${data.rooms > 1 ? "s" : ""} • ${data.guests} Guest${data.guests > 1 ? "s" : ""}',
              ),
              if (data.paymentMethod.isNotEmpty)
                _buildSmallInfoChip(Icons.payment, data.paymentMethod),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmallInfoChip(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.blueGrey),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 13, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildGuestInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
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
                  'Guest Information',
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
                  'Guest Information',
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

  Widget _buildPricingSummaryCard(HotelTicketData data) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
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
          Text(
            'Pricing Summary',
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildPriceRow(
            '${data.rooms} room${data.rooms > 1 ? "s" : ""} x ${data.nights} night${data.nights > 1 ? "s" : ""}',
            '\$${data.basePrice.toStringAsFixed(0)}',
          ),
          const SizedBox(height: 8),
          if (data.discount > 0)
            _buildPriceRow(
              'Discount',
              '-\$${data.discount.toStringAsFixed(0)}',
              isDiscount: true,
            ),
          if (data.discount > 0) const SizedBox(height: 8),
          _buildPriceRow('Taxes & fees', '\$${data.tax.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          _buildPriceRow('Service Fee', '\$${data.serviceFee.toStringAsFixed(2)}'),
          const Divider(height: 32, thickness: 1.2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Paid',
                style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '\$${data.totalPrice.toStringAsFixed(2)}',
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

  Widget _buildPriceRow(String label, String amount, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[700]),
        ),
        Text(
          amount,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDiscount ? Colors.green : Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(bool isFromMyBookings) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
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
              minimumSize: const Size(double.infinity, 40),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: OutlinedButton(
            onPressed: () {
              if (isFromMyBookings) {
                Get.back();
              } else {
                Get.offAllNamed('/my-bookings', arguments: {'fromTicket': true});
              }
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              side: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
              minimumSize: const Size(double.infinity, 40),
            ),
            child: Text(
              isFromMyBookings ? 'Back to Bookings' : 'View My Journey',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextButton(
            onPressed: () {
              if (!isFromMyBookings) {
                try {
                  Get.find<HotelsBookingController>().resetBookingForm();
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
    );
  }

  //  UI COMPONENTS

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
}