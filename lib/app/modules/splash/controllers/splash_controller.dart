import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../services/storage_service.dart';
import '../../../widgets/snackbar_helper.dart';

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
      final bool isLoggedIn = await _storage.isLoggedIn();

      if (isLoggedIn) {
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.offAllNamed(Routes.ONBOARDING);
      }
    } catch (e, stack) {
      Get.offAllNamed(Routes.ONBOARDING);
      SnackbarHelper.showError(
          'Something went wrong. Starting from onboarding.',
          title: 'Something Went Wrong'
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