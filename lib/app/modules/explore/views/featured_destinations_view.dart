import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/card_builders.dart';
import '../controllers/explore_controller.dart';

class FeaturedDestinationsView extends GetView<ExploreController> {
  const FeaturedDestinationsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
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
                      'Featured Destinations',
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
        ),
      body: SafeArea(
        child: Column(
          children: [
            _buildTabs(),
            Expanded(
              child: Obx(() {

                // Loading State
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFFECD08),
                    ),
                  );
                }

                //  Data Loaded - Show Content

                return RefreshIndicator(
                  color: const Color(0xFFFECD08),
                  onRefresh: () => controller.refreshData(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Obx(() {
                        final filteredList =
                        controller.getFilteredFeaturedDestinations();

                        //  Empty State

                        if (filteredList.isEmpty) {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.6,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.explore_off,
                                  size: 80,
                                  color: Colors.grey[300],
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'No featured destinations found',
                                  style: GoogleFonts.inter(
                                    color: Colors.grey[600],
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Check back later for trending spots',
                                  style: GoogleFonts.inter(
                                    color: Colors.grey[400],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        // Show List

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) {
                            return CardBuilders.buildDestinationCard(
                                filteredList[index]);
                          },
                        );
                      }),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Obx(
            () => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildTab('All', 0,
                  Image.asset('assets/images/explore_all.png')),
              const SizedBox(width: 12),
              _buildTab('Flights', 1,
                  Image.asset('assets/images/explore_flights.png')),
              const SizedBox(width: 12),
              _buildTab('Hotels', 2,
                  Image.asset('assets/images/explore_hotels.png')),
              const SizedBox(width: 12),
              _buildTab('Cars', 3,
                  Image.asset('assets/images/explore_cars.png')),
              const SizedBox(width: 12),
              _buildTab('Tours', 4,
                  Image.asset('assets/images/explore_tours.png')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String label, int index, dynamic iconSource) {
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
}