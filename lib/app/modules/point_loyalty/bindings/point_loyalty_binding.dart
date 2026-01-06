import 'package:get/get.dart';

import '../controllers/point_loyalty_controller.dart';

class PointLoyaltyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PointLoyaltyController>(
      () => PointLoyaltyController(),
    );
  }
}
