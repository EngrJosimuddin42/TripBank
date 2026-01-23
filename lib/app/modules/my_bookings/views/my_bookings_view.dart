import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/booking_model.dart';
import '../controllers/my_bookings_controller.dart';

class MyBookingsView extends GetView<MyBookingsController> {
  const MyBookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(child: _buildBookingsList()),
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
                  'My Bookings',
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert, color: Colors.black),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const Text('Sort by Date'),
                      onTap: () => controller.sortByDateNewest(),
                    ),
                    PopupMenuItem(
                      child: const Text('Sort by Amount'),
                      onTap: () => controller.sortByAmountHighest(),
                    ),
                    PopupMenuItem(
                      child: const Text('Clear All'),
                      onTap: () => controller.clearAllBookings(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // FILTERS
  // FILTERS
  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Type Filter
          SizedBox(
            height: 40,
            child: Obx(() {
              final selectedValue = controller.selectedFilter.value;
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.filterOptions.length,
                itemBuilder: (context, index) {
                  final option = controller.filterOptions[index];
                  final isSelected = controller.selectedFilter.value == option;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(option),
                      selected: isSelected,
                      onSelected: (_) => controller.updateFilter(option),
                      backgroundColor: Colors.white,
                      selectedColor: const Color(0xFFFECD08),
                      labelStyle: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected ? Colors.black : Colors.grey[700],
                      ),
                      side: BorderSide(
                        color: isSelected ? const Color(0xFFFECD08) : Colors.grey[300]!,
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          const SizedBox(height: 8),
          // Status Filter
          SizedBox(
            height: 40,
            child: Obx(() {
              final selectedStatusValue = controller.selectedStatus.value;              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.statusOptions.length,
                itemBuilder: (context, index) {
                  final status = controller.statusOptions[index];
                  final isSelected = controller.selectedStatus.value == status;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(status),
                      selected: isSelected,
                      onSelected: (_) => controller.updateStatusFilter(status),
                      backgroundColor: Colors.white,
                      selectedColor: _getStatusColor(status),
                      labelStyle: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected ? Colors.white : Colors.grey[700],
                      ),
                      side: BorderSide(
                        color: isSelected ? _getStatusColor(status) : Colors.grey[300]!,
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // BOOKINGS LIST
  Widget _buildBookingsList() {
    return Obx(() {
      final bookings = controller.filteredBookings;

      if (bookings.isEmpty) {
        return _buildEmptyState();
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return _buildBookingCard(booking);
        },
      );
    });
  }

  // BOOKING CARD
  Widget _buildBookingCard(BookingSummary booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Image & Type Badge
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  booking.imageUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 150,
                    color: Colors.grey[200],
                    child: Icon(Icons.image, size: 50, color: Colors.grey[400]),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getTypeColor(booking.type),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_getTypeIcon(booking.type), size: 16, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(
                        booking.type,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: _buildStatusBadge(booking.status),
              ),
            ],
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  booking.title,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                // Subtitle
                Text(
                  booking.subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Dates
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        booking.dates,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Booking ID & Amount
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ID: ${booking.bookingId.substring(booking.bookingId.length - 8)}',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Colors.grey[500],
                      ),
                    ),
                    Text(
                      booking.totalAmount,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFFECD08),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Action Buttons
                _buildActionButtons(booking),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ACTION BUTTONS
  Widget _buildActionButtons(BookingSummary booking) {
    final isCanceled = booking.status == 'Canceled';

    return Row(
      children: [
        // View Details
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => controller.viewTicketDetails(booking.bookingId),
            icon: const Icon(Icons.receipt_long, size: 16),
            label: const Text('Details'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black,
              side: const BorderSide(color: Color(0xFFFECD08)),
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        const SizedBox(width: 8),

        // Download
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => controller.downloadTicket(booking.bookingId),
            icon: const Icon(Icons.download, size: 16),
            label: const Text('Download'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black,
              side: BorderSide(color: Colors.grey[300]!),
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        const SizedBox(width: 8),

        // Cancel or More Actions
        PopupMenuButton(
          icon: const Icon(Icons.more_vert, size: 20),
          itemBuilder: (context) => [
            if (!isCanceled)
              PopupMenuItem(
                child: const Row(
                  children: [
                    Icon(Icons.cancel, size: 18, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Cancel'),
                  ],
                ),
                onTap: () => controller.cancelBooking(booking.bookingId),
              ),
            PopupMenuItem(
              child: const Row(
                children: [
                  Icon(Icons.share, size: 18),
                  SizedBox(width: 8),
                  Text('Share'),
                ],
              ),
              onTap: () => controller.shareTicket(booking.bookingId),
            ),
            PopupMenuItem(
              child: const Row(
                children: [
                  Icon(Icons.delete, size: 18, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete'),
                ],
              ),
              onTap: () => controller.deleteBooking(booking.bookingId),
            ),
          ],
        ),
      ],
    );
  }

  // STATUS BADGE
  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor(status),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  // EMPTY STATE
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 100, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No Bookings Yet',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your booking history will appear here',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // HELPER METHODS
  Color _getTypeColor(String type) {
    switch (type) {
      case 'Flight':
        return Colors.blue;
      case 'Hotel':
        return Colors.orange;
      case 'Car':
        return Colors.purple;
      case 'Bus':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'Flight':
        return Icons.flight;
      case 'Hotel':
        return Icons.hotel;
      case 'Car':
        return Icons.directions_car;
      case 'Bus':
        return Icons.directions_bus;
      default:
        return Icons.bookmark;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Confirmed':
        return Colors.green;
      case 'Canceled':
        return Colors.red;
      case 'Completed':
        return Colors.blue;
      case 'Pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}