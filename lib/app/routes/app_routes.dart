part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const home = _Paths.home;
  static const login = _Paths.login;
  static const splash = _Paths.splash;
  static const register = _Paths.register;
  static const onboarding = _Paths.onboarding;
  static const forgotPasswordEmail = _Paths.forgotPasswordEmail;
  static const forgotPasswordOtp = _Paths.forgotPasswordOtp;
  static const createNewPassword = _Paths.createNewPassword;
  static const profile = _Paths.profile;
  static const explore = _Paths.explore;
  static const hotels = _Paths.hotels;
  static const tours = _Paths.tours;
  static const loyaltyProgram = _Paths.loyaltyProgram;
  static const drawer = _Paths.drawer;
  static const saved = _Paths.saved;
  static const destinations = _Paths.destinations;
  static const destinationHotels = _Paths.destinationHotels;
  static const chatbot = _Paths.chatbot;
  static const allService = _Paths.allService;
  static const flightBooking = _Paths.flightBooking;
  static const hotelsBooking = _Paths.hotelsBooking;
  static const carsBooking = _Paths.carsBooking;
  static const toursBooking = _Paths.toursBooking;

  // Flight Booking Pages
  static const searchAllFlight = _Paths.searchAllFlight;
  static const flightDetails = _Paths.flightDetails;
  static const passengerDetails = _Paths.passengerDetails;
  static const payment = _Paths.payment;
  static const paymentConfirm = _Paths.paymentConfirm;
  static const ticket = _Paths.ticket;

  // Hotel Booking Pages
  static const allHotels = _Paths.allHotels;
  static const hotelDetails = _Paths.hotelDetails;
  static const paymentHotel = _Paths.paymentHotel;
  static const hotelTicket = _Paths.hotelTicket;

  // Car Booking Pages
  static const searchAllCars = _Paths.searchAllCars;
  static const carDetails = _Paths.carDetails;
  static const makePayment = _Paths.makePayment;
  static const carTicket = _Paths.carTicket;

  // Tour Booking Pages
  static const tourDetails = _Paths.tourDetails;
  static const paymentTour = _Paths.paymentTour;
  static const tourTicket = _Paths.tourTicket;
  static const allRelatedTours = _Paths.allRelatedTours;

  // Point & Loyalty Pages
  static const buyGiftCard = _Paths.buyGiftCard;
  static const sendGiftCard = _Paths.sendGiftCard;
  static const redeemGiftCard = _Paths.redeemGiftCard;
  static const myGiftCards = _Paths.myGiftCards;
  static const referFriends = _Paths.referFriends;
  static const myBookings = _Paths.myBookings;
}

abstract class _Paths {
  _Paths._();

  static const home = '/home';
  static const login = '/login';
  static const splash = '/splash';
  static const register = '/register';
  static const onboarding = '/onboarding';
  static const forgotPasswordEmail = '/forgot-password-email';
  static const forgotPasswordOtp = '/forgot-password-otp';
  static const createNewPassword = '/create-new-password';
  static const profile = '/profile';
  static const explore = '/explore';
  static const hotels = '/hotels';
  static const tours = '/tours';
  static const loyaltyProgram = '/loyalty-program';
  static const drawer = '/drawer';
  static const saved = '/saved';
  static const destinations = '/destinations';
  static const destinationHotels = '/destination-hotels';
  static const chatbot = '/chatbot';
  static const allService = '/all-service';
  static const flightBooking = '/flight-booking';
  static const hotelsBooking = '/hotels-booking';
  static const carsBooking = '/cars-booking';
  static const toursBooking = '/tours-booking';

  // Flight Booking Pages
  static const searchAllFlight = '/search-all-flight';
  static const flightDetails = '/flight-details';
  static const passengerDetails = '/passenger-details';
  static const payment = '/payment';
  static const paymentConfirm = '/payment-confirm';
  static const ticket = '/ticket';

  // Hotel Booking Pages
  static const allHotels = '/all-hotels';
  static const hotelDetails = '/hotel-details';
  static const paymentHotel = '/payment-hotel';
  static const hotelTicket = '/hotel-ticket';

  // Car Booking Pages
  static const searchAllCars = '/search-all-cars';
  static const carDetails = '/car-details';
  static const makePayment = '/make-payment';
  static const carTicket = '/car-ticket';

  // Tour Booking Pages
  static const tourDetails = '/tour-details';
  static const paymentTour = '/payment-tour';
  static const tourTicket = '/tour-ticket';
  static const allRelatedTours = '/all-related-tours';

  // Gift Card & Loyalty Pages
  static const buyGiftCard = '/buy-gift-card';
  static const sendGiftCard = '/send-gift-card';
  static const redeemGiftCard = '/redeem-gift-card';
  static const myGiftCards = '/my-gift-cards';
  static const referFriends = '/refer-friends';
  static const myBookings = '/my-bookings';
  static const myBookingsDetails = '/my-bookings-details';
}