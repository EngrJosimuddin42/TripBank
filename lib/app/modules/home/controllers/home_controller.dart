import 'package:flutter/material.dart' hide DrawerController;
import 'package:get/get.dart';
import 'dart:async';
import '../../../constants/api_constants.dart';
import '../../../repositories/user_repository.dart';
import '../../../services/api_service.dart';
import '../../../services/auth_service.dart';
import '../../../services/favorites_service.dart';

class HomeController extends GetxController {
  // Services
  final AuthService _authService = Get.find<AuthService>();
  final ApiService _apiService = Get.find<ApiService>();
  final FavoritesService _favoritesService = Get.find<FavoritesService>();
  late final UserRepository _userRepository;

  // Loading States
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxBool isLoadingProfile = false.obs;

  // Tab Management
  final RxInt currentIndex = 0.obs;
  final RxInt selectedTab = 0.obs;

  // User Data
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

  // Quick Actions
  final RxList<Map<String, dynamic>> quickActions = <Map<String, dynamic>>[
    {'image':'assets/images/airplane.png','label':'Flight'},
    {'image':'assets/images/hotel.png','label':'Hotels'},
    {'image':'assets/images/car.png','label':'Cars'},
    {'image':'assets/images/location.png','label':'Tours'},
  ].obs;

  // Data Lists
  final RxList<Map<String, dynamic>> destinations = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> hotels = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> tours = <Map<String, dynamic>>[].obs;

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
    });

    // Sync favorite status when favorites change
    ever(_favoritesService.favoriteHotels, (_) => _updateHotelFavoriteStatus());
    ever(_favoritesService.favoriteTours, (_) => _updateTourFavoriteStatus());
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

  // Update favorite status from FavoritesService
  void _updateHotelFavoriteStatus() {
    for (var hotel in hotels) {
      final itemId = hotel['id'] ?? hotel['name'];
      hotel['isFavorite'] = _favoritesService.isFavorite('hotel', itemId);
    }
    hotels.refresh();
  }

  void _updateTourFavoriteStatus() {
    for (var tour in tours) {
      final itemId = tour['id'] ?? tour['name'];
      tour['isFavorite'] = _favoritesService.isFavorite('tour', itemId);
    }
    tours.refresh();
  }

  Future<void> _loadInitialData() async {
    isLoading.value = true;
    try {
      await Future.wait([
        _loadProfile(),
        _loadPromotionalBanner(),
        _loadDestinations(),
        _loadHotels(),
        _loadTours(),
      ]);

      // Update favorite status after loading data
      _updateHotelFavoriteStatus();
      _updateTourFavoriteStatus();
    } catch (e) {
      print('Error loading initial data: $e');
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
      print('Error loading profile: $e');
    } finally {
      isLoadingProfile.value = false;
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
      print('Error loading banner: $e');
    }
  }

  Future<void> _loadDestinations() async {
    try {
      final response = await _apiService
          .get('${ApiConstants.baseUrl}/api/destinations/featured')
          .timeout(const Duration(seconds: 10));

      if (response['success'] == true && response['data'] != null) {
        destinations.assignAll(List<Map<String, dynamic>>.from(response['data']));
      } else {
        _loadDummyDestinations();
      }
    } catch (e) {
      print('Error loading destinations: $e');
      _loadDummyDestinations();
    }
  }

  Future<void> _loadHotels() async {
    try {
      final response = await _apiService
          .get('${ApiConstants.baseUrl}/api/hotels/popular')
          .timeout(const Duration(seconds: 10));

      if (response['success'] == true && response['data'] != null) {
        hotels.assignAll(List<Map<String, dynamic>>.from(response['data']));
      } else {
        _loadDummyHotels();
      }
    } catch (e) {
      print('Error loading hotels: $e');
      _loadDummyHotels();
    }
  }

  Future<void> _loadTours() async {
    try {
      final response = await _apiService
          .get('${ApiConstants.baseUrl}/api/tours/popular')
          .timeout(const Duration(seconds: 10));

      if (response['success'] == true && response['data'] != null) {
        tours.assignAll(List<Map<String, dynamic>>.from(response['data']));
      } else {
        _loadDummyTours();
      }
    } catch (e) {
      print('Error loading tours: $e');
      _loadDummyTours();
    }
  }

  void _loadDummyDestinations() {
    destinations.assignAll([
      {
        'id': 'dest_1',
        'name': 'Maldives',
        'subtitle': '120+ Hotels\nfrom \$599',
        'image': 'https://images.unsplash.com/photo-1514282401047-d79a71a590e8?w=400',
        'isFavorite': false,
      },
      {
        'id': 'dest_2',
        'name': 'Paris',
        'subtitle': '200+ Hotels\nfrom \$799',
        'image': 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=400',
        'isFavorite': false,
      },
      {
        'id': 'dest_3',
        'name': 'Dubai',
        'subtitle': '150+ Hotels\nfrom \$899',
        'image': 'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?w=400',
        'isFavorite': false,
      },
      {
        'id': 'dest_4',
        'name': 'Tokyo',
        'subtitle': '180+ Hotels\nfrom \$699',
        'image': 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400',
        'isFavorite': false,
      },
      {
        'id': 'dest_5',
        'name': 'Bali',
        'subtitle': '140+ Hotels\nfrom \$499',
        'image': 'https://images.unsplash.com/photo-1537996194471-e657df975ab4?w=400',
        'isFavorite': false,
      },
      {
        'id': 'dest_6',
        'name': 'New York',
        'subtitle': '250+ Hotels\nfrom \$950',
        'image': 'https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400',
        'isFavorite': false,
      },
      {
        'id': 'dest_7',
        'name': 'Santorini',
        'subtitle': '90+ Hotels\nfrom \$850',
        'image': 'https://images.unsplash.com/photo-1613395877344-13d4a8e0d49e?w=400',
        'isFavorite': false,
      },
      {
        'id': 'dest_8',
        'name': 'London',
        'subtitle': '220+ Hotels\nfrom \$750',
        'image': 'https://images.unsplash.com/photo-1513635269975-59663e0ac1ad?w=400',
        'isFavorite': false,
      },
    ]);
  }

  void _loadDummyHotels() {
    hotels.assignAll([
      {
        'id': 'hotel_1',
        'name': 'Grand Luxury Resort',
        'location': 'Maldives',
        'rating': 4.8,
        'reviews': 324,
        'price': '\$450',
        'isFavorite': false,
        'image': 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=400',
      },
      {
        'id': 'hotel_2',
        'name': 'Sunset Beach Villa',
        'location': 'Bali',
        'rating': 4.9,
        'reviews': 512,
        'price': '\$380',
        'isFavorite': false,
        'image': 'https://images.unsplash.com/photo-1540541338287-41700207dee6?w=400',
      },
      {
        'id': 'hotel_3',
        'name': 'City Center Hotel',
        'location': 'Paris',
        'rating': 4.7,
        'reviews': 289,
        'price': '\$320',
        'isFavorite': false,
        'image': 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=400',
      },
      {
        'id': 'hotel_4',
        'name': 'Desert Oasis Resort',
        'location': 'Dubai',
        'rating': 4.6,
        'reviews': 456,
        'price': '\$520',
        'isFavorite': false,
        'image': 'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?w=400',
      },
      {
        'id': 'hotel_5',
        'name': 'Mountain View Lodge',
        'location': 'Switzerland',
        'rating': 4.9,
        'reviews': 398,
        'price': '\$680',
        'isFavorite': false,
        'image': 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=400',
      },
    ]);
  }

  void _loadDummyTours() {
    tours.assignAll([
      {
        'id': 'tour_1',
        'name': 'Zuma Rock',
        'rating': 4.9,
        'days': 5,
        'price': '\$899',
        'isFavorite': false,
        'image': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400',
      },
      {
        'id': 'tour_2',
        'name': 'Osun-Osogbo Sacred Grove',
        'rating': 4.9,
        'days': 5,
        'price': '\$899',
        'isFavorite': false,
        'image': 'https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=400',
      },
      {
        'id': 'tour_3',
        'name': 'Olumo Rock Adventure',
        'rating': 4.7,
        'days': 3,
        'price': '\$599',
        'isFavorite': false,
        'image': 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?w=400',
      },
    ]);
  }

  // ==================== FAVORITE TOGGLE METHODS ====================

  /// Toggle hotel favorite status
  Future<void> toggleHotelFavorite(int index) async {
    if (index < 0 || index >= hotels.length) return;

    final hotel = hotels[index];

    // Optimistic update - update UI immediately
    hotel['isFavorite'] = !(hotel['isFavorite'] ?? false);
    hotels.refresh();

    // Sync with FavoritesService
    final success = await _favoritesService.toggleFavorite('hotel', hotel);

    if (!success) {
      // Rollback if failed
      hotel['isFavorite'] = !(hotel['isFavorite'] ?? false);
      hotels.refresh();
    }
  }

  /// Toggle tour favorite status
  Future<void> toggleTourFavorite(int index) async {
    if (index < 0 || index >= tours.length) return;

    final tour = tours[index];

    // Optimistic update
    tour['isFavorite'] = !(tour['isFavorite'] ?? false);
    tours.refresh();

    // Sync with FavoritesService
    final success = await _favoritesService.toggleFavorite('tour', tour);

    if (!success) {
      // Rollback if failed
      tour['isFavorite'] = !(tour['isFavorite'] ?? false);
      tours.refresh();
    }
  }

  // ==================== DISPLAY METHODS ====================

  /// Display limited destinations for home page
  List<Map<String, dynamic>> get displayedDestinations {
    return destinations.length > 4 ? destinations.sublist(0, 4) : destinations;
  }

  /// Display limited hotels for home page
  List<Map<String, dynamic>> get displayedHotels {
    return hotels.length > 3 ? hotels.sublist(0, 3) : hotels;
  }

  /// Display limited tours for home page
  List<Map<String, dynamic>> get displayedTours {
    return tours.length > 2 ? tours.sublist(0, 2) : tours;
  }

  // ==================== USER ACTIONS ====================

  Future<void> refreshData() async {
    isRefreshing.value = true;
    await _loadInitialData();
    isRefreshing.value = false;
    _showSuccess('Data refreshed successfully');
  }

  void selectTab(int index) {
    switch (index) {
      case 0:
        Get.toNamed('/flight-booking');
        break;
      case 1:
        Get.toNamed('/hotels-booking');
        break;
      case 2:
        Get.toNamed('/cars-booking');
        break;
      case 3:
        Get.toNamed('/tours-booking');
        break;
    }
  }

  Color getDestinationColor(int index) {
    return destinationColors[index % destinationColors.length];
  }

  // Navigation methods
  void onSearchTap() => Get.toNamed('/search');
  void onNotificationTap() => Get.toNamed('/notifications');
  void onBookNowTap() => Get.toNamed('/booking');

  void onDestinationTap(int index) {
    if (index < destinations.length) {
      Get.toNamed('/destination-details', arguments: destinations[index]);
    }
  }

  void onHotelTap(int index) {
    if (index < hotels.length) {
      Get.toNamed('/hotel-details', arguments: hotels[index]);
    }
  }

  void onTourTap(int index) {
    if (index < tours.length) {
      Get.toNamed('/tour-details', arguments: tours[index]);
    }
  }

  void onSeeAllDestinations() => Get.toNamed('/destinations');
  void onSeeAllHotels() => Get.toNamed('/hotels');
  void onSeeAllTours() => Get.toNamed('/tours');
  void onSeeAllCars() => Get.toNamed('/cars');
  void onSeeAllFlight() => Get.toNamed('/flight');

  // ==================== UI FEEDBACK ====================

  void _showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      backgroundColor: Colors.green.withOpacity(0.1),
      colorText: Colors.green[900],
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red.withOpacity(0.1),
      colorText: Colors.red[900],
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
}