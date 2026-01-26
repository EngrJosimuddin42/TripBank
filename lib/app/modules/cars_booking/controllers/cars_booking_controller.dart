import 'package:get/get.dart';
import '../../../models/car_model.dart';
import '../../../services/favorites_service.dart';
import '../../../utils/booking_helper.dart';
import '../../../widgets/snackbar_helper.dart';
import '../../my_bookings/controllers/my_bookings_controller.dart';

class CarTypeFilter {
  final String name;
  final int count;
  CarTypeFilter(this.name, this.count);
}

class CarsBookingController extends GetxController {
  final FavoritesService _favoritesService = Get.find<FavoritesService>();

  // UI STATE

  final selectedCategory = 'All'.obs;
  final selectedFilters = <String>[].obs;
  final isFareDetailsExpanded = false.obs;
  final tempFilters = <String>[].obs;
  final isFromSaved = false.obs;

  // TRIP CONFIGURATION

  final selectedTripType = 'One Way'.obs;
  final tripTypes = ['One Way', 'Round Way'];

  // DEPARTURE/ARRIVING LOCATIONS

  final ArrivingFromLocation = ''.obs;
  final ArrivingFromCode = ''.obs;
  final ArrivingFromTerminal = ''.obs;
  final ArrivingFromCountry = ''.obs;

  final ArrivingToLocation = ''.obs;
  final ArrivingToCode = ''.obs;
  final ArrivingToTerminal = ''.obs;
  final ArrivingToCountry = ''.obs;

  // RETURN LOCATIONS

  final returnFromLocation = ''.obs;
  final returnFromCode = ''.obs;
  final returnFromTerminal = ''.obs;
  final returnFromCountry = ''.obs;

  final returnToLocation = ''.obs;
  final returnToCode = ''.obs;
  final returnToTerminal = ''.obs;
  final returnToCountry = ''.obs;

  // DATES

  final ArrivingDate = Rx<DateTime?>(null);
  final returnDate = Rx<DateTime?>(null);

  // PASSENGERS

  final adults = 1.obs;
  final children = 0.obs;
  final infants = 0.obs;

  // TIME PREFERENCES

  final timeOptions = ['Early morning', 'Morning', 'Afternoon', 'Evening'];
  final ArrivingPreferredTimes = <String>[].obs;
  final returnPreferredTimes = <String>[].obs;
  final ArrivingSelectedTimeSlots = <String>[].obs;
  final returnSelectedTimeSlots = <String>[].obs;

  // SEARCH RESULTS

  final searchResults = <Car>[].obs;
  final allCars = <Car>[].obs;
  final isLoadingCars = false.obs;
  final selectedCar = Rx<Car?>(null);

  // PAYMENT

  final selectedPaymentMethod = ''.obs;
  final paymentMethods = [
    {'name': 'PayPal', 'icon': 'assets/images/paypal.png'},
    {'name': 'Stripe', 'icon': 'assets/images/stripe.png'},
    {'name': 'Paystack', 'icon': 'assets/images/paystack.png'},
    {'name': 'Coinbase Commerce', 'icon': 'assets/images/coinbase.png'},
  ];

  // CONTACT INFORMATION

  final contactEmail = ''.obs;
  final contactPhone = ''.obs;

  // CATEGORY COUNTS

  int get acCount => allCars.where((car) => car.transmission == 'Automatic').length;
  int get nonAcCount => allCars.where((car) => car.transmission != 'Automatic').length;
  int get totalCount => allCars.length;

  // CAR TYPES WITH COUNTS

  List<CarTypeFilter> get carTypes => [
    CarTypeFilter('Mini', _getCarCountByType('Mini')),
    CarTypeFilter('Economy', _getCarCountByType('Economy')),
    CarTypeFilter('Compact', _getCarCountByType('Compact')),
    CarTypeFilter('Midsize', _getCarCountByType('Midsize')),
    CarTypeFilter('Standard', _getCarCountByType('Standard')),
    CarTypeFilter('Full-size', _getCarCountByType('Full-size')),
    CarTypeFilter('Premium', _getCarCountByType('Premium')),
    CarTypeFilter('Luxury', _getCarCountByType('Luxury')),
    CarTypeFilter('SUV', _getCarCountByType('SUV')),
    CarTypeFilter('People Carrier', _getCarCountByType('People Carrier')),
    CarTypeFilter('Other', _getCarCountByType('Other')),
  ];

