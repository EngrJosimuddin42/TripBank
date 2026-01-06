import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class StorageService extends GetxService {
  late GetStorage _box;

  // Platform-specific options for better security
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

  // ==================== Token Management ====================

  Future<void> saveToken(String token) async {
    try {
      await _secureStorage.write(key: 'auth_token', value: token);
      if (kDebugMode) debugPrint('✅ Token saved successfully');
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Error saving token: $e');
      rethrow;
    }
  }

  Future<String?> getToken() async {
    try {
      final token = await _secureStorage.read(key: 'auth_token');
      if (kDebugMode && token != null) debugPrint('🔑 Token retrieved');
      return token;
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Error reading token: $e');
      return null;
    }
  }

  Future<void> removeToken() async {
    try {
      await _secureStorage.delete(key: 'auth_token');
      if (kDebugMode) debugPrint('🗑️ Token removed');
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Error removing token: $e');
    }
  }

  Future<bool> isLoggedIn() async {
    try {
      final token = await getToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Error checking login status: $e');
      return false;
    }
  }

  // ==================== User Data ====================

  Future<void> saveUser(Map<String, dynamic> user) async {
    try {
      final userCopy = Map<String, dynamic>.from(user);
      userCopy.remove('password');
      userCopy.remove('credit_card');
      userCopy.remove('token');
      await _box.write('user', userCopy);
      if (kDebugMode) debugPrint('👤 User data saved');
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Error saving user: $e');
      rethrow;
    }
  }

  Map<String, dynamic>? getUser() {
    try {
      final user = _box.read<Map>('user');
      return user?.cast<String, dynamic>();
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Error reading user: $e');
      return null;
    }
  }

  // ==================== Favorites Management ====================

  /// Save favorite hotels
  Future<void> saveFavoriteHotels(List<Map<String, dynamic>> hotels) async {
    try {
      await _box.write('favorite_hotels', hotels);
      if (kDebugMode) debugPrint('💖 Favorite hotels saved (${hotels.length} items)');
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Error saving favorite hotels: $e');
      rethrow;
    }
  }

  /// Get favorite hotels
  List<Map<String, dynamic>> getFavoriteHotels() {
    try {
      final data = _box.read<List>('favorite_hotels');
      if (data == null) return [];
      return data.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Error reading favorite hotels: $e');
      return [];
    }
  }

  /// Save favorite tours
  Future<void> saveFavoriteTours(List<Map<String, dynamic>> tours) async {
    try {
      await _box.write('favorite_tours', tours);
      if (kDebugMode) debugPrint('💖 Favorite tours saved (${tours.length} items)');
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Error saving favorite tours: $e');
      rethrow;
    }
  }

  /// Get favorite tours
  List<Map<String, dynamic>> getFavoriteTours() {
    try {
      final data = _box.read<List>('favorite_tours');
      if (data == null) return [];
      return data.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Error reading favorite tours: $e');
      return [];
    }
  }

  /// Save favorite places
  Future<void> saveFavoritePlaces(List<Map<String, dynamic>> places) async {
    try {
      await _box.write('favorite_places', places);
      if (kDebugMode) debugPrint('💖 Favorite places saved (${places.length} items)');
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Error saving favorite places: $e');
      rethrow;
    }
  }

  /// Get favorite places
  List<Map<String, dynamic>> getFavoritePlaces() {
    try {
      final data = _box.read<List>('favorite_places');
      if (data == null) return [];
      return data.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Error reading favorite places: $e');
      return [];
    }
  }

  /// Clear all favorites
  Future<void> clearAllFavorites() async {
    try {
      await _box.remove('favorite_hotels');
      await _box.remove('favorite_tours');
      await _box.remove('favorite_places');
      if (kDebugMode) debugPrint('🗑️ All favorites cleared');
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Error clearing favorites: $e');
    }
  }

  // ==================== First Time User ====================

  Future<bool> isFirstTime() async {
    try {
      final value = _box.read<bool>('first_time');
      if (kDebugMode) debugPrint('🔍 First time check: ${value ?? true}');
      return value ?? true;
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Error checking first time: $e');
      return true;
    }
  }

  Future<void> markAsOpened() async {
    try {
      await _box.write('first_time', false);
      if (kDebugMode) debugPrint('✅ Marked as opened (not first time)');
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Error marking as opened: $e');
    }
  }

  Future<void> resetFirstTime() async {
    try {
      await _box.write('first_time', true);
      if (kDebugMode) debugPrint('🔄 Reset to first time (for testing)');
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Error resetting first time: $e');
    }
  }

  // ==================== Settings ====================

  Future<void> saveThemeMode(String mode) async {
    await _box.write('theme_mode', mode);
  }

  String getThemeMode() => _box.read<String>('theme_mode') ?? 'system';

  // ==================== Cleanup ====================

  Future<void> clearAll() async {
    try {
      await _secureStorage.deleteAll();
      await _box.erase();
      if (kDebugMode) debugPrint('🧹 All storage cleared successfully');
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Error clearing storage: $e');
    }
  }
}