import 'package:get/get.dart';
import '../../../models/hotel_model.dart';
import '../../../services/favorites_service.dart';
import '../../../widgets/snackbar_helper.dart';
import '../../cars_booking/controllers/cars_booking_controller.dart';
import '../../tours_booking/controllers/tours_booking_controller.dart';
import '../../hotels_booking/controllers/hotels_booking_controller.dart';
import 'package:tripbank/app/models/tour_model.dart';
import 'package:tripbank/app/models/car_model.dart';

class SavedController extends GetxController {
  final FavoritesService _favoritesService = Get.find<FavoritesService>();

  RxList<Map<String, dynamic>> get savedHotels => _favoritesService.favoriteHotels;
  RxList<Map<String, dynamic>> get savedTours => _favoritesService.favoriteTours;
  RxList<Map<String, dynamic>> get savedCars => _favoritesService.favoriteCars;

  RxBool get isLoading => _favoritesService.isLoading;
  RxBool get isRefreshing => _favoritesService.isSyncing;

  Future<void> refreshSavedItems() async {
    await _favoritesService.syncWithServer();
  }


  Future<void> toggleHotelFavorite(int index) async {
    if (index < 0 || index >= savedHotels.length) return;
    final hotel = savedHotels[index];
    final itemId = hotel['id']?.toString() ?? hotel['name']?.toString() ?? '';
    if (itemId.isEmpty) return;
    await _favoritesService.removeFavorite('hotel', itemId);
  }

  Future<void> toggleTourFavorite(int index) async {
    if (index < 0 || index >= savedTours.length) return;
    final tour = savedTours[index];
    final itemId = tour['id']?.toString() ?? tour['name']?.toString() ?? '';
    if (itemId.isEmpty) return;
    await _favoritesService.removeFavorite('tour', itemId);
  }

  Future<void> toggleCarFavorite(int index) async {
    if (index < 0 || index >= savedCars.length) return;
    final car = savedCars[index];
    final itemId = car['id']?.toString() ?? car['name']?.toString() ?? '';
    if (itemId.isEmpty) return;
    await _favoritesService.removeFavorite('car', itemId);
  }


  // Navigation Methods
  void onHotelTap(int index) {
    if (index >= savedHotels.length) return;
    final hotelMap = savedHotels[index];
    final hotelsController = Get.find<HotelsBookingController>();
    try {
      final hotel = Hotel.fromJson(hotelMap);
      hotelsController.selectedHotel.value = hotel;
      hotelsController.location.value = hotel.location;
      Get.toNamed('/hotel-details', arguments: hotel);
    } catch (e) {}
  }


  void onTourTap(int index) {
    if (index >= savedTours.length) return;
    final tour = Tour.fromMap(savedTours[index]);
    final bookingController = Get.find<ToursBookingController>();
    bookingController.selectedTour.value = tour;
    Get.toNamed('/tour-details', arguments: tour);
  }


  void onTourBookNow(int index) {
    onTourTap(index);
  }

  void onBookNow(int index) {
    if (index >= savedHotels.length) return;
    final hotelMap = savedHotels[index];
    final hotelsController = Get.find<HotelsBookingController>();

    try {
      final hotel = Hotel.fromJson(hotelMap);
      hotelsController.selectedHotel.value = hotel;
      hotelsController.location.value = hotel.location;
      hotelsController.isFromSaved.value = true;
      Get.toNamed('/hotels-booking', arguments: hotel);
    } catch (e) {
      SnackbarHelper.showError(
          'Failed to load hotel details. Please try again.',
          title: 'Navigation Error'
      );
    }
  }

  void onCarTap(int index) {
    if (index >= savedCars.length) return;
    final carMap = savedCars[index];
    final car = Car.fromJson(carMap);
    final bookingController = Get.find<CarsBookingController>();
    bookingController.selectedCar.value = car;
    Get.toNamed('/car-details', arguments: car);
  }

  void onCarReserve(int index) {
    if (index >= savedCars.length) return;
    final carMap = savedCars[index];
    final carsController = Get.find<CarsBookingController>();

    try {
      final car = Car.fromJson(carMap);
      carsController.selectedCar.value = car;
      carsController.isFromSaved.value = true;
      Get.toNamed('/cars-booking', arguments: car);
    } catch (e) {
      SnackbarHelper.showError(
          'Failed to load car details. Please try again.',
          title: 'Car Details Error'
      );
    }
  }

  int get totalFavoritesCount => _favoritesService.totalFavoritesCount;
}