import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/my_trips_controller.dart';
import 'my_trip_details.dart';

class MyTripsView extends GetView<MyTripsController> {
  const MyTripsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'My Trips',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Manage and see all your tour and ticket',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
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
                borderRadius: BorderRadius.circular(25),
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
            child: Obx(() => ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.filteredTrips.length,
              itemBuilder: (context, index) {
                final trip = controller.filteredTrips[index];
                return _buildTripCard(trip);
              },
            )),
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
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFDD835) : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTripCard(Map<String, dynamic> trip) {
    final hasTag = trip['tag'] != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          if (hasTag)
          // Card with tag - Screenshot 1 layout
            _buildCardWithTag(trip)
          else
          // Card without tag - Screenshot 2 layout
            _buildCardWithoutTag(trip),
        ],
      ),
    );
  }


  Widget _buildCardWithTag(Map<String, dynamic> trip) {
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
                  children: const [
                    Icon(
                      Icons.auto_awesome,
                      size: 16,
                      color: Colors.black,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Next Adventure',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Paid badge
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
                      'Paid',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.green[800],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.check_circle,
                      size: 16,
                      color: Colors.green[700],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Main content
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
                      trip['title'] ?? 'Dubai Business Trip',
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
                        Text(
                          trip['location'] ?? 'Dubai, UAE',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
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
                          trip['detailedDates'] ?? '12-17 Dec 2025 • 5 days',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Services chips
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ...?trip['services']?.map<Widget>((service) {
                          Widget finalIcon;
                          Color color;
                          Color bgColor;

                          switch (service) {
                            case 'Flight':
                              color = Colors.blue[700]!;
                              bgColor = Colors.blue.withOpacity(0.1);
                              finalIcon = Image.asset('assets/images/flight_trip.png', width: 16, height: 16);
                              break;
                            case 'Hotel':
                              color = Colors.purple[700]!;
                              bgColor = Colors.purple.withOpacity(0.1);
                              finalIcon = Image.asset('assets/images/hotel_trip.png', width: 16, height: 16);
                              break;
                            case 'Tour':
                              color = Colors.pink[700]!;
                              bgColor = Colors.pink.withOpacity(0.1);
                              finalIcon = Image.asset('assets/images/tour_trip.png', width: 16, height: 16);
                              break;
                            case 'Car': // এই অংশটি নিশ্চিত করুন
                              color = Colors.orange[700]!;
                              bgColor = Colors.orange.withOpacity(0.1);
                              finalIcon = Image.asset('assets/images/car_trip.png', width: 16, height: 16);
                              break;
                            default:
                              color = Colors.grey;
                              bgColor = Colors.grey.withOpacity(0.1);
                              finalIcon = const Icon(Icons.circle, size: 16, color: Colors.grey);
                          }

                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                finalIcon,
                                const SizedBox(width: 6),
                                Text(
                                  service,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: color,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),

                        // Travelers chip
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.indigo.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset('assets/images/person_trip.png'),
                              const SizedBox(width: 6),
                              Text(
                                '${trip['travelers'] ?? 2} travelers',
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
                  trip['image'] ?? 'https://images.unsplash.com/photo-1518684079-3c830dcef090?w=400', // Dubai skyline fallback
                  width: 110,
                  height: 160,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),

        Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Color(0xFFFEF3C6),
                width: 1.5,
                style: BorderStyle.solid,
              ),
            ),
          ),
        ),

        const SizedBox(height:16),

        // Bottom
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child:
                GestureDetector(
                  onTap: () {
                    controller.selectTrip(trip);

                    final List services = trip['services'] ?? [];

                    if (services.isEmpty) {
                      Get.snackbar(
                        'No Services',
                        'This trip has no services',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      return;
                    }
                    Get.toNamed('/my-bookings');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDD835),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
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

              const SizedBox(width: 12),

              // ২. View
              GestureDetector(
                onTap: () {
                  controller.selectTrip(trip);
                  Get.to(() => const MyTripDetailsView());
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: const [
                      Text(
                        'View',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward, color: Colors.orange, size: 18),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCardWithoutTag(Map<String, dynamic> trip) {
    // Check if trip is canceled
    final isCanceled = trip['status'] == 'Canceled';

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // বামে ইমেজ (ইমেজ সাইজ এবং রাউন্ডেড কর্নার ঠিক করা হয়েছে)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    Image.network(
                      trip['image'],
                      width: 90,
                      height: 110,
                      fit: BoxFit.cover,
                    ),
                    // Gray overlay for canceled trips
                    if (isCanceled)
                      Container(
                        width: 90,
                        height: 110,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // মাঝখানে কন্টেন্ট
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip['title'],
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
                        Text(
                          trip['location'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Image.asset('assets/images/calendar_trip.png'),
                        const SizedBox(width: 4),
                        Text(
                          trip['dates'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Status Badge - Dynamic based on trip status
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isCanceled
                            ? Colors.red[50]
                            : const Color(0xFFE3F2FD),
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
                            isCanceled ? 'Canceled' : 'Upcoming',
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
          // নিচের সেকশন: সার্ভিস আইকন + ট্রাভেলার + View বাটন
          Row(
            children: [
              // ১. সার্ভিস আইকনগুলো (ছোট এবং রাউন্ডেড)
              // Show all services for both canceled and non-canceled trips
              ...trip['services'].map<Widget>((service) {
                Widget finalIcon;
                Color bgColor;
                switch (service) {
                  case 'Flight':
                    bgColor = Colors.blue;
                    finalIcon = Image.asset('assets/images/flight_trip.png', width: 16, height: 16);
                    break;
                  case 'Hotel':
                    bgColor = Colors.purple;
                    finalIcon = Image.asset('assets/images/hotel_trip.png', width: 16, height: 16);
                    break;
                  case 'Car':
                    bgColor = Colors.orange;
                    finalIcon = Image.asset('assets/images/car_trip.png', width: 16, height: 16);
                    break;
                  case 'Tour':
                    bgColor = Colors.pink;
                    finalIcon = Image.asset('assets/images/tour_trip.png', width: 16, height: 16);
                    break;
                  default:
                    bgColor = Colors.grey;
                    finalIcon = const Icon(Icons.circle, size: 16, color: Colors.white);
                }
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isCanceled
                        ? Colors.grey.withOpacity(0.1)
                        : bgColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Opacity(
                    opacity: isCanceled ? 0.5 : 1.0,
                    child: finalIcon,
                  ),
                );
              }).toList(),

              // ২. ট্রাভেলার চিপ
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isCanceled
                      ? Colors.grey.withOpacity(0.1)
                      : Colors.indigo.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Opacity(
                      opacity: isCanceled ? 0.5 : 1.0,
                      child: Image.asset('assets/images/person_trip.png'),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${trip['travelers']}',
                      style: TextStyle(
                        color: isCanceled ? Colors.grey[600] : Colors.indigo[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // ৩. View বাটন
              GestureDetector(
                onTap: () {
                  controller.selectTrip(trip);
                  Get.to(() => const MyTripDetailsView());
                },
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
}