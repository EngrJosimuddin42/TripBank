import 'package:get/get.dart';
import '../../../models/car_model.dart';
import '../../../models/flight_model.dart';
import '../../../models/hotel_model.dart';
import '../../../models/tour_model.dart';

class ExploreController extends GetxController {
  var selectedTab = 0.obs;
  var searchQuery = ''.obs;
  var showAllFeatured = false.obs;
  var showAllDestinations = false.obs;
  var selectedFlight = Rxn<Flight>();

  //  Loading State

  var isLoading = false.obs;
  var _isDataLoaded = false;

  // Featured Destinations

  final featuredDestinations = <Map>[].obs;

  // All Destinations

  final allDestinations = <Map>[].obs;

  @override
  void onInit() {
    super.onInit();
    selectedTab.value = 0;
    loadInitialData();
  }

  //  Load Initial Data

  Future<void> loadInitialData() async {
    if (_isDataLoaded &&
        featuredDestinations.isNotEmpty &&
        allDestinations.isNotEmpty) {
      print('⚡ Data already loaded, skipping...');
      return;
    }

    isLoading.value = true;

    try {
      print(' Loading data...');

      // Simulate API delay

      await Future.delayed(const Duration(seconds: 1));

      // Load dummy data

      featuredDestinations.value = _getFeaturedDummyData();
      allDestinations.value = _getAllDestinationsDummyData();

      _isDataLoaded = true;

      print(' Loaded ${featuredDestinations.length} featured');
      print(' Loaded ${allDestinations.length} destinations');

    } catch (e) {
      print('Error loading data: $e');
      Get.snackbar(
        'Error',
        'Failed to load destinations',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  //  Refresh Data (Pull to Refresh)

  Future<void> refreshData() async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Reload data

      featuredDestinations.value = _getFeaturedDummyData();
      allDestinations.value = _getAllDestinationsDummyData();

      Get.snackbar(
        'Success',
        'Data refreshed successfully',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('Error refreshing data: $e');
      Get.snackbar(
        'Error',
        'Failed to refresh data',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void selectTab(int index) {
    selectedTab.value = index;
    showAllDestinations.value = false;
    showAllFeatured.value = false;
  }

  void toggleShowAllFeatured() {
    showAllFeatured.value = !showAllFeatured.value;
  }

  void toggleShowAllDestinations() {
    showAllDestinations.value = !showAllDestinations.value;
  }

  List<Map> getFilteredDestinations() {
    return _filterList(allDestinations);
  }

  List<Map> getFilteredFeaturedDestinations() {
    return _filterList(featuredDestinations);
  }

  List<Map> _filterList(RxList<Map> sourceList) {
    var list = sourceList.toList();

    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      list = list.where((d) {
        final name = (d['name'] as String?)?.toLowerCase() ?? '';
        final location = (d['location'] as String?)?.toLowerCase() ?? '';
        return name.contains(query) || location.contains(query);
      }).toList();
    }

    if (selectedTab.value == 0) {
      return list;
    } else if (selectedTab.value == 1) {
      return list.where((d) => d['type'] == 'flight').toList();
    } else if (selectedTab.value == 2) {
      return list.where((d) => d['type'] == 'hotel').toList();
    } else if (selectedTab.value == 3) {
      return list.where((d) => d['type'] == 'car').toList();
    } else if (selectedTab.value == 4) {
      return list.where((d) => d['type'] == 'tour').toList();
    }

    return list;
  }

  // Helper method to create model from map

  Flight createFlightFromMap(Map destination) {
    double price = (destination['price'] as num?)?.toDouble() ?? 0.0;
    int stopsCount = destination['stops'] ?? 0;
    return Flight(
      id: destination['id']?.toString() ?? '',
      airline: destination['name'] ?? 'Airlines',
      airlineLogo: destination['image'] ?? '',
      flightNumber: destination['flightNumber'] ?? 'XX-000',
      from: destination['location']?.toString().split(' - ').first ?? 'From',
      to: destination['location']?.toString().split(' - ').last ?? 'To',
      fromCode: destination['fromCode'] ?? 'XXX',
      toCode: destination['toCode'] ?? 'XXX',
      departureTime: DateTime.tryParse(destination['date'] ?? '') ?? DateTime.now(),
      arrivalTime: (DateTime.tryParse(destination['date'] ?? '') ?? DateTime.now())
          .add(const Duration(hours: 14, minutes: 15)),
      duration: destination['duration'] ?? '0h 0m',
      stops: 0,
      price: (destination['price'] as num?)?.toDouble() ?? 0.0,
      vatAmount: price * 0.05,
      cabinClass: 'Economy',
      availableSeats: 10,
      isRefundable: true,
      baggageAllowance: '30kg',
      flightType: Flight.getFlightTypeLabel(stopsCount),
      facilities: ['WiFi', 'Meal'],
    );
  }


  Hotel createHotelFromMap(Map destination) {
    return Hotel(
      id: destination['id']?.toString() ?? '',
      name: destination['name'] ?? 'Luxury Hotel',
      image: destination['image'] ?? '',
      images: List<String>.from(destination['images'] ?? [destination['image'] ?? '']),
      rating: (destination['rating'] as num?)?.toDouble() ?? 4.0,
      reviews: destination['reviews'] ?? 100,
      description: destination['description'] ?? 'No description available',
      address: destination['location'] ?? 'Address not found',
      location: destination['location']?.toString() ?? 'Unknown Location',
      price: (destination['price'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (destination['originalPrice'] as num?)?.toDouble(),
      nights: destination['nights'] ?? 1,
      discount: destination['discount'] ?? 0,
      highlights: List<String>.from(destination['highlights'] ?? []),
      services: (destination['Services'] as List?)
          ?.map((e) => Service.fromJson(Map<String, dynamic>.from(e)))
          .toList() ?? [],
      roomDetails: (destination['roomDetails'] as List?)
          ?.map((e) => RoomDetail.fromJson(Map<String, dynamic>.from(e)))
          .toList() ?? [],
    );
  }


  Car createCarFromMap(Map destination) {
    String name = destination['name'] ?? 'Unknown Car';
    List<String> nameParts = name.split(' ');
    return Car(
      id: destination['id']?.toString() ?? '',
      brand: nameParts.first,
      model: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : 'Model',
      year: destination['year'] ?? 2024,
      types: destination['carType'] ?? 'Sedan',
      seats: destination['seats'] ?? 5,
      bags: destination['bags'] ?? 1,
      doors: destination['doors'] ?? 4,
      transmission: destination['transmission'] ?? 'Automatic',
      pricePerDay: (destination['price'] as num?)?.toDouble() ?? 0.0,
      rating: (destination['rating'] as num?)?.toDouble() ?? 4.0,
      imageUrl: destination['image'] ?? '',
      available: destination['available'] ?? true,
    );
  }


  Tour createTourFromMap(Map destination) {
    return Tour(
      id: destination['id']?.toString() ?? '',
      title: destination['name'] ?? 'Amazing Tour',
      location: destination['location'] ?? 'Various Locations',
      imageUrl: destination['image'] ?? '',
      category: destination['category'] ?? 'Adventure',
      duration: destination['duration'] ?? '5 Hours',
      maxPeople: destination['maxPeople'] ?? 15,
      price: (destination['price'] as num?)?.toDouble() ?? 0.0,
      rating: (destination['rating'] as num?)?.toDouble() ?? 4.5,
      reviewsCount: destination['reviewsCount'] ?? 50,
      description: destination['description'] ?? 'Tour description goes here...',
      isFullDay: destination['isFullDay'] ?? false,
      buttonText: 'Book Now',
    );
  }

  // Time formatting helper

  String formatTime(DateTime time) {
    String hour = (time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour)).toString();
    String minute = time.minute.toString().padLeft(2, '0');
    String period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  String _getTimeCategory(String timeSlot) {
    final parts = timeSlot.split(' ');
    final timePart = parts[0];
    final period = parts[1];

    final hourMinute = timePart.split(':');
    int hour = int.parse(hourMinute[0]);

    if (period == 'pm' && hour != 12) hour += 12;
    if (period == 'am' && hour == 12) hour = 0;

    if (hour >= 0 && hour < 6) {
      return 'Early morning';
    } else if (hour >= 6 && hour < 12) {
      return 'Morning';
    } else if (hour >= 12 && hour < 18) {
      return 'Afternoon';
    } else {
      return 'Evening';
    }
  }

  void resetToAllTab() {
    selectedTab.value = 0;
  }

  void searchDestinations(String query) {
    searchQuery.value = query.trim();
  }

  void clearSearch() {
    searchQuery.value = '';
  }

  void navigateToDetails(Map data) {
    String type = data['type'] ?? 'hotel';

    switch (type.toLowerCase()) {
      case 'flight':
        final flight = createFlightFromMap(data);
        Get.toNamed('/flight-details', arguments: flight);
        break;

      case 'hotel':
        final hotel = createHotelFromMap(data);
        Get.toNamed('/hotel-details', arguments: hotel);
        break;

      case 'car':
        final car = createCarFromMap(data);
        Get.toNamed('/car-details', arguments: car);
        break;

      case 'tour':
        final tour = createTourFromMap(data);
        Get.toNamed('/tour-details', arguments: tour);
        break;

      default:
        Get.toNamed('/explore-details', arguments: data);
        break;
    }
  }



  // DUMMY DATA ( For Development)

  List<Map> _getFeaturedDummyData() {
    return [
      {
        'id': 1,
        'name': 'Maldives Paradise',
        'location': 'Maldives',
        'rating': 4.9,
        'price': 350,
        'type': 'hotel',
        'image': 'https://images.unsplash.com/photo-1514282401047-d79a71a590e8',
        'date': '2026-01-15',
        'isTrending': true,
      },
      {
        'id': 2,
        'name': 'Emirates A380',
        'location': 'Dubai - NYC',
        'rating': 4.9,
        'price': 850,
        'type': 'flight',
        'image': 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05',
        'date': '2026-01-14',
        'fromCode': 'DXB',
        'toCode': 'NYC',
        'duration': '14h 15m',
        'flightNumber': 'EK-202',
        'isTrending': true,
      },
      {
        'id': 3,
        'name': 'BMW 5 Series',
        'location': 'Los Angeles',
        'rating': 4.7,
        'price': 120,
        'type': 'car',
        'image': 'https://images.unsplash.com/photo-1555215695-3004980ad54e',
        'date': '2026-01-13',
        'seats': 5,
        'bags': 1,
        'doors': 4,
        'isTrending': true,
      },
      {
        'id': 4,
        'name': 'European Heritage Tour',
        'location': 'Europe',
        'rating': 4.8,
        'price': 1200,
        'type': 'tour',
        'image': 'https://images.unsplash.com/photo-1488646953014-85cb44e25828',
        'date': '2026-01-12',
        'duration': '5 Hours',
        'maxPeople': 15,
        'isTrending': true,
      },
      {
        'id': 5,
        'name': 'Singapore Airlines',
        'location': 'London - Singapore',
        'rating': 4.9,
        'price': 920,
        'type': 'flight',
        'image': 'https://images.unsplash.com/photo-1464037866556-6812c9d1c72e',
        'date': '2026-01-11',
        'fromCode': 'LHR',
        'toCode': 'SIN',
        'duration': '13h 30m',
        'flightNumber': 'SQ-317',
        'isTrending': true,
      },
      {
        'id': 6,
        'name': 'Tesla Model S',
        'location': 'San Francisco',
        'rating': 4.8,
        'price': 150,
        'type': 'car',
        'image': 'https://images.unsplash.com/photo-1560958089-b8a1929cea89',
        'date': '2026-01-10',
        'seats': 5,
        'bags': 1,
        'doors': 4,
        'isTrending': true,
      },
      {
        'id': 7,
        'name': 'Dubai Luxury Hotel',
        'location': 'Dubai, UAE',
        'rating': 4.7,
        'price': 420,
        'type': 'hotel',
        'image': 'https://images.unsplash.com/photo-1512453979798-5ea266f8880c',
        'date': '2026-01-09',
        'isTrending': true,
      },
      {
        'id': 8,
        'name': 'Amazon Rainforest Adventure',
        'location': 'Brazil',
        'rating': 4.9,
        'price': 980,
        'type': 'tour',
        'image': 'https://images.unsplash.com/photo-1516426122078-c23e76319801',
        'date': '2026-01-08',
        'duration': '8 Hours',
        'maxPeople': 12,
        'isTrending': true,
      },
      {
        'id': 9,
        'name': 'Mercedes E-Class',
        'location': 'Miami',
        'rating': 4.6,
        'price': 140,
        'type': 'car',
        'image': 'https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8',
        'date': '2026-01-07',
        'seats': 5,
        'bags': 1,
        'doors': 4,
        'isTrending': true,
      },
      {
        'id': 10,
        'name': 'African Safari Tour',
        'location': 'Kenya',
        'rating': 4.8,
        'price': 1500,
        'type': 'tour',
        'image': 'https://images.unsplash.com/photo-1547471080-7cc2caa01a7e',
        'date': '2026-01-06',
        'duration': '6 Hours',
        'maxPeople': 20,
        'isTrending': true,
      },
    ];
  }

  List<Map> _getAllDestinationsDummyData() {
    return [
      {
        'id': 101,
        'name': 'Grand Plaza Hotel',
        'location': 'New York City',
        'rating': 4.8,
        'price': 180,
        'type': 'hotel',
        'image': 'https://images.unsplash.com/photo-1566073771259-6a8506099945',
        'date': '2026-01-15',
      },
      {
        'id': 102,
        'name': 'American Airlines',
        'location': 'LA - Miami',
        'rating': 4.5,
        'price': 320,
        'type': 'flight',
        'image': 'https://images.unsplash.com/photo-1556388158-158ea5ccacbd',
        'date': '2026-01-14',
        'fromCode': 'LAX',
        'toCode': 'MIA',
        'duration': '5h 30m',
        'flightNumber': 'AA-125',
      },
      {
        'id': 103,
        'name': 'Audi A6',
        'location': 'Boston',
        'rating': 4.6,
        'price': 110,
        'type': 'car',
        'image': 'https://images.unsplash.com/photo-1606664515524-ed2f786a0bd6',
        'date': '2026-01-13',
        'seats': 5,
        'bags': 1,
        'doors': 4,
      },
      {
        'id': 104,
        'name': 'City Walking Tour',
        'location': 'Rome, Italy',
        'rating': 4.7,
        'price': 80,
        'type': 'tour',
        'image': 'https://images.unsplash.com/photo-1552832230-c0197dd311b5',
        'date': '2026-01-12',
        'duration': '3 Hours',
        'maxPeople': 25,
      },
      {
        'id': 105,
        'name': 'Delta Airlines',
        'location': 'NYC - Atlanta',
        'rating': 4.4,
        'price': 280,
        'type': 'flight',
        'image': 'https://images.unsplash.com/photo-1569629743817-70d8db6c323b',
        'date': '2026-01-11',
        'fromCode': 'JFK',
        'toCode': 'ATL',
        'duration': '2h 45m',
        'flightNumber': 'DL-456',
      },
      {
        'id': 106,
        'name': 'Lexus ES',
        'location': 'Seattle',
        'rating': 4.5,
        'price': 130,
        'type': 'car',
        'image': 'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2',
        'date': '2026-01-10',
        'seats': 5,
        'bags': 1,
        'doors': 4,
      },
      {
        'id': 107,
        'name': 'Mountain Lodge',
        'location': 'Aspen, Colorado',
        'rating': 4.7,
        'price': 200,
        'type': 'hotel',
        'image': 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb',
        'date': '2026-01-09',
      },
      {
        'id': 108,
        'name': 'Desert Safari Tour',
        'location': 'Dubai, UAE',
        'rating': 4.6,
        'price': 150,
        'type': 'tour',
        'image': 'https://images.unsplash.com/photo-1451337516015-6b6e9a44a8a3',
        'date': '2026-01-08',
        'duration': '4 Hours',
        'maxPeople': 18,
      },
      {
        'id': 109,
        'name': 'Honda Accord',
        'location': 'Phoenix',
        'rating': 4.4,
        'price': 90,
        'type': 'car',
        'image': 'https://images.unsplash.com/photo-1590362891991-f776e747a588',
        'date': '2026-01-07',
        'seats': 5,
        'bags': 1,
        'doors': 4,
      },
      {
        'id': 110,
        'name': 'Beach Resort Spa',
        'location': 'Miami Beach',
        'rating': 4.6,
        'price': 250,
        'type': 'hotel',
        'image': 'https://images.unsplash.com/photo-1571896349842-33c89424de2d',
        'date': '2026-01-06',
      },
      {
        'id': 111,
        'name': 'United Airlines',
        'location': 'Chicago - Denver',
        'rating': 4.3,
        'price': 250,
        'type': 'flight',
        'image': 'https://images.unsplash.com/photo-1574717024653-61fd2cf4d44d',
        'date': '2026-01-05',
        'fromCode': 'ORD',
        'toCode': 'DEN',
        'duration': '2h 30m',
        'flightNumber': 'UA-789',
      },
      {
        'id': 112,
        'name': 'Historical Temple Tour',
        'location': 'Bangkok, Thailand',
        'rating': 4.8,
        'price': 120,
        'type': 'tour',
        'image': 'https://images.unsplash.com/photo-1563492065599-3520f775eeed',
        'date': '2026-01-04',
        'duration': '5 Hours',
        'maxPeople': 30,
      },
    ];
  }
}