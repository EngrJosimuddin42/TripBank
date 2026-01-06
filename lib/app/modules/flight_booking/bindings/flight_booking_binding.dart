import 'package:get/get.dart';

import '../controllers/flight_booking_controller.dart';

class FlightBookingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FlightBookingController>(
      () => FlightBookingController(),
    );
  }
}
