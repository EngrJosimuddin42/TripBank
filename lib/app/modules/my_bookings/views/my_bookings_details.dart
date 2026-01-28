import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/booking_model.dart';
import '../controllers/my_bookings_controller.dart';

class MyBookingsDetailsView extends GetView<MyBookingsController> {
  const MyBookingsDetailsView({super.key});

  @override
  Widget build(BuildContext context) {

    // Keys for sections
    final tourPlanKey = GlobalKey();
    final meetingPointKey = GlobalKey();
    final tourDetailsKey = GlobalKey();

    // State variables for dropdown
    final RxMap<String, bool> expandedSections = <String, bool>{
      'highlights': true,
      'included': false,
      'notIncluded': false,
      'toBring': false,
    }.obs;

    final BookingSummary? booking = Get.arguments?['booking'];

    if (booking == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Booking Details')),
        body: const Center(child: Text('No booking selected')),
      );
    }
    // Helper function to scroll to section
    void scrollToSection(GlobalKey key) {
      final context = key.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          alignment: 0.1,
        );
      }
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
            _buildActionTabs(booking, scrollToSection, tourPlanKey, meetingPointKey),
            const SizedBox(height: 24),
            _buildBookingOverview(booking),
            const SizedBox(height: 24),
            _buildServiceDetails(booking),
            const SizedBox(height: 24),
            if (booking.type == 'Tour' || booking.ticketData.containsKey('itinerary')) ...[
              Container(
                key: tourPlanKey,
                child: _buildTourPlan(),
              ),
              const SizedBox(height: 24),
            ],
            Container(
              key: meetingPointKey,
              child: _buildMeetingPoint(booking),
            ),

            const SizedBox(height: 24),
            Container(
              key: tourDetailsKey,
              child: _buildTourDetailsWithDropdown(expandedSections),
            ),

            const SizedBox(height: 24),
            _buildPaymentAndDocuments(booking),

            const SizedBox(height: 24),
            _buildNeedHelpSection(booking),

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
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10),
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
                  errorBuilder: (context, error, stackTrace) => Container(
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
                }),
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
// Action Tabs - Updated
  Widget _buildActionTabs(
      BookingSummary booking,
      Function(GlobalKey) scrollToSection,
      GlobalKey tourPlanKey,
      GlobalKey meetingPointKey,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildTab(Icons.confirmation_num_outlined, 'Tickets', () {
            controller.downloadTicket(booking.bookingId);
          }),
          const SizedBox(width: 8),
          _buildTab(Icons.assignment_outlined, 'Itinerary', () {
            // Scroll to tour plan section
            if (booking.type == 'Tour' || booking.ticketData.containsKey('itinerary')) {
              scrollToSection(tourPlanKey);
              Get.snackbar(
                'Itinerary',
                'Showing your trip timeline',
                snackPosition: SnackPosition.BOTTOM,
                duration: const Duration(seconds: 1),
                backgroundColor: const Color(0xFFFEDE5A),
                colorText: Colors.black,
              );
            } else {
              Get.snackbar(
                'Itinerary',
                'No itinerary available for this booking',
                snackPosition: SnackPosition.BOTTOM,
                duration: const Duration(seconds: 2),
              );
            }
          }),

          const SizedBox(width: 8),
          _buildTab(Icons.location_on_outlined, 'Location', () {
            // Scroll to meeting point section
            scrollToSection(meetingPointKey);
            Get.snackbar(
              'Location',
              'Showing meeting point details',
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 1),
              backgroundColor: const Color(0xFFFEDE5A),
              colorText: Colors.black,
            );
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
            color: const Color(0xFF8E95A1).withValues(alpha: 0.9),
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
    final leadTraveler = booking.ticketData['leadTraveler'] ?? 'Mahfujul Hoque';

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
                _buildInfoRow('Lead traveler:', leadTraveler),
                const SizedBox(height: 12),

                // Status Row with "View details"
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Payment status:',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    Row(
                      children: [
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
                        const SizedBox(width: 8),
                        // ADDED: View details button
                        GestureDetector(
                          onTap: () {
                          },
                          child: const Text(
                            'View details',
                            style: TextStyle(
                              color: Color(0xFFFBC02D),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
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
          )),
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


  // Tour Plan (Timeline) Widget
  Widget _buildTourPlan() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tour plan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                _buildDaySection('Day 1 – Arrival', [
                  _buildTimelineItem('10:30', 'Flight: Lagos → Tokyo', null),
                  _buildTimelineItem('21:45', 'Arrive at Narita Airport', null),
                  _buildTimelineItem('23:00', 'Hotel check-in', 'Shinjuku Sakura Hotel'),
                ]),
                _buildDaySection('Day 2 – Tokyo Cherry Blossom Tour', [
                  _buildTimelineItem('09:00', 'Meet at Shinjuku Station', 'East Exit, look for Tripbank flag'),
                  _buildTimelineItem('10:00', 'Ueno Park visit', 'Enjoy cherry blossoms in full bloom'),
                  _buildTimelineItem('13:00', 'Lunch break', 'Traditional Japanese cuisine'),
                  _buildTimelineItem('15:00', 'River cruise', 'Sumida River cherry blossom viewing'),
                  _buildTimelineItem('18:00', 'Drop-off at hotel', null),
                ]),
                _buildDaySection('Day 3 – Free day', [
                  _buildTimelineItem(null, 'Explore Tokyo at your own pace', null),
                  _buildTimelineItem(null, 'Optional activities available', null),
                ], isLast: false),
                _buildDaySection('Day 4 – Departure', [
                  _buildTimelineItem('10:00', 'Hotel check-out', null),
                  _buildTimelineItem('14:30', 'Departure flight to Lagos', null),
                ], isLast: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaySection(String title, List<Widget> items, {bool isLast = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF333333)),
        ),
        const SizedBox(height: 20),
        ...items,
        if (!isLast) const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildTimelineItem(String? time, String activity, String? subtitle) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFC107),
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Container(
                  width: 2,
                  color: Colors.grey.shade200,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (time != null) ...[
                      Text(
                        time,
                        style: TextStyle(color: Colors.grey[400], fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 10),
                    ],
                    Expanded(
                      child: Text(
                        activity,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF444444)),
                      ),
                    ),
                  ],
                ),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 15),
                    child: Text(
                      subtitle,
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  )
                else
                  const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

