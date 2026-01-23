import 'dart:io';
import '../constants/api_constants.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class UserRepository {
  final ApiService _apiService;

  UserRepository(this._apiService);

  // Get current user profile

  Future<User> getProfile() async {
    try {
      final response = await _apiService.get(ApiConstants.profile);

      if (response['success'] == true && response['data'] != null) {
        return User.fromJson(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Failed to load profile');
      }
    } catch (e) {
      throw Exception('Failed to load profile: $e');
    }
  }

  // Update profile
  Future<User> updateProfile({
    String? name,
    String? phone,
    String? address,
    String? city,
    String? country,
  }) async {
    try {
      final body = <String, dynamic>{};

      if (name != null) body['name'] = name;
      if (phone != null) body['phone'] = phone;
      if (address != null) body['address'] = address;
      if (city != null) body['city'] = city;
      if (country != null) body['country'] = country;

      final response = await _apiService.put(ApiConstants.profile, body);

      if (response['success'] == true && response['data'] != null) {
        return User.fromJson(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Failed to update profile');
      }
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  // Upload profile image
  Future<User> updateProfileImage(File imageFile) async {
    try {
      final response = await _apiService.uploadFile(
        '${ApiConstants.profile}/image',
        imageFile,
        fieldName: 'profile_image',
      );

      if (response['success'] == true && response['data'] != null) {
        return User.fromJson(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Failed to upload image');
      }
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  // Delete profile image
  Future<User> deleteProfileImage() async {
    try {
      final response = await _apiService.delete('${ApiConstants.profile}/image');

      if (response['success'] == true && response['data'] != null) {
        return User.fromJson(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Failed to delete image');
      }
    } catch (e) {
      throw Exception('Failed to delete image: $e');
    }
  }

  // Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _apiService.post(
        '${ApiConstants.profile}/change-password',
        {
          'current_password': currentPassword,
          'new_password': newPassword,
          'new_password_confirmation': newPassword,
        },
      );

      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Failed to change password');
      }
    } catch (e) {
      throw Exception('Failed to change password: $e');
    }
  }

  // Get user statistics
  Future<Map<String, dynamic>> getUserStats() async {
    try {
      final response = await _apiService.get('${ApiConstants.profile}/stats');

      if (response['success'] == true && response['data'] != null) {
        return response['data'];
      } else {
        throw Exception(response['message'] ?? 'Failed to load stats');
      }
    } catch (e) {
      throw Exception('Failed to load stats: $e');
    }
  }

  // Get user bookings
  Future<List<Map<String, dynamic>>> getUserBookings() async {
    try {
      final response = await _apiService.get('${ApiConstants.profile}/bookings');

      if (response['success'] == true && response['data'] != null) {
        return List<Map<String, dynamic>>.from(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Failed to load bookings');
      }
    } catch (e) {
      throw Exception('Failed to load bookings: $e');
    }
  }

  // Get user favorites
  Future<List<Map<String, dynamic>>> getUserFavorites() async {
    try {
      final response = await _apiService.get('${ApiConstants.profile}/favorites');

      if (response['success'] == true && response['data'] != null) {
        return List<Map<String, dynamic>>.from(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Failed to load favorites');
      }
    } catch (e) {
      throw Exception('Failed to load favorites: $e');
    }
  }
}