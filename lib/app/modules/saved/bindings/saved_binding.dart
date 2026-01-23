import 'package:get/get.dart';
import 'package:tripbank/app/modules/hotels_booking/controllers/hotels_booking_controller.dart';
import '../../cars_booking/controllers/cars_booking_controller.dart';
import '../controllers/saved_controller.dart';
import '../../tours_booking/controllers/tours_booking_controller.dart';

class SavedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SavedController>(() => SavedController());
    Get.lazyPut<ToursBookingController>(() => ToursBookingController());
    Get.lazyPut<CarsBookingController>(() => CarsBookingController());
    Get.lazyPut<HotelsBookingController>(() => HotelsBookingController());
  }
}