part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const LOGIN = _Paths.LOGIN;
  static const SPLASH = _Paths.SPLASH;
  static const REGISTER = _Paths.REGISTER;
  static const ONBOARDING = _Paths.ONBOARDING;
  static const FORGOT_PASSWORD_EMAIL = _Paths.FORGOT_PASSWORD_EMAIL;
  static const FORGOT_PASSWORD_OTP = _Paths.FORGOT_PASSWORD_OTP;
  static const CREATE_NEW_PASSWORD = _Paths.CREATE_NEW_PASSWORD;
  static const PROFILE = _Paths.PROFILE;
  static const EXPLORE = _Paths.EXPLORE;
  static const HOTELS = _Paths.HOTELS;
  static const TOURS = _Paths.TOURS;
  static const POINT_LOYALTY = _Paths.POINT_LOYALTY;
  static const DRAWER = _Paths.DRAWER;
  static const SAVED = _Paths.SAVED;
  static const DESTINATIONS = _Paths.DESTINATIONS;
  static const CHATBOT = _Paths.CHATBOT;
  static const FLIGHT_BOOKING = _Paths.FLIGHT_BOOKING;
  static const HOTELS_BOOKING = _Paths.HOTELS_BOOKING;
  static const CARS_BOOKING = _Paths.CARS_BOOKING;
  static const TOURS_BOOKING = _Paths.TOURS_BOOKING;

  // ✅ Flight Booking Pages
  static const FLIGHT_RESULTS = _Paths.FLIGHT_RESULTS;
  static const FLIGHT_DETAILS = _Paths.FLIGHT_DETAILS;
  static const PASSENGER_DETAILS = _Paths.PASSENGER_DETAILS;
  static const PAYMENT = _Paths.PAYMENT;
  static const BOOKING_SUCCESS = _Paths.BOOKING_SUCCESS;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const LOGIN = '/login';
  static const SPLASH = '/splash';
  static const REGISTER = '/register';
  static const ONBOARDING = '/onboarding';
  static const FORGOT_PASSWORD_EMAIL = '/forgot-password-email';
  static const FORGOT_PASSWORD_OTP = '/forgot-password-otp';
  static const CREATE_NEW_PASSWORD = '/create-new-password';
  static const PROFILE = '/profile';
  static const EXPLORE = '/explore';
  static const HOTELS = '/hotels';
  static const TOURS = '/tours';
  static const POINT_LOYALTY = '/point-loyalty';
  static const DRAWER = '/drawer';
  static const SAVED = '/saved';
  static const DESTINATIONS = '/destinations';
  static const CHATBOT = '/chatbot';
  static const FLIGHT_BOOKING = '/flight-booking';
  static const HOTELS_BOOKING = '/hotels-booking';
  static const CARS_BOOKING = '/cars-booking';
  static const TOURS_BOOKING = '/tours-booking';
  // ✅ Flight Booking Pages
  static const FLIGHT_RESULTS = '/flight-results';
  static const FLIGHT_DETAILS = '/flight-details';
  static const PASSENGER_DETAILS = '/passenger-details';
  static const PAYMENT = '/payment';
  static const BOOKING_SUCCESS = '/booking-success';
}
