class ApiConstants {
  // Development mode toggle
  static const bool isProduction = false; // ← এইটা development এ false and Production এ  true

  // Base URL dynamic
  static String get baseUrl {
    return isProduction
        ? 'https://api.tripbank.com' // Real base API
        : 'http://10.0.2.2:8000'; // Android Emulator API
  }

  // Auth Endpoints
  static String get register => '$baseUrl/api/register';
  static String get login => '$baseUrl/api/login';
  static String get logout => '$baseUrl/api/logout';
  static String get profile => '$baseUrl/api/profile';

  // Password Reset Endpoints
  static String get forgotPassword => '$baseUrl/api/forgot-password';
  static String get forgotPasswordSendOtp => '$forgotPassword/send-otp';
  static String get forgotPasswordVerifyOtp => '$forgotPassword/verify-otp';
  static String get forgotPasswordReset => '$forgotPassword/reset';

  // Social Login Endpoints
  static String get socialLogin => '$baseUrl/api/social-login';

  // Home Page Endpoints Endpoints
  static String get featuredDestinations => '$baseUrl/api/destinations/featured';
  static String get popularHotels => '$baseUrl/api/hotels/popular';
  static String get popularTours => '$baseUrl/api/tours/popular';

// Chatbot Endpoints
  static String get chatSendMessage => '$baseUrl/api/chat/send';
  static String get chatHistory => '$baseUrl/api/chat/history';
  static String get chatById => '$baseUrl/api/chat'; // + /{id}
  static String get chatNew => '$baseUrl/api/chat/new';
}