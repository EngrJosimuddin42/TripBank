import 'package:get/get.dart';

import '../controllers/tours_controller.dart';

class ToursBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ToursController>(
      () => ToursController(),
    );
  }
}
