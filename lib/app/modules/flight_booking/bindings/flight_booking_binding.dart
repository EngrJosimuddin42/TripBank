import 'package:get/get.dart';

import '../controllers/flight_booking_controller.dart';
import '../controllers/flight_search_controller.dart';

class FlightBookingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<FlightBookingController>(
      FlightBookingController(), permanent: true);
    Get.lazyPut<FlightSearchController>(() => FlightSearchController(),fenix: true,);
  }
}
