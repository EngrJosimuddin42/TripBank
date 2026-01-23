import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../constants/app_strings.dart';
import '../../../models/tour_model.dart';
import '../controllers/tours_booking_controller.dart';

class ToursBookingView extends GetView<ToursBookingController> {
  const ToursBookingView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isFromPopularSeeAll = Get.arguments == 'popular';
    return Scaffold(
      backgroundColor: const Color(0xFFFFFAE6),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
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
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                  ),
                  Expanded(
                    child: Text(
                      isFromPopularSeeAll ? "Popular Tours" : AppStrings.allTours,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: TextField(
              onChanged: (value) => controller.searchQuery.value = value,
              decoration: InputDecoration(
                hintText: AppStrings.searchTourPlaces,
                hintStyle: const TextStyle(color: Color(0xFF9D9D9D)),
                prefixIcon: const Icon(Icons.search, color: Color(0xFFFECD08)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFFEDE5A)),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          Expanded(
            child: Obx(() {
              final displayTours = isFromPopularSeeAll
                  ? controller.allTours.where((tour) => tour.rating >= 4.5).toList()
                  : controller.filteredTours;

              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFFFEDE5A)),
                );
              }

              if (displayTours.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isFromPopularSeeAll ? Icons.tour_outlined : Icons.search_off_rounded,
                        size: 80,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        isFromPopularSeeAll ? "No popular tours right now" : AppStrings.noToursFound,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: displayTours.length,
                itemBuilder: (context, index) {
                  return _buildTourCard(displayTours[index]);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTourCard(Tour tour) {
    final bool isViewDetailsStyle = tour.buttonText == 'View Details';

    return GestureDetector(
      onTap: () => controller.onTourTap(tour),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Image + Badges
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: CachedNetworkImage(
                    imageUrl: tour.imageUrl,
                    height: 190,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 190,
                      color: Colors.grey.shade200,
                      child: const Center(child: CircularProgressIndicator(color: Color(0xFFFEDE5A))),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 190,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image_not_supported, size: 70),
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD60A),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      tour.category,
                      style: GoogleFonts.inter(
                        color: Colors.black87,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          tour.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Info Section
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tour.title,
                    style: GoogleFonts.inter(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 18, color: Colors.grey.shade700),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          tour.location,
                          style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade700),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  // Description Only View Details style
                  if (isViewDetailsStyle) ...[
                    const SizedBox(height: 12),
                    Text(
                      tour.description,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],

                  const SizedBox(height: 14),

                  Row(
                    children: [
                      _buildInfoChip(Icons.timer_outlined, tour.duration),
                      const SizedBox(width: 12),
                      _buildInfoChip(Icons.group_outlined, "${AppStrings.maxPeopleLabel} ${tour.maxPeople}"),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Price & Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isViewDetailsStyle)
                              Text(
                                AppStrings.startingFrom,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  "\$${tour.price.toStringAsFixed(0)}",
                                  style: GoogleFonts.inter(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFFF6B00),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  AppStrings.perPerson,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => controller.onTourTap(tour),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFD60A),
                          foregroundColor: Colors.black87,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                        ),
                        child: Text(
                          tour.buttonText,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
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
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade700),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.grey.shade800,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}