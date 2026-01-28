import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import '../widgets/snackbar_helper.dart';

class StorageService extends GetxService {
  late GetStorage _box;

  final _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  Future<StorageService> init() async {
    await GetStorage.init();
    _box = GetStorage();
    return this;
  }

  //Token Management

  Future<void> saveToken(String token) async {
    try {
      await _secureStorage.write(key: 'auth_token', value: token);
    } catch (e) {
      if (kDebugMode) debugPrint(' Error saving token: $e');
      SnackbarHelper.showError('Security Storage failed. Please try again.');
      rethrow;
    }
  }

  Future<String?> getToken() async {
    try {
      final token = await _secureStorage.read(key: 'auth_token');
      if (kDebugMode && token != null) debugPrint(' Token retrieved');
      return token;
    } catch (e) {
      if (kDebugMode) debugPrint('Error reading token: $e');
      return null;
    }
  }

  Future<void> removeToken() async {
    try {
      await _secureStorage.delete(key: 'auth_token');
    } catch (e) {
      SnackbarHelper.showError('Failed to clear session.');
    }
  }

  Future<bool> isLoggedIn() async {
    try {
      final token = await getToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      if (kDebugMode) debugPrint('Error checking login status: $e');
      return false;
    }
  }

  //User Data

  Future<void> saveUser(Map<String, dynamic> user) async {
    try {
      final userCopy = Map<String, dynamic>.from(user);
      userCopy.remove('password');
      userCopy.remove('credit_card');
      userCopy.remove('token');
      await _box.write('user', userCopy);
    } catch (e) {
      SnackbarHelper.showError('Failed to save user profile locally.');
      rethrow;
    }
  }

  Map<String, dynamic>? getUser() {
    try {
      final user = _box.read<Map>('user');
      return user?.cast<String, dynamic>();
    } catch (e) {
      if (kDebugMode) debugPrint('Error reading user: $e');
      return null;
    }
  }

  //  User Profile Methods

  void saveUserName(String name) {
    try {
      _box.write('user_name', name);
      if (kDebugMode) debugPrint(' User name saved: $name');
    } catch (e) {
      if (kDebugMode) debugPrint(' Error saving user name: $e');
    }
  }

  String? getUserName() {
    try {
      return _box.read<String>('user_name');
    } catch (e) {
      if (kDebugMode) debugPrint(' Error reading user name: $e');
      return null;
    }
  }

  void saveUserEmail(String email) {
    try {
      _box.write('user_email', email);
      if (kDebugMode) debugPrint(' User email saved: $email');
    } catch (e) {
      if (kDebugMode) debugPrint(' Error saving user email: $e');
    }
  }

  String? getUserEmail() {
    try {
      return _box.read<String>('user_email');
    } catch (e) {
      if (kDebugMode) debugPrint(' Error reading user email: $e');
      return null;
    }
  }

  void saveUserPhone(String phone) {
    try {
      _box.write('user_phone', phone);
      if (kDebugMode) debugPrint('User phone saved: $phone');
    } catch (e) {
      if (kDebugMode) debugPrint(' Error saving user phone: $e');
    }
  }

  String? getUserPhone() {
    try {
      return _box.read<String>('user_phone');
    } catch (e) {
      if (kDebugMode) debugPrint(' Error reading user phone: $e');
      return null;
    }
  }

  void saveUserAvatar(String avatarUrl) {
    try {
      _box.write('user_avatar', avatarUrl);
      if (kDebugMode) debugPrint(' User avatar saved');
    } catch (e) {
      if (kDebugMode) debugPrint(' Error saving user avatar: $e');
    }
  }

  String? getUserAvatar() {
    try {
      return _box.read<String>('user_avatar');
    } catch (e) {
      if (kDebugMode) debugPrint('Error reading user avatar: $e');
      return null;
    }
  }

  Future<void> clearUserProfile() async {
    try {
      await _box.remove('user_name');
      await _box.remove('user_email');
      await _box.remove('user_phone');
      await _box.remove('user_avatar');
      if (kDebugMode) debugPrint(' User profile cleared');
    } catch (e) {
      if (kDebugMode) debugPrint(' Error clearing user profile: $e');
    }
  }


  // Save favorite hotels

  Future<void> saveFavoriteHotels(List<Map<String, dynamic>> hotels) async {
    try {
      await _box.write('favorite_hotels', hotels);
      if (kDebugMode) debugPrint(' Favorite hotels saved (${hotels.length} items)');
    } catch (e) {
      if (kDebugMode) debugPrint(' Error saving favorite hotels: $e');
      rethrow;
    }
  }

  // Get favorite hotels

