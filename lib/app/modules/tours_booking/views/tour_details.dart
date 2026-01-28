import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../constants/app_strings.dart';
import '../../../widgets/custom_date_picker.dart';
import '../../../widgets/snackbar_helper.dart';
import '../controllers/tours_booking_controller.dart';

class TourDetailsView extends StatelessWidget {
  const TourDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ToursBookingController>();

    return Obx(() {
      final tour = controller.selectedTour.value;

      if (tour == null || tour.id.isEmpty) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Get.back(),
            ),
          ),
          body: Center(child: Text(AppStrings.noToursFound)),
        );
      }

      return Scaffold(
        backgroundColor: const Color(0xFFFFFAE6),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            backgroundColor: const Color(0xFFFEDE5A),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Get.back(),
            ),
            title: Text(
              AppStrings.tourDetails,
              style: GoogleFonts.inter(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
        ),
        body: CustomScrollView(
          slivers: [

            // Big tour image
            SliverToBoxAdapter(
              child: SizedBox(
                height: 260,
                child: tour.imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                  imageUrl: tour.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(color: Colors.grey.shade300),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                )
                    : Container(
                  color: Colors.grey.shade300,
                  child: const Center(child: Icon(Icons.landscape, size: 80)),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Main Info Section
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tour.title,
                            style: GoogleFonts.inter(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Color(0xFFFECD08), size: 20),
                              const SizedBox(width: 6),
                              Text( tour.rating.toStringAsFixed(1),
                                style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 18),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '(${tour.reviewsCount} ${AppStrings.reviews})',
                                style: GoogleFonts.inter(fontSize: 16, color: Colors.grey.shade600),
                              ),
                              const Spacer(),

                              Obx(() {
                                final isFavorite = controller.isTourFavorite(tour.id);

                                return IconButton(
                                  icon: Icon(
                                    isFavorite ? Icons.favorite : Icons.favorite_border,
                                    color: isFavorite ? Colors.red : Colors.black,
                                  ),
                                  onPressed: () async {
                                    await controller.toggleTourFavorite(tour.id);
                                    Get.snackbar(
                                      isFavorite ? AppStrings.removedFromFavorites : AppStrings.addToFavorites,
                                      '',
                                      snackPosition: SnackPosition.BOTTOM,
                                      duration: const Duration(seconds: 1),
                                      backgroundColor: const Color(0xFFFECD08),
                                      colorText: Colors.black,
                                    );
                                  }
                                );
                              }),
                            ],
                          ),

                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Icon(Icons.location_on_outlined, size: 20, color: Colors.grey.shade500),
                              const SizedBox(width: 6),
                              Text(
                                tour.location,
                                style: GoogleFonts.inter(fontSize: 16, color: Colors.grey.shade600),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          Row(
                            children: [
                              _buildQuickInfo(Icons.access_time_outlined, tour.duration),
                              const SizedBox(width: 24),
                              _buildQuickInfo(Icons.people_outline, '${AppStrings.maxPeopleLabel} ${tour.maxPeople}'),
                            ],
                          ),

                          const SizedBox(height: 24),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: _buildPriceCard(tour.price),
                          ),

                          const SizedBox(height: 20),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: _buildCategoryChips(tour.category),
                          ),

                          const SizedBox(height: 24),

                         // Overview

                          _sectionTitle(AppStrings.overview),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              tour.description,
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                height: 1.6,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ),

                      // Key Highlights

                          if (tour.keyHighlights.isNotEmpty) ...[
                            _sectionTitle(AppStrings.keyHighlights),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: tour.keyHighlights.map((text) => _buildKeyHighlight(text)).toList(),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],

                    // Included / Not Included
                          if (tour.included.isNotEmpty || tour.notIncluded.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _buildIncludedSection(AppStrings.included, true, tour.included),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: _buildIncludedSection(AppStrings.notIncluded, false, tour.notIncluded),
                            ),
                          ],
                        ),
                      ),

                    // What to Bring

                          if (tour.whatToBring.isNotEmpty) ...[
                      _sectionTitle(AppStrings.whatToBring),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFAE6),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFFEDE5A), width: 1),
                          ),
                          child: Text(
                            tour.whatToBring.join(', '),
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              height: 1.6,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ),
                    ],

                    // Itinerary

                          if (tour.itinerary.isNotEmpty) ...[
                      _sectionTitle(AppStrings.itinerary),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: tour.itinerary
                              .asMap()
                              .entries
                              .map((entry) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildExpandableItinerary(
                              entry.value.day,
                              entry.value.title,
                              entry.value.activities,
                            ),
                          ))
                              .toList(),
                        ),
                      ),
                    ],

                    // Meeting Point

                          if (tour.meetingPoint != null) ...[
                      _sectionTitle(AppStrings.meetingPoint),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                height: 200,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                ),
                                child: tour.meetingPoint!.mapImageUrl != null &&
                                    tour.meetingPoint!.mapImageUrl!.isNotEmpty
                                    ? Image.network(
                                  tour.meetingPoint!.mapImageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.map, size: 60),
                                )
                                    : Image.asset(
                                  'assets/images/location_1.png',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.map, size: 60),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on, color: Color(0xFF4A90E2), size: 24),
                                      const SizedBox(width: 8),
                                      Text(
                                        AppStrings.meetingLocation,
                                        style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    tour.meetingPoint!.address,
                                    style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade800, height: 1.5),
                                  ),
                                  if (tour.meetingPoint!.description != null) ...[
                                    const SizedBox(height: 12),
                                    Text(
                                      tour.meetingPoint!.description!,
                                      style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade600, height: 1.5),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Select Participants

                    _sectionTitle(AppStrings.selectParticipants),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          _buildParticipantCounter(
                            AppStrings.adults,
                            AppStrings.age13Plus,
                            'adult',
                          ),
                          const SizedBox(height: 16),
                          _buildParticipantCounter(
                            AppStrings.children,
                            AppStrings.age3to12,
                            'child',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Bottom Action Buttons

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                SnackbarHelper.showInfo(
                                    'Downloading tour details...',
                                    title: 'PDF Download'
                                );
                              },
                              icon: const Icon(Icons.picture_as_pdf_outlined, size: 20),
                              label: Text(
                                'PDF',
                                style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.black87,
                                side: BorderSide(color: Colors.grey.shade300),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton.icon(
                            onPressed: () async {
                              final selectedDate = await showDialog<DateTime>(
                                context: context,
                                builder: (context) => CustomDatePicker(
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                  onDateSelected: (date) {
                                  },
                                ),
                              );

                              if (selectedDate != null) {
                                controller.selectedDate.value = selectedDate;
                                Get.snackbar(
                                  AppStrings.calendar,
                                  '${AppStrings.selected}: ${DateFormat('dd MMM, yyyy').format(selectedDate)}',
                                  backgroundColor: Colors.white,
                                  colorText: Colors.black87,
                                );
                              }
                            },
                            icon: const Icon(Icons.calendar_today_outlined, size: 20),
                            label: Text(
                              AppStrings.calendar,
                              style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.black87,
                              side: BorderSide(color: Colors.grey.shade300),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Get.snackbar(
                                  AppStrings.invite,
                                  AppStrings.shareWithFriends,
                                  backgroundColor: Colors.white,
                                  colorText: Colors.black87,
                                );
                              },
                              icon: const Icon(Icons.person_add_outlined, size: 20),
                              label: Text(
                                AppStrings.invite,
                                style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.black87,
                                side: BorderSide(color: Colors.grey.shade300),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                          // Related Tours

                    _sectionHeader(
                      AppStrings.relatedTours,
                      onSeeAll: () => Get.toNamed('/all-related-tours'),
                    ),
                    Obx(() {
                      final relatedTours = controller.allTours
                          .where((t) => t.id != tour.id)
                          .take(2)
                          .toList();

                      if (relatedTours.isEmpty) return const SizedBox.shrink();

                      return SizedBox(
                        height: 250,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: relatedTours.length,
                          itemBuilder: (context, index) {
                            final related = relatedTours[index];
                            return Padding(
                              padding: EdgeInsets.only(right: index < relatedTours.length - 1 ? 16 : 0),
                              child: GestureDetector(
                                onTap: () => controller.onTourTap(related),
                                child: _buildRelatedTourCard(
                                  related.title,
                                  related.location,
                                  (related.price).toStringAsFixed(0),
                                  related.rating,
                                  related.imageUrl,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
              ],
            ),
      ),
            ),
          ],
        ),

        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5)),
            ],
          ),
          child: SafeArea(
            child: Obx(() {
              final total = controller.calculateTotalAmount();
              return Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.totalPrice,
                        style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade600),
                      ),
                      Text(
                        '\$${total.toStringAsFixed(2)}',
                        style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => controller.proceedToPayment(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFECD08),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text(
                        AppStrings.bookNow,
                        style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      );
    });
  }

  // Helper Widgets

  Widget _buildParticipantCounter(String title, String subtitle, String type) {
    final controller = Get.find<ToursBookingController>();
    final count = type == 'adult' ? controller.adultsCount : controller.childrenCount;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
                const SizedBox(height: 2),
                Text(subtitle, style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade600)),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  if (type == 'adult' && count.value > 1) count.value--;
                  if (type == 'child' && count.value > 0) count.value--;
                },
                icon: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(color: Colors.grey.shade200, shape: BoxShape.circle),
                  child: const Icon(Icons.remove, size: 18),
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 16),
              Obx(
                    () => SizedBox(
                  width: 30,
                  child: Text(
                    '${count.value}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black87),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: () => count.value++,
                icon: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(color: Color(0xFFFECD08), shape: BoxShape.circle),
                  child: const Icon(Icons.add, size: 18, color: Colors.black87),
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
      child: Text(title, style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700)),
    );
  }

  Widget _buildQuickInfo(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(30)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade700),
          const SizedBox(width: 6),
          Text(text, style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade800)),
        ],
      ),
    );
  }

  Widget _buildKeyHighlight(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(color: Color(0xFFFECD08), shape: BoxShape.circle),
            child: const Icon(Icons.check, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(fontSize: 15, height: 1.5, color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncludedSection(String title, bool isIncluded, List<String> items) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 16),
        ...items.map(
              (item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  isIncluded ? Icons.check : Icons.close,
                  size: 18,
                  color: isIncluded ? Colors.green.shade600 : Colors.red.shade400,
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(item, style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade600))),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExpandableItinerary(String day, String title, List<String> activities) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(color: Color(0xFFFECD08), shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text(
              day,
              style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 13, color: Colors.black87),
            ),
          ),
          title: Text(
            title,
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
          ),
          trailing: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade600),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(82, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...activities.map(
                        (activity) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(color: Color(0xFFFECD08), shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              activity,
                              style: GoogleFonts.inter(fontSize: 14, height: 1.6, color: Colors.grey.shade700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceCard(double price) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFAE6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '\$${price.toStringAsFixed(0)}',
                style: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w700, color: Colors.black87),
              ),
              const SizedBox(width: 4),
              Text(
                AppStrings.perPerson,
                style: GoogleFonts.inter(fontSize: 16, color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${AppStrings.startingFrom} (${AppStrings.priceVariesByDate})',
            style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips(String category) {
    return Wrap(
      spacing: 24,
      runSpacing: 8,
      children: [
        Text(
          category,
          style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 14, color: const Color(0xFF8B6B23)),
        ),
        Text(
          AppStrings.familyFriendly,
          style: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 14, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _sectionHeader(String title, {VoidCallback? onSeeAll}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700)),
          TextButton(
            onPressed: onSeeAll,
            child: Text(
              AppStrings.seeAll,
              style: GoogleFonts.inter(color: const Color(0xFFFECD08), fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildRelatedTourCard(String title, String loc, String price, double rat, String img) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: img,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(color: Colors.grey.shade300),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.landscape, size: 40),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Color(0xFFFECD08), size: 14),
                      const SizedBox(width: 4),
                      Text(rat.toStringAsFixed(1), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.grey.shade400),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        loc,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('\$$price', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}