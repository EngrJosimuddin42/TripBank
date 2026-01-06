import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/draggable_chat_bubble.dart';
import '../../drawer/views/drawer_view.dart';
import '../../explore/controllers/explore_controller.dart';
import '../../explore/views/explore_view.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../profile/views/profile_view.dart';
import '../controllers/home_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: SizedBox(
        width: Get.width > 400 ? 350 : Get.width * 0.85,
        child: const DrawerView(),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return _buildCurrentPage();
                }),
              ),
            ],
          ),
          // ✅ Conditional Draggable Chatbot - শুধু Home tab এ দেখাবে
          Obx(() => controller.currentIndex.value == 0
              ? const DraggableChatBubble()
              : const SizedBox.shrink()
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
  Widget _buildCurrentPage() {
    return Obx(() {
      switch (controller.currentIndex.value) {
        case 0:
          return _buildHomeContent();
        case 1:
          return _buildExplorePage();
        case 2:
          return _buildMyTripsPage();
        case 3:
          return _buildProfilePage();
        default:
          return _buildHomeContent();
      }
    });
  }

  Widget _buildHomeContent() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 140),
          child: RefreshIndicator(
            onRefresh: controller.refreshData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  _buildSearchBar(),
                  const SizedBox(height: 20),
                  _buildQuickActions(),
                  const SizedBox(height: 16),
                  _buildGoodPlaceSection(),
                  const SizedBox(height: 24),
                  _buildFeaturedDestinations(),
                  const SizedBox(height: 24),
                  _buildPopularHotels(),
                  const SizedBox(height: 24),
                  _buildPopularTours(),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),

        // Fixed Header Background + AppBar Content
        Container(
          height: 140,
          decoration: const BoxDecoration(
            color: Color(0xFFFEDE5A),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [_buildAppBarLeft(), _buildAppBarRight()],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return Obx(() => Container(
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
      child: BottomNavigationBar(
        currentIndex: controller.currentIndex.value,
        onTap: (index) => controller.currentIndex.value = index,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,

        selectedItemColor: const Color(0xFFE7BB07),
        unselectedItemColor: const Color(0xFF4E4E4E),

        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),

        items:[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'Explore',
          ),

          BottomNavigationBarItem(
            icon: Image.asset('assets/images/triangle_flag.png'),
            activeIcon: Image.asset('assets/images/triangle_flag.png',color: const Color(0xFFE7BB07),),
            label: 'My Trips',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/user.png'),
            activeIcon: Image.asset('assets/images/user.png',color: const Color(0xFFE7BB07),),
            label: 'Profile',
          ),
        ],
      ),
    ));
  }

  Widget _buildAppBarLeft() {
    return Row(
      children: [
        Builder(
          builder: (context) => InkWell(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: const Icon(Icons.menu, size: 24, color: Colors.black),
          ),
        ),
        const SizedBox(width: 12),
        Obx(
              () => Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.userName.value,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    controller.greeting.value,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
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

  Widget _buildAppBarRight() {
    return InkWell(
      onTap: controller.onNotificationTap,
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 40,
        height: 40,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Notification Icon
            Center(
              child: Image.asset(
                'assets/images/notifications.png',
                width: 32,
                height: 32,
                color: Color(0xFF3A3A3A),
              ),
            ),

            // Notification Badge (Red Dot)
            Obx(() => controller.hasNotifications.value
                ? Positioned(
              right: -2,
              top: -2,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
            )
                : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(
            () => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: const Color(0xFFFECD08),
              width: controller.isSearching.value ? 2 : 1,
            ),
            boxShadow: controller.isSearching.value
                ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ]
                : null,
          ),
          child: Row(
            children: [
              // Back button when searching
              if (controller.isSearching.value)
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    controller.isSearching.value = false;
                    controller.searchQuery.value = '';
                    controller.searchController.clear();
                    controller.searchFocusNode.unfocus();
                  },
                ),

              // Search Icon
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.search,
                  color: const Color(0xFFFECD08),
                  size: 24,
                ),
              ),

              // TextField
              Expanded(
                child: controller.isSearching.value
                    ? TextField(
                  controller: controller.searchController,
                  focusNode: controller.searchFocusNode,
                  autofocus: true,
                  style: GoogleFonts.inter(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Search any places...',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF9D9D9D),
                    ),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    controller.searchQuery.value = value;
                  },
                )
                    : InkWell(
                  onTap: () {
                    controller.isSearching.value = true;
                    // ফোকাস দিয়ে কীবোর্ড আনা
                    Future.delayed(const Duration(milliseconds: 100), () {
                      controller.searchFocusNode.requestFocus();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'Search any places...',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF9D9D9D),
                      ),
                    ),
                  ),
                ),
              ),

              // Clear button when typing
              if (controller.isSearching.value &&
                  controller.searchQuery.value.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    controller.searchController.clear();
                    controller.searchQuery.value = '';
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 108,
        child: Obx(
              () => ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.quickActions.length,
            itemBuilder: (context, index) {
              final action = controller.quickActions[index];
              final String imagePath = action['image'];
              final String label = action['label'];

              return Container(
                width: 94,
                height: 108,
                margin: EdgeInsets.only(
                  right: index < controller.quickActions.length - 1 ? 12 : 0,
                ),
                child: InkWell(
                  onTap: () => controller.selectTab(index),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFAE6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Image.asset(imagePath,
                      width: 32,
                      height: 32,
                    ),
                        const SizedBox(height: 6),
                        Text(
                          action['label'] as String,
                          style: GoogleFonts.workSans(
                            fontSize: 16,
                            color: const Color(0xFF6B5603),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildGoodPlaceSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        height: 185,
        padding: const EdgeInsets.only(
          top: 23.99,
          left: 23.99,
          right: 86.49,
          bottom: 20,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFEDE5A), Color(0xFFAF8E08)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    controller.goodPlaceData['badge'] as String,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF8C7104),
                    ),
                  ),
                ),
                const SizedBox(height: 19),
                Text(
                  controller.goodPlaceData['title'] as String,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF3A3A3A),
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Text(
                  controller.goodPlaceData['sub title'] as String,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 98,
              height: 36,
              child: ElevatedButton(
                onPressed: controller.onBookNowTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  controller.goodPlaceData['buttonText'] as String,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: const Color(0xFF8C7104),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedDestinations() {
    return Obx(() {
      if (controller.destinations.isEmpty) return const SizedBox.shrink();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            'Featured Destinations',
            controller.onSeeAllDestinations,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              height: 472,
              child: GridView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemCount: controller.displayedDestinations.length,
                itemBuilder: (context, index) => _buildDestinationCard(index),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildDestinationCard(int index) {
    final destination = controller.destinations[index];
    final color = controller.getDestinationColor(index);
    final imageUrl = destination['image'] as String?;

    return InkWell(
      onTap: () => controller.onDestinationTap(index),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: 164,
        height: 205,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image with Caching
            if (imageUrl != null && imageUrl.isNotEmpty)
              CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [color.withOpacity(0.6), color],
                    ),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [color.withOpacity(0.6), color],
                    ),
                  ),
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              )
            else
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [color.withOpacity(0.6), color],
                  ),
                ),
              ),

            // Dark overlay for text readability
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Color.fromRGBO(0, 0, 0, 0.7),
                  ],
                ),
              ),
            ),

            // Text Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    destination['name'] as String,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    destination['subtitle'] as String,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularHotels() {
    return Obx(() {
      final hotelList = controller.hotels;
      if (hotelList.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Popular Hotels', controller.onSeeAllHotels),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: List.generate(
                controller.displayedHotels.length,
                    (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildHotelCard(index),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildHotelCard(int index) {
    return Obx(() {
      final hotel = controller.hotels[index];
      final isFavorite = hotel['isFavorite'] as bool;
      final imageUrl = hotel['image'] as String?;

      return InkWell(
        onTap: () => controller.onHotelTap(index),
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Hotel Image
              Container(
                width: 140,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
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
                    child: const Icon(
                      Icons.hotel,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                )
                    : Container(
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.hotel,
                    size: 40,
                    color: Colors.grey,
                  ),
                ),
              ),

              // Hotel Info
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Hotel Name
                      Text(
                        hotel['name'] as String,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF101828),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // Location
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: Color(0xFF4A5565),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            hotel['location'] as String,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: const Color(0xFF4A5565),
                            ),
                          ),
                        ],
                      ),

                      // Rating & Price Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Rating
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 16,
                                color: Color(0xFFFDC700),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${hotel['rating']}',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF0A0A0A),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '(${hotel['reviews']} reviews)',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF99A1AF),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Price
                      Text(
                        '${hotel['price']}/night',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF8C7104),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Favorite Button
              Padding(
                padding: const EdgeInsets.only(right: 12, top: 12),
                child: InkWell(
                  onTap: () => controller.toggleHotelFavorite(index),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    size: 20,
                    color: isFavorite ? Colors.red : const Color(0xFF9E9E9E),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildPopularTours() {
    return Obx(() {
      if (controller.tours.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Popular Tours', controller.onSeeAllTours),
          const SizedBox(height: 16),
          SizedBox(
            height: 260,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.displayedTours.length,
              itemBuilder: (context, index) => _buildTourCard(index),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildTourCard(int index) {
    return Obx(() {
      final tour = controller.tours[index];
      final isFavorite = tour['isFavorite'] as bool? ?? false;
      final imageUrl = tour['image'] as String?;

      return InkWell(
        onTap: () => controller.onTourTap(index),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 180,
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tour Image
              Container(
                height: 140,
                width: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(10),
                  ),
                ),
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
                    child: const Icon(
                      Icons.landscape,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                )
                    : Container(
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.landscape,
                    size: 40,
                    color: Colors.grey,
                  ),
                ),
              ),

              // Tour Info
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Tour Name
                      Text(
                        tour['name'] as String,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF101828),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // Rating and Days
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 16,
                            color: Color(0xFFFDC700),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${tour['rating']}',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF0A0A0A),
                            ),
                          ),
                          const SizedBox(width: 60),
                          Text(
                            '${tour['days']} Days',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF4A5565),
                            ),
                          ),
                        ],
                      ),

                      // Price and Favorite Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            tour['price'] as String,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF8C7104),
                            ),
                          ),
                          InkWell(
                            onTap: () => controller.toggleTourFavorite(index),
                            child: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              size: 20,
                              color: isFavorite ? Colors.red : const Color(0xFF9E9E9E),
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
      );
    });
  }

  Widget _buildSectionHeader(String title, VoidCallback onSeeAll) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xFF101828)),
          ),
          InkWell(
            onTap: onSeeAll,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'See all',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF8C7104),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Color(0xFF8C7104),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExplorePage() {
    if (!Get.isRegistered<ExploreController>()) {
      Get.lazyPut(() => ExploreController());
    }
    return const ExploreView();
  }

  Widget _buildMyTripsPage() {
    return const Center(
      child: Text(
        'My Trips Page',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildProfilePage() {
    if (!Get.isRegistered<ProfileController>()) {
      Get.lazyPut(() => ProfileController());
    }
    return const ProfileView();
  }
}