  List<Map<String, dynamic>> getFavoriteHotels() {
    try {
      final data = _box.read<List>('favorite_hotels');
      if (data == null) return [];
      return data.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (e) {
      if (kDebugMode) debugPrint(' Error reading favorite hotels: $e');
      return [];
    }
  }

  // Save favorite tours

  Future<void> saveFavoriteTours(List<Map<String, dynamic>> tours) async {
    try {
      await _box.write('favorite_tours', tours);
      if (kDebugMode) debugPrint('Favorite tours saved (${tours.length} items)');
    } catch (e) {
      if (kDebugMode) debugPrint(' Error saving favorite tours: $e');
      rethrow;
    }
  }

  // Get favorite tours

  List<Map<String, dynamic>> getFavoriteTours() {
    try {
      final data = _box.read<List>('favorite_tours');
      if (data == null) return [];
      return data.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (e) {
      if (kDebugMode) debugPrint(' Error reading favorite tours: $e');
      return [];
    }
  }

  // Save favorite cars

  Future<void> saveFavoriteCars(List<Map<String, dynamic>> cars) async {
    try {
      await _box.write('favorite_cars', cars);
      if (kDebugMode) debugPrint(' Favorite cars saved (${cars.length} items)');
    } catch (e) {
      if (kDebugMode) debugPrint('Error saving favorite cars: $e');
      rethrow;
    }
  }

  // Get favorite cars

  List<Map<String, dynamic>> getFavoriteCars() {
    try {
      final data = _box.read<List>('favorite_cars');
      if (data == null) return [];
      return data.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (e) {
      if (kDebugMode) debugPrint(' Error reading favorite cars: $e');
      return [];
    }
  }

  // Save favorite places

  Future<void> saveFavoritePlaces(List<Map<String, dynamic>> places) async {
    try {
      await _box.write('favorite_places', places);
      if (kDebugMode) debugPrint(' Favorite places saved (${places.length} items)');
    } catch (e) {
      if (kDebugMode) debugPrint(' Error saving favorite places: $e');
      rethrow;
    }
  }

  // Get favorite places

  List<Map<String, dynamic>> getFavoritePlaces() {
    try {
      final data = _box.read<List>('favorite_places');
      if (data == null) return [];
      return data.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (e) {
      if (kDebugMode) debugPrint(' Error reading favorite places: $e');
      return [];
    }
  }

  // Clear all favorites

  Future<void> clearAllFavorites() async {
    try {
      await _box.remove('favorite_hotels');
      await _box.remove('favorite_tours');
      await _box.remove('favorite_cars');
      await _box.remove('favorite_places');
      if (kDebugMode) debugPrint(' All favorites cleared');
    } catch (e) {
      SnackbarHelper.showError('Could not clear favorite list.');
    }
  }


  //  First Time User

  Future<bool> isFirstTime() async {
    try {
      final value = _box.read<bool>('first_time');
      if (kDebugMode) debugPrint('First time check: ${value ?? true}');
      return value ?? true;
    } catch (e) {
      if (kDebugMode) debugPrint(' Error checking first time: $e');
      return true;
    }
  }

  Future<void> markAsOpened() async {
    try {
      await _box.write('first_time', false);
      if (kDebugMode) debugPrint(' Marked as opened (not first time)');
    } catch (e) {
      if (kDebugMode) debugPrint(' Error marking as opened: $e');
    }
  }

  Future<void> resetFirstTime() async {
    try {
      await _box.write('first_time', true);
      if (kDebugMode) debugPrint(' Reset to first time (for testing)');
    } catch (e) {
      if (kDebugMode) debugPrint('Error resetting first time: $e');
    }
  }

  //Save all bookings

  Future<void> saveBookings(List<Map<String, dynamic>> bookings) async {
    try {
      await _box.write('my_bookings', bookings);
      if (kDebugMode) debugPrint(' Bookings saved (${bookings.length} items)');
    } catch (e) {
      if (kDebugMode) debugPrint(' Error saving bookings: $e');
      rethrow;
    }
  }

  //Get all bookings

  List<Map<String, dynamic>> getBookings() {
    try {
      final data = _box.read<List>('my_bookings');
      if (data == null) return [];
      return data.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (e) {
      if (kDebugMode) debugPrint(' Error reading bookings: $e');
      return [];
    }
  }

  Future<void> saveThemeMode(String mode) async {
    await _box.write('theme_mode', mode);
  }

  String getThemeMode() => _box.read<String>('theme_mode') ?? 'system';

  Future<void> clearAll() async {
    try {
      await _secureStorage.deleteAll();
      await _box.erase();
      SnackbarHelper.showSuccess('All local data has been cleared.');
    } catch (e) {
      SnackbarHelper.showError('Failed to clear storage completely.');
    }
  }
}