// Meeting point & map Widget
  Widget _buildMeetingPoint(BookingSummary booking) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Meeting point & map',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1526772662000-3f88f10405ff?w=600',
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 180,
                      color: Colors.grey[200],
                      child: const Icon(Icons.map_outlined, size: 40, color: Colors.grey),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Meeting point: Shinjuku Station, East Exit',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Look for Tripbank flag near the main entrance.',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Get.snackbar('Maps', 'Opening Google Maps...');
                              },
                              icon: const Icon(Icons.open_in_new, size: 18),
                              label: const Text('Open in Maps'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFEDE5A),
                                foregroundColor: Colors.black,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Get.snackbar('Route', 'Calculating route...');
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFFFEDE5A)),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: const Text('View route'),
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
        ],
      ),
    );
  }

  Widget _buildTourDetailsWithDropdown(RxMap<String, bool> expandedSections) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tour details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enjoy a full-day guided tour of Tokyo during cherry blossom season. Experience the beauty of sakura in bloom at carefully selected locations including Ueno Park, the Imperial Palace, and a scenic river cruise along the Sumida River.',
                  style: TextStyle(color: Colors.grey[700], fontSize: 14, height: 1.5),
                ),
                const SizedBox(height: 24),

                _buildInteractiveDropdown(
                  'highlights',
                  'Highlights',
                  [
                    'Visit iconic cherry blossom viewing spots in Tokyo',
                    'Scenic Sumida River cruise with cherry blossom views',
                    'Traditional Japanese lunch included',
                    'Professional English-speaking guide',
                  ],
                  expandedSections,
                  isBullet: true,
                ),
                const Divider(height: 32),

                _buildInteractiveDropdown(
                  'included',
                  'What\'s included',
                  [
                    'Professional tour guide',
                    'Traditional Japanese lunch',
                    'River cruise tickets',
                    'All entrance fees',
                  ],
                  expandedSections,
                  isCheck: true,
                ),
                const Divider(height: 32),

                _buildInteractiveDropdown(
                  'notIncluded',
                  'What\'s not included',
                  [
                    'Personal expenses',
                    'Hotel pickup and drop-off',
                    'Travel insurance',
                  ],
                  expandedSections,
                  isCross: true,
                ),
                const Divider(height: 32),

                _buildInteractiveDropdown(
                  'toBring',
                  'What to bring',
                  [
                    'Comfortable walking shoes',
                    'Light jacket or sweater',
                    'Camera for photos',
                    'Water bottle',
                  ],
                  expandedSections,
                  isArrow: true,
                ),
              ],
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveDropdown(
      String key,
      String title,
      List<String> items,
      RxMap<String, bool> expandedSections,
      {bool isBullet = false, bool isCheck = false, bool isCross = false, bool isArrow = false}
      ) {
    final isExpanded = expandedSections[key] ?? false;

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            expandedSections[key] = !isExpanded;
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              AnimatedRotation(
                turns: isExpanded ? 0 : 0.5, // 0 = up, 0.5 = down
                duration: const Duration(milliseconds: 200),
                child: const Icon(Icons.keyboard_arrow_up, size: 20, color: Colors.grey),
              ),
            ],
          ),
        ),

        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: isExpanded
              ? Column(
            children: [
              const SizedBox(height: 12),
              ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isBullet) Text('• ', style: TextStyle(color: Colors.orange[400], fontWeight: FontWeight.bold)),
                    if (isCheck) const Icon(Icons.check_circle_outline, color: Colors.green, size: 16),
                    if (isCross) const Icon(Icons.close, color: Colors.grey, size: 16),
                    if (isArrow) Icon(Icons.arrow_right_alt, color: Colors.orange[300], size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item,
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ),
                  ],
                ),
              )),
            ],
          )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

