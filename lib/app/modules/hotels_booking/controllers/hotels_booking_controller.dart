import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/booking_model.dart';
import '../../../models/hotel_model.dart';
import '../../../services/favorites_service.dart';
import '../../my_bookings/controllers/my_bookings_controller.dart';

class HotelsBookingController extends GetxController {
  final isFromSaved = false.obs;
  final FavoritesService _favoritesService = Get.find<FavoritesService>();

  final RxList<Map<String, dynamic>> destinations = <Map<String, dynamic>>[].obs;

  final RxList<String> selectedFilters = <String>[].obs;
  final RxList<Hotel> allHotels = <Hotel>[].obs;
  final RxList<Hotel> searchResults = <Hotel>[].obs;
  final RxBool isLoadingHotels = false.obs;

  bool isHotelFavorite(String hotelId) {
    return _favoritesService.isFavorite('hotel', hotelId);
  }



  Future<void> toggleHotelFavorite(String hotelId) async {
    final hotel = searchResults.firstWhereOrNull((h) => h.id == hotelId);
    if (hotel == null) return;

    final hotelData = {
      'id': hotel.id,
      'name': hotel.name,
      'location': hotel.location,
      'image': hotel.image,
      'images': hotel.images,
      'rating': hotel.rating,
      'reviews': hotel.reviews,
      'price': hotel.price,
      'originalPrice': hotel.originalPrice,
      'discount': hotel.discount,
      'nights': hotel.nights,
      'address': hotel.address,
      'description': hotel.description,
      'highlights': hotel.highlights,
      'Services': hotel.services?.map((s) => {
        'name': s.name,
        'icon': Service.iconToString(s.icon),
      }).toList(),
      'roomDetails': hotel.roomDetails?.map((r) => {
        'label': r.label,
        'value': r.value,
        'isPrice': r.isPrice,
      }).toList(),
    };

    await _favoritesService.toggleFavorite('hotel', hotelData);
    searchResults.refresh();
  }


  Future<List<Hotel>> fetchHotels({
    required String location,
    required DateTime checkIn,
    required DateTime checkOut,
    required int rooms,
    required int guests,
  }) async {


    // return dummy data

    await Future.delayed(const Duration(seconds: 1));
    return _getDummyHotels();
  }

  // Date fields

  final Rx<DateTime> checkInDate = DateTime(2026, 12, 1).obs;
  final Rx<DateTime> checkOutDate = DateTime(2026, 12, 10).obs;
  var selectedRoomIndex = 0.obs;
  var currentPage = 0.obs;
  var selectedTab = 'Overview'.obs;

  void changePage(int index) => currentPage.value = index;
  void changeTab(String tab) => selectedTab.value = tab;
  void selectRoom(int index) => selectedRoomIndex.value = index;

  // Booking details

  final RxString location = 'Paris, France'.obs;
  final RxInt roomCount = 1.obs;
  final RxInt guestCount = 1.obs;
  final RxString preferredClass = 'Economy'.obs;

  // Computed property for nights

  Rx<int> get nights {
    final difference = checkOutDate.value.difference(checkInDate.value).inDays;
    return difference.obs;
  }
  final RxList<Map<String, dynamic>> allLocationData = <Map<String, dynamic>>[].obs;
  final Rx<Hotel?> selectedHotel = Rx<Hotel?>(null);



  // Rooms using Model

  final RxList<Room> roomList = <Room>[].obs;

  // Filter
  final RxInt selectedTabIndex = 0.obs;

  // Price range filter
  final RxDouble minPrice = 0.0.obs;
  final RxDouble maxPrice = 10000.0.obs;


  // Payment and booking fields

  final RxString selectedPaymentMethod = ''.obs;
  final RxString couponCode = ''.obs;
  final RxDouble discountPercentage = 0.0.obs;

  // User Information Controllers

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final specialRequestsController = TextEditingController();

  // Billing Address Controllers

  final billingFirstNameController = TextEditingController();
  final billingLastNameController = TextEditingController();
  final billingPhoneController = TextEditingController();
  final billingEmailController = TextEditingController();
  final billingCountryController = TextEditingController();
  final billingStateController = TextEditingController();
  final billingZipController = TextEditingController();

  void _loadDummyData() {
    isLoadingHotels.value = true;
    Future.delayed(const Duration(seconds: 1), () {
      final hotels = _getDummyHotels();
      allHotels.assignAll(hotels);
      searchResults.assignAll(_getDummyHotels());
      roomList.assignAll(getDummyRooms());
      _populateDestinations();
      isLoadingHotels.value = false;
    });
  }

