import 'package:flutter/foundation.dart';
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
        Get.offAllNamed(Routes.home);
      } else {
        Get.offAllNamed(Routes.onboarding);
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('Navigation error: $e');
        debugPrint('Stack: $stackTrace');
      }
      Get.offAllNamed(Routes.onboarding);
      SnackbarHelper.showError(
          'Something went wrong. Starting from onboarding.',
          title: 'Something Went Wrong'
      );

    } finally {
      isLoading.value = false;
    }
  }
}