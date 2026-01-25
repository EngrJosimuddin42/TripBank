import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../constants/app_strings.dart';
import '../../../widgets/snackbar_helper.dart';
import '../controllers/hotels_booking_controller.dart';

class HotelTicketView extends GetView<HotelsBookingController> {
  const HotelTicketView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: _buildAppBar(),
      body: Obx(() {
        final hotel = controller.selectedHotel.value;
        if (hotel == null) {
          return const Center(child: Text('No booking information available'));
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildHotelDetailsCard(hotel),
              const SizedBox(height: 24),
              _buildBookingDetailsCard(),
              const SizedBox(height: 24),
              _buildPricingSummaryCard(hotel),
              const SizedBox(height: 24),
              _buildActionButtons(),
              const SizedBox(height: 32),
            ],
          ),
        );
      }),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80),
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
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
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

  Widget _buildHotelDetailsCard(hotel) {
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
          _buildHotelImage(hotel.image),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hotel.name,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                _buildRatingStars(hotel.rating),
                const SizedBox(height: 8),
                _buildAddress(hotel.address),
                const SizedBox(height: 12),
                _buildReviewsBadge(hotel.reviews),
                const SizedBox(height: 16),
                _buildAmenitiesGrid(),
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
        errorWidget: (context, url, error) => Image.asset(
          'assets/images/hotel_1.png',
          fit: BoxFit.cover,
          height: 220,
          width: double.infinity,
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

  Widget _buildAddress(String address) {
    return Row(
      children: [
        Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Expanded(
          child: Obx(() => Text(
            '$address, ${controller.location.value}',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          )),
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
        '$reviews ${AppStrings.reviews}',
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildAmenitiesGrid() {
    final amenities = [
      {'icon': Icons.wifi, 'label': 'Free Wi-Fi'},
      {'icon': Icons.spa, 'label': 'Room Service'},
      {'icon': Icons.local_cafe, 'label': 'Cafe'},
      {'icon': Icons.local_parking, 'label': 'Parking Service'},
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: amenities.map((amenity) {
        return _buildAmenityIcon(
          amenity['icon'] as IconData,
          amenity['label'] as String,
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

  Widget _buildBookingDetailsCard() {
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
          Obx(() => Row(
            children: [
              Expanded(
                child: _buildDateColumn(
                  'Check-in',
                  DateFormat('EEE, dd MMM, yyyy').format(controller.checkInDate.value),
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
                  DateFormat('EEE, dd MMM, yyyy').format(controller.checkOutDate.value),
                ),
              ),
            ],
          )),
          const SizedBox(height: 20),
          _buildRoomNightsInfo(),
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

  Widget _buildRoomNightsInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Obx(() {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${controller.preferredClass.value} Room', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                Text('${controller.nights.value} Nights', style: GoogleFonts.inter(color: Colors.grey[600])),
              ],
            ),
        const Divider(height: 20, thickness: 0.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSmallInfoChip(Icons.people_outline, controller.roomAndGuestSummary),
                _buildSmallInfoChip(Icons.payment, controller.selectedPaymentMethod.value.isEmpty
                    ? 'Not Selected' : controller.selectedPaymentMethod.value),
              ],
            ),
          ],
        );
      }),
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

  Widget _buildPricingSummaryCard(hotel) {
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
      child: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pricing Summary', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),


            _buildPriceRow(controller.pricingDescription, '\$${controller.totalBasePrice.toStringAsFixed(0)}'),

            const SizedBox(height: 8),


            if (controller.totalDiscountAmount > 0)
              _buildPriceRow('Discount (${controller.discountPercentage.value}%)', '-\$${controller.totalDiscountAmount.toStringAsFixed(0)}', isDiscount: true),

            const SizedBox(height: 8),


            _buildPriceRow('Taxes (${controller.taxPercentage}%)', '\$${controller.totalTaxAmount.toStringAsFixed(2)}'),

            const SizedBox(height: 8),


            _buildPriceRow('Service Fees', '\$${controller.totalServiceFee.toStringAsFixed(2)}'),

            const Divider(height: 32, thickness: 1.2),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppStrings.total, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('\$${controller.finalAmount.toStringAsFixed(2)}', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.blue)),
              ],
            ),
          ],
        );
      }),
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

  Widget _buildActionButtons() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ElevatedButton.icon(
            onPressed: () {
              SnackbarHelper.showSuccess(
                  'Downloading booking PDF...',
                  title: 'Download Started'
              );
            },
            icon: const Icon(Icons.download, color: Colors.black, size: 20),
            label: Text(
              'Download Booking PDF',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF8C7104),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFECD08),
              padding: const EdgeInsets.symmetric(vertical: 12),
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
            onPressed: () => Get.offAllNamed('/home'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              side: const BorderSide(color: Colors.black54),
              minimumSize: const Size(double.infinity, 40),
            ),
            child: Text(
              AppStrings.backToHome,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF0A0A0A),
              ),
            ),
          ),
        ),
      ],
    );
  }
}