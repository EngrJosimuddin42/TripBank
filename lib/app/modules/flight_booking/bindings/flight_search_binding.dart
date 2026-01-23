import 'package:get/get.dart';
import '../controllers/flight_search_controller.dart';

class FlightSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FlightSearchController>(
          () => FlightSearchController(),
    );
  }
}