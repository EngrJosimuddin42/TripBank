import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/car_location_search_dialog.dart';
import '../../../widgets/custom_date_picker.dart';
import '../../../widgets/snackbar_helper.dart';
import '../controllers/cars_booking_controller.dart';

class CarsBookingView extends GetView<CarsBookingController> {
  const CarsBookingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: _buildAppBar(),
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
              Obx(() {
                bool showReturnOptions = controller.selectedTripType.value == 'Round Way' &&
                    controller.returnDate.value != null;

                return AnimatedSize(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  child: showReturnOptions ? _buildReturnSection() : const SizedBox.shrink(),
                );
              }),

              const SizedBox(height: 90),
              _buildSearchButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  //APP BAR

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
                  icon: const Icon(
                      Icons.arrow_back_ios_new, color: Colors.black),
                ),
                Text(
                  'Book a Car',
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

  // TRIP TYPE TABS

  Widget _buildTripTypeSection() {
    return Center(
      child: Container(
        width: 250,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFFECD08), width: 1.5),
        ),
        child: Obx(() =>
            Row(
              children: controller.tripTypes.map((type) {
                final isSelected = controller.selectedTripType.value == type;
                return Expanded(
                  child: GestureDetector(
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
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: isSelected
                                  ? const Color(0xFFD4A017)
                                  : Colors.black,
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
                  ),
                );
              }).toList(),
            )),
      ),
    );
  }

  // LOCATION SECTION

  Widget _buildLocationSection({required bool isDeparture}) {
    return Obx(() {
      final fromLocation = isDeparture
          ? controller.ArrivingFromLocation.value
          : controller.returnFromLocation.value;
      final fromCode = isDeparture
          ? controller.ArrivingFromCode.value
          : controller.returnFromCode.value;
      final fromTerminal = isDeparture
          ? controller.ArrivingFromTerminal.value
          : controller.returnFromTerminal.value;
      final fromCountry = isDeparture
          ? controller.ArrivingFromCountry.value
          : controller.returnFromCountry.value;

      final toLocation = isDeparture
          ? controller.ArrivingToLocation.value
          : controller.returnToLocation.value;
      final toCode = isDeparture
          ? controller.ArrivingToCode.value
          : controller.returnToCode.value;
      final toTerminal = isDeparture
          ? controller.ArrivingToTerminal.value
          : controller.returnToTerminal.value;
      final toCountry = isDeparture
          ? controller.ArrivingToCountry.value
          : controller.returnToCountry.value;

      final fromLabel = isDeparture ? 'From' : 'Pickup';
      final toLabel = isDeparture ? 'To' : 'Drop Off';

      return Row(
        children: [
          Expanded(
            child: _buildLocationCard(
              city: fromLocation,
              code: fromCode,
              terminal: fromTerminal,
              country: fromCountry,
              label: fromLabel,
              onTap: () => _showLocationPicker(true, isDeparture),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: isDeparture
                ? controller.swapArrivingLocations
                : controller.swapReturnLocations,
            child: Container(
              height: 44,
              width: 44,
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
          const SizedBox(width: 8),
          Expanded(
            child: _buildLocationCard(
              city: toLocation,
              code: toCode,
              terminal: toTerminal,
              country: toCountry,
              label: toLabel,
              onTap: () => _showLocationPicker(false, isDeparture),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildLocationCard({
    required String city,
    required String code,
    required String label,
    required VoidCallback onTap,
    String? terminal,
    String? country,
  }) {
    final bool isEmpty = city.isEmpty;

    String placeholderText;
    if (label.toLowerCase() == 'from') {
      placeholderText = 'Select You Received location';
    } else if (label.toLowerCase() == 'to') {
      placeholderText = 'Dropping Point';
    } else if (label.toLowerCase() == 'pickup') {
      placeholderText = 'Select Origin';
    } else if (label.toLowerCase().contains('drop')) {
      placeholderText = 'Select Destination';
    } else {
      placeholderText = 'Select Location';
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 110,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFAE6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFFECD08), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isEmpty)
              Column(
                children: [
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    placeholderText,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    city,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (terminal != null && terminal.isNotEmpty)
                    Text(
                      terminal,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (country != null && country.isNotEmpty)
                        Text(
                          country,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFFD4A017),
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (country != null && country.isNotEmpty)
                        const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFECD08),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          code,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _showLocationPicker(bool isFrom, bool isDeparture) async {
    String dialogTitle = isFrom ? "Select Origin" : "Select Destination";

    final result = await showDialog(
      context: Get.context!,
      builder: (context) => LocationSearchDialog(title: dialogTitle),
    );

    if (result != null && result is LocationData) {
      if (isDeparture) {
        if (isFrom) {
          controller.ArrivingFromLocation.value = result.city;
          controller.ArrivingFromCode.value = result.code;
          controller.ArrivingFromTerminal.value = result.terminal;
          controller.ArrivingFromCountry.value = result.country;
        } else {
          controller.ArrivingToLocation.value = result.city;
          controller.ArrivingToCode.value = result.code;
          controller.ArrivingToTerminal.value = result.terminal;
          controller.ArrivingToCountry.value = result.country;
        }
      } else {
        if (isFrom) {
          controller.returnFromLocation.value = result.city;
          controller.returnFromCode.value = result.code;
          controller.returnFromTerminal.value = result.terminal;
          controller.returnFromCountry.value = result.country;
        } else {
          controller.returnToLocation.value = result.city;
          controller.returnToCode.value = result.code;
          controller.returnToTerminal.value = result.terminal;
          controller.returnToCountry.value = result.country;
        }
      }
    }
  }

  //  TIME OF JOURNEY
  Widget _buildTimeOfJourney({required bool isDeparture}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isDeparture ? 'Pickup Time' : 'Return Time',
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 12,
          childAspectRatio: 3.4,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          children: controller.timeOptions.map((time) {
            return _buildTimeOption(time, isDeparture);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTimeOption(String time, bool isDeparture) {
    return Obx(() {
      final isSelected = isDeparture
          ? controller.ArrivingPreferredTimes.contains(time)
          : controller.returnPreferredTimes.contains(time);

      return GestureDetector(
        onTap: () {
          if (isDeparture) {
            controller.ArrivingPreferredTimes.clear();
            controller.ArrivingPreferredTimes.add(time);
          } else {
            controller.returnPreferredTimes.clear();
            controller.returnPreferredTimes.add(time);
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFFFECD08) : Colors.grey
                      .shade400,
                  width: 2.2,
                ),
              ),
              child: isSelected
                  ? const Center(
                child: CircleAvatar(
                  radius: 6,
                  backgroundColor: Color(0xFFFECD08),
                ),
              )
                  : null,
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                time,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    });
  }

  // SET TIME BUTTON

  Widget _buildSetTimeButton({required bool isDeparture}) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => _showTimeSelectionSheet(isDeparture: isDeparture),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: const BorderSide(color: Color(0xFFFECD08), width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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

  //TIME SELECTION BOTTOM SHEET

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
          children: [
            Text(
              isDeparture ? 'Select Pickup Time' : 'Select Return Time',
              style: GoogleFonts.inter(
                  fontSize: 20, fontWeight: FontWeight.w700),
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
                        ? controller.ArrivingSelectedTimeSlots.contains(time)
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
                          color: isSelected ? const Color(0xFFFECD08) : Colors
                              .white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected ? const Color(0xFFFECD08) : Colors
                                .grey[300]!,
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            time,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
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
                      ? controller.ArrivingSelectedTimeSlots
                      : controller.returnSelectedTimeSlots;
                  if (selectedSlots.isEmpty) {
                    SnackbarHelper.showWarning(
                        'Please select at least one time slot to continue.',
                        title: 'Select Time'
                    );
                  } else {
                    Get.back();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFECD08),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
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
        slots.add(
            '${displayHour.toString().padLeft(2, '0')}:$displayMinute $period');
      }
    }
    return slots;
  }

  //DATE SECTION

  Widget _buildDateSection() {
    return Builder(
      builder: (context) => Obx(() {
        bool isLocationFilled = controller.ArrivingFromLocation.value.isNotEmpty &&
            controller.ArrivingToLocation.value.isNotEmpty;

        bool isTimeSelected = controller.ArrivingPreferredTimes.isNotEmpty ||
            controller.ArrivingSelectedTimeSlots.isNotEmpty;

        bool canShowAddReturnButton = isLocationFilled && isTimeSelected;

            if (controller.selectedTripType.value == 'One Way') {
              return GestureDetector(
                onTap: () => _selectDate(true, context),
                child: _buildSingleDateCard(
                  'Pickup Date',
                  controller.ArrivingDate.value,
                ),
              );
            }

            return Column(
              children: [
                Container(
                  height: 90,
                  width: double.infinity,
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
                          onTap: () => _selectDate(true, context),
                          child: _buildDateColumn('Pickup', controller.ArrivingDate.value),
                        ),
                      ),
                      Container(width: 1.5, height: 40, color: const Color(0xFFFECD08)),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _selectDate(false, context),
                          child: _buildDateColumn(
                              'Return',
                              controller.returnDate.value,
                              showDashIfNull: true
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                if (controller.selectedTripType.value == 'Round Way' && controller.returnDate.value == null)
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: canShowAddReturnButton ? 1.0 : 0.0,
                    child: canShowAddReturnButton
                        ? Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: _buildAddReturnButton(),
                    )
                        : const SizedBox(height: 0),
                  ),
              ],
            );
      }),
    );
  }

  Widget _buildSingleDateCard(String label, DateTime? date) {
    return Container(
      height: 76,
      width: double.infinity,
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
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: const Color(0xFFD4A017),
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _formatDateShort(date),
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: date == null ? Colors.grey[500] : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateColumn(String label, DateTime? date,
      {bool showDashIfNull = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: const Color(0xFFD4A017),
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          date == null
              ? (showDashIfNull ? '------' : 'Select date')
              : _formatDateShort(date),
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: date == null ? Colors.grey[500] : Colors.black,
          ),
        ),
      ],
    );
  }

  //  RETURN SECTION

  Widget _buildReturnSection() {
    bool showReturnOptions = controller.selectedTripType.value == 'Round Way' &&
        controller.returnDate.value != null;

    if (!showReturnOptions) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        _buildLocationSection(isDeparture: false),
        const SizedBox(height: 20),
        _buildTimeOfJourney(isDeparture: false),
        const SizedBox(height: 20),
        _buildSetTimeButton(isDeparture: false),
      ],
    );
  }



  Widget _buildAddReturnButton() {
    return Builder(
      builder: (context) =>
          Center(
            child: TextButton.icon(
              onPressed: () => _selectDate(false, context),
              icon: const Icon(Icons.add, color: Color(0xFFD4A017), size: 18),
              label: Text(
                'ADD RETURN DATE',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFD4A017),
                ),
              ),
            ),
          ),
    );
  }

  // SEARCH BUTTON

  Widget _buildSearchButton() {
    return Obx(() {
      final isFromSaved = controller.isFromSaved.value;
      final buttonText = isFromSaved ? 'OK' : 'Search Cars';


      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: controller.searchCars,
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
              Text(
                buttonText,
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
    });
  }

  // DATE PICKER

  Future<void> _selectDate(bool isPickup, BuildContext context) async {
    final DateTime initial = isPickup
        ? (controller.ArrivingDate.value ?? DateTime.now().add(const Duration(days: 1)))
        : (controller.returnDate.value ??
        controller.ArrivingDate.value?.add(const Duration(days: 7)) ??
        DateTime.now().add(const Duration(days: 8)));

    final DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (dialogContext) => CustomDatePicker(
        initialDate: initial,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
        onDateSelected: (selectedDate) {},
      ),
    );

    if (picked == null) return;

    if (isPickup) {
      controller.ArrivingDate.value = picked;

      if (controller.selectedTripType.value == 'Round Way' &&
          controller.returnDate.value != null &&
          controller.returnDate.value!.isBefore(picked)) {
        controller.returnDate.value = null;
      }
    } else {
      final wasReturnDateNull = controller.returnDate.value == null;

      if (controller.ArrivingDate.value != null &&
          picked.isBefore(controller.ArrivingDate.value!)) {
        SnackbarHelper.showWarning(
            'Return date cannot be before pickup date.',
            title: 'Invalid Selection'
        );
        return;
      }

      controller.returnDate.value = picked;
      if (controller.selectedTripType.value == 'Round Way' && wasReturnDateNull) {

        // Return Pickup = Arriving To

        controller.returnFromLocation.value = controller.ArrivingToLocation.value;
        controller.returnFromCode.value      = controller.ArrivingToCode.value;
        controller.returnFromTerminal.value  = controller.ArrivingToTerminal.value;
        controller.returnFromCountry.value   = controller.ArrivingToCountry.value;

        // Return Drop-off = Arriving From

        controller.returnToLocation.value    = controller.ArrivingFromLocation.value;
        controller.returnToCode.value        = controller.ArrivingFromCode.value;
        controller.returnToTerminal.value    = controller.ArrivingFromTerminal.value;
        controller.returnToCountry.value     = controller.ArrivingFromCountry.value;
        SnackbarHelper.showSuccess(
            'Return trip: ${controller.ArrivingToLocation.value} → ${controller.ArrivingFromLocation.value}',
            title: 'Return Locations Filled'
        );
      }
    }
  }

  //  DATE FORMATTER

  String _formatDateShort(DateTime? date) {
    if (date == null) return '------';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]}, ${date.year}';
  }
}