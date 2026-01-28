class ApiConstants {

  // Development mode toggle
  static const bool isProduction = false;

  // Base URL dynamic
  static String get baseUrl {
    return isProduction
        ? 'https://api.tripbank.com' // Real base API
        : 'http://10.0.2.2:8000'; // Android Emulator API
  }

  // ============ Auth Endpoints ============
  static String get register => '$baseUrl/api/register';
  static String get login => '$baseUrl/api/login';
  static String get logout => '$baseUrl/api/logout';
  static String get profile => '$baseUrl/api/profile';
  static String get updateProfile => '$baseUrl/api/profile/update';

  // Password Reset Endpoints
  static String get forgotPassword => '$baseUrl/api/forgot-password';
  static String get forgotPasswordSendOtp => '$forgotPassword/send-otp';
  static String get forgotPasswordVerifyOtp => '$forgotPassword/verify-otp';
  static String get forgotPasswordReset => '$forgotPassword/reset';

  // Social Login Endpoints
  static String get socialLogin => '$baseUrl/api/social-login';

  // ============ Home Page Endpoints ============
  static String get featuredDestinations => '$baseUrl/api/destinations/featured';
  static String get popularHotels => '$baseUrl/api/hotels/popular';
  static String get popularTours => '$baseUrl/api/tours/popular';
  static String get trendingDestinations => '$baseUrl/api/destinations/trending';
  static String get promotionalBanner => '$baseUrl/api/promotional-banner';

  // ============ Flight Booking Endpoints ============
  static String get searchFlights => '$baseUrl/api/flights/search';
  static String get flightClasses => '$baseUrl/api/flights/classes';
  static String get flightFacilities => '$baseUrl/api/flights/facilities';
  static String get airlines => '$baseUrl/api/flights/airlines';
  static String get airports => '$baseUrl/api/flights/airports';
  static String get searchAirports => '$baseUrl/api/flights/airports/search';
  static String get bookFlight => '$baseUrl/api/flights/book';
  static String get flightBookingConfirm => '$baseUrl/api/flights/booking/confirm';

  // ============ Hotel Booking Endpoints ============
  static String get searchHotels => '$baseUrl/api/hotels/search';
  static String get hotelAmenities => '$baseUrl/api/hotels/amenities';
  static String get bookHotel => '$baseUrl/api/hotels/book';
  static String get hotelBookingConfirm => '$baseUrl/api/hotels/booking/confirm';
  static String get validateHotelCoupon => '$baseUrl/api/hotels/validate-coupon';

  // ============ Car Rental Endpoints ============
  static String get searchCars => '$baseUrl/api/cars/search';
  static String get carTypes => '$baseUrl/api/cars/types';
  static String get carBrands => '$baseUrl/api/cars/brands';
  static String get bookCar => '$baseUrl/api/cars/book';
  static String get carBookingConfirm => '$baseUrl/api/cars/booking/confirm';

  // ============ Tour Booking Endpoints ============
  static String get searchTours => '$baseUrl/api/tours/search';
  static String get bookTour => '$baseUrl/api/tours/book';
  static String get tourBookingConfirm => '$baseUrl/api/tours/booking/confirm';
  static String get validateTourCoupon => '$baseUrl/api/tours/validate-coupon';


  // ============ Destinations Endpoints ============
  static String get allDestinations => '$baseUrl/api/destinations';

  // ============ My Bookings Endpoints ============
  static String get myBookings => '$baseUrl/api/bookings';
  static String cancelBooking(String bookingId) => '$baseUrl/api/bookings/$bookingId/cancel';
  static String downloadTicket(String bookingId) => '$baseUrl/api/bookings/$bookingId/ticket';
  static String get bookingStats => '$baseUrl/api/bookings/stats';

  // ============ Saved/Wishlist Endpoints ============
  static String get savedItems => '$baseUrl/api/wishlist';
  static String get addToWishlist => '$baseUrl/api/wishlist/add';

  // ============ Favorites Endpoints ============
  static String get getAllFavorites => '$baseUrl/api/favorites';
  static String addFavoriteByType(String type) => '$baseUrl/api/favorites/$type';
  static String removeFavoriteByType(String type, String itemId) =>'$baseUrl/api/favorites/$type/$itemId';

  // ============ Payment Endpoints ============
  static String get processPayment => '$baseUrl/api/payments/process';
  static String get paymentMethods => '$baseUrl/api/payments/methods';
  static String get paymentHistory => '$baseUrl/api/payments/history';

  // ============ Gift Card & Loyalty Endpoints ============
  static String get buyGiftCard => '$baseUrl/api/gift-cards/buy';
  static String get sendGiftCard => '$baseUrl/api/gift-cards/send';
  static String get redeemGiftCard => '$baseUrl/api/gift-cards/redeem';
  static String get myGiftCards => '$baseUrl/api/gift-cards/my-cards';
  static String get giftCardBalance => '$baseUrl/api/gift-cards/balance';
  static String get referFriends => '$baseUrl/api/referrals/send';
  static String get referralCode => '$baseUrl/api/referrals/code';
  static String get referralHistory => '$baseUrl/api/referrals/history';
  static String get referralStats => '$baseUrl/api/referrals/stats';
  static String get loyaltyPoints => '$baseUrl/api/loyalty/points';
  static String get loyaltyHistory => '$baseUrl/api/loyalty/history';


  // ============ Chatbot Endpoints ============
  static String get chatSendMessage => '$baseUrl/api/chat/send';
  static String get chatHistory => '$baseUrl/api/chat/history';
  static String get chatNew => '$baseUrl/api/chat/new';

  // ============ Explore Endpoints ============
  static String get explorePackages => '$baseUrl/api/explore/packages';
  static String get exploreDeals => '$baseUrl/api/explore/deals';
  static String get searchAll => '$baseUrl/api/explore/search';
  static String get exploreFeatured => '$baseUrl/api/explore/featured';
  static String get exploreAll => '$baseUrl/api/explore/all';
  static String exploreSearch(String query) => '$baseUrl/api/explore/search?q=$query';

  // ============ Reviews & Ratings Endpoints ============
  static String get submitReview => '$baseUrl/api/reviews/submit';
  static String get getReviews => '$baseUrl/api/reviews'; // GET /api/reviews?type=hotel&id=1

  // ============ Profile Extended Endpoints ============
  static String get changePassword => '$baseUrl/api/profile/change-password';
  static String get userStats => '$baseUrl/api/profile/stats';
  static String get userBookings => '$baseUrl/api/profile/bookings';
  static String get userFavorites => '$baseUrl/api/profile/favorites';
  static String get uploadProfilePicture => '$baseUrl/api/profile/upload-picture';


  // ============ Legal Information Endpoints ============
  static String get legalInfo => '$baseUrl/api/legal-info';
  static String get termsAndConditions => '$baseUrl/api/legal/terms';
  static String get privacyPolicy => '$baseUrl/api/legal/privacy';
  static String get aboutUs => '$baseUrl/api/about-us';


  // ============ Notifications Endpoints ============
  static String get notifications => '$baseUrl/api/notifications';

  // ============ Helper Methods for Dynamic URLs ============

  // Flight
  static String getFlightDetails(String flightId) => '$baseUrl/api/flights/$flightId';

  // Hotel
  static String getHotelDetails(String hotelId) => '$baseUrl/api/hotels/$hotelId';
  static String getHotelRooms(String hotelId) => '$baseUrl/api/hotels/$hotelId/rooms';
  static String getHotelReviews(String hotelId) => '$baseUrl/api/hotels/$hotelId/reviews';

  // Car
  static String getCarDetails(String carId) => '$baseUrl/api/cars/$carId';

  // Tour
  static String getTourDetails(String tourId) => '$baseUrl/api/tours/$tourId';
  static String getRelatedTours(String tourId) => '$baseUrl/api/tours/$tourId/related';
  static String getTourReviews(String tourId) => '$baseUrl/api/tours/$tourId/reviews';

  // Destination
  static String getDestinationDetails(String destinationId) => '$baseUrl/api/destinations/$destinationId';
  static String getDestinationHotels(String destinationId) => '$baseUrl/api/destinations/$destinationId/hotels';
  static String getDestinationTours(String destinationId) => '$baseUrl/api/destinations/$destinationId/tours';

  // Booking
  static String getBookingDetails(String bookingId) => '$baseUrl/api/bookings/$bookingId';


  // Wishlist
  static String removeFromWishlist(String itemId) => '$baseUrl/api/wishlist/$itemId';

  // Payment
  static String getPaymentStatus(String paymentId) => '$baseUrl/api/payments/$paymentId/status';

  // Chat
  static String getChatById(String chatId) => '$baseUrl/api/chat/$chatId';
  static String deleteChat(String chatId) => '$baseUrl/api/chat/$chatId';

  // Notification
  static String markNotificationAsRead(String notificationId) => '$baseUrl/api/notifications/$notificationId/read';
  static String deleteNotification(String notificationId) => '$baseUrl/api/notifications/$notificationId';

  // Profile picture
  static String get deleteProfilePicture => '$baseUrl/api/profile/delete-picture';

// Preferences
  static String get updatePreferences => '$baseUrl/api/profile/preferences';
  static String get getPreferences => '$baseUrl/api/profile/preferences';

  // Filters
  static String get getFilters => '$baseUrl/api/filters'; // Get available filters
  static String get saveSearchFilters => '$baseUrl/api/filters/save';

// currency & language
  static String get currencies => '$baseUrl/api/currencies';
  static String get languages => '$baseUrl/api/languages';

  // promo &  coupons
  static String get validatePromoCode => '$baseUrl/api/promo-codes/validate';
  static String get applyPromoCode => '$baseUrl/api/promo-codes/apply';
  static String get availableCoupons => '$baseUrl/api/coupons/available';
  static String get validateCarCoupon => '$baseUrl/api/cars/validate-coupon';


  // customer support
  static String get supportTickets => '$baseUrl/api/support/tickets';
  static String get createSupportTicket => '$baseUrl/api/support/tickets/create';
  static String getSupportTicket(String ticketId) => '$baseUrl/api/support/tickets/$ticketId';

  // tracking

  static String get trackUserActivity => '$baseUrl/api/analytics/track';
}