  void _populateDestinations() {
    final destinationsMap = <String, Map<String, dynamic>>{};

    for (var hotel in allHotels) {
      if (hotel.subtitle != null && hotel.subtitle!.trim().isNotEmpty) {
        final key = hotel.location;
        if (!destinationsMap.containsKey(key)) {
          destinationsMap[key] = {
            'name': hotel.name,
            'location': hotel.location,
            'image': hotel.image,
            'subtitle': hotel.subtitle,
            'price': hotel.price,
            'rating': hotel.rating,
          };
        }
      }
    }

    destinations.assignAll(destinationsMap.values.toList());
  }


  @override
  void onInit() {
    super.onInit();
    if (!isFromSaved.value) {
      location.value = 'Paris, France';
    }
    _loadDummyData();
    allHotels.assignAll(_getDummyHotels());
  }

  @override
  void onReady() {
    super.onReady();
  }


  @override
  void onClose() {
    _disposeControllers();
    super.onClose();
  }

  void resetToInitialState() {
    //  Reset location to default
    location.value = 'Paris, France';
    isFromSaved.value = false;
    selectedHotel.value = null;
    //  Reset Room & Guest to default
    roomCount.value = 1;
    guestCount.value = 1;
    //  Reset Class to default
    preferredClass.value = 'Economy';
    //  Reset dates to default
    checkInDate.value = DateTime.now().add(const Duration(days: 1));
    checkOutDate.value = DateTime.now().add(const Duration(days: 2));
  }