  // PRICE RANGES

  List<String> get priceRanges => [
    'Less than \$35',
    '\$35 to \$75',
    '\$75 to \$100',
    '\$100 to \$200',
    '\$200 to \$300',
    'Greater than \$300',
  ];

  int _getCarCountByType(String type) {
    return allCars.where((car) => car.types == type).length;
  }

  @override
  void onInit() {
    super.onInit();
    ArrivingDate.value ??= DateTime.now().add(const Duration(days: 1));
  }

  // FAVORITES

  bool isCarFavorite(String carId) {
    return _favoritesService.isFavorite('car', carId);
  }

  Future<void> toggleCarFavorite(String carId) async {
    final car = allCars.firstWhereOrNull((c) => c.id == carId);
    if (car == null) return;

    final carData = {
      'id': car.id,
      'name': '${car.brand} ${car.model}',
      'types': car.types,
      'brand': car.brand,
      'model': car.model,
      'pricePerDay': car.pricePerDay,
      'seats': car.seats,
      'bags': car.bags,
      'doors': car.doors,
      'transmission': car.transmission,
      'rating': car.rating,
      'reviews': car.reviews,
      'ratingPercentage': getRatingPercentage(car.rating),
      'ratingText': getRatingText(car.rating),
      'image': car.imageUrl,
    };

    await _favoritesService.toggleFavorite('car', carData);
  }

  // FILTERING

  void updateCategory(String category) {
    selectedCategory.value = category;
    if (category == 'All') {
      searchResults.assignAll(allCars);
    } else if (category == 'AC') {
      searchResults.assignAll(allCars.where((car) => car.transmission == 'Automatic').toList());
    } else if (category == 'Non-AC') {
      searchResults.assignAll(allCars.where((car) => car.transmission != 'Automatic').toList());
    }
  }

  final Map<String, List<Map<String, dynamic>>> filterGroups = {
    'Car hire company': [
      {'name': 'Alamo rent a car', 'price': 35},
      {'name': 'Avis', 'price': 35},
      {'name': 'Budget', 'price': 37},
      {'name': 'Carnaz', 'price': 39},
      {'name': 'Dollar', 'price': 39},
      {'name': 'Drivalia', 'price': 83},
    ],
    'Airport pick-up': [
      {'name': 'At terminal', 'price': 35},
      {'name': 'Free shuttle', 'price': 35},
    ],
    'Car type': [
      {'name': 'Mini', 'price': 31},
      {'name': 'Economy', 'price': 35},
      {'name': 'Compact', 'price': 37},
      {'name': 'Midsize', 'price': 54},
      {'name': 'Standard', 'price': 35},
      {'name': 'Full-size', 'price': 54},
      {'name': 'Premium', 'price': 56},
      {'name': 'Luxury', 'price': 104},
      {'name': 'SUV', 'price': 58},
      {'name': 'People Carrier', 'price': 83},
      {'name': 'Other', 'price': 0},
    ],
    'Car passengers': [
      {'name': '2-4 car passengers', 'price': 0},
      {'name': '5-6 car passengers', 'price': 0},
    ],
    'Mileage': [
      {'name': 'Unlimited', 'price': 31},
      {'name': 'Limited', 'price': 0},
    ],
    'Supplier pick-up type': [
      {'name': 'Meet & greet', 'price': 31},
      {'name': 'Shuttle', 'price': 37},
    ],
    'Specifications': [
      {'name': 'Automatic or car', 'price': 31},
      {'name': 'Manual', 'price': 37},
      {'name': 'Air con', 'price': 31},
      {'name': 'Diesel', 'price': 37},
      {'name': 'Estate', 'price': 56},
      {'name': 'Envato', 'price': 104},
    ],
  };

  final List<String> priceRangeOptions = [
    'Less than \$ 35',
    '\$ 35 to \$ 75',
    '\$ 75 to \$ 100',
    '\$ 100 to \$ 200',
    '\$ 200 to \$ 300',
    'Greater than \$ 300',
  ];

  // Rating calculation

  String getRatingPercentage(double rating) {
    return '${(rating * 20).toStringAsFixed(0)}%';
  }

