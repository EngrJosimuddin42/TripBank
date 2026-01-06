import 'package:get/get.dart';

import '../controllers/cars_booking_controller.dart';

class CarsBookingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CarsBookingController>(
      () => CarsBookingController(),
    );
  }
}
