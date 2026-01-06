import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../../../repositories/auth_repository.dart';
import '../../../services/api_service.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(() => AuthRepository(Get.find<ApiService>()));
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