  void _disposeControllers() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    specialRequestsController.dispose();
    billingFirstNameController.dispose();
    billingLastNameController.dispose();
    billingPhoneController.dispose();
    billingEmailController.dispose();
    billingCountryController.dispose();
    billingStateController.dispose();
    billingZipController.dispose();
  }

  // Dummy data for Development

  List<Hotel> _getDummyHotels() {
    return [
      Hotel(
        id: '1',
        name: 'The Fullerton Hotel Singapore',
        image: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400',
        images: [
          'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400',
          'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=400',
          'https://images.unsplash.com/photo-1611892440504-42a792e24d32?w=400',
        ],
        rating: 5.0,
        reviews: 1200,
        description:
        'With a stay at The Fullerton Hotel Singapore, you\'ll be centrally located in Singapore, steps from Merlion and 4 minutes by foot from Esplanade Theatres. This 5-star hotel is 0.5 mi (0.8 km) from Marina Bay Sands Casino and 0.5 mi (0.9 km) from Marina Bay.',
        address: '1 Fullerton Square',
        price: 2024,
        originalPrice: 2400,
        nights: 1,
        discount: 15,
        location: 'Uk, Marina Bay',
        highlights: [
          'The location of this hotel has a driving score of 98',
          'This hotel has very welcoming rating score of 85 out of 100',
          'The WiFi service, the hotel provides has a rating score of 91',
          'The staff\'s service has an overall rating of 91!'
        ],
        services: [
          Service(name: 'Air Conditioning', icon: Icons.ac_unit),
          Service(name: 'Business Center', icon: Icons.business),
          Service(name: 'Dry Cleaning', icon: Icons.dry_cleaning),
          Service(name: 'Clothing Iron', icon: Icons.iron),
          Service(name: 'Cafe', icon: Icons.local_cafe),
          Service(name: 'Wifi', icon: Icons.wifi),
        ],
        roomDetails: [
          RoomDetail(label: 'Bedroom', value: '2 Double'),
          RoomDetail(label: 'Living room', value: '1 Sofa Bed'),
          RoomDetail(label: 'Toilet', value: '1'),
          RoomDetail(label: 'Shower', value: '1'),
          RoomDetail(label: 'Room Size', value: '40 sqm'),
          RoomDetail(label: 'Cancellation policy', value: 'See details'),
          RoomDetail(
              label: 'Fully refundable before 13 Dec',
              value: '+\$0.00',
              isPrice: true),
          RoomDetail(
              label: 'Pay nothing until 13 Dec',
              value: '+\$0.00',
              isPrice: true),
        ],
      ),
      Hotel(
        id: '2',
        name: 'Marina Bay Sands Hotel',
        image:   'https://images.unsplash.com/photo-1564507592333-c3f5c451e9d1?w=400',
        images: [
          'https://images.unsplash.com/photo-1564507592333-c3f5c451e9d1?w=400',
          'https://images.unsplash.com/photo-1584132967334-10e028bd69f7?w=400',
          'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400',
        ],
        rating: 4.0,
        reviews: 14500,
        description:
        'Iconic luxury hotel with infinity pool on the 57th floor, stunning views of Marina Bay, and direct access to The Shoppes mall. Famous for its three-tower design and SkyPark.',
        address: '10 Bayfront Avenue',
        price: 2850,
        originalPrice: 3400,
        nights: 1,
        discount: 16,
        location: 'Singapore, Marina Bay',
        highlights: [
          'Infinity pool with panoramic city views',
          'Direct access to The Shoppes & casino',
          'Location score: 97/100',
          'Staff service rating: 92/100'
        ],
        services: [
          Service(name: 'Infinity Pool', icon: Icons.pool),
          Service(name: 'Casino', icon: Icons.casino),
          Service(name: 'Spa', icon: Icons.spa),
          Service(name: '24h Room Service', icon: Icons.room_service),
          Service(name: 'Gym', icon: Icons.fitness_center),
          Service(name: 'Wifi', icon: Icons.wifi),
        ],
        roomDetails: [
          RoomDetail(label: 'Bedroom', value: '1 King'),
          RoomDetail(label: 'Living area', value: 'Yes'),
          RoomDetail(label: 'Toilet', value: '1'),
          RoomDetail(label: 'Bathtub + Shower', value: '1'),
          RoomDetail(label: 'Room Size', value: '55 sqm'),
          RoomDetail(label: 'Cancellation policy', value: 'See details'),
          RoomDetail(label: 'Fully refundable before 13 Dec', value: '+\$0.00', isPrice: true),
          RoomDetail(label: 'Pay nothing until 13 Dec', value: '+\$0.00', isPrice: true),
        ],
      ),

      Hotel(
        id: '3',
        name: 'Raffles Singapore',
        image: 'https://images.unsplash.com/photo-1578683015146-bda0e180a9b7?w=400',
        images: [
          'https://images.unsplash.com/photo-1578683015146-bda0e180a9b7?w=400',
          'https://images.unsplash.com/photo-1562790351-d273a961e0e9?w=400',
          'https://images.unsplash.com/photo-1584132967334-10e028bd69f7?w=400',
        ],
        rating: 3.0,
        reviews: 3200,
        description:
        'Historic luxury colonial-style hotel in the heart of Singapore. Famous for the Long Bar (birthplace of Singapore Sling) and impeccable heritage service.',
        address: '1 Beach Road',
        price: 1680,
        originalPrice: 1950,
        nights: 1,
        discount: 14,
        location: 'Singapore, City Hall',
        highlights: [
          'Heritage building since 1887',
          'Famous Long Bar & Singapore Sling',
          'Location score: 96/100',
          'Personalized butler service'
        ],
        services: [
          Service(name: 'Butler Service', icon: Icons.person),
          Service(name: 'Long Bar', icon: Icons.local_bar),
          Service(name: 'Spa', icon: Icons.spa),
          Service(name: 'Pool', icon: Icons.pool),
          Service(name: 'High-speed Wifi', icon: Icons.wifi),
          Service(name: '24h Concierge', icon: Icons.headset),
        ],
        roomDetails: [
          RoomDetail(label: 'Bedroom', value: '1 King'),
          RoomDetail(label: 'Living area', value: 'Separate'),
          RoomDetail(label: 'Toilet', value: '1.5'),
          RoomDetail(label: 'Bathtub', value: 'Yes'),
          RoomDetail(label: 'Room Size', value: '65 sqm'),
          RoomDetail(label: 'Cancellation policy', value: 'See details'),
          RoomDetail(label: 'Fully refundable before 13 Dec', value: '+\$0.00', isPrice: true),
          RoomDetail(label: 'Pay nothing until 13 Dec', value: '+\$0.00', isPrice: true),
        ],
      ),

      Hotel(
        id: '4',
        name: 'Mandarin Oriental Singapore',
        image: 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=400',
        images: [
          'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=400',
          'https://images.unsplash.com/photo-1564507592333-c3f5c451e9d1?w=400',
          'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=400',
        ],
        rating: 5.0,
        reviews: 4800,
        description:
        'Luxury waterfront hotel with panoramic views of Marina Bay. Renowned for its award-winning restaurants and exceptional service.',
        address: '5 Raffles Avenue',
        price: 2350,
        originalPrice: 2800,
        nights: 1,
        discount: 16,
        location: 'Singapore, Marina Bay',
        highlights: [
          'Stunning Marina Bay views',
          'Multiple Michelin-starred dining',
          'Location score: 98/100',
          'Excellent spa & pool facilities'
        ],
        services: [
          Service(name: 'Outdoor Pool', icon: Icons.pool),
          Service(name: 'Spa', icon: Icons.spa),
          Service(name: 'Fine Dining', icon: Icons.restaurant),
          Service(name: 'Gym', icon: Icons.fitness_center),
          Service(name: 'Wifi', icon: Icons.wifi),
          Service(name: 'Concierge', icon: Icons.headset),
        ],
        roomDetails: [
          RoomDetail(label: 'Bedroom', value: '1 King'),
          RoomDetail(label: 'Living area', value: 'Yes'),
          RoomDetail(label: 'Toilet', value: '1'),
          RoomDetail(label: 'Bathtub + Rain Shower', value: '1'),
          RoomDetail(label: 'Room Size', value: '50 sqm'),
          RoomDetail(label: 'Cancellation policy', value: 'See details'),
          RoomDetail(label: 'Fully refundable before 13 Dec', value: '+\$0.00', isPrice: true),
          RoomDetail(label: 'Pay nothing until 13 Dec', value: '+\$0.00', isPrice: true),
        ],
      ),

      Hotel(
        id: '5',
        name: 'Shangri-La Singapore',
        image: 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=400',
        images: [
          'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=400',
          'https://images.unsplash.com/photo-1562790351-d273a961e0e9?w=400',
          'https://images.unsplash.com/photo-1584132967334-10e028bd69f7?w=400',
        ],
        rating: 4.0,
        reviews: 6800,
        description:
        'Set in lush tropical gardens, this luxury hotel offers a tranquil escape in the heart of Orchard Road with excellent facilities and service.',
        address: '22 Orange Grove Road',
        price: 1420,
        originalPrice: 1700,
        nights: 1,
        discount: 16,
        location: 'Singapore, Orchard Road',
        highlights: [
          '22 acres of tropical gardens',
          'Award-winning spa CHI',
          'Location score: 94/100',
          'Multiple award-winning restaurants'
        ],
        services: [
          Service(name: 'Outdoor Pool', icon: Icons.pool),
          Service(name: 'Spa CHI', icon: Icons.spa),
          Service(name: 'Kids Club', icon: Icons.child_care),
          Service(name: 'Gym', icon: Icons.fitness_center),
          Service(name: 'Wifi', icon: Icons.wifi),
          Service(name: 'Tennis Court', icon: Icons.sports_tennis),
        ],
        roomDetails: [
          RoomDetail(label: 'Bedroom', value: '1 King'),
          RoomDetail(label: 'Balcony', value: 'Yes'),
          RoomDetail(label: 'Toilet', value: '1'),
          RoomDetail(label: 'Bathtub', value: 'Yes'),
          RoomDetail(label: 'Room Size', value: '48 sqm'),
          RoomDetail(label: 'Cancellation policy', value: 'See details'),
          RoomDetail(label: 'Fully refundable before 13 Dec', value: '+\$0.00', isPrice: true),
          RoomDetail(label: 'Pay nothing until 13 Dec', value: '+\$0.00', isPrice: true),
        ],
      ),

      Hotel(
        id: '6',
        name: 'Capella Singapore',
        subtitle: '140+ Hotels\nfrom \$499',
        image: 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=400',
        images: [
          'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=400',
          'https://images.unsplash.com/photo-1564507592333-c3f5c451e9d1?w=400',
          'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=400',
        ],
        rating: 3.0,
        reviews: 2100,
        description:
        'Luxury resort on Sentosa Island with colonial architecture, lush gardens, and world-class service. Perfect for a tranquil island escape.',
        address: '1 The Knolls, Sentosa Island',
        price: 1980,
        originalPrice: 2350,
        nights: 1,
        discount: 16,
        location: 'Singapore, Sentosa Island',
        highlights: [
          'Private island resort experience',
          'Award-winning Auriga Spa',
          'Two beaches nearby',
          'Location score: 95/100'
        ],
        services: [
          Service(name: 'Private Beach', icon: Icons.beach_access),
          Service(name: 'Spa Auriga', icon: Icons.spa),
          Service(name: 'Kids Club', icon: Icons.child_care),
          Service(name: 'Infinity Pool', icon: Icons.pool),
          Service(name: 'Wifi', icon: Icons.wifi),
          Service(name: 'Golf Course Access', icon: Icons.golf_course),
        ],
        roomDetails: [
          RoomDetail(label: 'Bedroom', value: '1 King'),
          RoomDetail(label: 'Outdoor Terrace', value: 'Yes'),
          RoomDetail(label: 'Toilet', value: '1'),
          RoomDetail(label: 'Rain Shower + Bathtub', value: '1'),
          RoomDetail(label: 'Room Size', value: '62 sqm'),
          RoomDetail(label: 'Cancellation policy', value: 'See details'),
          RoomDetail(label: 'Fully refundable before 13 Dec', value: '+\$0.00', isPrice: true),
          RoomDetail(label: 'Pay nothing until 13 Dec', value: '+\$0.00', isPrice: true),
        ],
      ),

      Hotel(
        id: '7',
        name: 'Marina Bay Sands Hotel',
        image: 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?w=400',
        images: [
          'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?w=400',
          'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=400',
          'https://images.unsplash.com/photo-1578683010236-d716f9a3f461?w=400',
        ],
        rating: 5.0,
        reviews: 3450,
        description:
        'Experience luxury at Marina Bay Sands, an iconic landmark in Singapore\'s skyline. This integrated resort features world-class dining, shopping, and entertainment.',
        address: '10 Bayfront Avenue',
        price: 3150,
        originalPrice: 3600,
        nights: 1,
        discount: 12,
        location: 'Singapore, Marina Bay',
        highlights: [
          'Stunning rooftop infinity pool with city views',
          'Award-winning restaurants and celebrity chef dining',
          'Direct access to luxury shopping at The Shoppes',
          'The staff\'s service has an overall rating of 91!'
        ],
        services: [
          Service(name: 'Air Conditioning', icon: Icons.ac_unit),
          Service(name: 'Business Center', icon: Icons.business),
          Service(name: 'Pool', icon: Icons.pool),
          Service(name: 'Spa', icon: Icons.spa),
          Service(name: 'Restaurant', icon: Icons.restaurant),
          Service(name: 'Wifi', icon: Icons.wifi),
        ],
        roomDetails: [
          RoomDetail(label: 'Bedroom', value: '1 King'),
          RoomDetail(label: 'Living room', value: '1 Sofa'),
          RoomDetail(label: 'Toilet', value: '1'),
          RoomDetail(label: 'Shower', value: '1'),
          RoomDetail(label: 'Room Size', value: '50 sqm'),
          RoomDetail(label: 'Cancellation policy', value: 'See details'),
          RoomDetail(
              label: 'Fully refundable before 13 Dec',
              value: '+\$0.00',
              isPrice: true),
          RoomDetail(
              label: 'Pay nothing until 25 Dec',
              value: '+\$0.00',
              isPrice: true),
        ],
      ),
      Hotel(
        id: '8',
        name: 'Maldives Paradise Resort',
        subtitle: '120+ Hotels\nfrom \$599',
        image: 'https://images.unsplash.com/photo-1514282401047-d79a71a590e8?w=400',
        images: [
          'https://images.unsplash.com/photo-1514282401047-d79a71a590e8?w=400',
          'https://images.unsplash.com/photo-1439066615861-d1af74d74000?w=400',
        ],
        rating: 4.9,
        reviews: 1250,
        description: 'Experience the ultimate tropical getaway in the heart of Maldives.',
        address: 'North Male Atoll',
        price: 599,
        originalPrice: 750,
        nights: 1,
        discount: 20,
        location: 'Maldives',
        highlights: ['Overwater bungalows', 'Private beach', 'World-class diving'],
        services: [
          Service(name: 'Wifi', icon: Icons.wifi),
          Service(name: 'Pool', icon: Icons.pool),
          Service(name: 'Spa', icon: Icons.spa),
        ],
        roomDetails: [
          RoomDetail(label: 'Bedroom', value: '1 King'),
          RoomDetail(label: 'Room Size', value: '75 sqm'),
        ],
      ),
      Hotel(
        id: '9',
        name: 'The Paris Elegance',
        subtitle: '200+ Hotels\nfrom \$799',
        image: 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=400',
        images: [
          'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=400',
          'https://images.unsplash.com/photo-1499856871958-5b9627545d1a?w=400',
        ],
        rating: 6.8,
        reviews: 2100,
        description: 'Luxury stay with a view of the Eiffel Tower.',
        address: 'Avenue Montaigne, Paris',
        price: 799,
        originalPrice: 950,
        nights: 1,
        discount: 15,
        location: 'Paris, France',
        highlights: ['Eiffel Tower view', 'Gourmet Breakfast', 'Luxury Shopping'],
        services: [
          Service(name: 'AC', icon: Icons.ac_unit),
          Service(name: 'Wifi', icon: Icons.wifi),
          Service(name: 'Restaurant', icon: Icons.restaurant),
        ],
        roomDetails: [
          RoomDetail(label: 'Bedroom', value: '1 Queen'),
          RoomDetail(label: 'Room Size', value: '45 sqm'),
        ],
      ),
      Hotel(
        id: '10',
        name: 'Dubai Sky Tower Hotel',
        subtitle: '150+ Hotels\nfrom \$899',
        image: 'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?w=400',
        images: [
          'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?w=400',
          'https://images.unsplash.com/photo-1518684079-3c830dcef090?w=400',
        ],
        rating: 5.0,
        reviews: 4200,
        description: 'Live like royalty in the world\'s most luxurious city.',
        address: 'Sheikh Zayed Road, Dubai',
        price: 899,
        originalPrice: 1100,
        nights: 1,
        discount: 18,
        location: 'Dubai, UAE',
        highlights: ['Gold Interior', 'Desert Safari access', 'Infinity Pool'],
        services: [
          Service(name: 'Pool', icon: Icons.pool),
          Service(name: 'Gym', icon: Icons.fitness_center),
          Service(name: 'Spa', icon: Icons.spa),
        ],
        roomDetails: [
          RoomDetail(label: 'Bedroom', value: '2 King'),
          RoomDetail(label: 'Room Size', value: '110 sqm'),
        ],
      ),
      Hotel(
        id: '11',
        name: 'Bali Garden Retreat',
        subtitle: '180+ Hotels\nfrom \$699',
        image: 'https://images.unsplash.com/photo-1537996194471-e657df975ab4?w=400',
        images: [
          'https://images.unsplash.com/photo-1537996194471-e657df975ab4?w=400',
        ],
        rating: 4.7,
        reviews: 1800,
        description: 'Find peace and serenity in the lush gardens of Bali.',
        address: 'Ubud, Bali',
        price: 499,
        originalPrice: 600,
        nights: 1,
        discount: 17,
        location: 'Bali, Indonesia',
        highlights: ['Yoga Studio', 'Organic Cafe', 'Jungle View'],
        services: [
          Service(name: 'Wifi', icon: Icons.wifi),
          Service(name: 'Spa', icon: Icons.spa),
          Service(name: 'Pool', icon: Icons.pool),
        ],
        roomDetails: [
          RoomDetail(label: 'Bedroom', value: '1 King'),
          RoomDetail(label: 'Room Size', value: '60 sqm'),
        ],
      ),

    ];
  }

  List<Room> getDummyRooms() {
    return [
      Room(
        id: '1',
        name: 'Standard Room, 1 King Bed',
        image:
        'https://images.unsplash.com/photo-1590490360182-c33d57733427?w=400',
        rating: '9.0',
        ratingText: 'Wonderful',
        reviews: '2 reviews',
        refundPrice: 109,
        breakfastPrice: 13,
        leftCount: 5,
        features: [
          RoomFeature(icon: Icons.directions_car, text: 'Free self parking'),
          RoomFeature(icon: Icons.aspect_ratio, text: '24 sq m'),
          RoomFeature(icon: Icons.people, text: 'Sleeps 2'),
          RoomFeature(icon: Icons.king_bed, text: '1 King Bed'),
          RoomFeature(icon: Icons.wifi, text: 'Free WiFi'),
        ],
        price: 436,
      ),
      Room(
        id: '2',
        name: 'Deluxe Ocean View',
        image:
        'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=400',
        rating: '9.5',
        ratingText: 'Excellent',
        reviews: '15 reviews',
        refundPrice: 194,
        breakfastPrice: 25,
        leftCount: 4,
        features: [
          RoomFeature(icon: Icons.pool, text: 'Access to Pool'),
          RoomFeature(icon: Icons.aspect_ratio, text: '35 sq m'),
          RoomFeature(icon: Icons.people, text: 'Sleeps 3'),
          RoomFeature(icon: Icons.king_bed, text: '1 Super King'),
          RoomFeature(icon: Icons.wifi, text: 'High Speed WiFi'),
        ],
        price: 572,
      ),
    ];
  }

  // Get currently selected room

  Room? get currentRoom {
    if (roomList.isEmpty || selectedRoomIndex.value >= roomList.length) {
      return null;
    }
    return roomList[selectedRoomIndex.value];
  }

  // Calculate total price with discount

  double calculateTotalPrice() {
    final hotel = selectedHotel.value;
    if (hotel == null) return 0.0;
    final nightsValue = nights.value;
    final basePrice = hotel.price * nightsValue;
    final discount = basePrice * (discountPercentage.value / 100);
    return basePrice - discount;
  }