  String getRatingText(double rating) {
    if (rating >= 4.5) return "Excellent";
    if (rating >= 4.0) return "Very Good";
    if (rating >= 3.5) return "Good";
    if (rating >= 3.0) return "Average";
    return "Fair";
  }

  void selectCar(Car car) {
    selectedCar.value = car;
    if (ArrivingDate.value == null) {
      SnackbarHelper.showWarning(
        "Please select a pickup date before proceeding.",
        title: "Date Required",
      );
      return;
    }
    Get.toNamed(
      '/car-details',
      arguments: {
        'car': car,
        'pickupDate': ArrivingDate.value,
        'returnDate': returnDate.value,
        'tripType': selectedTripType.value,
        'totalDays': calculateBookingDays(),
      },
    );
  }

  void toggleFilter(String filterName) {
    if (tempFilters.contains(filterName)) {
      tempFilters.remove(filterName);
    } else {
      tempFilters.add(filterName);
    }
  }

  void applyTempFilters() {
    selectedFilters.assignAll(tempFilters);
    applyFilters();
  }

  void cancelFilters() {
    tempFilters.assignAll(selectedFilters);
  }

  void resetFilters() {
    selectedFilters.clear();
    tempFilters.clear();
  }

  void initTempFilters() {
    tempFilters.assignAll(selectedFilters);
  }

  // LOCATION MANAGEMENT

  void swapArrivingLocations() {
    final tempLocation = ArrivingFromLocation.value;
    ArrivingFromLocation.value = ArrivingToLocation.value;
    ArrivingToLocation.value = tempLocation;

    final tempCode = ArrivingFromCode.value;
    ArrivingFromCode.value = ArrivingToCode.value;
    ArrivingToCode.value = tempCode;

    final tempTerminal = ArrivingFromTerminal.value;
    ArrivingFromTerminal.value = ArrivingToTerminal.value;
    ArrivingToTerminal.value = tempTerminal;

    final tempCountry = ArrivingFromCountry.value;
    ArrivingFromCountry.value = ArrivingToCountry.value;
    ArrivingToCountry.value = tempCountry;
  }

  void swapReturnLocations() {
    final tempLocation = returnFromLocation.value;
    returnFromLocation.value = returnToLocation.value;
    returnToLocation.value = tempLocation;

    final tempCode = returnFromCode.value;
    returnFromCode.value = returnToCode.value;
    returnToCode.value = tempCode;

    final tempTerminal = returnFromTerminal.value;
    returnFromTerminal.value = returnToTerminal.value;
    returnToTerminal.value = tempTerminal;

    final tempCountry = returnFromCountry.value;
    returnFromCountry.value = returnToCountry.value;
    returnToCountry.value = tempCountry;
  }

  // TRIP TYPE

  void updateTripType(String type) {
    selectedTripType.value = type;
    if (type == 'One Way') returnDate.value = null;
  }

  int get totalPassengers => adults.value + children.value + infants.value;

  // TIME SLOTS

  String _getTimeCategory(String timeSlot) {
    final parts = timeSlot.split(' ');
    final timePart = parts[0];
    final period = parts[1];
    var hour = int.parse(timePart.split(':')[0]);

    if (period == 'pm' && hour != 12) hour += 12;
    if (period == 'am' && hour == 12) hour = 0;

    if (hour < 6) return 'Early morning';
    if (hour < 12) return 'Morning';
    if (hour < 18) return 'Afternoon';
    return 'Evening';
  }

  String getDefaultTimeFromPreference(String preference) {
    switch (preference) {
      case 'Early morning':
        return '06:00 am';
      case 'Morning':
        return '09:00 am';
      case 'Afternoon':
        return '02:00 pm';
      case 'Evening':
        return '06:00 pm';
      default:
        return '10:00 am';
    }
  }

  void toggleDepartureTimeSlot(String slot) {
    ArrivingSelectedTimeSlots
      ..clear()
      ..add(slot);
    ArrivingPreferredTimes
      ..clear()
      ..add(_getTimeCategory(slot));
  }

  void toggleReturnTimeSlot(String slot) {
    returnSelectedTimeSlots
      ..clear()
      ..add(slot);
    returnPreferredTimes
      ..clear()
      ..add(_getTimeCategory(slot));
  }

