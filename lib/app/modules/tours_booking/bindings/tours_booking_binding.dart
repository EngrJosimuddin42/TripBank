import 'package:get/get.dart';

import '../controllers/tours_booking_controller.dart';

class ToursBookingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ToursBookingController>(
      () => ToursBookingController(),
    );
  }
}
