import 'package:get/get.dart';
import '../../../services/storage_service.dart';
import '../../../routes/app_pages.dart';

class OnboardingController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();

  final RxInt currentPage = 0.obs;

  Future<void> completeOnboarding() async {
    try {
      await _storage.markAsOpened();
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      print('❌ Error saving onboarding status: $e');
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  void setCurrentPage(int index) {
    currentPage.value = index;
  }
}