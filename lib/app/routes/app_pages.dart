import 'package:get/get.dart';
import '../modules/cars_booking/bindings/cars_booking_binding.dart';
import '../modules/cars_booking/views/cars_booking_view.dart';
import '../modules/chatbot/bindings/chatbot_binding.dart';
import '../modules/chatbot/views/chatbot_view.dart';
import '../modules/destinations/bindings/destinations_binding.dart';
import '../modules/destinations/views/destinations_view.dart';
import '../modules/drawer/bindings/drawer_binding.dart';
import '../modules/drawer/views/drawer_view.dart';
import '../modules/explore/bindings/explore_binding.dart';
import '../modules/explore/views/explore_view.dart';
import '../modules/flight_booking/bindings/flight_booking_binding.dart';
import '../modules/flight_booking/views/booking_success.dart';
import '../modules/flight_booking/views/flight_booking_view.dart';
import '../modules/flight_booking/views/flight_details.dart';
import '../modules/flight_booking/views/flight_results.dart';
import '../modules/flight_booking/views/passenger_details.dart';
import '../modules/flight_booking/views/payment.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/hotels/bindings/hotels_binding.dart';
import '../modules/hotels/views/hotels_view.dart';
import '../modules/hotels_booking/bindings/hotels_booking_binding.dart';
import '../modules/hotels_booking/views/hotels_booking_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/password/bindings/password_binding.dart';
import '../modules/password/views/create_new_password_view.dart';
import '../modules/password/views/forgot_password_email_view.dart';
import '../modules/password/views/forgot_password_otp_view.dart';
import '../modules/point_loyalty/bindings/point_loyalty_binding.dart';
import '../modules/point_loyalty/views/point_loyalty_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/saved/bindings/saved_binding.dart';
import '../modules/saved/views/saved_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/tours/bindings/tours_binding.dart';
import '../modules/tours/views/tours_view.dart';
import '../modules/tours_booking/bindings/tours_booking_binding.dart';
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
      name: _Paths.EXPLORE,
      page: () => const ExploreView(),
      binding: ExploreBinding(),
    ),
    GetPage(
      name: _Paths.HOTELS,
      page: () => const HotelsView(),
      binding: HotelsBinding(),
    ),
    GetPage(
      name: _Paths.TOURS,
      page: () => const ToursView(),
      binding: ToursBinding(),
    ),
    GetPage(
      name: _Paths.POINT_LOYALTY,
      page: () => const PointLoyaltyView(),
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
    // ✅ Flight Booking Related Pages
    GetPage(
      name: _Paths.FLIGHT_RESULTS,
      page: () => const FlightResultsView(),
      binding: FlightBookingBinding(),
    ),
    GetPage(
      name: _Paths.FLIGHT_DETAILS,
      page: () => const FlightDetailsView(),
      binding: FlightBookingBinding(),
    ),
    GetPage(
      name: _Paths.PASSENGER_DETAILS,
      page: () =>  PassengerDetailsView(),
      binding: FlightBookingBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT,
      page: () => const PaymentView(),
      binding: FlightBookingBinding(),
    ),
    GetPage(
      name: _Paths.BOOKING_SUCCESS,
      page: () => const BookingSuccessView(),
      binding: FlightBookingBinding(),
    ),
  ];
}
