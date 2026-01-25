import 'package:flutter/material.dart' hide DrawerController;
import 'package:get/get.dart';
import 'dart:async';
import '../../../constants/api_constants.dart';
import '../../../models/hotel_model.dart';
import '../../../models/tour_model.dart';
import '../../../repositories/user_repository.dart';
import '../../../routes/app_pages.dart';
import '../../../services/api_service.dart';
import '../../../services/auth_service.dart';
import '../../../widgets/snackbar_helper.dart';
import '../../hotels_booking/controllers/hotels_booking_controller.dart';
import '../../tours_booking/controllers/tours_booking_controller.dart';
import '../../tours_booking/views/tours_booking_view.dart';

class HomeController extends GetxController {

  // Services

  final AuthService _authService = Get.find<AuthService>();
  final ApiService _apiService = Get.find<ApiService>();
  late final UserRepository _userRepository;

// Controllers

  final ToursBookingController _tourBookingController = Get.find<ToursBookingController>();
  final HotelsBookingController _hotelsController = Get.find<HotelsBookingController>();

// Getters

  bool get isLoadingHotels => _hotelsController.isLoadingHotels.value;
  bool get isLoadingTours => _tourBookingController.isLoading.value;
  List<dynamic> get displayedDestinations => _hotelsController.destinations
      .where((dest) => dest['subtitle'] != null && dest['subtitle'].toString().trim().isNotEmpty)
      .take(4)
      .toList();

  // Hotel Getter

  List<Hotel> get popularHotels => _hotelsController.searchResults
      .where((hotel) => hotel.rating >= 4.8)
      .take(3)
      .toList();

// Tour Getter

  List<Tour> get popularTours => _tourBookingController.allTours;
  List<Tour> get topTwoPopularTours {
    final popularList = _tourBookingController.allTours
        .where((tour) => tour.rating >= 5.2)
        .toList();
    return popularList.length > 2
        ? popularList.sublist(0, 2)
        : popularList;
  }
  List<Tour> get displayedTours {
    return _tourBookingController.allTours
        .where((tour) => tour.rating >= 4.5)
        .take(2)
        .toList();
  }

  List<Map<String, dynamic>> get filteredDisplayedDestinations =>
      _hotelsController.destinations
          .where((dest) => dest['subtitle'] != null && dest['subtitle'].toString().isNotEmpty)
          .take(4)
          .toList();

  List<Map<String, dynamic>> get allDestinationsWithSubtitle =>
      _hotelsController.destinations
          .where((dest) => dest['subtitle'] != null && dest['subtitle'].toString().isNotEmpty)
          .toList();

  // Loading States

  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxBool isLoadingProfile = false.obs;
  final RxList<Tour> filteredTours = <Tour>[].obs;


  // Tab & User Data

  final RxInt currentIndex = 0.obs;
  final RxInt selectedTab = 0.obs;
  final RxString userName = 'Guest'.obs;
  final RxString greeting = 'Good Evening'.obs;
  final RxString profileImageUrl = RxString('');
  final RxString userInitials = 'G'.obs;
  final RxBool hasNotifications = false.obs;

  // Search States

  final RxBool isSearching = false.obs;
  final RxString searchQuery = ''.obs;
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();


// Filtered lists for UI

  final RxList<Map<String, dynamic>> filteredDestinations = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> filteredHotels = <Map<String, dynamic>>[].obs;

  // Quick Actions

  final RxList<Map<String, dynamic>> quickActions = <Map<String, dynamic>>[
    {'image':'assets/images/airplane.png','label':'Flight'},
    {'image':'assets/images/hotel.png','label':'Hotels'},
    {'image':'assets/images/car.png','label':'Cars'},
    {'image':'assets/images/location.png','label':'Tours'},
  ].obs;

  // Data Lists

  final RxList<Map<String, dynamic>> hotels = <Map<String, dynamic>>[].obs;
  HotelsBookingController get getHotelsController => _hotelsController;

  // Good Place Data

  final RxMap<String, String> goodPlaceData = <String, String>{
    'badge': 'Limited Time',
    'title': 'Get 30% Off Your First Booking',
    'sub title': 'Use code: TRAVEL30',
    'buttonText': 'Book Now',
  }.obs;

  // Colors

  final List<Color> destinationColors = [
    Colors.teal.shade700,
    Colors.orange.shade700,
    Colors.cyan.shade700,
    Colors.red.shade700,
  ];

  @override
  void onInit() {
    super.onInit();
    _userRepository = UserRepository(_apiService);
    _updateGreeting();
    _loadInitialData();
    ever(_authService.currentUser, (_) => _updateUserData());

    searchController.addListener(() {
      searchQuery.value = searchController.text;
      _performSearch();
    });
  }

