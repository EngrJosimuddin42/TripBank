import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/card_builders.dart';
import '../controllers/explore_controller.dart';
import 'all_destinations_view.dart';
import 'featured_destinations_view.dart';

class ExploreView extends StatelessWidget {
  const ExploreView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ExploreController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
      children: [
        Column(
          children: [
            _buildHeader(),
            _buildSearchBar(controller),
            _buildTabs(controller),
            Expanded(
              child: Obx(() {

                //  Loading State

                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFFECD08),
                    ),
                  );
                }

                // Data Loaded - Show Content

                return RefreshIndicator(
                  color: const Color(0xFFFECD08),
                  onRefresh: () => controller.refreshData(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFeaturedSection(controller),
                        const SizedBox(height: 24),
                        _buildAllDestinationsSection(controller),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),

      // Conditional Back Button

        Positioned(
          top: 40,
          right: 16,
          child: Builder(
            builder: (context) {
              final canGoBack = Navigator.canPop(context);
              if (!canGoBack) return const SizedBox.shrink();

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => Get.back(),
                    borderRadius: BorderRadius.circular(25),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.black87,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        ],
      ),
      ),
    );
  }

  Widget _buildHeader() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Explore',
              style: GoogleFonts.inter(
                fontSize: 26,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Find your next adventure',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF666666),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(ExploreController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFFFECD08)),
        ),
        child: TextField(
          onChanged: (value) => controller.searchDestinations(value),
          decoration: InputDecoration(
            hintText: 'Search any places...',
            hintStyle: GoogleFonts.inter(
              color: const Color(0xFF9D9D9D),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: const Icon(
              Icons.search,
              color: Color(0xFFFECD08),
              size: 22,
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 32),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildTabs(ExploreController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Obx(
            () => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildTab(controller, 'All', 0,
                  Image.asset('assets/images/explore_all.png')),
              const SizedBox(width: 12),
              _buildTab(controller, 'Flights', 1,
                  Image.asset('assets/images/explore_flights.png')),
              const SizedBox(width: 12),
              _buildTab(controller, 'Hotels', 2,
                  Image.asset('assets/images/explore_hotels.png')),
              const SizedBox(width: 12),
              _buildTab(controller, 'Cars', 3,
                  Image.asset('assets/images/explore_cars.png')),
              const SizedBox(width: 12),
              _buildTab(controller, 'Tours', 4,
                  Image.asset('assets/images/explore_tours.png')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(
      ExploreController controller,
      String label,
      int index,
      dynamic iconSource,
      ) {
    final isSelected = controller.selectedTab.value == index;

    return InkWell(
      onTap: () => controller.selectTab(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFECD08) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
            isSelected ? const Color(0xFFFECD08) : const Color(0xFFDDDDDD),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: iconSource is IconData
                  ? Icon(
                iconSource,
                size: 18,
                color: isSelected
                    ? const Color(0xFF3A3A3A)
                    : Colors.grey,
              )
                  : iconSource,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                color: isSelected ? const Color(0xFF3A3A3A) : Colors.grey,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedSection(ExploreController controller) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Featured Destinations',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF101828),
                ),
              ),
              InkWell(
                onTap: () => Get.to(() => const FeaturedDestinationsView()),
                child: Row(
                  children: [
                    Text(
                      'See All',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF8C7104),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFF8C7104),
                      size: 14,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Obx(() {
            final filteredList = controller.getFilteredFeaturedDestinations();

            //  Empty State for Featured

            if (filteredList.isEmpty) {
              return Container(
                height: 200,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.explore_off,
                      size: 64,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No featured destinations found',
                      style: GoogleFonts.inter(
                        color: Colors.grey[500],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            }

            final displayList = filteredList.take(4).toList();
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: displayList.length,
              itemBuilder: (context, index) {
                return CardBuilders.buildTrendingGridCard(displayList[index]);
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildAllDestinationsSection(ExploreController controller) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'All Destinations',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF101828),
                ),
              ),
              InkWell(
                onTap: () => Get.to(() => const AllDestinationsView()),
                child: Row(
                  children: [
                    Text(
                      'See All',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF8C7104),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFF8C7104),
                      size: 14,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Obx(() {
            final filteredList = controller.getFilteredDestinations();

            // Empty State for All Destinations

            if (filteredList.isEmpty) {
              return Container(
                height: 200,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 64,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No destinations found',
                      style: GoogleFonts.inter(
                        color: Colors.grey[500],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Try adjusting your filters',
                      style: GoogleFonts.inter(
                        color: Colors.grey[400],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            }

            final displayList = filteredList.take(4).toList();
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: displayList.length,
              itemBuilder: (context, index) {
                return CardBuilders.buildDestinationCard(displayList[index]);
              },
            );
          }),
        ),
      ],
    );
  }
}