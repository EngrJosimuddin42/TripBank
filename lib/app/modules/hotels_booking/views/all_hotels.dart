import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/hotel_model.dart';
import '../../../widgets/snackbar_helper.dart';
import '../controllers/hotels_booking_controller.dart';

class AllHotelsView extends GetView<HotelsBookingController> {
  const AllHotelsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildFilterButton(),
          Expanded(child: _buildHotelsList()),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final args = Get.arguments as Map<String, dynamic>?;
    final title = args?['title'] ?? 'Hotels in ${controller.location.value.split(',')[0]}';

    return PreferredSize(
      preferredSize: const Size.fromHeight(80),
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
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                ),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton.icon(
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 0,
          ),
        ),
      ),
    );
  }

  Widget _buildHotelsList() {
    final args = Get.arguments as Map<String, dynamic>?;
    final passedHotels = args?['hotels'] as List?;

    return Obx(() {
      final hotels = passedHotels ?? controller.searchResults;

      if (controller.isLoadingHotels.value && passedHotels == null) {
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFFFECD08)),
        );
      }

      if (hotels.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.hotel_outlined, size: 80, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'No hotels found',
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
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: hotels.length,
        itemBuilder: (context, index) {
          final hotel = hotels[index];
          return _buildHotelCard(hotel, index);
        },
      );
    });
  }

  Widget _buildHotelCard(hotel, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFAE6),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHotelImage(hotel.image, index),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHotelHeader(hotel),
                const SizedBox(height: 8),
                _buildRating(hotel),
                const SizedBox(height: 8),
                _buildDescription(hotel),
                const SizedBox(height: 12),
                _buildAddress(hotel),
                const SizedBox(height: 16),
                _buildSelectButton(hotel),
                const SizedBox(height: 12),
                _buildPriceSection(hotel),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotelImage(String imageUrl, int index) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
        placeholder: (context, url) =>
        const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) {
          final placeholders = [
            'assets/images/hotel_1.png',
            'assets/images/hotel_2.png',
          ];
          return Image.asset(
            placeholders[index % placeholders.length],
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }

  Widget _buildHotelHeader(hotel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            hotel.name,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF0A0A0A),
            ),
          ),
        ),
        if (hotel.discount > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              hotel.discountText,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRating(hotel) {
    return Row(
      children: [
        ...List.generate(5, (index) {
          return Icon(
            index < hotel.rating.floor() ? Icons.star : Icons.star_border,
            color: const Color(0xFFFF8904),
            size: 24,
          );
        }),
        const SizedBox(width: 8),
        Text(
          '${hotel.rating} (${hotel.reviews} Reviews)',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: const Color(0xFF4A5565),
          ),
        ),
      ],
    );
  }

  Widget _buildDescription(hotel) {
    return Text(
      hotel.description,
      style: GoogleFonts.inter(
        fontSize: 14,
        color: const Color(0xFF4A5565),
        height: 1.4,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildAddress(Hotel hotel) {
    return Row(
      children: [
        const Icon(Icons.location_on, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          hotel.address,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: const Color(0xFF364153),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectButton(Hotel hotel) {
    return SizedBox(
      width: 140,
      height: 48,
      child: ElevatedButton(
        onPressed: () => controller.navigateToHotelDetails(hotel),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFDC700),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: Text(
          'Select',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildPriceSection(hotel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${hotel.nights} room ${hotel.nights} night',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: const Color(0xFF4A5565),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          hotel.formattedPrice,
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: const Color(0xFFFF6900),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        Text(
          'Taxes incl.',
          style: GoogleFonts.inter(
            fontSize: 12,
            color: const Color(0xFF6A7282),
          ),
        ),
          const Spacer(),
          Obx(() {
            final isFav = controller.isHotelFavorite(hotel.id);
            return InkWell(
              onTap: () => controller.toggleHotelFavorite(hotel.id),
              child: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                size: 20,
                color: isFav ? Colors.red : const Color(0xFF9E9E9E),
              ),
            );
          }),
        ],
        ),
      ],
    );
  }

  void _showFilterBottomSheet() {
    final List<Map<String, dynamic>> priceRanges = [
      {'label': '\$0 - \$200', 'min': 0, 'max': 200, 'count': 200},
      {'label': '\$200 - \$500', 'min': 200, 'max': 500, 'count': 100},
      {'label': '\$500 - \$1,000', 'min': 500, 'max': 1000, 'count': 15},
      {'label': '\$1,000 - \$2,000', 'min': 1000, 'max': 2000, 'count': 12},
      {'label': '\$2,000 - \$5,000', 'min': 2000, 'max': 5000, 'count': 230},
    ];

    RxString selectedPriceRange = ''.obs;

    Get.bottomSheet(
      Container(
        width: Get.width * 0.92,
        height: Get.height * 0.92,
        decoration: const BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            _buildFilterHeader(),
            _buildSearchByNameCard(),
            Expanded(child: _buildFilterContent(priceRanges, selectedPriceRange)),
            _buildApplyButton(),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
    );
  }

  Widget _buildFilterHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              ),
              Text(
                'Filter results',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () => controller.selectedFilters.clear(),
            child: Text(
              'Reset',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchByNameCard() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF4C430),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Search by hotel name',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                hintText: 'eg. The Fullerton Hotel',
                hintStyle: GoogleFonts.inter(color: Colors.grey[600], fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterContent(List<Map<String, dynamic>> priceRanges, RxString selectedPriceRange) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildPriceRangeCard(priceRanges, selectedPriceRange),
          const SizedBox(height: 16),
          _buildViewOnMapCard(),
          const SizedBox(height: 16),
          _buildAccessibilityCard(),
          const SizedBox(height: 16),
          _buildMealPlansCard(),
          const SizedBox(height: 16),
          _buildPropertyTypeCard(),
          const SizedBox(height: 16),
          _buildTravellerExperienceCard(),
          const SizedBox(height: 16),
          _buildStarRatingCard(),
          const SizedBox(height: 16),
          _buildAmenitiesCard(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildPriceRangeCard(List<Map<String, dynamic>> priceRanges, RxString selectedPriceRange) {
    return _buildYellowHeaderCard(
      title: 'Price Range',
      child: Column(
        children: priceRanges.map((range) {
          return Obx(() => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: selectedPriceRange.value == range['label'],
                      onChanged: (v) {
                        selectedPriceRange.value = v == true ? range['label'] : '';
                      },
                      activeColor: const Color(0xFFFECD08),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      range['label'],
                      style: GoogleFonts.inter(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
                Text(
                  '${range['count']}',
                  style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ));
        }).toList(),
      ),
    );
  }

  Widget _buildViewOnMapCard() {
    return _buildSectionCard(
      child: GestureDetector(
        onTap: () =>
            SnackbarHelper.showInfo(
                'We are working on integrating an interactive map. Stay tuned!',
                title: 'Map View Coming Soon'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset('assets/images/map_preview.png', height: 160, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Text(
                  'View on Map',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF8C7104),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccessibilityCard() {
    return _buildSectionCard(
      title: 'Accessibility',
      child: Column(
        children: [
          _buildSimpleCheckbox('Lift'),
          _buildSimpleCheckbox('Roll-in shower'),
          _buildSimpleCheckbox('In-room accessibility'),
          _buildSimpleCheckbox('Accessible bathroom'),
          _buildSimpleCheckbox('Stair-free path to entrance'),
          _buildSimpleCheckbox('Wheelchair-accessible parking'),
          _buildSimpleCheckbox('Service animals allowed'),
          _buildSimpleCheckbox('Sign language-capable staff'),
        ],
      ),
    );
  }

  Widget _buildMealPlansCard() {
    return _buildSectionCard(
      title: 'Meal plans available',
      child: Column(
        children: [
          _buildSimpleCheckbox('Breakfast included'),
          _buildSimpleCheckbox('All-inclusive'),
          _buildSimpleCheckbox('Full board'),
          _buildSimpleCheckbox('Half board'),
        ],
      ),
    );
  }

  Widget _buildPropertyTypeCard() {
    return _buildSectionCard(
      title: 'Property Type',
      child: Column(
        children: [
          _buildSimpleCheckbox('Hotel'),
          _buildSimpleCheckbox('Bed & Breakfast'),
          _buildSimpleCheckbox('Aparthotel'),
        ],
      ),
    );
  }

  Widget _buildTravellerExperienceCard() {
    return _buildSectionCard(
      title: 'Traveller experience',
      child: Column(
        children: [
          _buildSimpleCheckbox('Luxury'),
          _buildSimpleCheckbox('Adults only'),
          _buildSimpleCheckbox('Budget'),
          _buildSimpleCheckbox('Romantic'),
        ],
      ),
    );
  }

  Widget _buildStarRatingCard() {
    return _buildSectionCard(
      title: 'Star rating',
      child: Column(
        children: [
          _buildStarFilterRow('5 Stars', 31),
          _buildStarFilterRow('4 Stars', 19),
          _buildStarFilterRow('3 Stars', 13),
          _buildStarFilterRow('2 Stars', 10),
          _buildStarFilterRow('1 Star', 8),
        ],
      ),
    );
  }

  Widget _buildAmenitiesCard() {
    return _buildSectionCard(
      title: 'Amenities',
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.8,
        children: [
          _buildAmenityItem(icon: Icons.local_taxi, label: 'Airport shuttle included', isHighlighted: true),
          _buildAmenityItem(icon: Icons.spa, label: 'Spa included', isHighlighted: true),
          _buildAmenityItem(icon: Icons.pool, label: 'Pool'),
          _buildAmenityItem(icon: Icons.wifi, label: 'Wi-Fi included'),
          _buildAmenityItem(icon: Icons.hot_tub, label: 'Hot tub'),
          _buildAmenityItem(icon: Icons.restaurant, label: 'Restaurant'),
          _buildAmenityItem(icon: Icons.fitness_center, label: 'Gym'),
          _buildAmenityItem(icon: Icons.ac_unit, label: 'Air conditioned'),
          _buildAmenityItem(icon: Icons.casino, label: 'Casino'),
          _buildAmenityItem(icon: Icons.local_bar, label: 'Bar'),
          _buildAmenityItem(icon: Icons.pets, label: 'Pet-friendly'),
          _buildAmenityItem(icon: Icons.deck, label: 'Outdoor space'),
          _buildAmenityItem(icon: Icons.kitchen, label: 'Kitchen'),
          _buildAmenityItem(icon: Icons.golf_course, label: 'Golf course'),
        ],
      ),
    );
  }

  Widget _buildYellowHeaderCard({required String title, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFF4C430),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Padding(padding: const EdgeInsets.all(16), child: child),
        ],
      ),
    );
  }

  Widget _buildSectionCard({String? title, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              _sectionHeader(title),
              const SizedBox(height: 8),
            ],
            child,
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildStarFilterRow(String title, int count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Obx(() => Checkbox(
                value: controller.selectedFilters.contains(title),
                onChanged: (v) => controller.toggleFilter(title),
                activeColor: const Color(0xFFFECD08),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              )),
              const SizedBox(width: 8),
              Text(title, style: GoogleFonts.inter(fontSize: 14)),
            ],
          ),
          Text('\$$count', style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildSimpleCheckbox(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            height: 24,
            width: 24,
            child: Obx(() => Checkbox(
              value: controller.selectedFilters.contains(title),
              onChanged: (v) => controller.toggleFilter(title),
              activeColor: const Color(0xFFFECD08),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            )),
          ),
          const SizedBox(width: 8),
          Text(title, style: GoogleFonts.inter(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildAmenityItem({required IconData icon, required String label, bool isHighlighted = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isHighlighted ? const Color(0xFFFFF8E1) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHighlighted ? const Color(0xFFFECD08) : Colors.grey[300]!,
          width: isHighlighted ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 22,
            color: isHighlighted ? const Color(0xFFFECD08) : Colors.grey[700],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplyButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => Get.back(),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFECD08),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: Text(
            'Apply Filters',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}