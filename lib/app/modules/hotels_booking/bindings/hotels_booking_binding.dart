import 'package:get/get.dart';

import '../../../services/favorites_service.dart';
import '../../home/controllers/home_controller.dart';
import '../../my_bookings/controllers/my_bookings_controller.dart';
import '../controllers/hotels_booking_controller.dart';

class HotelsBookingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HotelsBookingController>(() => HotelsBookingController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<MyBookingsController>(() => MyBookingsController());
        Get.lazyPut(() => FavoritesService());
  }
}
