import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../models/car_model.dart';
import '../controllers/saved_controller.dart';

class SavedView extends GetView<SavedController> {
  const SavedView({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF2A2A2A),
                    ),
                    onPressed: () => Get.back(),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Saved',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF3A3A3A),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
          ),
        ),
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.savedHotels.isEmpty &&
            controller.savedTours.isEmpty &&
            controller.savedCars.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: controller.refreshSavedItems,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // Hotels Section
                if (controller.savedHotels.isNotEmpty) ...[
                  _buildSectionTitle('Hotel'),
                  const SizedBox(height: 12),
                  _buildHotelsList(),
                  const SizedBox(height: 12),
                ],

                // Cars Section
                if (controller.savedCars.isNotEmpty) ...[
                  _buildSectionTitle('Car'),
                  const SizedBox(height: 12),
                  _buildCarsList(),
                  const SizedBox(height: 12),
                ],

                // Tours Section
                if (controller.savedTours.isNotEmpty) ...[
                  _buildSectionTitle('Tour'),
                  const SizedBox(height: 12),
                  _buildToursList(),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No saved items yet',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start exploring and save your favorites',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF2A2A2A),
        ),
      ),
    );
  }

  // CARS LIST
  Widget _buildCarsList() {
    return Obx(() => ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: controller.savedCars.length,
      itemBuilder: (context, index) => _buildCarCard(index),
    ));
  }


  Widget _buildCarCard(int index) {
    return Obx(() {
      final car = controller.savedCars[index];
      final imageUrl = (car['image'] as String?)?.trim() ?? '';

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
            _buildCarImageSection(Car.fromJson(car), imageUrl, index),
            const SizedBox(height: 16),
            _buildCarFeatures(car),
            const SizedBox(height: 16),
            _buildCarFooter(car, index),
          ],
        ),
      );
    });
  }

  Widget _buildCarImageSection(Car car, String imageUrl, int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                imageUrl,
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
                  // Car type name
                  Expanded(
                    child: Text(
                      "${car.brand} ${car.model} ",
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        color: Colors.black87,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Favorite button
                  InkWell(
                    onTap: () => controller.toggleCarFavorite(index),
                      child:Icon(
                          Icons.favorite,
                          size: 20,
                              color: Colors.red,
                            ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                car.types,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
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

  Widget _buildCarFeatures(Map<String, dynamic> car) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildFeatureItem(Icons.people_outline, car['seats']?.toString() ?? '5'),
            const SizedBox(width: 40),
            _buildFeatureItem(Icons.speed_outlined, car['transmission']?.toString() ?? 'Auto'),
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

  Widget _buildCarFooter(Map<String, dynamic> car, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Company Badge
        _buildBadge(car['brand']?.toString() ?? 'Brand'),
        const SizedBox(width: 10),
        // Rating Badge
        _buildBadge(car['ratingPercentage']?.toString() ?? '90%'),
        const SizedBox(width: 10),
        // Rating Text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                car['ratingText']?.toString() ?? 'Excellent',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "(${car['reviews']?.toString() ?? '0'} ratings)",
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
          onTap: () => controller.onCarReserve(index),
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

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF8B7355),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Hotels List
  Widget _buildHotelsList() {
    return Obx(() => ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: controller.savedHotels.length,
      itemBuilder: (context, index) => _buildHotelCard(index),
    ));
  }

  Widget _buildHotelCard(int index) {
    return Obx(() {
      final hotel = controller.savedHotels[index];
      final imageUrl = hotel['image'] as String?;

      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: InkWell(
          onTap: () => controller.onHotelTap(index),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 130,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 130,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: imageUrl != null && imageUrl.isNotEmpty
                      ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.hotel, size: 40, color: Colors.grey),
                    ),
                  )
                      : Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.hotel, size: 40, color: Colors.grey),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                hotel['name']?.toString() ?? 'Unknown Hotel',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF2A2A2A),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () => controller.toggleHotelFavorite(index),
                              child: const Icon(Icons.favorite, size: 20, color: Color(0xFFFF2D1A)),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, size: 18, color: Color(0xFFFECD08)),
                            const SizedBox(width: 4),
                            Text(
                              hotel['rating']?.toString() ?? '0.0',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF2A2A2A),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 14, color: Color(0xFF9D9D9D)),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                hotel['location']?.toString() ?? 'Unknown',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF9D9D9D),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: hotel['price']?.toString() ?? '\$0',
                                      style: GoogleFonts.inter(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF2A2A2A),
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' /Room/Night',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFF696969),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () => controller.onBookNow(index),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFECD08),
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'Book Now',
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF6B5603),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  // Tours List
  Widget _buildToursList() {
    return Obx(() => ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: controller.savedTours.length,
      itemBuilder: (context, index) => _buildToursCard(index),
    ));
  }

  Widget _buildToursCard(int index) {
    return Obx(() {
      final tour = controller.savedTours[index];
      final imageUrl = tour['image'] as String?;

      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: InkWell(
          onTap: () => controller.onTourTap(index),
          borderRadius: BorderRadius.circular(15),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: imageUrl != null && imageUrl.isNotEmpty
                        ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.landscape,
                        size: 30,
                        color: Colors.grey,
                      ),
                    )
                        : const Icon(Icons.landscape, size: 30, color: Colors.grey),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tour['name']?.toString() ?? 'Unknown Tour',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2A2A2A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 14, color: Color(0xFF9D9D9D)),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                tour['location']?.toString() ?? 'Unknown Location',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF9D9D9D),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star, size: 18, color: Color(0xFFFECD08)),
                            const SizedBox(width: 4),
                            Text(
                              tour['rating']?.toString() ?? '0.0',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF2A2A2A),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      InkWell(
                        onTap: () => controller.toggleTourFavorite(index),
                        child: const Icon(Icons.favorite, size: 20, color: Color(0xFFFF2D1A)),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => controller.onTourBookNow(index),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFECD08),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          minimumSize: const Size(80, 32),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Book Now',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF6B5603),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}