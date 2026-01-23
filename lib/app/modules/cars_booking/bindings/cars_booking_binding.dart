import 'package:get/get.dart';
import '../../../services/favorites_service.dart';
import '../controllers/car_details_controller.dart';
import '../controllers/cars_booking_controller.dart';

class CarsBookingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FavoritesService>(() => FavoritesService(), fenix: true);
    Get.lazyPut<CarDetailsController>(() => CarDetailsController());
    Get.lazyPut<CarsBookingController>(() => CarsBookingController());
  }
}