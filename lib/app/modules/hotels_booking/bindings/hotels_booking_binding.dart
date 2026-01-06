import 'package:get/get.dart';

import '../controllers/hotels_booking_controller.dart';

class HotelsBookingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HotelsBookingController>(
      () => HotelsBookingController(),
    );
  }
}