  Future<void> _loadInitialData() async {
    isLoading.value = true;
    try {
      await Future.wait([
        _loadProfile(),
        _loadPromotionalBanner(),
        _loadHotelsData(),
      ]);
    } catch (e) {
      _showError('Failed to load data');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadProfile() async {
    if (!_authService.isAuthenticated) return;

    isLoadingProfile.value = true;
    try {
      final user = await _userRepository.getProfile();
      await _authService.updateUser(user);
    } catch (e) {
    } finally {
      isLoadingProfile.value = false;
    }
  }

  Future<void> _loadHotelsData() async {
    if (_hotelsController.allHotels.isNotEmpty) {
      final destinationsSet = <String, Map<String, dynamic>>{};
      for (var hotel in _hotelsController.allHotels) {
        final locationKey = hotel.location;
        if (!destinationsSet.containsKey(locationKey)) {
          destinationsSet[locationKey] = {
            'name': hotel.name,
            'location': hotel.location,
            'image': hotel.image,
            'subtitle': hotel.subtitle ?? '',
            'price': hotel.price,
            'rating': hotel.rating,
          };
        }
      }
      _hotelsController.destinations.assignAll(destinationsSet.values.toList());
    }
  }

  Future<void> _loadPromotionalBanner() async {
    try {
      final response = await _apiService
          .get('${ApiConstants.baseUrl}/api/promotional-banner')
          .timeout(const Duration(seconds: 10));

      if (response['success'] == true && response['data'] != null) {
        final bannerData = response['data'];
        goodPlaceData.assignAll({
          'badge': bannerData['badge'] ?? 'Limited Time',
          'title': bannerData['title'] ?? 'Get 30% Off Your First Booking',
          'sub title': bannerData['subtitle'] ?? 'Use code: TRAVEL30',
          'buttonText': bannerData['buttonText'] ?? 'Book Now',
        });
      }
    } catch (e) {
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }

  void _updateGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      greeting.value = 'Good Morning';
    } else if (hour < 17) {
      greeting.value = 'Good Afternoon';
    } else {
      greeting.value = 'Good Evening';
    }
  }

  void _updateUserData() {
    final user = _authService.currentUser.value;
    userName.value = user?.name ?? 'Guest';
    profileImageUrl.value = user?.profileImageUrl ?? '';
    userInitials.value = user?.initials ?? 'G';
  }

  //  Search method

  void _performSearch() {
    final query = searchQuery.value.toLowerCase().trim();
    _tourBookingController.searchQuery.value = query;

    if (query.isEmpty) {
      filteredDestinations.clear();
      filteredHotels.clear();
      filteredTours.clear();
      return;
    }

    // Search in destinations

    filteredDestinations.assignAll(
      _hotelsController.destinations.where((item) {
        final name = (item['name'] as String? ?? '').toLowerCase();
        return name.contains(query);
      }).toList(),
    );


    // Search in hotels

    filteredHotels.assignAll(
      _hotelsController.allHotels.where((hotel) {
        return hotel.name.toLowerCase().contains(query) ||
            hotel.location.toLowerCase().contains(query);
      }).map((hotel) => {
        'name': hotel.name,
        'location': hotel.location,
        'rating': hotel.rating,
      }).toList(),
    );

    // Search in tours

    filteredTours.assignAll(
        _tourBookingController.allTours.where((tour) {
          final title = tour.title.toLowerCase();
          final location = tour.location.toLowerCase();
          final category = tour.category.toLowerCase();

          return title.contains(query) ||
              location.contains(query) ||
              category.contains(query);
        }).toList()
    );
  }

// Featured Destination

  void onDestinationTap(int index) {
    if (index >= _hotelsController.destinations.length) return;

    final destination = _hotelsController.destinations[index];
    final String destLocation = destination['location'] ?? '';
    final hotelsInLocation = _hotelsController.allHotels
        .where((hotel) => hotel.location.toLowerCase().contains(destLocation.toLowerCase()))
        .toList();
    Get.toNamed(
      '/all-hotels',
      arguments: {
        'title': 'Hotels in $destLocation',
        'hotels': hotelsInLocation,
        'isPopular': false,
      },
    );
  }

  // Display limited hotels for home page

List<Hotel> get displayedHotels {
  final hotelList = _hotelsController.allHotels;
  return hotelList.length > 3 ? hotelList.sublist(0, 3) : hotelList;
}

  // USER ACTIONS

  Future<void> refreshData() async {
    isRefreshing.value = true;
    await _loadInitialData();
    isRefreshing.value = false;
    _showSuccess('Data refreshed successfully');
  }

  void selectTab(int index) {
    switch (index) {
      case 0:Get.toNamed('/flight-booking');
        break;
      case 1:Get.toNamed('/hotels-booking');
        break;
      case 2:Get.toNamed('/cars-booking');
        break;
      case 3:Get.toNamed('/tours-booking');
        break;
    }
  }

  Color getDestinationColor(int index) {
    return destinationColors[index % destinationColors.length];
  }

  // Navigation methods

  void onSearchTap() => Get.toNamed('/search');
  void onNotificationTap() => Get.toNamed('/notifications');

  void onBookNowTap() => Get.toNamed('/explore');

  void onSeeAllTours() {
    Get.to(() => const ToursBookingView(), arguments: 'popular');
  }


  void onSeeAllHotels() {
    Get.toNamed('/all-hotels', arguments: {
      'title': 'Popular Hotels',
      'hotels': popularHotels,
      'isPopular': true,
    });
  }

  void onHotelTap(int index) {
    if (index < hotels.length) {
      Get.toNamed('/hotel-details', arguments: hotels[index]);
    }
  }

  void onTourTapObject(Tour tour) {
    Get.toNamed(Routes.TOUR_DETAILS, arguments: tour);

  }

  void onSeeAllDestinations() => Get.toNamed('/destinations');
  void onSeeAllCars() => Get.toNamed('/cars');
  void onSeeAllFlight() => Get.toNamed('/flight');

  // UI Feedback Helper

  void _showSuccess(String message) {
    SnackbarHelper.showSuccess('Operation completed successfully!');
  }

  void _showError(String message) {
    SnackbarHelper.showError('Something went wrong');
  }
}