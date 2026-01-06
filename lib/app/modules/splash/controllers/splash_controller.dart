import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../services/storage_service.dart';

class SplashController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();
  final RxBool isLoading = true.obs;
  final RxString statusMessage = 'Loading...'.obs;

  @override
  void onReady() {
    super.onReady();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      // শুধু লগইন স্ট্যাটাস চেক
      final bool isLoggedIn = await _storage.isLoggedIn();

      if (isLoggedIn) {
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.offAllNamed(Routes.ONBOARDING);
      }
    } catch (e, stack) {
      Get.offAllNamed(Routes.ONBOARDING);

      Get.snackbar(
        'দুঃখিত!',
        'কিছু সমস্যা হয়েছে। অনবোর্ডিং থেকে শুরু করছি।',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}