// Base price with room $ night count

  double get totalBasePrice {
    final hotel = selectedHotel.value;
    if (hotel == null) return 0.0;
    return hotel.price * nights.value * roomCount.value;
  }

  // Get discount amount

  double get totalDiscountAmount {
    return totalBasePrice * (discountPercentage.value / 100);
  }

  // Tax Calculation after discount

  double get totalTaxAmount {
    final netBase = totalBasePrice - totalDiscountAmount;
    return netBase * (taxPercentage / 100);
  }

// Service fee
  double get totalServiceFee => serviceFeeAmount;

  // Tax % Service fee

  final double taxPercentage = 10.0;
  final double serviceFeeAmount = 5.0;

// Total Calculation

  double get finalAmount {
    return (totalBasePrice - totalDiscountAmount) + totalTaxAmount + totalServiceFee;
  }


  // UI string formating

  String get pricingDescription =>
      '${roomCount.value} ${roomCount.value > 1 ? "rooms" : "room"} x ${nights.value} ${nights.value > 1 ? "nights" : "night"}';

  String get roomAndGuestSummary =>
      '${roomCount.value} Room${roomCount.value > 1 ? "s" : ""} • ${guestCount.value} Guest${guestCount.value > 1 ? "s" : ""}';


  // Format price as currency

  String formatPrice(double price) {
    return '\$${price.toStringAsFixed(0)}';
  }

  // Get formatted date range
  String getFormattedDateRange() {
    final checkIn = DateFormat('dd MMM').format(checkInDate.value);
    final checkOut = DateFormat('dd MMM yyyy').format(checkOutDate.value);
    return '$checkIn - $checkOut';
  }

  // Get filtered hotels based on selected filters

  List<Hotel> getFilteredHotels() {
    if (selectedFilters.isEmpty && minPrice.value == 0 && maxPrice.value == 10000) {
      return searchResults;
    }

    return searchResults.where((hotel) {
      // Price filter
      if (hotel.price < minPrice.value || hotel.price > maxPrice.value) {
        return false;
      }

      // Star rating filter

      if (selectedFilters.contains('5 Stars') && hotel.rating < 5.0) return false;
      if (selectedFilters.contains('4 Stars') && (hotel.rating < 4.0 || hotel.rating >= 5.0)) return false;
      if (selectedFilters.contains('3 Stars') && (hotel.rating < 3.0 || hotel.rating >= 4.0)) return false;

      return true;
    }).toList();
  }

  // Sort hotels by price

  void sortHotelsByPrice({bool ascending = true}) {
    searchResults.sort((a, b) {
      return ascending
          ? a.price.compareTo(b.price)
          : b.price.compareTo(a.price);
    });
    searchResults.refresh();
  }

  // Sort hotels by rating

  void sortHotelsByRating({bool ascending = false}) {
    searchResults.sort((a, b) {
      return ascending
          ? a.rating.compareTo(b.rating)
          : b.rating.compareTo(a.rating);
    });
    searchResults.refresh();
  }

  // Clear all filters

  void clearFilters() {
    selectedFilters.clear();
    minPrice.value = 0.0;
    maxPrice.value = 10000.0;
  }

  // Reset booking form

  void resetBookingForm() {
    firstNameController.clear();
    lastNameController.clear();
    phoneController.clear();
    emailController.clear();
    specialRequestsController.clear();
    billingFirstNameController.clear();
    billingLastNameController.clear();
    billingPhoneController.clear();
    billingEmailController.clear();
    billingCountryController.clear();
    billingStateController.clear();
    billingZipController.clear();
    selectedPaymentMethod.value = '';
    couponCode.value = '';
    discountPercentage.value = 0.0;
  }

  //  COUPON & PAYMENT

  void applyCoupon(String code) {
    if (code.isEmpty) {
      _showError('Please enter a coupon code');
      return;
    }

    // Simulate coupon validation (replace with actual API call)
    final validCoupons = {
      'SAVE10': 10.0,
      'SAVE20': 20.0,
      'FIRST50': 50.0,
    };

    if (validCoupons.containsKey(code.toUpperCase())) {
      discountPercentage.value = validCoupons[code.toUpperCase()]!;
      couponCode.value = code.toUpperCase();
      _showSuccess('Coupon applied! You saved ${discountPercentage.value}%');
    } else {
      _showError('Invalid coupon code');
    }
  }

  void removeCoupon() {
    couponCode.value = '';
    discountPercentage.value = 0.0;
    _showSuccess('Coupon removed');
  }

  void navigateToHotelDetails(Hotel hotel) {
    selectedHotel.value = hotel;
    Get.toNamed('/hotel-details', arguments: hotel);
  }

  //  VALIDATION

  bool validateBookingForm() {
    if (firstNameController.text.trim().isEmpty ||
        lastNameController.text.trim().isEmpty) {
      _showError('Please enter your name');
      return false;
    }

    if (phoneController.text.trim().isEmpty) {
      _showError('Please enter your phone number');
      return false;
    }

    if (!_isValidEmail(emailController.text.trim())) {
      _showError('Please enter a valid email');
      return false;
    }

    if (selectedPaymentMethod.value.isEmpty) {
      _showError('Please select a payment method');
      return false;
    }

    return true;
  }

  bool _isValidEmail(String email) {
    return email.isNotEmpty &&
        email.contains('@') &&
        email.contains('.') &&
        email.indexOf('@') < email.lastIndexOf('.');
  }

  // BOOKING

  void confirmBooking() {
    if (!validateBookingForm()) return;

    _showSuccess('Booking confirmed successfully!');
    _saveHotelBookingToMyBookings();

    Future.delayed(const Duration(milliseconds: 800), () {
      Get.toNamed('/hotel-ticket');
    });
  }

  void _saveHotelBookingToMyBookings() {
    final hotel = selectedHotel.value;
    if (hotel == null) return;

    final summary = BookingSummary(
      type: 'Hotel',
      title: hotel.name,
      subtitle: '$roomAndGuestSummary • ${nights.value} night${nights.value > 1 ? "s" : ""}',
      dates: getFormattedDateRange(),
      imageUrl: hotel.image,
      bookingId: 'HB-${DateTime.now().millisecondsSinceEpoch}',
      status: 'Confirmed',
      totalAmount: formatPrice(finalAmount),
      ticketData: {
        'hotel': hotel.toJson(),
        'nights': nights.value,
        'checkIn': checkInDate.value.toIso8601String(),
        'checkOut': checkOutDate.value.toIso8601String(),
        'room': currentRoom?.toJson(),
        'roomClass': preferredClass.value,
        'basePrice': totalBasePrice,
        'discount': totalDiscountAmount,
        'tax': totalTaxAmount,
        'serviceFee': totalServiceFee,
        'totalPrice': finalAmount,
        'paymentMethod': selectedPaymentMethod.value,
        'couponCode': couponCode.value,
      },
    );

    Get.find<MyBookingsController>().addBooking(summary);
  }


  List<Map<String, dynamic>> get featuredDestinations {
    return allHotels
        .where((hotel) =>
    hotel.subtitle != null &&
        hotel.subtitle!.trim().isNotEmpty)
        .map((hotel) => {
      'name': hotel.name,
      'location': hotel.location,
      'image': hotel.image,
      'subtitle': hotel.subtitle,
      'price': hotel.price,
      'rating': hotel.rating,

    })
        .take(4)
        .toList();
  }


  Future<void> selectCheckInDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: checkInDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime(2027, 12, 31),
    );

    if (picked != null && picked != checkInDate.value) {
      checkInDate.value = picked;

      // Auto-adjust checkout if needed
      if (checkOutDate.value.isBefore(picked) ||
          checkOutDate.value.isAtSameMomentAs(picked)) {
        checkOutDate.value = picked.add(const Duration(days: 1));
      }
    }
  }

  Future<void> selectCheckOutDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: checkOutDate.value,
      firstDate: checkInDate.value.add(const Duration(days: 1)),
      lastDate: DateTime(2027, 12, 31),
    );

    if (picked != null && picked != checkOutDate.value) {
      checkOutDate.value = picked;
    }
  }

  //  SEARCH & SELECT

  Future<void> searchHotels() async {
    if (isFromSaved.value) {
      isFromSaved.value = false;
      if (selectedHotel.value != null) {
        Get.toNamed('/hotel-details', arguments: selectedHotel.value);
      } else {
        Get.snackbar('Error', 'No hotel selected to view details');
      }
      return;
    }
    if (nights.value < 1) {
      Get.snackbar('Error', 'Check-out must be after check-in');
      return;
    }

    isLoadingHotels.value = true;
    try {
      final hotels = await fetchHotels(
        location: location.value,
        checkIn: checkInDate.value,
        checkOut: checkOutDate.value,
        rooms: roomCount.value,
        guests: guestCount.value,
      );

      searchResults.value = hotels;

      if (hotels.isEmpty) {
        Get.snackbar('Info', 'No hotels found for your search');
      } else {
        Get.toNamed('/all-hotels');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load hotels: $e');
    } finally {
      isLoadingHotels.value = false;
    }
  }



  void searchHotelsByLocation(String locationName) {
    if (locationName.isEmpty) {
      searchResults.assignAll(allHotels);
    } else {
      searchResults.assignAll(
          allHotels.where((hotel) =>
              hotel.location.toLowerCase().contains(locationName.toLowerCase())
          ).toList()
      );
    }
  }


  //  SNACKBAR HELPERS

  void _showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green[100],
      colorText: Colors.green[800],
      duration: const Duration(seconds: 2),
    );
  }

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red[100],
      colorText: Colors.red[800],
      duration: const Duration(seconds: 3),
    );
  }

  void _showInfo(String message) {
    Get.snackbar(
      'Info',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue[100],
      colorText: Colors.blue[800],
      duration: const Duration(seconds: 2),
    );
  }

  void toggleFilter(String filter) {
    if (selectedFilters.contains(filter)) {
      selectedFilters.remove(filter);
    } else {
      selectedFilters.add(filter);
    }
  }


  //  NAVIGATION HELPERS

  void goToPayment() {
    if (selectedHotel.value == null) {
      _showError('Please select a hotel first');
      return;
    }
    Get.toNamed('/payment-hotel');
  }

  void goToTicket() {
    if (selectedHotel.value == null) {
      _showError('No booking found');
      return;
    }
    Get.toNamed('/hotel-ticket');
  }

  void goBackToSearch() {
    selectedHotel.value = null;
    resetBookingForm();
    Get.back();
  }
}