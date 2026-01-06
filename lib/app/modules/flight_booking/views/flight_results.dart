import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/flight_booking_controller.dart';
import '../../../models/flight_model.dart';

class FlightResultsView extends GetView<FlightBookingController> {
  const FlightResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
        ),
        title: Text(
          'Available Flights',
          style: GoogleFonts.inter(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton.icon(
              onPressed: _showFilterSheet,
              icon: const Icon(Icons.tune, color: Colors.black, size: 20),
              label: Text(
                'Filter',
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFFECD08),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoadingFlights.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFFECD08)),
          );
        }

        if (controller.searchResults.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.flight_takeoff, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No flights found',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.searchResults.length,
          itemBuilder: (context, index) {
            final flight = controller.searchResults[index];
            return _buildFlightCard(flight);
          },
        );
      }),
    );
  }

  Widget _buildFlightCard(Flight flight) {
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Airline Header
                Row(
                  children: [
                    // Airline Logo
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFF0066FF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.flight,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Airline Name & Code
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            flight.airline,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            flight.flightNumber,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${flight.price.toStringAsFixed(0)}',
                          style: GoogleFonts.inter(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '/person',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Flight Times
                Row(
                  children: [
                    // Departure
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            flight.fromCode,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            controller.formatTime(flight.departureTime),
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Plane Icon
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(
                        Icons.flight,
                        color: Colors.grey[400],
                        size: 20,
                      ),
                    ),

                    // Arrival
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            flight.toCode,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            controller.formatTime(flight.arrivalTime),
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Duration
                Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      flight.duration,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Book Flight Button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey[200]!,
                  width: 1,
                ),
              ),
            ),
            child: ElevatedButton(
              onPressed: () => controller.selectFlight(flight),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFECD08),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Text(
                'Book Flight',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet() {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.9,
        decoration: const BoxDecoration(
          color: Color(0xFFFECD08),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                  ),
                  Expanded(
                    child: Text(
                      'Filter',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  TextButton(
                    onPressed: controller.resetFilters,
                    child: Text(
                      'Reset',
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Stops
                      _buildSectionTitle('STOPS'),
                      const SizedBox(height: 12),
                      _buildStopsRadio(),

                      const SizedBox(height: 24),

                      // Airlines
                      _buildSectionTitle('AIRLINES'),
                      const SizedBox(height: 12),
                      _buildAirlinesCheckboxes(),

                      const SizedBox(height: 24),

                      // Price Range
                      _buildSectionTitle('PRICE RANGE'),
                      const SizedBox(height: 8),
                      _buildPriceRange(),

                      const SizedBox(height: 24),

                      // Arrival Times
                      _buildSectionTitle('ARRIVAL IN ${controller.departureToLocation.value.toUpperCase()}'),
                      const SizedBox(height: 12),
                      _buildTimeSlots('arrival'),

                      const SizedBox(height: 24),

                      // Departure Times
                      _buildSectionTitle('DEPARTURE FROM ${controller.departureFromLocation.value.toUpperCase()}'),
                      const SizedBox(height: 12),
                      _buildTimeSlots('departure'),

                      const SizedBox(height: 24),

                      // Preferred Class
                      _buildSectionTitle('PREFERRED CLASS'),
                      const SizedBox(height: 12),
                      _buildClassOptions(),

                      const SizedBox(height: 24),

                      // Facility and Baggage
                      _buildSectionTitle('FACILITY AND BAGGAGE'),
                      const SizedBox(height: 12),
                      _buildFacilities(),

                      const SizedBox(height: 24),

                      // Total Travel Time
                      _buildSectionTitle('TOTAL TRAVEL TIME'),
                      const SizedBox(height: 8),
                      _buildTravelTime(),

                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),

            // Apply Button
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.applyFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFECD08),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Apply Filter',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      isDismissible: true,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: Colors.grey[600],
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildStopsRadio() {
    final stops = ['0+', '1+', '2+'];
    return Obx(() => Row(
      children: stops.map((stop) {
        final value = stop.replaceAll('+', '');
        final isSelected = controller.selectedStops.contains(value);
        return Expanded(
          child: GestureDetector(
            onTap: () {
              controller.selectedStops.clear();
              controller.selectedStops.add(value);
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? const Color(0xFFFECD08) : Colors.grey[300]!,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? const Color(0xFFFECD08) : Colors.grey[400]!,
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFECD08),
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    stop,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    ));
  }

  Widget _buildAirlinesCheckboxes() {
    final airlines = [
      'All',
      'British Airways',
      'Air Newzealand',
      'Turkish Airlines',
      'Current air',
      'Asky Airlines',
    ];

    return Obx(() => Column(
      children: airlines.map((airline) {
        final isSelected = controller.selectedAirlines.contains(airline) ||
            (airline == 'All' && controller.selectedAirlines.isEmpty);
        return GestureDetector(
          onTap: () {
            if (airline == 'All') {
              controller.selectedAirlines.clear();
            } else {
              if (controller.selectedAirlines.contains(airline)) {
                controller.selectedAirlines.remove(airline);
              } else {
                controller.selectedAirlines.add(airline);
              }
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFFECD08) : Colors.white,
                    border: Border.all(
                      color: isSelected ? const Color(0xFFFECD08) : Colors.grey[400]!,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, size: 14, color: Colors.black)
                      : null,
                ),
                const SizedBox(width: 12),
                Text(
                  airline,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    ));
  }

  Widget _buildPriceRange() {
    return Obx(() => Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '\$${controller.priceRange.value.start.round()}',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '\$${controller.priceRange.value.end.round()}',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: const Color(0xFFFECD08),
            inactiveTrackColor: Colors.grey[300],
            thumbColor: const Color(0xFFFECD08),
            overlayColor: const Color(0xFFFECD08).withOpacity(0.2),
            trackHeight: 4,
          ),
          child: RangeSlider(
            values: controller.priceRange.value,
            min: 0,
            max: 5000,
            divisions: 50,
            onChanged: (values) => controller.priceRange.value = values,
          ),
        ),
      ],
    ));
  }

  Widget _buildTimeSlots(String type) {
    final times = [
      {'time': '00:00 - 05:59', 'label': 'Early morning', 'icon': Icons.nightlight},
      {'time': '06:00 - 11:59', 'label': 'Morning', 'icon': Icons.wb_sunny},
      {'time': '12:00 - 17:59', 'label': 'Afternoon', 'icon': Icons.wb_sunny_outlined},
      {'time': '18:00 - 23:59', 'label': 'Evening', 'icon': Icons.nights_stay},
    ];

    return Column(
      children: times.map((timeSlot) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFECD08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(timeSlot['icon'] as IconData, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      timeSlot['label'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      timeSlot['time'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildClassOptions() {
    final classes = [
      {'name': 'Economy', 'price': '\$ 320'},
      {'name': 'Premium economy', 'price': '\$ 4,325'},
      {'name': 'Business class', 'price': '\$ 5,027'},
      {'name': 'First class', 'price': '\$ 5,027'},
    ];

    return Column(
      children: classes.map((classType) {
        return GestureDetector(
          onTap: () => controller.selectedClass.value = classType['name']!,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: Row(
              children: [
                Obx(() {
                  final isSelected = controller.selectedClass.value == classType['name'];
                  return Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? const Color(0xFFFECD08) : Colors.grey[400]!,
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFECD08),
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                        : null,
                  );
                }),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    classType['name']!,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  classType['price']!,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFacilities() {
    final facilities = [
      {'name': 'Travel mode included', 'price': '\$ 2,358'},
      {'name': 'In-flight meal', 'price': '\$ 3,208'},
      {'name': 'In-flight wifi', 'price': '\$ 3,458'},
      {'name': 'No cancel fee', 'price': '\$ 3,654'},
      {'name': 'wifi included', 'price': '\$ 3,654'},
    ];

    final selectedFacilities = <String>[].obs;

    return Column(
      children: facilities.map((facility) {
        return Obx(() {
          final isSelected = selectedFacilities.contains(facility['name']);
          return GestureDetector(
            onTap: () {
              if (isSelected) {
                selectedFacilities.remove(facility['name']);
              } else {
                selectedFacilities.add(facility['name']!);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey[200]!),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFFECD08) : Colors.white,
                      border: Border.all(
                        color: isSelected ? const Color(0xFFFECD08) : Colors.grey[400]!,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, size: 14, color: Colors.black)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      facility['name']!,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    facility['price']!,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      }).toList(),
    );
  }

  Widget _buildTravelTime() {
    final maxTime = 30.0.obs;

    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Under ${maxTime.value.round()}h',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: const Color(0xFFFECD08),
            inactiveTrackColor: Colors.grey[300],
            thumbColor: const Color(0xFFFECD08),
            overlayColor: const Color(0xFFFECD08).withOpacity(0.2),
            trackHeight: 4,
          ),
          child: Slider(
            value: maxTime.value,
            min: 0,
            max: 30,
            divisions: 30,
            onChanged: (value) => maxTime.value = value,
          ),
        ),
      ],
    ));
  }
}