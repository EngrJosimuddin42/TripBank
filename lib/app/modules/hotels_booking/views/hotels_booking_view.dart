import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../constants/app_strings.dart';
import '../../../widgets/custom_date_picker.dart';
import '../controllers/hotels_booking_controller.dart';


class HotelsBookingView extends GetView<HotelsBookingController> {
  const HotelsBookingView({super.key});

  // Available locations (Next Come From API )

  static const List<String> _locations = [
    'Paris, France',
    'Dubai, UAE',
    'New York, USA',
    'Tokyo, Japan',
    'Bangkok, Thailand',
    'Singapore',
    'London, UK',
  ];

  // Available room classes

  static const List<String> _roomClasses = [
    'Economy',
    'Standard',
    'Deluxe',
    'Suite',
    'Luxury',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildCombinedDateField(context),
              const SizedBox(height: 32),
              _buildLocationAndRoomsRow(context),
              const SizedBox(height: 32),
              _buildClassAndGuestsRow(),
              const SizedBox(height: 250),
              _buildSearchButton(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
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
                  onPressed: () {
                    controller.resetToInitialState();
                    Get.back();
                  },
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                ),
                Text(
                  AppStrings.bookHotelTickets,
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

  Widget _buildCombinedDateField(BuildContext context) {
    return Container(
      height: 100,
      width: 376,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFAE6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFECD08)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: InkWell(
                onTap: () => _showCustomCheckInPicker(context),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _buildDateColumn(AppStrings.checkInDate, controller.checkInDate),
                ),
              ),
            ),
            const VerticalDivider(
              color: Color(0xFF818898),
              thickness: 1,
              width: 1,
              indent: 12,
              endIndent: 12,
            ),
            Expanded(
              child: InkWell(
                onTap: () => _showCustomCheckOutPicker(context),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _buildDateColumn(AppStrings.checkOutDate, controller.checkOutDate),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCustomCheckInPicker(BuildContext context) async {
    final selected = await showDialog<DateTime>(
      context: context,
      builder: (context) => CustomDatePicker(
        initialDate: controller.checkInDate.value,
        firstDate: DateTime.now(),
        lastDate: DateTime(2026, 12, 31),
        onDateSelected: (date) {},
      ),
    );

    if (selected != null) {
      controller.checkInDate.value = selected;
      if (controller.checkOutDate.value.isBefore(selected)) {
        controller.checkOutDate.value = selected.add(const Duration(days: 1));
      }
    }
  }

  Future<void> _showCustomCheckOutPicker(BuildContext context) async {
    final selected = await showDialog<DateTime>(
      context: context,
      builder: (context) => CustomDatePicker(
        initialDate: controller.checkOutDate.value,
        firstDate: controller.checkInDate.value.add(const Duration(days: 1)),
        lastDate: DateTime(2026, 12, 31),
        onDateSelected: (date) {},
      ),
    );

    if (selected != null) {
      controller.checkOutDate.value = selected;
    }
  }

  Widget _buildDateColumn(String label, Rx<DateTime> date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: const Color(0xFF8C7104),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 6),
        Obx(() => Text(
          DateFormat('dd MMM, yyyy').format(date.value),
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF3A3A3A),
          ),
        )),
      ],
    );
  }

  Widget _buildLocationAndRoomsRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildSelectableField(
            label: AppStrings.location,
            value: controller.location,
            onTap: () => _showLocationBottomSheet(context),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildCounterField(
            label: AppStrings.rooms,
            count: controller.roomCount,
            onDecrement: () {
              if (controller.roomCount.value > 1) {
                controller.roomCount.value--;
              }
            },
            onIncrement: () => controller.roomCount.value++,
          ),
        ),
      ],
    );
  }

  Widget _buildClassAndGuestsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildDropdownField(
            label: AppStrings.preferredClass,
            value: controller.preferredClass,
            items: _roomClasses,
            onChanged: (val) {
              if (val != null) controller.preferredClass.value = val;
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildCounterField(
            label: AppStrings.guests,
            count: controller.guestCount,
            onDecrement: () {
              if (controller.guestCount.value > 1) {
                controller.guestCount.value--;
              }
            },
            onIncrement: () => controller.guestCount.value++,
          ),
        ),
      ],
    );
  }


  Widget _buildSelectableField({
    required String label,
    required RxString value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFAE6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFFECD08)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            Obx(() => Text(
              value.value,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFFB49206),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildCounterField({
    required String label,
    required RxInt count,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
  }) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFAE6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFECD08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: onDecrement,
                icon: const Icon(Icons.remove_circle_outline, color: Color(0xFFB49206)),
              ),
              Obx(() => Text(
                count.value.toString(),
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFB49206),
                ),
              )),
              IconButton(
                onPressed: onIncrement,
                icon: const Icon(Icons.add_circle_outline, color: Color(0xFFB49206)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required RxString value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFAE6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFECD08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              color: const Color(0xFF8C7104),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          Expanded(
            child: Obx(() => DropdownButton<String>(
              value: value.value,
              isExpanded: true,
              underline: const SizedBox(),
              items: items
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: onChanged,
              style: GoogleFonts.poppins(
                color: const Color(0xFF000000),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              dropdownColor: const Color(0xFFFFFFFF),
              icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFB49206)),
            )),
          ),
        ],
      ),
    );
  }


  Widget _buildSearchButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: Obx(() {
        final fromSaved = controller.isFromSaved.value;
        return ElevatedButton.icon(
          onPressed: () {
            controller.searchHotels();
          },
          label: Text(
            fromSaved ? 'OK' : AppStrings.search,
            style: GoogleFonts.poppins(
              color: const Color(0xFF6B5603),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFECD08),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
        );
      }),
    );
  }



  void _showLocationBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Location',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ..._locations.map((loc) => ListTile(
                title: Text(
                  loc,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  controller.location.value = loc;
                  Get.back();
                },
              )),
            ],
          ),
        );
      },
    );
  }
}