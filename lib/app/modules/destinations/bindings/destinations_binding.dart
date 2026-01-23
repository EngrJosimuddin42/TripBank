import 'package:get/get.dart';

import '../../../services/favorites_service.dart';
import '../../home/controllers/home_controller.dart';
import '../../hotels_booking/controllers/hotels_booking_controller.dart';
import '../controllers/destinations_controller.dart';

class DestinationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DestinationsController>(() => DestinationsController());
    Get.lazyPut<HotelsBookingController>(() => HotelsBookingController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut(() => FavoritesService());
  }
}
