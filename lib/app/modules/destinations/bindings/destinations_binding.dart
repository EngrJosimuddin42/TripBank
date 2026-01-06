import 'package:get/get.dart';

import '../controllers/destinations_controller.dart';

class DestinationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DestinationsController>(
      () => DestinationsController(),
    );
  }
}
