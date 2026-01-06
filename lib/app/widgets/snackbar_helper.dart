import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackbarHelper {

  // Success Snackbar
  static void showSuccess(String message, {String title = 'Success'}) {
    Get.snackbar(
      '',
      '',
      titleText: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      messageText: Text(
        message,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withValues(alpha: 0.9),
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.check_circle, color: Colors.white, size: 28),
      shouldIconPulse: true,
      barBlur: 20,
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }

  // Error Snackbar
  static void showError(String message, {String title = 'Error'}) {
    Get.snackbar(
      '',
      '',
      titleText: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      messageText: Text(
        message,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withValues(alpha: 0.9),
      duration: const Duration(seconds: 5),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.error, color: Colors.white, size: 28),
      shouldIconPulse: true,
      barBlur: 20,
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }
  // Warning / Info Snackbar
  static void showWarning(String message, {String title = 'Warning'}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange.withValues(alpha: 0.9),
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 28),
    );
  }

  // Network Error
  static void showNetworkError() {
    showError(
      'No internet connection or server error. Please try again.',
      title: 'Network Error',
    );
  }
}