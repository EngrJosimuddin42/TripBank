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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: Navigator.canPop(context)
            ? IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
        )
            : null,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              'My Trips',
              style: GoogleFonts.poppins(
                color: Color(0xFF3A3A3A),
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Manage and  see all your tour and ticket',
              style: GoogleFonts.inter(
                color: Color(0xFF666666),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Obx(() => Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Color(0xFFFECD08))
              ),
              child: Row(
                children: [
                  _buildTabButton('All', 0),
                  const SizedBox(width: 4),
                  _buildTabButton('Today', 1),
                  const SizedBox(width: 4),
                  _buildTabButton('Upcoming', 2),
                  const SizedBox(width: 4),
                  _buildTabButton('Cancel', 3),
                ],
              ),
            )),
          ),
          Expanded(
            child: Obx(() {
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
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, int index) {
    final isSelected = controller.selectedTab.value == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeTab(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFECD08) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Color(0xFF3A3A3A),
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookingCard(BookingSummary booking) {
    final hasTag = booking.ticketData['tag'] != null;
    final isCanceled = booking.status == 'Canceled';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: hasTag ? _buildCardWithTag(booking, isCanceled) : _buildCardWithoutTag(booking, isCanceled),
    );
  }

  Widget _buildCardWithTag(BookingSummary booking, bool isCanceled) {
    final services = List<String>.from(booking.ticketData['services'] ?? []);
    final travelers = booking.ticketData['travelers'] ?? 1;
    final tag = booking.ticketData['tag'] ?? '';

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDD835),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.auto_awesome, size: 16, color: Colors.black),
                    const SizedBox(width: 6),
                    Text(
                      tag,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      booking.status,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.green[800],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(Icons.check_circle, size: 16, color: Colors.green[700]),
                  ],
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Image.asset('assets/images/location_trip.png'),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                          booking.displayLocation,
                          style: TextStyle(color: Colors.grey[700], fontSize: 14),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                        ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Image.asset('assets/images/calendar_trip.png'),
                        const SizedBox(width: 4),
                        Text(
                          booking.dates,
                          style: TextStyle(color: Colors.grey[700], fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ...services.map((service) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _getServiceColor(service).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(_getServiceIcon(service), size: 16, color: _getServiceColor(service)),
                                const SizedBox(width: 6),
                                Text(
                                  service,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: _getServiceColor(service),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.indigo.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.people, size: 16, color: Colors.indigo),
                              const SizedBox(width: 6),
                              Text(
                                '$travelers travelers',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.indigo[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  booking.imageUrl,
                  width: 110,
                  height: 160,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 110,
                    height: 160,
                    color: Colors.grey[200],
                    child: Icon(Icons.image, size: 50, color: Colors.grey[400]),
                  ),
                ),
              ),
            ],
          ),
        ),

        Container(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Color(0xFFFEF3C6), width: 1.5)),
          ),
        ),

        const SizedBox(height: 16),

        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: GestureDetector(
                  onTap: () => controller.viewBookingDetails(booking),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDD835),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.confirmation_number_outlined, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Tickets',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => controller.viewBookingDetails(booking),
                child: Row(
                  children: [
                    Text(
                      'View',
                      style: TextStyle(
                        color: isCanceled ? Colors.grey[600] : Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward,
                      color: isCanceled ? Colors.grey[600] : Colors.orange,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCardWithoutTag(BookingSummary booking, bool isCanceled) {
    final services = List<String>.from(booking.ticketData['services'] ?? []);
    final travelers = booking.ticketData['travelers'] ?? 1;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    Image.network(
                      booking.imageUrl,
                      width: 90,
                      height: 110,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 90,
                        height: 110,
                        color: Colors.grey[200],
                        child: Icon(Icons.image, color: Colors.grey[400]),
                      ),
                    ),
                    if (isCanceled)
                      Container(
                        width: 90,
                        height: 110,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                        color: isCanceled ? Colors.grey[600] : Colors.black,
                        decoration: isCanceled ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Image.asset('assets/images/location_trip.png'),
                        const SizedBox(width: 4),
                        Expanded(
                          child:Text(
                          booking.displayLocation,
                          style: TextStyle(color: Colors.grey[600], fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                        ),
              ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Image.asset('assets/images/calendar_trip.png'),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            booking.dates,
                            style: TextStyle(color: Colors.grey[600], fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isCanceled ? Colors.red[50] : const Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isCanceled ? Icons.cancel : Icons.rocket_launch,
                            size: 12,
                            color: isCanceled ? Colors.red : Colors.blue,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isCanceled ? 'Canceled' : booking.status,
                            style: TextStyle(
                              color: isCanceled ? Colors.red : Colors.blue,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              ...services.map((service) {
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isCanceled
                        ? Colors.grey.withValues(alpha: 0.1)
                        : _getServiceColor(service).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Opacity(
                    opacity: isCanceled ? 0.5 : 1.0,
                    child: Icon(_getServiceIcon(service), size: 16, color: _getServiceColor(service)),
                  ),
                );
              }).toList(),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isCanceled
                      ? Colors.grey.withValues(alpha: 0.1)
                      : Colors.indigo.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.people,
                      size: 14,
                      color: isCanceled ? Colors.grey : Colors.indigo,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$travelers',
                      style: TextStyle(
                        color: isCanceled ? Colors.grey[600] : Colors.indigo[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => controller.viewBookingDetails(booking),
                child: Row(
                  children: [
                    Text(
                      'View',
                      style: TextStyle(
                        color: isCanceled ? Colors.grey[600] : Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward,
                      color: isCanceled ? Colors.grey[600] : Colors.orange,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

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
            'Your bookings will appear here',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
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
}