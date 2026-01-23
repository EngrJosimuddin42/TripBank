import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/cars_booking_controller.dart';
import '../../../models/car_model.dart';

class SearchAllCarsView extends GetView<CarsBookingController> {
  const SearchAllCarsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: Obx(() => _buildCarsList()),
          ),
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
                  'All Cars',
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

  // FILTER BAR

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ElevatedButton.icon(
            onPressed: _showFilterBottomSheet,
            icon: const Icon(Icons.tune, color: Colors.black, size: 16),
            label: Text(
              'Filter',
              style: GoogleFonts.inter(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFECD08),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
          ),
          const SizedBox(height: 20),
          _buildCategoryTabs(),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Obx(() => Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildTabItem("All", controller.totalCount),
        const SizedBox(width: 8),
        _buildTabItem("AC", controller.acCount),
        const SizedBox(width: 8),
        _buildTabItem("Non-AC", controller.nonAcCount),
      ],
    ));
  }

  Widget _buildTabItem(String text, int count) {
    return Obx(() {
      final isActive = controller.selectedCategory.value == text;

      return GestureDetector(
        onTap: () => controller.updateCategory(text),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFFECD08) : const Color(0xFFFFF9E5),
            borderRadius: BorderRadius.circular(25),
            border: isActive
                ? null
                : Border.all(color: const Color(0xFFFEDE5A).withValues(alpha: 0.5)),
          ),
          child: Text(
            "$text ($count)",
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
      );
    });
  }

  // CARS LIST

  Widget _buildCarsList() {
    if (controller.isLoadingCars.value) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFFECD08)),
      );
    }

    if (controller.searchResults.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: controller.searchResults.length,
      itemBuilder: (context, index) {
        final car = controller.searchResults[index];
        return _buildCarCard(car);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.directions_car, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No cars found',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // CAR CARD

  Widget _buildCarCard(Car car) {
    return Obx(() {
      final isFavorite = controller.isCarFavorite(car.id);
      final days = controller.calculateBookingDays();
      final totalPrice = car.pricePerDay * days;

      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCarImageSection(car, isFavorite),
            const SizedBox(height: 16),
            _buildCarFeatures(car),
            const SizedBox(height: 16),
            _buildCarFooter(car, totalPrice),
          ],
        ),
      );
    });
  }

  Widget _buildCarImageSection(Car car, bool isFavorite) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: car.imageUrl.isNotEmpty
                  ? Image.network(
                car.imageUrl,
                width: 140,
                height: 140,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {

                  // Network image failed, show asset image

                  return Image.asset(
                    'assets/images/car_image.jpg',
                    width: 140,
                    height: 140,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {

                      // Asset also failed, show icon

                      return Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.directions_car,
                          size: 60,
                          color: Colors.grey[400],
                        ),
                      );
                    },
                  );
                },
              )
                  : Image.asset(
                'assets/images/car_image.jpg',
                width: 140,
                height: 140,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {

                  // Asset failed, show icon

                  return Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.directions_car,
                      size: 60,
                      color: Colors.grey[400],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Car type + Favorite button row

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      "${car.brand} ${car.model} ",
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Favorite button

                  InkWell(
                    onTap: () => controller.toggleCarFavorite(car.id),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      size: 20,
                      color: isFavorite ? Colors.red : Colors.black54,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text("${car.types}",style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87)),

              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "\$${car.pricePerDay.toStringAsFixed(0)}",
                    style: GoogleFonts.inter(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      height: 1,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      "/day",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCarFeatures(Car car) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildFeatureItem(Icons.people_outline, "${car.seats}"),
            const SizedBox(width: 40),
            _buildFeatureItem(Icons.speed_outlined, car.transmission),
          ],
        ),

        const SizedBox(height: 10),
        Row(
          children: [
            _buildFeatureItem(Icons.sync, "Unlimited mileage"),
            const SizedBox(width: 12),
            _buildFeatureItem(Icons.directions_bus_outlined, "Shuttle service"),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureItem(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: Colors.black54),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildCarFooter(Car car, double totalPrice) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Company Badge
        _buildBadge(car.brand),
        const SizedBox(width: 10),
        // Rating Badge
        _buildBadge(
          controller.getRatingPercentage(car.rating),
        ),
        const SizedBox(width: 10),
        // Rating Text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                controller.getRatingText(car.rating),
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "(${car.reviews} ratings)",
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),

        // Reserve Button

        GestureDetector(
          onTap: () => controller.selectCar(car),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFECD08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "Reserve",
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(String text, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF8B7355),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: Colors.white),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // FILTER BOTTOM SHEET

  void _showFilterBottomSheet() {
    controller.initTempFilters();
    Get.bottomSheet(
      Container(
        height: Get.height * 0.85,
        decoration: const BoxDecoration(
          color: Color(0xFFFFFBEA),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            _buildFilterHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: _buildFilterContent(),
              ),
            ),
            _buildApplyButton(),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildFilterHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: Color(0xFFFEDE5A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  controller.cancelFilters();
                  Get.back();
                },
                icon: const Icon(Icons.arrow_back_ios),
              ),
              Text(
                'Filters',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          OutlinedButton(
            onPressed: () {
              controller.resetFilters();
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              side: const BorderSide(color: Colors.black54),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'RESET',
              style: GoogleFonts.inter(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...controller.filterGroups.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _buildFilterSection(
              entry.key,
              'From',
              entry.value.map((item) {
                return _buildFilterCheckboxWithPrice(
                    item['name'],
                    item['price'] as int
                );
              }).toList(),
            ),
          );
        }),
        _buildFilterSection(
          'Price',
          '',
          controller.priceRangeOptions.map((range) {
            return _buildFilterCheckbox(range);
          }).toList(),
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildFilterSection(String title, String subtitle, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            if (subtitle.isNotEmpty)
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }


  Widget _buildFilterCheckbox(String title) {
    return InkWell(
      onTap: () => controller.toggleFilter(title),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            SizedBox(
              height: 20,
              width: 20,
              child: Obx(() => Checkbox(
                value: controller.tempFilters.contains(title),
                onChanged: (v) => controller.toggleFilter(title),
                activeColor: const Color(0xFFFECD08),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
              )),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(fontSize: 14, color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterCheckboxWithPrice(String title, int price) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  height: 20,
                  width: 20,
                  child: Obx(() => Checkbox(
                    value: controller.tempFilters.contains(title),
                    onChanged: (v) => controller.toggleFilter(title),
                    activeColor: const Color(0xFFFECD08),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                  )),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '\$ $price',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplyButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              controller.applyTempFilters();
              Get.back();
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
              'Apply filter',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}