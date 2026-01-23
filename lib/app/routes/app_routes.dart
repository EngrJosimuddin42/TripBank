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
  static const MY_TRIPS = _Paths.MY_TRIPS;
  static const MY_TRIP_DETAILS = _Paths.MY_TRIP_DETAILS;
  static const EXPLORE = _Paths.EXPLORE;
  static const HOTELS = _Paths.HOTELS;
  static const TOURS = _Paths.TOURS;
  static const LOYALTY_PROGRAM = _Paths.LOYALTY_PROGRAM;
  static const DRAWER = _Paths.DRAWER;
  static const SAVED = _Paths.SAVED;
  static const DESTINATIONS = _Paths.DESTINATIONS;
  static const DESTINATION_HOTELS = _Paths.DESTINATION_HOTELS;
  static const CHATBOT = _Paths.CHATBOT;
  static const ALL_SERVICE = _Paths.ALL_SERVICE;
  static const FLIGHT_BOOKING = _Paths.FLIGHT_BOOKING;
  static const HOTELS_BOOKING = _Paths.HOTELS_BOOKING;
  static const CARS_BOOKING = _Paths.CARS_BOOKING;
  static const TOURS_BOOKING = _Paths.TOURS_BOOKING;

  //  Flight Booking Pages
  static const SEARCH_ALL_FLIGHT = _Paths.SEARCH_ALL_FLIGHT;
  static const FLIGHT_DETAILS = _Paths.FLIGHT_DETAILS;
  static const PASSENGER_DETAILS = _Paths.PASSENGER_DETAILS;
  static const PAYMENT = _Paths.PAYMENT;
  static const PAYMENT_CONFIRM = _Paths.PAYMENT_CONFIRM;
  static const TICKET = _Paths.TICKET;

  //  Hotel Booking Pages
  static const ALL_HOTELS = _Paths.ALL_HOTELS;
  static const HOTEL_DETAILS = _Paths.HOTEL_DETAILS;
  static const PAYMENT_HOTEL = _Paths.PAYMENT_HOTEL;
  static const HOTEL_TICKET = _Paths.HOTEL_TICKET;

  //  Car Booking Pages
  static const SEARCH_ALL_CARS = _Paths.SEARCH_ALL_CARS;
  static const CAR_DETAILS = _Paths.CAR_DETAILS;
  static const MAKE_PAYMENT = _Paths.MAKE_PAYMENT;
  static const CAR_TICKET = _Paths.CAR_TICKET;

// Tour Booking Pages
  static const TOUR_DETAILS = _Paths.TOUR_DETAILS;
  static const PAYMENT_TOUR = _Paths.PAYMENT_TOUR;
  static const TOUR_TICKET = _Paths.TOUR_TICKET;
  static const ALL_RELATED_TOURS = _Paths.ALL_RELATED_TOURS;

  // Point & Loyalty Pages
  static const BUY_GIFT_CARD = _Paths.BUY_GIFT_CARD;
  static const SEND_GIFT_CARD = _Paths.SEND_GIFT_CARD;
  static const REDEEM_GIFT_CARD = _Paths.REDEEM_GIFT_CARD;
  static const MY_GIFT_CARDS = _Paths.MY_GIFT_CARDS;
  static const REFER_FRIENDS = _Paths.REFER_FRIENDS;
  static const MY_BOOKINGS = _Paths.MY_BOOKINGS;

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
  static const MY_TRIPS = '/my-trips';
  static const MY_TRIP_DETAILS = '/my-trip-details';
  static const EXPLORE = '/explore';
  static const HOTELS = '/hotels';
  static const TOURS = '/tours';
  static const LOYALTY_PROGRAM = '/loyalty-program';
  static const DRAWER = '/drawer';
  static const SAVED = '/saved';
  static const DESTINATIONS = '/destinations';
  static const DESTINATION_HOTELS = '/destination-hotels';
  static const CHATBOT = '/chatbot';
  static const ALL_SERVICE = '/all-service';
  static const FLIGHT_BOOKING = '/flight-booking';
  static const HOTELS_BOOKING = '/hotels-booking';
  static const CARS_BOOKING = '/cars-booking';
  static const TOURS_BOOKING = '/tours-booking';

  //  Flight Booking Pages
  static const SEARCH_ALL_FLIGHT = '/search-all-flight';
  static const FLIGHT_DETAILS = '/flight-details';
  static const PASSENGER_DETAILS = '/passenger-details';
  static const PAYMENT = '/payment';
  static const PAYMENT_CONFIRM = '/payment-confirm';
  static const TICKET = '/ticket';

  // Hotel Booking Pages
  static const ALL_HOTELS = '/all-hotels';
  static const HOTEL_DETAILS = '/hotel-details';
  static const PAYMENT_HOTEL = '/payment-hotel';
  static const HOTEL_TICKET = '/hotel-ticket';

  // Car Booking Pages
  static const SEARCH_ALL_CARS = '/search-all-cars';
  static const CAR_DETAILS = '/car-details';
  static const MAKE_PAYMENT = '/make-payment';
  static const CAR_TICKET = '/car-ticket';
  static const carPayment = '/car-payment';

  // Tour Booking Pages
  static const TOUR_DETAILS = '/tour-details';
  static const PAYMENT_TOUR = '/payment-tour';
  static const TOUR_TICKET = '/tour-ticket';
  static const ALL_RELATED_TOURS = '/all-related-tours';

  //  Gift Card & Loyalty Pages
  static const BUY_GIFT_CARD = '/buy-gift-card';
  static const SEND_GIFT_CARD = '/send-gift-card';
  static const REDEEM_GIFT_CARD = '/redeem-gift-card';
  static const MY_GIFT_CARDS = '/my-gift-cards';
  static const REFER_FRIENDS = '/refer-friends';
  static const MY_BOOKINGS = '/my-bookings';
}
