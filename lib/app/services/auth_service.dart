import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/user_model.dart';

class AuthService extends GetxService {
  final GetStorage _storage = GetStorage();

  // Keys

  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  static const String _isLoggedInKey = 'is_logged_in';

  // Observable

  final Rx<User?> currentUser = Rx<User?>(null);
  final RxBool isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserFromStorage();
  }

  // Load user from storage

  void _loadUserFromStorage() {
    final token = _storage.read<String>(_tokenKey);
    final userData = _storage.read(_userKey);

    if (token != null && userData != null) {
      try {

        // Cast to Map properly

        final userMap = Map<String, dynamic>.from(userData as Map);
        currentUser.value = User.fromJson(userMap);
        isLoggedIn.value = true;
      } catch (e) {
        logout();
      }
    }
  }

  String? getToken() {
    return _storage.read<String>(_tokenKey);
  }

  // Save token

  Future<void> saveToken(String token) async {
    await _storage.write(_tokenKey, token);
  }

  // Save user

  Future<void> saveUser(User user) async {
    await _storage.write(_userKey, user.toJson());
    currentUser.value = user;
    isLoggedIn.value = true;
  }

  // Update user

  Future<void> updateUser(User user) async {
    await saveUser(user);
  }

  // Login

  Future<void> login(String token, User user) async {
    await saveToken(token);
    await saveUser(user);
    await _storage.write(_isLoggedInKey, true);
  }

  // Logout

  Future<void> logout() async {
    await _storage.remove(_tokenKey);
    await _storage.remove(_userKey);
    await _storage.write(_isLoggedInKey, false);
    currentUser.value = null;
    isLoggedIn.value = false;

    // Navigate to login

    Get.offAllNamed('/login');
  }

  // Check if logged in

  bool get isAuthenticated {
    final token = _storage.read<String>(_tokenKey);
    return token != null && token.isNotEmpty;
  }

  // Get user name

  String get userName {
    return currentUser.value?.name ?? 'Guest';
  }

  // Get user email

  String get userEmail {
    return currentUser.value?.email ?? '';
  }

  // Get profile image

  String? get profileImage {
    return currentUser.value?.profileImageUrl;
  }

  // Get user initials

  String get userInitials {
    return currentUser.value?.initials ?? 'G';
  }

  // Clear all data

  Future<void> clearAllData() async {
    await _storage.erase();
    currentUser.value = null;
    isLoggedIn.value = false;
  }
}