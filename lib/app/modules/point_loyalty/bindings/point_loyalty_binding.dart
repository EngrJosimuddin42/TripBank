import 'package:get/get.dart';

import '../controllers/loyalty_program_controller.dart';

class PointLoyaltyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoyaltyProgramController>(
      () => LoyaltyProgramController(),
    );
  }
}
