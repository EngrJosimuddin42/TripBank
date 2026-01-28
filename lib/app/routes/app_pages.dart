import 'package:get/get.dart';
import 'package:tripbank/app/modules/my_bookings/views/my_bookings_details.dart';
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
      name: _Paths.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.register,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.forgotPasswordEmail,
      page: () => const ForgotPasswordEmailView(),
      binding: PasswordBinding(),
    ),
    GetPage(
      name: _Paths.forgotPasswordOtp,
      page: () => const ForgotPasswordOTPView(),
      binding: PasswordBinding(),
    ),
    GetPage(
      name: _Paths.createNewPassword,
      page: () => const CreateNewPasswordView(),
      binding: PasswordBinding(),
    ),
    GetPage(
      name: _Paths.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.explore,
      page: () => const ExploreView(),
      binding: ExploreBinding(),
    ),

    GetPage(
      name: _Paths.loyaltyProgram,
      page: () => const LoyaltyProgramView(),
      binding: PointLoyaltyBinding(),
    ),
    GetPage(
      name: _Paths.drawer,
      page: () => const DrawerView(),
      binding: DrawerBinding(),
    ),
    GetPage(
      name: _Paths.saved,
      page: () => const SavedView(),
      binding: SavedBinding(),
    ),
    GetPage(
      name: _Paths.destinations,
      page: () => const DestinationsView(),
      binding: DestinationsBinding(),
    ),
    GetPage(
      name: _Paths.chatbot,
      page: () => const ChatbotView(),
      binding: ChatbotBinding(),
    ),

    GetPage(
      name: _Paths.flightBooking,
      page: () => const FlightBookingView(),
      binding: FlightBookingBinding(),
    ),
    GetPage(
      name: _Paths.hotelsBooking,
      page: () => const HotelsBookingView(),
      binding: HotelsBookingBinding(),
    ),
    GetPage(
      name: _Paths.carsBooking,
      page: () => const CarsBookingView(),
      binding: CarsBookingBinding(),
    ),
    GetPage(
      name: _Paths.toursBooking,
      page: () => const ToursBookingView(),
      binding: ToursBookingBinding(),
    ),
    GetPage(
      name: _Paths.myBookings,
      page: () => const MyBookingsView(),
      binding: MyBookingsBinding(),
    ),
    GetPage(
      name: _Paths.myBookingsDetails,
      page: () =>const MyBookingsDetailsView(),
      binding: MyBookingsBinding(),
    ),

    // Flight Booking Related Pages
    GetPage(
      name: _Paths.searchAllFlight,
      page: () => const SearchAllFlightView(),
      binding: FlightSearchBinding(),
    ),
    GetPage(
      name: _Paths.flightDetails,
      page: () => const FlightDetailsView(),
      binding: FlightDetailsBinding(),
    ),

    GetPage(
      name: _Paths.passengerDetails,
      page: () => PassengerDetailsView(),
      binding: FlightBookingBinding(),
    ),
    GetPage(
      name: _Paths.payment,
      page: () => const PaymentView(),
      binding: FlightBookingBinding(),
    ),
    GetPage(
      name: _Paths.paymentConfirm,
      page: () => const PaymentConfirmView(),
      binding: FlightBookingBinding(),
    ),
    GetPage(
      name: _Paths.ticket,
      page: () => TicketView(),
      binding: FlightBookingBinding(),
    ),

    // Hotel Booking Related Pages
    GetPage(
      name: _Paths.allHotels,
      page: () => AllHotelsView(),
      binding: HotelsBookingBinding(),
    ),
    GetPage(
      name: _Paths.hotelDetails,
      page: () => const HotelDetailsView(),
      binding: HotelsBookingBinding(),
    ),

    GetPage(
      name: _Paths.paymentHotel,
      page: () => const PaymentHotelView(),
      binding: HotelsBookingBinding(),
    ),

    GetPage(
      name: _Paths.hotelTicket,
      page: () => const HotelTicketView(),
      binding: HotelsBookingBinding(),
    ),

    //  Car Booking Related Pages
    GetPage(
      name: _Paths.searchAllCars,
      page: () => SearchAllCarsView(),
      binding: CarsBookingBinding(),
    ),
    GetPage(
      name: _Paths.carDetails,
      page: () => const CarDetailsView(),
      binding: CarsBookingBinding(),
    ),

    GetPage(
      name: _Paths.makePayment,
      page: () =>  MakePaymentView(),
      binding: CarsBookingBinding(),
    ),

    GetPage(
      name: _Paths.carTicket,
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
      name: _Paths.tourDetails,
      page: () => const TourDetailsView(),
      binding: ToursBookingBinding(),
    ),

    GetPage(
      name: _Paths.paymentTour,
      page: () => const PaymentTourView(),
      binding: ToursBookingBinding(),
    ),

    GetPage(
      name: _Paths.tourTicket,
      page: () => const TourTicketView(),
      binding: ToursBookingBinding(),
    ),

    GetPage(
      name: _Paths.allRelatedTours,
      page: () => const AllRelatedToursView(),
      binding: ToursBookingBinding(),
    ),

    // Gift Card & Loyalty Pages
    GetPage(
      name: _Paths.buyGiftCard,
      page: () => const BuyGiftCardView(),
      binding: PointLoyaltyBinding(),
    ),
    GetPage(
      name: _Paths.sendGiftCard,
      page: () => const SendGiftCardView(),
      binding: PointLoyaltyBinding(),
    ),
    GetPage(
      name: _Paths.redeemGiftCard,
      page: () => const RedeemGiftCardView(),
      binding: PointLoyaltyBinding(),
    ),
    GetPage(
      name: _Paths.myGiftCards,
      page: () => const MyGiftCardsView(),
      binding: PointLoyaltyBinding(),
    ),
    GetPage(
      name: _Paths.referFriends,
      page: () => const ReferFriendsView(),
      binding: PointLoyaltyBinding(),
    ),
  ];
}
