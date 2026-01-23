import '../constants/api_constants.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthRepository {
  final ApiService _apiService;

  AuthRepository(this._apiService);

  // REGISTER
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConstants.register,
        {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      if (response['success'] == true) {
        return {
          'user': User.fromJson(response['data']['user']),
          'token': response['data']['token'],
        };
      } else {
        throw Exception(response['message'] ?? 'Registration failed');
      }
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  //  LOGIN
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConstants.login,
        {
          'email': email,
          'password': password,
        },
      );

      if (response['success'] == true) {
        return {
          'user': User.fromJson(response['data']['user']),
          'token': response['data']['token'],
        };
      } else {
        throw Exception(response['message'] ?? 'Login failed');
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  //  SOCIAL LOGIN
  Future<Map<String, dynamic>> socialLogin({
    required String provider,
    required String token,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConstants.socialLogin,
        {
          'provider': provider,
          'token': token,
        },
      );

      if (response['success'] == true) {
        return {
          'user': User.fromJson(response['data']['user']),
          'token': response['data']['token'],
        };
      } else {
        throw Exception(response['message'] ?? 'Social login failed');
      }
    } catch (e) {
      throw Exception('Social login failed: $e');
    }
  }

  //  LOGOUT
  Future<void> logout() async {
    try {
      final response = await _apiService.post(ApiConstants.logout, {});

      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Logout failed');
      }
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  // FORGOT PASSWORD - SEND OTP
  Future<void> sendOtp({required String email}) async {
    try {
      final response = await _apiService.post(
        ApiConstants.forgotPasswordSendOtp,
        {'email': email},
      );

      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Failed to send OTP');
      }
    } catch (e) {
      throw Exception('Failed to send OTP: $e');
    }
  }

  //  FORGOT PASSWORD - VERIFY OTP
  Future<void> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConstants.forgotPasswordVerifyOtp,
        {
          'email': email,
          'otp': otp,
        },
      );

      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Invalid OTP');
      }
    } catch (e) {
      throw Exception('OTP verification failed: $e');
    }
  }

  //  FORGOT PASSWORD - RESET PASSWORD
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConstants.forgotPasswordReset,
        {
          'email': email,
          'otp': otp,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Failed to reset password');
      }
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }
}