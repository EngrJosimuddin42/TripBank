import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../repositories/auth_repository.dart';
import '../repositories/user_repository.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class DependencyInjection {
  static Future<void> init() async {
    // Initialize GetStorage
    await GetStorage.init();

    // Register StorageService
    await Get.putAsync<StorageService>(() => StorageService().init());

    // Register core services
    Get.put<AuthService>(AuthService(), permanent: true);
    Get.put<ApiService>(ApiService(), permanent: true);

    // Register repositories
    Get.lazyPut(() => UserRepository(Get.find<ApiService>()));
    Get.lazyPut(() => AuthRepository(Get.find<ApiService>()));

    print('✅ All dependencies initialized');
  }
}