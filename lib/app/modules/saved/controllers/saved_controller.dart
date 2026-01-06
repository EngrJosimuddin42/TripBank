import 'package:get/get.dart';
import '../../../services/favorites_service.dart';

class SavedController extends GetxController {
  final FavoritesService _favoritesService = Get.find<FavoritesService>();

  // Use FavoritesService's reactive lists directly
  RxList<Map<String, dynamic>> get savedHotels => _favoritesService.favoriteHotels;
  RxList<Map<String, dynamic>> get savedTours => _favoritesService.favoriteTours;

  // Loading States
  RxBool get isLoading => _favoritesService.isLoading;
  RxBool get isRefreshing => _favoritesService.isSyncing;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> refreshSavedItems() async {
    await _favoritesService.syncWithServer();
  }

  // Toggle favorite (remove from saved)

  Future<void> toggleHotelFavorite(int index) async {
    if (index < 0 || index >= savedHotels.length) return;

    final hotel = savedHotels[index];
    final itemId = hotel['id'] ?? hotel['name'];

    await _favoritesService.removeFavorite('hotel', itemId);
  }

  Future<void> toggleTourFavorite(int index) async {
    if (index < 0 || index >= savedTours.length) return;

    final tour = savedTours[index];
    final itemId = tour['id'] ?? tour['name'];

    await _favoritesService.removeFavorite('tour', itemId);
  }

  // Navigation methods

  void onHotelTap(int index) {
    if (index < savedHotels.length) {
      Get.toNamed('/hotel-details', arguments: savedHotels[index]);
    }
  }

  void onTourTap(int index) {
    if (index < savedTours.length) {
      Get.toNamed('/tour-details', arguments: savedTours[index]);
    }
  }

  void onBookNow(int index) {
    if (index < savedHotels.length) {
      Get.toNamed('/booking', arguments: savedHotels[index]);
    }
  }

  // Get total favorites count
  int get totalFavoritesCount => _favoritesService.totalFavoritesCount;
}