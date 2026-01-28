import 'package:get/get.dart';

import '../../../services/favorites_service.dart';
import '../../my_bookings/controllers/my_bookings_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../controllers/tours_booking_controller.dart';

class ToursBookingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ToursBookingController>(() => ToursBookingController(),
      fenix: true);
    Get.lazyPut<FavoritesService>(() => FavoritesService(),
      fenix: true);

    Get.lazyPut<MyBookingsController>(() => MyBookingsController(),
      fenix: true);

    Get.lazyPut<ProfileController>(() => ProfileController(),
      fenix: true);
  }
}