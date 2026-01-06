import 'package:get/get.dart';
import 'package:tripbank/app/services/favorites_service.dart';
import '../../drawer/controllers/drawer_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<DrawerController>(() => DrawerController());
    Get.lazyPut(() => FavoritesService());
  }
}