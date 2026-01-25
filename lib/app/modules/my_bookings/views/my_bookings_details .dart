import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/booking_model.dart';
import '../controllers/my_bookings_controller.dart';

class MyBookingsDetailsView extends GetView<MyBookingsController> {
  const MyBookingsDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get booking from arguments
    final BookingSummary? booking = Get.arguments?['booking'];

    if (booking == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Booking Details')),
        body: const Center(child: Text('No booking selected')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
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
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      booking.title,
                      style: GoogleFonts.roboto(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMainCard(booking),
            _buildActionTabs(booking),
            const SizedBox(height: 24),
            _buildBookingOverview(booking),
            const SizedBox(height: 24),
            _buildServiceDetails(booking),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Main Card with Image and Services
  Widget _buildMainCard(BookingSummary booking) {
    final services = List<String>.from(booking.ticketData['services'] ?? []);
    final travelers = booking.ticketData['travelers'] ?? 1;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  booking.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[200],
                    child: Icon(Icons.image, color: Colors.grey[400]),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    _buildIconText(Icons.location_on, booking.subtitle),
                    const SizedBox(height: 4),
                    _buildIconText(Icons.calendar_today, booking.dates),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...services.map((service) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: _buildSmallChip(_getServiceIcon(service), service),
                  );
                }).toList(),
                _buildSmallChip(Icons.people, '$travelers Travelers', isBlue: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildSmallChip(IconData icon, String label, {bool isBlue = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: isBlue ? Colors.blue[50] : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isBlue ? Colors.transparent : Colors.grey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: isBlue ? Colors.blue : Colors.grey),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isBlue ? Colors.blue : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // Action Tabs
  Widget _buildActionTabs(BookingSummary booking) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildTab(Icons.confirmation_num_outlined, 'Tickets', () {
            // Download ticket
            controller.downloadTicket(booking.bookingId);
          }),
          const SizedBox(width: 8),
          _buildTab(Icons.share_outlined, 'Share', () {
            // Share ticket
            controller.shareTicket(booking.bookingId);
          }),
          const SizedBox(width: 8),
          _buildTab(Icons.location_on_outlined, 'Location', () {
            // Show location
            Get.snackbar('Location', 'Opening map for ${booking.subtitle}');
          }),
        ],
      ),
    );
  }

  Widget _buildTab(IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF8E95A1).withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Trip overview
  Widget _buildBookingOverview(BookingSummary booking) {
    final isCanceled = booking.status == 'Canceled';
    final canceledOn = booking.ticketData['canceledOn'];
    final refundAmount = booking.ticketData['refundAmount'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Trip overview',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                _buildInfoRow('Booking ID:', booking.bookingId),
                const SizedBox(height: 12),
                _buildInfoRow(
                  'Booked on:',
                  '${booking.bookingDate.day} ${_getMonth(booking.bookingDate.month)} ${booking.bookingDate.year}',
                ),
                const SizedBox(height: 12),
                _buildInfoRow('Booking type:', booking.type),
                const SizedBox(height: 12),

                // Status Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Status:',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isCanceled
                            ? const Color(0xFFFFEBEE)
                            : const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        booking.status,
                        style: TextStyle(
                          color: isCanceled
                              ? const Color(0xFFC62828)
                              : const Color(0xFF2E7D32),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                if (isCanceled && canceledOn != null) ...[
                  const SizedBox(height: 12),
                  _buildInfoRow('Canceled on:', canceledOn),
                ],

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total amount:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      booking.totalAmount,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                if (isCanceled && refundAmount != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Refund amount:',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      Text(
                        refundAmount,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      Icons.info,
                      size: 18,
                      color: isCanceled ? Colors.red[300] : const Color(0xFF90A4AE),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isCanceled
                            ? 'This booking has been canceled'
                            : 'Free cancellation available',
                        style: TextStyle(
                          color: isCanceled ? Colors.red[700] : const Color(0xFF78909C),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  // Service Details
  Widget _buildServiceDetails(BookingSummary booking) {
    final services = List<String>.from(booking.ticketData['services'] ?? []);

    if (services.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your bookings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...services.map((service) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildServiceItem(service, booking),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildServiceItem(String service, BookingSummary booking) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getServiceIcon(service),
                color: _getServiceColor(service),
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                service,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  controller.viewServiceTicket(booking, service);
                },
                child: const Row(
                  children: [
                    Text(
                      'View ticket',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(Icons.chevron_right, color: Colors.orange, size: 18),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildServiceInfo(service, booking),
        ],
      ),
    );
  }

  Widget _buildServiceInfo(String service, BookingSummary booking) {
    switch (service) {
      case 'Flight':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              booking.title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              booking.dates,
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
            const SizedBox(height: 4),
            Text(
              'Location: ${booking.subtitle}',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                _buildTag('Economy'),
                _buildTag('2 bags'),
              ],
            ),
          ],
        );
      case 'Hotel':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              booking.title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              booking.dates,
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
            const SizedBox(height: 4),
            Text(
              'Location: ${booking.subtitle}',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                _buildTag('Breakfast included'),
                _buildTag('Free WiFi'),
              ],
            ),
          ],
        );
      case 'Car':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Car Rental',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              booking.dates,
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
            const SizedBox(height: 4),
            Text(
              'Pickup: ${booking.subtitle}',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                _buildTag('Automatic'),
                _buildTag('Full Insurance'),
              ],
            ),
          ],
        );
      case 'Tour':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              booking.title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              booking.dates,
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
            const SizedBox(height: 4),
            Text(
              'Location: ${booking.subtitle}',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                _buildTag('Guided'),
                _buildTag('Lunch included'),
              ],
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7F9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(text, style: const TextStyle(fontSize: 11)),
    );
  }

  // Helper methods
  IconData _getServiceIcon(String service) {
    switch (service) {
      case 'Flight':
        return Icons.flight;
      case 'Hotel':
        return Icons.hotel;
      case 'Car':
        return Icons.directions_car;
      case 'Tour':
        return Icons.directions_bus;
      default:
        return Icons.circle;
    }
  }

  Color _getServiceColor(String service) {
    switch (service) {
      case 'Flight':
        return Colors.blue;
      case 'Hotel':
        return Colors.purple;
      case 'Car':
        return Colors.orange;
      case 'Tour':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  String _getMonth(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}