  void resetToInitialState() {
    isFromSaved.value = false;
    selectedCar.value = null;
  }

  // All filter condition

  void applyFilters() {
    List<Car> filtered = allCars;
    if (selectedCategory.value == 'AC') {
      filtered = filtered.where((car) => car.transmission == 'Automatic').toList();
    } else if (selectedCategory.value == 'Non-AC') {
      filtered = filtered.where((car) => car.transmission != 'Automatic').toList();
    }

    if (selectedFilters.isNotEmpty) {
      filtered = filtered.where((car) {
        bool matches = true;

        final selectedTypes = selectedFilters
            .where((f) => carTypes.any((ct) => ct.name == f))
            .toList();

        if (selectedTypes.isNotEmpty) {
          matches = matches && selectedTypes.contains(car.types);
        }

        if (selectedFilters.contains('Air con') || selectedFilters.contains('Automatic or car')) {
          matches = matches && car.transmission == 'Automatic';
        }
        if (selectedFilters.contains('Manual')) {
          matches = matches && car.transmission != 'Automatic';
        }

        if (selectedFilters.any((f) => priceRanges.contains(f))) {
          final selectedRange = selectedFilters.firstWhereOrNull((f) => priceRanges.contains(f));
          if (selectedRange != null) {
            matches = matches && _priceInRange(car.pricePerDay, selectedRange);
          }
        }

        return matches;
      }).toList();
    }
    searchResults.assignAll(filtered);
  }

  // Helper for price range matching

  bool _priceInRange(double price, String range) {
    if (range == 'Less than \$35') return price < 35;
    if (range == '\$35 to \$75') return price >= 35 && price <= 75;
    if (range == '\$75 to \$100') return price > 75 && price <= 100;
    if (range == '\$100 to \$200') return price > 100 && price <= 200;
    if (range == '\$200 to \$300') return price > 200 && price <= 300;
    if (range == 'Greater than \$300') return price > 300;
    return true;
  }


  @override
  void onClose() {
    isFromSaved.value = false;
    selectedCar.value = null;
    super.onClose();
  }

  // SEARCH CARS

  Future<void> searchCars() async {

    if (isFromSaved.value && selectedCar.value != null) {
      isFromSaved.value = false;
      Get.toNamed('/car-details', arguments: selectedCar.value);
      return;
    }

    // Validation

    if (ArrivingFromCode.value == ArrivingToCode.value) {
      SnackbarHelper.showError(
          'Pickup and Drop-off locations cannot be the same. Please change one.',
          title: 'Invalid Location'
      );      return;
    }
    if (ArrivingDate.value == null) {
      SnackbarHelper.showWarning(
          'Please select a pickup date to proceed.',
          title: 'Date Required'
      );      return;
    }
    if (selectedTripType.value == 'Round Way' &&
        (returnDate.value == null || returnDate.value!.isBefore(ArrivingDate.value!))) {
      SnackbarHelper.showWarning(
          'Return date must be after pickup',
          title: 'Invalid Return Date'
      );
      return;
    }

    isLoadingCars.value = true;

    // Generate dummy data (Production: API call)

    await Future.delayed(const Duration(seconds: 2));
    final cars = _generateDemoCars();

    allCars.assignAll(cars);
    searchResults.assignAll(cars);
    Get.toNamed('/search-all-cars');

    isLoadingCars.value = false;
  }

  List<Car> _generateDemoCars() {
    final brands = ['Toyota', 'Honda', 'BMW', 'Mercedes', 'Tesla'];
    final models = ['Camry', 'Civic', 'X5', 'C-Class', 'Model 3'];
    final types = ['Sedan', 'SUV', 'Luxury', 'Electric', 'Hatchback'];

    return List.generate(12, (i) {
      final brand = brands[i % brands.length];
      final model = models[i % models.length];
      final price = 50 + (i * 15);

      return Car(
        id: 'CAR${1000 + i}',
        brand: brand,
        model: model,
        year: 2023 + (i % 3),
        types: types[i % types.length],
        seats: 4 + (i % 3),
        bags: 1 + (i % 2),
        doors: 4,
        transmission: i % 2 == 0 ? 'Automatic' : 'Manual',
        pricePerDay: price.toDouble(),
        rating: 4.2 + (i * 0.1),
        reviews: 100 + (i * 25),
        imageUrl: '',
        available: true,
        extras: [
          "Free cancellation",
          "Basic Collision Damage Protection",
          "Online check-in",
          "Pay now and save",
          if (i % 2 == 0) "Unlimited mileage",
        ],
      );
    });
  }

