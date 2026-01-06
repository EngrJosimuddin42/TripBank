import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/custom_date_picker.dart';
import '../controllers/flight_booking_controller.dart';

class FlightBookingView extends GetView<FlightBookingController> {
  const FlightBookingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFECD08),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
        ),
        title: Text(
          'Book Flight Tickets',
          style: GoogleFonts.roboto(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildTripTypeSection(),

              const SizedBox(height: 20),
              _buildLocationSection(isDeparture: true),

              const SizedBox(height: 20),
              _buildTimeOfJourney(isDeparture: true),

              const SizedBox(height: 20),
              _buildSetTimeButton(isDeparture: true),

              const SizedBox(height: 20),
              _buildDateSection(),

              // ====== ADD MULTI-WAY SECTION HERE ======
              Obx(() {
                if (controller.selectedTripType.value == 'Multi Way') {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      // List of multi-way flights
                      ...controller.multiWayFlights.asMap().entries.map((entry) {
                        final index = entry.key;
                        final flight = entry.value;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFFAE6),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFFECD08), width: 1.5),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          // TODO: Open location picker for from
                                        },
                                        child: _buildLocationCard(
                                          city: flight.fromLocation,
                                          airport: '${flight.fromLocation} Airport',
                                          country: 'Nigeria', // বা ডায়নামিক করতে পারো পরে
                                          code: flight.fromCode,
                                          onTap: () {}, // ইতিমধ্যে GestureDetector আছে, তাই এটা empty রাখলেও চলবে
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    GestureDetector(
                                      onTap: () => controller.swapMultiWayLocations(index),
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFFECD08),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Image.asset(
                                          'assets/images/swap.png',
                                          height: 44,
                                          width: 44,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          // TODO: Open location picker for to
                                        },
                                        child: _buildLocationCard(
                                          city: flight.toLocation,
                                          airport: '${flight.toLocation} Airport',
                                          country: 'United Kingdom',
                                          code: flight.toCode,
                                          onTap: () {},
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                GestureDetector(
                                  onTap: () async {
                                    final DateTime? picked = await showDialog<DateTime>(
                                      context: Get.context!,
                                      builder: (context) => CustomDatePicker(
                                        initialDate: flight.date,
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.now().add(const Duration(days: 365)),
                                        onDateSelected: (_) {}, // not used here
                                      ),
                                    );
                                    if (picked != null) {
                                      controller.updateMultiWayFlight(index, date: picked);
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: const Color(0xFFFECD08)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Date',
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        Text(
                                          controller.formatDate(flight.date),
                                          style: GoogleFonts.inter(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const Icon(Icons.calendar_today, color: Color(0xFFD4A017), size: 20),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                if (controller.multiWayFlights.length > 1)
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton.icon(
                                      onPressed: () => controller.removeMultiWayFlight(index),
                                      icon: const Icon(Icons.delete_outline, color: Colors.red, size: 18),
                                      label: const Text('Remove', style: TextStyle(color: Colors.red)),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),

                      const SizedBox(height: 16),
                      if (controller.multiWayFlights.length < 5)
                        Center(
                          child: OutlinedButton.icon(
                            onPressed: controller.addMultiWayFlight,
                            icon: const Icon(Icons.add, color: Color(0xFFD4A017)),
                            label: Text(
                              'Add Another Flight',
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFD4A017),
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFFECD08), width: 1.5),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                    ],
                  );
                }
                return const SizedBox.shrink();
              }),

              // Return Flight Section
              Obx(() {
                if (controller.selectedTripType.value == 'Round Way') {
                  if (controller.returnDate.value == null) {
                    return _buildAddReturnButton();
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        _buildLocationSection(isDeparture: false),
                        const SizedBox(height: 20),
                        _buildTimeOfJourney(isDeparture: false),
                        const SizedBox(height: 20),
                        _buildSetTimeButton(isDeparture: false),
                        const SizedBox(height: 20),
                      ],
                    );
                  }
                }
                return const SizedBox.shrink();
              }),

              const SizedBox(height: 20),
              _buildTravellerClassSection(),

              const SizedBox(height: 80),
              _buildSearchButton(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTripTypeSection() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFECD08), width: 1.5),
      ),
      child: Row(
        children: controller.tripTypes.map((type) {
          return Expanded(
            child: Obx(() {
              final isSelected = controller.selectedTripType.value == type;
              return GestureDetector(
                onTap: () => controller.updateTripType(type),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        type,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected ? const Color(0xFFD4A017) : Colors.black,
                        ),
                      ),
                    ),
                    if (isSelected)
                      Positioned(
                        bottom: 0,
                        child: Container(
                          height: 2,
                          width: 60,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD4A017),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLocationSection({required bool isDeparture}) {
    return Row(
      children: [
        // From Location
        Expanded(
          child: Obx(() => _buildLocationCard(
            city: isDeparture
                ? controller.departureFromLocation.value
                : controller.returnFromLocation.value,
            airport: '${isDeparture ? controller.departureFromLocation.value : controller.returnFromLocation.value} Airport',
            country: isDeparture ? 'Abuja, Nigeria' : 'London, England',
            code: isDeparture
                ? controller.departureFromCode.value
                : controller.returnFromCode.value,
            onTap: () {
              // TODO: Open location picker
            },
          )),
        ),

        // Swap Button
        GestureDetector(
          onTap: isDeparture
              ? controller.swapDepartureLocations
              : controller.swapReturnLocations,
          child: Container(
            height: 44,
            width: 44,
            decoration: const BoxDecoration(
              color: Color(0xFFFECD08),
              shape: BoxShape.circle,
            ),
            child: Image.asset('assets/images/swap.png', height: 44, width: 44, fit: BoxFit.contain),
          ),
        ),

        // To Location
        Expanded(
          child: Obx(() => _buildLocationCard(
            city: isDeparture
                ? controller.departureToLocation.value
                : controller.returnToLocation.value,
            airport: '${isDeparture ? controller.departureToLocation.value : controller.returnToLocation.value} Airport',
            country: isDeparture ? 'London, England' : 'Abuja, Nigeria',
            code: isDeparture
                ? controller.departureToCode.value
                : controller.returnToCode.value,
            onTap: () {
              // TODO: Open location picker
            },
          )),
        ),
      ],
    );
  }

  Widget _buildLocationCard({
    required String city,
    required String airport,
    required String country,
    required String code,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 110,
        width: 160,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFAE6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFFECD08), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              city,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              airport,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              country,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFFD4A017),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildMultiWayLocationCard({
    required String label,
    required String city,
    required String code,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFECD08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600]),
          ),
          const SizedBox(height: 4),
          Text(
            city,
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          Text(
            '$code • Airport',
            style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSection() {
    return Obx(() {
      final isOneWayOrMulti = controller.selectedTripType.value == 'One Way' ||
          controller.selectedTripType.value == 'Multi Way';

      if (isOneWayOrMulti) {
        return GestureDetector(
          onTap: () => _selectDate(true),
          child: Center(
            child: Container(
              height: 76,
              width: 375,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFAE6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFECD08), width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Departure',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: const Color(0xFFD4A017),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatDateShort(controller.departureDate.value),
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      return Center(
        child: Container(
          height: 90,
          width: 375,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFAE6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFFECD08), width: 1.5),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectDate(true),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Departure',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: const Color(0xFFD4A017),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatDateShort(controller.departureDate.value),
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 1.5,
                height: 40,
                color: const Color(0xFFFECD08),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectDate(false),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Arrive',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: const Color(0xFFD4A017),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDateShort(controller.returnDate.value),
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildAddReturnButton() {
    return Center(
      child: TextButton.icon(
        onPressed: () => _selectDate(false),
        icon: const Icon(
          Icons.add,
          color: Color(0xFFD4A017),
          size: 18,
        ),
        label: Text(
          'ADD RETURN FLIGHT DATE',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFD4A017),
          ),
        ),
      ),
    );
  }



  Widget _buildTravellerClassSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFAE6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFECD08), width: 1.5),
      ),
      child: Obx(() => Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _showTravellerClassPicker,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Traveller(s)',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    controller.totalPassengers.toString().padLeft(2, '0'),
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 1.5,
            height: 40,
            color: const Color(0xFF818898).withValues(alpha: 0.8),
          ),
          Expanded(
            child: GestureDetector(
              onTap: _showTravellerClassPicker,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'PREFERRED CLASS',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: const Color(0xFFD4A017),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    controller.selectedClass.value,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }

  Widget _buildTimeOfJourney({required bool isDeparture}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Time of Journey',
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children: [
            Row(
              children: [
                Expanded(child: _buildTimeOption('Early morning', isDeparture)),
                const SizedBox(width: 12),
                Expanded(child: _buildTimeOption('Morning', isDeparture)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildTimeOption('Afternoon', isDeparture)),
                const SizedBox(width: 12),
                Expanded(child: _buildTimeOption('Evening', isDeparture)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeOption(String time, bool isDeparture) {
    return Obx(() {
      final isSelected = isDeparture
          ? controller.departurePreferredTimes.contains(time)
          : controller.returnPreferredTimes.contains(time);

      return GestureDetector(
        onTap: () {},
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFFFECD08) : Colors.grey,
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
              time,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSetTimeButton({required bool isDeparture}) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => _showTimeSelectionSheet(isDeparture: isDeparture),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: const BorderSide(color: Color(0xFFFECD08), width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: const Color(0xFFFFFAE6),
        ),
        child: Text(
          'Set Time',
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  void _showTimeSelectionSheet({required bool isDeparture}) {
    final List<String> timeSlots = _generateTimeSlots();

    Get.bottomSheet(
      Container(
        height: Get.height * 0.7,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              isDeparture ? 'Select Departure Time' : 'Select Return Time',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2.2,
                ),
                itemCount: timeSlots.length,
                itemBuilder: (context, index) {
                  final time = timeSlots[index];

                  return Obx(() {
                    final isSelected = isDeparture
                        ? controller.departureSelectedTimeSlots.contains(time)
                        : controller.returnSelectedTimeSlots.contains(time);

                    return GestureDetector(
                      onTap: () {
                        if (isDeparture) {
                          controller.toggleDepartureTimeSlot(time);
                        } else {
                          controller.toggleReturnTimeSlot(time);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFFECD08) : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected ? const Color(0xFFFECD08) : Colors.grey[300]!,
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            time,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final selectedSlots = isDeparture
                      ? controller.departureSelectedTimeSlots
                      : controller.returnSelectedTimeSlots;

                  if (selectedSlots.isEmpty) {
                    Get.snackbar(
                      'Select Time',
                      'Please select at least one time slot',
                      backgroundColor: Colors.orange[100],
                      colorText: Colors.orange[800],
                      duration: const Duration(seconds: 2),
                    );
                  } else {
                    Get.back();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFECD08),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'OK',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  List<String> _generateTimeSlots() {
    List<String> slots = [];
    for (int hour = 0; hour < 24; hour++) {
      for (int minute = 0; minute < 60; minute += 30) {
        final period = hour < 12 ? 'am' : 'pm';
        final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
        final displayMinute = minute.toString().padLeft(2, '0');
        slots.add('${displayHour.toString().padLeft(2, '0')}:$displayMinute $period');
      }
    }
    return slots;
  }

  Widget _buildSearchButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: controller.searchFlights,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFECD08),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search, color: Colors.black, size: 20),
            const SizedBox(width: 8),
            Text(
              'Search',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(bool isDeparture) async {
    final DateTime initialDate = isDeparture
        ? (controller.departureDate.value ?? DateTime.now().add(const Duration(days: 1)))
        : (controller.returnDate.value ??
        controller.departureDate.value?.add(const Duration(days: 7)) ??
        DateTime.now().add(const Duration(days: 8)));

    await showDialog(
      context: Get.context!,
      builder: (context) => CustomDatePicker(
        initialDate: initialDate,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
        onDateSelected: (DateTime picked) {
          if (isDeparture) {
            controller.departureDate.value = picked;
            if (controller.selectedTripType.value == 'Round Way' &&
                controller.returnDate.value != null &&
                controller.returnDate.value!.isBefore(picked)) {
              controller.returnDate.value = null;
            }
          } else {
            if (controller.departureDate.value != null &&
                picked.isBefore(controller.departureDate.value!)) {
              Get.snackbar(
                'Invalid Date',
                'Return date cannot be before departure date',
                backgroundColor: Colors.red[100],
                colorText: Colors.red[800],
              );
              return;
            }
            controller.returnDate.value = picked;
          }
        },
      ),
    );
  }

  String _formatDateShort(DateTime? date) {
    if (date == null) return '------';
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]}, ${date.year}';
  }

  void _showTravellerClassPicker() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Preferred Class',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFD4A017),
                ),
              ),
              const SizedBox(height: 16),
              Obx(() => Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildClassOption('Economy')),
                      const SizedBox(width: 12),
                      Expanded(child: _buildClassOption('Premium Economy')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildClassOption('Business')),
                      const SizedBox(width: 12),
                      Expanded(child: _buildClassOption('First Class')),
                    ],
                  ),
                ],
              )),
              const SizedBox(height: 24),
              Text(
                'Traveler (s)',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFD4A017),
                ),
              ),
              const SizedBox(height: 16),
              Obx(() => _buildPassengerCounter(
                label: 'Adult',
                subtitle: '12+ years',
                count: controller.adults.value,
                onIncrement: controller.incrementAdults,
                onDecrement: controller.decrementAdults,
              )),
              const SizedBox(height: 16),
              Obx(() => _buildPassengerCounter(
                label: 'Child',
                subtitle: '2-12 years',
                count: controller.children.value,
                onIncrement: controller.incrementChildren,
                onDecrement: controller.decrementChildren,
              )),
              const SizedBox(height: 16),
              Obx(() => _buildPassengerCounter(
                label: 'Infant',
                subtitle: 'Below 2 years',
                count: controller.infants.value,
                onIncrement: controller.incrementInfants,
                onDecrement: controller.decrementInfants,
              )),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFECD08),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Done',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildClassOption(String classType) {
    final isSelected = controller.selectedClass.value == classType;
    return GestureDetector(
      onTap: () => controller.selectedClass.value = classType,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFECD08) : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          classType,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.black : Colors.grey[700],
          ),
        ),
      ),
    );
  }

  Widget _buildPassengerCounter({
    required String label,
    required String subtitle,
    required int count,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFD4A017),
              ),
            ),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        Row(
          children: [
            GestureDetector(
              onTap: count > (label == 'Adult' ? 1 : 0) ? onDecrement : null,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: count > (label == 'Adult' ? 1 : 0) ? Colors.white : Colors.grey[300],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFFECD08),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.remove,
                  size: 18,
                  color: count > (label == 'Adult' ? 1 : 0) ? const Color(0xFFD4A017) : Colors.grey,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Text(
              count.toString(),
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 20),
            GestureDetector(
              onTap: count < 9 ? onIncrement : null,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: count < 9 ? const Color(0xFFFECD08) : Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add,
                  size: 18,
                  color: count < 9 ? Colors.black : Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}