// Payment & documents Widget
  Widget _buildPaymentAndDocuments(BookingSummary booking) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment & documents',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                _buildPaymentRow(
                  'Payment method:',
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.credit_card, size: 20, color: Color(0xFF546E7A)),
                      const SizedBox(width: 8),
                      const Text(
                        'Visa •••• 2931',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildPaymentRow(
                  'Total:',
                  Text(
                    booking.totalAmount,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                const SizedBox(height: 16),

                _buildPaymentRow(
                  'Status:',
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle_outline, size: 16, color: Color(0xFF2E7D32)),
                         SizedBox(width: 4),
                        Text(
                          'Paid in full',
                          style: TextStyle(
                            color: Color(0xFF2E7D32),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                const Divider(height: 1, color: Color(0xFFEEEEEE)),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: _buildDownloadButton(
                        Icons.file_download_outlined,
                        'Invoice',
                            () => controller.downloadTicket(booking.bookingId),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDownloadButton(
                        Icons.file_download_outlined,
                        'Itinerary PDF',
                            () => controller.downloadTicket(booking.bookingId),
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

  Widget _buildPaymentRow(String label, Widget value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        value,
      ],
    );
  }

  Widget _buildDownloadButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F7F9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: const Color(0xFF455A64)),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF455A64),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Need help? Section Widget
  Widget _buildNeedHelpSection(BookingSummary booking) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Need help?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                // Chat with provider button
                _buildLargeButton(
                  icon: Icons.chat_bubble_outline,
                  label: 'Chat with provider',
                  onTap: () => Get.snackbar('Chat', 'Connecting to provider...'),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF448AFF), Color(0xFF693AF1)],
                  ),
                ),
                const SizedBox(height: 12),

                // Cancel button
                if (booking.status != 'Canceled')
                  _buildLargeButton(
                    label: 'cancel',
                    onTap: () => controller.cancelBooking(booking.bookingId),
                    color: const Color(0xFFF1F3F4),
                    textColor: const Color(0xFF5F6368),
                  ),
                const SizedBox(height: 12),

                // Ask AI button
                _buildLargeButton(
                  icon: Icons.smart_toy_outlined,
                  label: 'Ask AI about this trip',
                  onTap: () => Get.snackbar('AI Assistant', 'How can I help you today?'),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFBC02D), Color(0xFFF9A825)],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

// Large Button Helper for Help Section
  Widget _buildLargeButton({
    IconData? icon,
    required String label,
    required VoidCallback onTap,
    Gradient? gradient,
    Color? color,
    Color textColor = Colors.white,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color,
          gradient: gradient,
          borderRadius: BorderRadius.circular(12),
          boxShadow: gradient != null
              ? [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2))]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: textColor, size: 20),
              const SizedBox(width: 10),
            ],
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
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