  // PRICE CALCULATE

  int calculateBookingDays() {
    if (ArrivingDate.value == null) return 1;
    if (selectedTripType.value == 'Round Way' && returnDate.value != null) {
      return returnDate.value!.difference(ArrivingDate.value!).inDays + 1;
    }
    return 1;
  }

  // BOOKING & PAYMENT

  double calculateTotalAmount() {
    final breakdown = getPriceBreakdown();
    return breakdown['total'] ?? 0.0;
  }

  Map<String, double> getPriceBreakdown() {
    if (selectedCar.value == null) {
      return {
        'baseFare': 0.0,
        'tax': 0.0,
        'aitVat': 0.0,
        'otherCharges': 0.0,
        'total': 0.0,
        'days': 1.0,
        'pricePerDay': 0.0,
      };
    }

    final days = calculateBookingDays();
    final pricePerDay = selectedCar.value!.pricePerDay;
    final baseFare = pricePerDay * days;
    final tax = baseFare * 0.15;
    final aitVat = 0.0;
    final otherCharges = 0.0;
    final total = baseFare + tax + aitVat + otherCharges;

    return {
      'baseFare': baseFare,
      'tax': tax,
      'aitVat': aitVat,
      'otherCharges': otherCharges,
      'total': total,
      'days': days.toDouble(),
      'pricePerDay': pricePerDay,
    };
  }

  void bookCar() {
    if (selectedCar.value == null) {
      SnackbarHelper.showError(
          'Please select a car before proceeding to booking.',
          title: 'Selection Required'
      );      return;
    }
    _saveCarBookingToMyBookings();
  }

  void _saveCarBookingToMyBookings() {
    final car = selectedCar.value;
    if (car == null) return;

    final days = calculateBookingDays();
    final total = calculateTotalAmount();

    final dynamicImageUrl = car.imageUrl.isNotEmpty
        ? car.imageUrl
        : 'https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?w=400';


    // USE BookingHelper
    final bookingToSave = BookingHelper.createCarBooking(
      carModel: '${car.brand} ${car.model}',
      pickupLocation: ArrivingFromLocation.value.isNotEmpty
          ? ArrivingFromLocation.value
          : 'Airport',
      country: ArrivingFromCountry.value.isNotEmpty
          ? ArrivingFromCountry.value
          : 'UAE',
      pickupDate: ArrivingDate.value ?? DateTime.now(),
      returnDate: returnDate.value ?? ArrivingDate.value?.add(Duration(days: days)) ?? DateTime.now(),
      totalPrice: total,
      passengers: totalPassengers,
      imageUrl: dynamicImageUrl,
      carDetails: {
        'carId': car.id,
        'brand': car.brand,
        'model': car.model,
        'year': car.year,
        'types': car.types,
        'seats': car.seats,
        'bags': car.bags,
        'doors': car.doors,
        'transmission': car.transmission,
        'rating': car.rating,
        'reviews': car.reviews,
        'pricePerDay': car.pricePerDay,
        'extras': car.extras,
        'days': days,
        'pickup': {
          'location': ArrivingFromLocation.value,
          'code': ArrivingFromCode.value,
          'terminal': ArrivingFromTerminal.value,
          'country': ArrivingFromCountry.value,
          'date': ArrivingDate.value?.toIso8601String(),
        },
        'dropoff': {
          'location': ArrivingToLocation.value,
          'code': ArrivingToCode.value,
          'terminal': ArrivingToTerminal.value,
          'country': ArrivingToCountry.value,
          'date': returnDate.value?.toIso8601String(),
        },
        'paymentMethod': selectedPaymentMethod.value,
      },
    );

    Get.find<MyBookingsController>().addBooking(bookingToSave);

    SnackbarHelper.showSuccess(
      'Your car rental has been booked successfully!',
      title: 'Booking Confirmed',
    );
  }

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]}, ${date.year}';
  }

  void resetBooking() {
    selectedCar.value = null;
    selectedPaymentMethod.value = '';
  }
}