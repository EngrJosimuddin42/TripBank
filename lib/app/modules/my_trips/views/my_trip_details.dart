import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/my_trips_controller.dart';

class MyTripDetailsView extends GetView<MyTripsController> {
  const MyTripDetailsView({super.key});


  @override
  Widget build(BuildContext context) {
    final showAllBookings = false.obs;
    return Obx(() {
      final trip = controller.selectedTrip.value;

      if (trip == null) {
        return Scaffold(
          appBar: AppBar(title: const Text('Trip Details')),
          body: const Center(child: Text('No trip selected')),
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
                        trip['title'] ?? 'Trip Details',
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
              _buildMainCard(trip),
              _buildActionTabs(),
              const SizedBox(height: 24),
              _buildTripOverview(trip),
              const SizedBox(height: 24),
              _buildYourBookings(trip, showAllBookings),
              const SizedBox(height: 40),
            ],
          ),
        ),
      );
    });
  }

  // ১. উপরের প্রধান কার্ড (ইমেজ ও সার্ভিস চিপস)
  Widget _buildMainCard(Map<String, dynamic> trip) {
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
                  trip['image'],
                  width: 80, height: 80, fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip['fullTitle'] ?? trip['title'],
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    _buildIconText(Icons.location_on, trip['location']),
                    const SizedBox(height: 4),
                    _buildIconText(Icons.calendar_today, trip['detailedDates'] ?? trip['dates']),
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
                _buildSmallChip(Icons.flight, 'Flight'),
                const SizedBox(width: 5),
                _buildSmallChip(Icons.directions_car, 'Car'),
                const SizedBox(width: 5),
                _buildSmallChip(Icons.hotel, 'Hotel'),
                const SizedBox(width: 5),
                _buildSmallChip(Icons.map, 'Tour'),
                const SizedBox(width: 5),
                _buildSmallChip(Icons.people, '${trip['travelers']} Travelers', isBlue: true),
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
        Text(text, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
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
        children: [
          Icon(icon, size: 12, color: isBlue ? Colors.blue : Colors.grey),
          const SizedBox(width: 3),
          Text(label, style: TextStyle(fontSize: 12, color: isBlue ? Colors.blue : Colors.black87)),
        ],
      ),
    );
  }

  // ২. অ্যাকশন ট্যাব (Tickets, Tour Plan, Meeting point)
  Widget _buildActionTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildTab(Icons.confirmation_num_outlined, 'Tickets'),
          const SizedBox(width: 8),
          _buildTab(Icons.list_alt_outlined, 'Tour plan'),
          const SizedBox(width: 8),
          _buildTab(Icons.location_on_outlined, 'Meeting point'),
        ],
      ),
    );
  }

  Widget _buildTab(IconData icon, String label) {
    return Expanded(
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
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  // ৩. Trip Overview সেকশন (স্ক্রিনশট অনুযায়ী পেমেন্ট ও ডিভাইডারসহ)
  Widget _buildTripOverview(Map<String, dynamic> trip) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Trip overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                _buildInfoRow('Booking ID:', trip['bookingId']),
                const SizedBox(height: 12),
                _buildInfoRow('Booked on:', trip['bookedOn']),
                const SizedBox(height: 12),
                _buildInfoRow('Lead traveler:', trip['travelerName']),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Payment status:', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(20)),
                          child: const Text('Paid in full', style: TextStyle(color: Color(0xFF2E7D32), fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 8),
                        const Text('View details', style: TextStyle(color: Color(0xFFFBC02D), fontSize: 14, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total amount:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(trip['totalAmount'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.info, size: 18, color: Color(0xFF90A4AE)),
                    const SizedBox(width: 8),
                    Expanded(child: Text(trip['cancellationPolicy'], style: const TextStyle(color: Color(0xFF78909C), fontSize: 13))),
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
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildYourBookings(Map<String, dynamic> trip, RxBool showAllBookings) {
    final List? bookings = trip['bookings'];

    if (bookings == null || bookings.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your bookings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text('No bookings found for this trip', style: TextStyle(color: Colors.grey)),
              ),
            ),
          ],
        ),
      );
    }
    final Map<String, Map<String, dynamic>> firstBookings = {};
    for (var item in bookings) {
      final type = item['type'] as String?;
      if (type != null && !firstBookings.containsKey(type)) {
        firstBookings[type] = item;
      }
    }

    final displayBookings = showAllBookings.value ? bookings : firstBookings.values.toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Your bookings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () {
                  showAllBookings.value = !showAllBookings.value; // toggle
                },
                child: Text(
                  showAllBookings.value ? 'Show Less' : 'View all',
                  style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          ...displayBookings.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildBookingItem(item),
          )).toList(),
        ],
      ),
    );
  }

  // ২. বুকিং আইটেমে ইমেজ এরর হ্যান্ডলিং
  Widget _buildBookingItem(Map<String, dynamic> item) {
    bool isTour = item['type'] == 'Tour';
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
              Icon(item['icon'] is IconData ? item['icon'] : Icons.stars, color: Colors.blue.shade400, size: 22),
              const SizedBox(width: 8),
              Text(item['type'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const Spacer(),

      GestureDetector(
          onTap: () {
            Get.toNamed('/my-bookings');
          },
          child: Row(
            children: const [
              const Text('View ticket', style: TextStyle(color: Colors.orange, fontSize: 13, fontWeight: FontWeight.w600)),
              const Icon(Icons.chevron_right, color: Colors.orange, size: 18),
            ],
          ),
      ),
            ],
          ),

          const SizedBox(height: 16),
          if (!isTour && item['image'] != null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    item['image'],
                    width: 64, height: 64, fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 64, height: 64, color: Colors.grey[100],
                      child: const Icon(Icons.broken_image, size: 20, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['title'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(item['time'] ?? '', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                      Text(item['extra'] ?? '', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['title'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                if (item['details'] is List)
                  ...(item['details'] as List).map((d) => Text(d, style: TextStyle(color: Colors.grey.shade600, fontSize: 13))),
              ],
            ),
          if (item['tags'] != null && (item['tags'] as List).isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: (item['tags'] as List).map((tag) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: const Color(0xFFF5F7F9), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade200)),
                child: Text(tag, style: const TextStyle(fontSize: 11)),
              )).toList(),
            ),
          ],
        ],
      ),
    );
  }
}