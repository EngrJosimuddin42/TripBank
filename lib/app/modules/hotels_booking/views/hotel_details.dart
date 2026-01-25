import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../widgets/snackbar_helper.dart';
import '../controllers/hotels_booking_controller.dart';

class HotelDetailsView extends GetView<HotelsBookingController> {
  const HotelDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: _buildAppBar(),
      body: Obx(() {
        final hotel = controller.selectedHotel.value;
        if (hotel == null) {
          return const Center(child: Text('No hotel selected'));
        }

        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageGallery(hotel.images.isNotEmpty ? hotel.images : [hotel.image]),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHotelHeader(hotel),
                        const SizedBox(height: 24),
                        _buildOverviewSection(hotel),
                        const SizedBox(height: 20),
                        _buildViewOnMapCard(),
                        const SizedBox(height: 24),
                        if (hotel.highlights.isNotEmpty) _buildHighlightsSection(hotel),
                        if (hotel.highlights.isNotEmpty) const SizedBox(height: 24),
                        if (hotel.services.isNotEmpty) _buildServicesSection(hotel),
                        if (hotel.services.isNotEmpty) const SizedBox(height: 24),
                        _buildSimilarMoreSection(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _buildBottomBookButton(),
          ],
        );
      }),
    );
  }

  PreferredSizeWidget _buildAppBar() {
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
                Text(
                  'Hotel Details',
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

  Widget _buildImageGallery(List<String> images) {
    final PageController pageController = PageController();
    final RxInt currentIndex = 0.obs;
    return SizedBox(
      height: 250,
      child: Stack(
        children: [
      PageView.builder(
        controller: pageController,
        onPageChanged: (index) => currentIndex.value = index,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return CachedNetworkImage(
            imageUrl: images[index],
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                Container(
                  color: Colors.grey[300],
                  child: const Center(child: CircularProgressIndicator()),
                ),
            errorWidget: (context, url, error) =>
                Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.hotel, size: 60, color: Colors.grey),
                ),
          );
        },
      ),

          // Image Slider (first image it Hide)
          Obx(() => currentIndex.value > 0
              ? Positioned(
            left: 10,
            top: 0,
            bottom: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                ),
              ),
            ),
          )
              : const SizedBox.shrink()),

          // Image Slider (Image end it Hide)
          Obx(() => currentIndex.value < images.length - 1
              ? Positioned(
            right: 10,
            top: 0,
            bottom: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
                ),
              ),
            ),
          )
              : const SizedBox.shrink()),
        ],
      ),
    );
  }

  Widget _buildHotelHeader(hotel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          hotel.name,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            ...List.generate(5, (index) {
              return Icon(
                index < hotel.rating.floor() ? Icons.star : Icons.star_border,
                color: const Color(0xFFFFA726),
                size: 18,
              );
            }),
            const SizedBox(width: 8),
            Text(
              '${hotel.rating}',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.location_on, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                hotel.address,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOverviewSection(hotel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF8C7104),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          hotel.description,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: Colors.grey[700],
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildViewOnMapCard() {
    return _buildSectionCard(
      child: GestureDetector(
        onTap: () =>
            SnackbarHelper.showInfo(
                'We are working hard to bring the interactive map view to you very soon!',
                title: 'Map View Coming Soon'
            ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/map_preview.png',
                height: 160,
                fit: BoxFit.cover,
              ),
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

  Widget _buildHighlightsSection(hotel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Highlights',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF8C7104),
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(hotel.highlights.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF9E6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    _getHighlightIcon(index),
                    size: 16,
                    color: const Color(0xFFFFA726),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    hotel.highlights[index],
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildServicesSection(hotel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Services',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF8C7104),
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: hotel.services.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            mainAxisExtent: 50,
          ),
          itemBuilder: (context, index) {
            final service = hotel.services[index];
            bool isFirst = index == 0;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: isFirst ? const Color(0xFFFEDE5A) : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isFirst ? Colors.transparent : const Color(0xFFD1D5DB),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    service.icon,
                    size: 20,
                    color: const Color(0xFF8C7104),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      service.name,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSimilarMoreSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Similar More',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF8C7104),
          ),
        ),
        const SizedBox(height: 12),
        _buildRoomImages(),
        const SizedBox(height: 16),
        Obx(() => _buildRoomDetails(controller.roomList[controller.selectedRoomIndex.value])),
      ],
    );
  }

  Widget _buildRoomImages() {
    final PageController roomPageController = PageController(
      viewportFraction: 1.0,
      initialPage: controller.selectedRoomIndex.value,
    );

    return SizedBox(
      height: 180,
      child: Stack(
        children: [
          // Room Image Slider
          PageView.builder(
            controller: roomPageController,
            itemCount: controller.roomList.length,
            onPageChanged: (index) {
              controller.selectRoom(index);
            },
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                clipBehavior: Clip.antiAlias,
                child: CachedNetworkImage(
                  imageUrl: controller.roomList[index].image,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[300],
                    child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.hotel, size: 40, color: Colors.grey),
                  ),
                ),
              );
            },
          ),

          Obx(() => controller.selectedRoomIndex.value > 0
              ? Positioned(
            left: 10,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black.withValues(alpha: 0.3),
                ),
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                onPressed: () {
                  roomPageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
          )
              : const SizedBox.shrink()),

          Obx(() => controller.selectedRoomIndex.value < controller.roomList.length - 1
              ? Positioned(
            right: 10,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black.withValues(alpha: 0.3),
                ),
                icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
                onPressed: () {
                  roomPageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
          )
              : const SizedBox.shrink()),

          // Room Name Top of Image
          Positioned(
            bottom: 12,
            left: 12,
            child: Obx(() => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                controller.roomList[controller.selectedRoomIndex.value].name,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomDetails(room) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            room.name,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          _buildRoomRating(room),
          const SizedBox(height: 16),
          ...room.features.map((feature) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Icon(feature.icon, size: 18, color: Colors.grey[700]),
                const SizedBox(width: 12),
                Text(
                  feature.text,
                  style: GoogleFonts.inter(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          )),
          GestureDetector(
            onTap: () {},
            child: Text(
              'More details >',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF8C7104),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildPolicySection(room),
          const SizedBox(height: 20),
          _buildExtrasSection(room),
          const SizedBox(height: 24),
          _buildPriceAndReserveButton(room),
        ],
      ),
    );
  }

  Widget _buildRoomRating(room) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF2E7D32),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            room.rating,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          room.ratingText,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(width: 6),
        Text(
          '(${room.reviews})',
          style: TextStyle(color: Colors.grey[600], fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildPolicySection(room) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPolicyHeader('Cancellation policy', 'per stay'),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () {
            SnackbarHelper.showInfo(
                'Full cancellation policy details will be shown here',
                title: 'Policy Details'
            );
          },
          child: Row(
            children: [
              Text(
                'More details on all policy options',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF4A5565),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.info_outline, size: 16, color: Color(0xFF4A5565)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        _buildPolicyRow('Non-refundable', '+ \$0'),
        _buildPolicyRow('Fully refundable before 12 Dec', '+ \$${room.refundPrice}'),
        const Text('Reserve now, pay later', style: TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildExtrasSection(room) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPolicyHeader('Extras', 'per night'),
        const SizedBox(height: 8),
        _buildPolicyRow('No extras', '+ \$0'),
        _buildPolicyRow('Breakfast', '+ \$${room.breakfastPrice}'),
      ],
    );
  }

  Widget _buildPriceAndReserveButton(room) {
    return Center(
      child: Column(
        children: [
          Text(
            '\$${room.price}',
            style: GoogleFonts.inter(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          const Text('for 1 room', style: TextStyle(color: Colors.grey, fontSize: 12)),
          const Text('includes taxes & fees', style: TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            'We have ${room.leftCount} left',
            style: const TextStyle(
              color: Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.toNamed('/payment-hotel', arguments: room),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8C7104),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text(
                'Reserve',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text('You will not be charged yet', style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildPolicyHeader(String title, String trailing) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700),
        ),
        Text(
          trailing,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildPolicyRow(String label, String price) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.inter(fontSize: 13, color: Colors.black87)),
          Text(price, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
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
            if (title != null) ...[],
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBookButton() {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () => Get.toNamed('/payment-hotel'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFECD08),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: Text(
            'Continue to book',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6B5603),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getHighlightIcon(int index) {
    switch (index) {
      case 0:
        return Icons.location_on;
      case 1:
        return Icons.thumb_up;
      case 2:
        return Icons.wifi;
      default:
        return Icons.star;
    }
  }
}