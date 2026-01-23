import 'package:get/get.dart';
import '../modules/cars_booking/bindings/cars_booking_binding.dart';
import '../modules/cars_booking/controllers/car_details_controller.dart';
import '../modules/cars_booking/views/car_details.dart';
import '../modules/cars_booking/views/car_ticket.dart';
import '../modules/cars_booking/views/cars_booking_view.dart';
import '../modules/cars_booking/views/make_payment.dart';
import '../modules/cars_booking/views/search_all_cars.dart';
import '../modules/chatbot/bindings/chatbot_binding.dart';
import '../modules/chatbot/views/chatbot_view.dart';
import '../modules/destinations/bindings/destinations_binding.dart';
import '../modules/destinations/views/destinations_view.dart';
import '../modules/drawer/bindings/drawer_binding.dart';
import '../modules/drawer/views/drawer_view.dart';
import '../modules/explore/bindings/explore_binding.dart';
import '../modules/explore/views/explore_view.dart';
import '../modules/flight_booking/bindings/flight_booking_binding.dart';
import '../modules/flight_booking/bindings/flight_details_binding.dart';
import '../modules/flight_booking/bindings/flight_search_binding.dart';
import '../modules/flight_booking/views/flight_booking_view.dart';
import '../modules/flight_booking/views/flight_details.dart';
import '../modules/flight_booking/views/passenger_details.dart';
import '../modules/flight_booking/views/payment.dart';
import '../modules/flight_booking/views/payment_confirm.dart';
import '../modules/flight_booking/views/search_all_flight.dart';
import '../modules/flight_booking/views/ticket.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/hotels_booking/bindings/hotels_booking_binding.dart';
import '../modules/hotels_booking/views/all_hotels.dart';
import '../modules/hotels_booking/views/hotel_details.dart';
import '../modules/hotels_booking/views/hotel_ticket.dart';
import '../modules/hotels_booking/views/hotels_booking_view.dart';
import '../modules/hotels_booking/views/payment_hotel.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/my_bookings/bindings/my_bookings_binding.dart';
import '../modules/my_bookings/views/my_bookings_view.dart';
import '../modules/my_trips/bindings/my_trips_binding.dart';
import '../modules/my_trips/views/my_trip_details.dart';
import '../modules/my_trips/views/my_trips_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/password/bindings/password_binding.dart';
import '../modules/password/views/create_new_password_view.dart';
import '../modules/password/views/forgot_password_email_view.dart';
import '../modules/password/views/forgot_password_otp_view.dart';
import '../modules/point_loyalty/bindings/point_loyalty_binding.dart';
import '../modules/point_loyalty/views/buy_gift_card.dart';
import '../modules/point_loyalty/views/loyalty_program_view.dart';
import '../modules/point_loyalty/views/my_gift_cards.dart';
import '../modules/point_loyalty/views/redeem_gift_card.dart';
import '../modules/point_loyalty/views/refer_friends.dart';
import '../modules/point_loyalty/views/send_gift_card.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/saved/bindings/saved_binding.dart';
import '../modules/saved/views/saved_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/tours_booking/bindings/tours_booking_binding.dart';
import '../modules/tours_booking/views/all_related_tours.dart';
import '../modules/tours_booking/views/payment_tour.dart';
import '../modules/tours_booking/views/tour_details.dart';
import '../modules/tours_booking/views/tour_ticket.dart';
import '../modules/tours_booking/views/tours_booking_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();
  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD_EMAIL,
      page: () => const ForgotPasswordEmailView(),
      binding: PasswordBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD_OTP,
      page: () => const ForgotPasswordOTPView(),
      binding: PasswordBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_NEW_PASSWORD,
      page: () => const CreateNewPasswordView(),
      binding: PasswordBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.MY_TRIPS,
      page: () => const MyTripsView(),
      binding: MyTripsBinding(),
    ),
    GetPage(
      name: _Paths.MY_TRIP_DETAILS,
      page: () => const MyTripDetailsView(),
      binding: MyTripsBinding(),
    ),
    GetPage(
      name: _Paths.EXPLORE,
      page: () => const ExploreView(),
      binding: ExploreBinding(),
    ),

    GetPage(
      name: _Paths.LOYALTY_PROGRAM,
      page: () => const LoyaltyProgramView(),
      binding: PointLoyaltyBinding(),
    ),
    GetPage(
      name: _Paths.DRAWER,
      page: () => const DrawerView(),
      binding: DrawerBinding(),
    ),
    GetPage(
      name: _Paths.SAVED,
      page: () => const SavedView(),
      binding: SavedBinding(),
    ),
    GetPage(
      name: _Paths.DESTINATIONS,
      page: () => const DestinationsView(),
      binding: DestinationsBinding(),
    ),
    GetPage(
      name: _Paths.CHATBOT,
      page: () => const ChatbotView(),
      binding: ChatbotBinding(),
    ),

    GetPage(
      name: _Paths.FLIGHT_BOOKING,
      page: () => const FlightBookingView(),
      binding: FlightBookingBinding(),
    ),
    GetPage(
      name: _Paths.HOTELS_BOOKING,
      page: () => const HotelsBookingView(),
      binding: HotelsBookingBinding(),
    ),
    GetPage(
      name: _Paths.CARS_BOOKING,
      page: () => const CarsBookingView(),
      binding: CarsBookingBinding(),
    ),
    GetPage(
      name: _Paths.TOURS_BOOKING,
      page: () => const ToursBookingView(),
      binding: ToursBookingBinding(),
    ),

    // Flight Booking Related Pages
    GetPage(
      name: _Paths.SEARCH_ALL_FLIGHT,
      page: () => const SearchAllFlightView(),
      binding: FlightSearchBinding(),
    ),
    GetPage(
      name: _Paths.FLIGHT_DETAILS,
      page: () => const FlightDetailsView(),
      binding: FlightDetailsBinding(),
    ),

    GetPage(
      name: _Paths.PASSENGER_DETAILS,
      page: () => PassengerDetailsView(),
      binding: FlightBookingBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT,
      page: () => const PaymentView(),
      binding: FlightBookingBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT_CONFIRM,
      page: () => const PaymentConfirmView(),
      binding: FlightBookingBinding(),
    ),
    GetPage(
      name: _Paths.TICKET,
      page: () => TicketView(),
      binding: FlightBookingBinding(),
    ),

    // Hotel Booking Related Pages
    GetPage(
      name: _Paths.ALL_HOTELS,
      page: () => AllHotelsView(),
      binding: HotelsBookingBinding(),
    ),
    GetPage(
      name: _Paths.HOTEL_DETAILS,
      page: () => const HotelDetailsView(),
      binding: HotelsBookingBinding(),
    ),

    GetPage(
      name: _Paths.PAYMENT_HOTEL,
      page: () => const PaymentHotelView(),
      binding: HotelsBookingBinding(),
    ),

    GetPage(
      name: _Paths.HOTEL_TICKET,
      page: () => const HotelTicketView(),
      binding: HotelsBookingBinding(),
    ),

    //  Car Booking Related Pages
    GetPage(
      name: _Paths.SEARCH_ALL_CARS,
      page: () => SearchAllCarsView(),
      binding: CarsBookingBinding(),
    ),
    GetPage(
      name: _Paths.CAR_DETAILS,
      page: () => const CarDetailsView(),
      binding: CarsBookingBinding(),
    ),

    GetPage(
      name: _Paths.MAKE_PAYMENT,
      page: () =>  MakePaymentView(),
      binding: CarsBookingBinding(),
    ),

    GetPage(
      name: _Paths.CAR_TICKET,
      page: () => const CarTicketView(),
      binding: CarsBookingBinding(),
    ),

    GetPage(
      name: '/car-details',
      page: () => const CarDetailsView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<CarDetailsController>(() => CarDetailsController());
      }),
    ),

    // Tour Booking Related Pages
    GetPage(
      name: _Paths.TOUR_DETAILS,
      page: () => const TourDetailsView(),
      binding: ToursBookingBinding(),
    ),

    GetPage(
      name: _Paths.PAYMENT_TOUR,
      page: () => const PaymentTourView(),
      binding: ToursBookingBinding(),
    ),

    GetPage(
      name: _Paths.TOUR_TICKET,
      page: () => const TourTicketView(),
      binding: ToursBookingBinding(),
    ),

    GetPage(
      name: _Paths.ALL_RELATED_TOURS,
      page: () => const AllRelatedToursView(),
      binding: ToursBookingBinding(),
    ),

    // Gift Card & Loyalty Pages
    GetPage(
      name: _Paths.BUY_GIFT_CARD,
      page: () => const BuyGiftCardView(),
      binding: PointLoyaltyBinding(),
    ),
    GetPage(
      name: _Paths.SEND_GIFT_CARD,
      page: () => const SendGiftCardView(),
      binding: PointLoyaltyBinding(),
    ),
    GetPage(
      name: _Paths.REDEEM_GIFT_CARD,
      page: () => const RedeemGiftCardView(),
      binding: PointLoyaltyBinding(),
    ),
    GetPage(
      name: _Paths.MY_GIFT_CARDS,
      page: () => const MyGiftCardsView(),
      binding: PointLoyaltyBinding(),
    ),
    GetPage(
      name: _Paths.REFER_FRIENDS,
      page: () => const ReferFriendsView(),
      binding: PointLoyaltyBinding(),
    ),
    GetPage(
      name: _Paths.MY_BOOKINGS,
      page: () => const MyBookingsView(),
      binding: MyBookingsBinding(),
    ),
  ];
}
