import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import '../constants/api_constants.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';

class FavoritesService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();
  final AuthService _authService = Get.find<AuthService>();
  final StorageService _storageService = Get.find<StorageService>();

  // Reactive Lists - Shared across the app

  final RxList<Map<String, dynamic>> favoriteHotels = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> favoriteTours = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> favoriteCars = <Map<String, dynamic>>[].obs;

  // Loading states

  final RxBool isLoading = false.obs;
  final RxBool isSyncing = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadLocalFavorites();
    syncWithServer();
  }

  //Load favorites from StorageService (offline support)

  Future<void> _loadLocalFavorites() async {
    try {
      // Load Hotels

      final hotels = _storageService.getFavoriteHotels();
      favoriteHotels.assignAll(hotels);

      // Load Tours

      final tours = _storageService.getFavoriteTours();
      favoriteTours.assignAll(tours);

      // Load Cars

      final cars = _storageService.getFavoriteCars();
      favoriteCars.assignAll(cars);

      print(' Local favorites loaded from StorageService');
    } catch (e) {
      print(' Error loading local favorites: $e');
    }
  }

  // Save favorites to StorageService

  Future<void> _saveLocalFavorites() async {
    try {
      await _storageService.saveFavoriteHotels(favoriteHotels.toList());
      await _storageService.saveFavoriteTours(favoriteTours.toList());
      await _storageService.saveFavoriteCars(favoriteCars.toList());

      print(' Favorites saved to StorageService');
    } catch (e) {
      print(' Error saving favorites: $e');
    }
  }

  // Sync with server

  Future<void> syncWithServer() async {
    if (!_authService.isAuthenticated) {
      print('️ User not authenticated, skipping sync');
      return;
    }

    isSyncing.value = true;
    try {
      final response = await _apiService.get(
        '${ApiConstants.baseUrl}/api/favorites',
      ).timeout(const Duration(seconds: 10));

      if (response['success'] == true && response['data'] != null) {
        final data = response['data'];

        if (data['hotels'] != null) {
          favoriteHotels.assignAll(List<Map<String, dynamic>>.from(data['hotels']));
        }
        if (data['tours'] != null) {
          favoriteTours.assignAll(List<Map<String, dynamic>>.from(data['tours']));
        }
        if (data['cars'] != null) {
          favoriteCars.assignAll(List<Map<String, dynamic>>.from(data['cars']));
        }

        await _saveLocalFavorites();
        print(' Favorites synced with server');
      }
    } catch (e) {
      print(' Error syncing favorites: $e');
    } finally {
      isSyncing.value = false;
    }
  }

  // Add item to favorites

  Future<bool> addFavorite(String type, Map<String, dynamic> item) async {
    final targetList = _getListByType(type);
    if (targetList == null) return false;

    // Check if already exists

    if (_isFavorite(type, item['id'] ?? item['name'])) {
      print(' Item already in favorites');
      return true;
    }

    //  add to local list

    targetList.add(item);
    await _saveLocalFavorites();

    // Sync with server

    if (_authService.isAuthenticated) {
      try {
        final response = await _apiService.post(
          '${ApiConstants.baseUrl}/api/favorites/$type',
          {'item': item},
        ).timeout(const Duration(seconds: 10));

        if (response['success'] == true) {
          print(' Favorite added to server: $type');
          return true;
        } else {
          // Rollback if server fails
          targetList.removeWhere((e) =>
          (e['id'] ?? e['name']) == (item['id'] ?? item['name'])
          );
          await _saveLocalFavorites();
          _showError('Failed to add favorite');
          return false;
        }
      } catch (e) {
        print(' Error adding favorite to server: $e');
        _showError('Added locally, will sync later');
        return true;
      }
    }

    return true;
  }

  // Remove item from favorites

  Future<bool> removeFavorite(String type, dynamic itemId) async {
    final targetList = _getListByType(type);
    if (targetList == null) return false;

    // Find item

    final item = targetList.firstWhereOrNull(
          (e) => (e['id'] ?? e['name']) == itemId,
    );

    if (item == null) {
      print(' Item not found in favorites');
      return false;
    }

    //  remove from local list

    targetList.removeWhere((e) => (e['id'] ?? e['name']) == itemId);
    await _saveLocalFavorites();

    // Sync with server

    if (_authService.isAuthenticated) {
      try {
        final response = await _apiService.delete(
          '${ApiConstants.baseUrl}/api/favorites/$type/$itemId',
        ).timeout(const Duration(seconds: 10));

        if (response['success'] == true) {
          print(' Favorite removed from server: $type');
          return true;
        } else {

          // Rollback if server fails

          targetList.add(item);
          await _saveLocalFavorites();
          _showError('Failed to remove favorite');
          return false;
        }
      } catch (e) {
        print('Error removing favorite from server: $e');
        _showError('Removed locally, will sync later');
        return true;
      }
    }

    return true;
  }

  // Toggle favorite status

  Future<bool> toggleFavorite(String type, Map<String, dynamic> item) async {
    final itemId = item['id'] ?? item['name'];

    if (_isFavorite(type, itemId)) {
      return await removeFavorite(type, itemId);
    } else {
      return await addFavorite(type, item);
    }
  }

  //Check if item is favorite

  bool _isFavorite(String type, dynamic itemId) {
    final targetList = _getListByType(type);
    if (targetList == null) return false;

    return targetList.any((e) => (e['id'] ?? e['name']) == itemId);
  }

  // Public method to check favorite status

  bool isFavorite(String type, dynamic itemId) {
    return _isFavorite(type, itemId);
  }

  // Get list by type

  RxList<Map<String, dynamic>>? _getListByType(String type) {
    switch (type.toLowerCase()) {
      case 'hotel':
      case 'hotels':
        return favoriteHotels;
      case 'tour':
      case 'tours':
        return favoriteTours;
      case 'car':
      case 'cars':
        return favoriteCars;
      default:
        print(' Unknown favorite type: $type');
        return null;
    }
  }

  // Get all favorites count

  int get totalFavoritesCount {
    return favoriteHotels.length + favoriteTours.length + favoriteCars.length;
  }

  // Clear all favorites (for logout)

  Future<void> clearAllFavorites() async {
    favoriteHotels.clear();
    favoriteTours.clear();
    favoriteCars.clear();

    await _storageService.clearAllFavorites();

    print(' All favorites cleared');
  }

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red.withValues(alpha: 0.1),
      colorText: Colors.red[900],
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
}