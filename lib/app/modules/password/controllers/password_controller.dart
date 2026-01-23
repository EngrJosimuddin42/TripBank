import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../constants/api_constants.dart';
import '../../../widgets/snackbar_helper.dart';

class PasswordController extends GetxController {

  // OTP Controllers
  final List<TextEditingController> otpControllers =
  List.generate(6, (index) => TextEditingController());
  final RxList<String> otpValues = List.generate(6, (index) => '').obs;

  // Email Controller
  final emailController = TextEditingController();

  // Password Controllers
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Observable states
  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;
  final RxString userEmail = ''.obs;

  // 1. Send OTP to Email
  Future<void> sendOTP(String email) async {
    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse(ApiConstants.forgotPasswordSendOtp),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      if (response.statusCode == 200) {
        userEmail.value = email;
        SnackbarHelper.showSuccess('OTP sent to $email');
      } else {
        final error = json.decode(response.body);
        SnackbarHelper.showError(error['message'] ?? 'Failed to send OTP');
      }
    } catch (e) {
      SnackbarHelper.showNetworkError();
    } finally {
      isLoading.value = false;
    }
  }

  // 2. Resend OTP
  Future<void> resendOTP() async {
    if (userEmail.value.isEmpty) {
      SnackbarHelper.showError('Email not found');
      return;
    }
    await sendOTP(userEmail.value);
  }

  // Verify OTP
  Future<bool> verifyOTP() async {
    try {
      isLoading.value = true;
      String otp = getFullOTP();

      if (otp.length != 6) {
        SnackbarHelper.showError('Please enter complete OTP');
        return false;
      }

      final response = await http.post(
        Uri.parse(ApiConstants.forgotPasswordVerifyOtp),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': userEmail.value,
          'otp': otp,
        }),
      );

      if (response.statusCode == 200) {
        SnackbarHelper.showSuccess('OTP verified successfully');
        return true;
      } else {
        final error = json.decode(response.body);
        SnackbarHelper.showError(error['message'] ?? 'Invalid OTP');
        return false;
      }
    } catch (e) {
      SnackbarHelper.showNetworkError();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Reset Password (Save new password)
  Future<void> resetPassword() async {
    try {
      if (passwordController.text.isEmpty ||
          confirmPasswordController.text.isEmpty) {
        SnackbarHelper.showError('Please fill all fields');
        return;
      }

      if (passwordController.text != confirmPasswordController.text) {
        SnackbarHelper.showError('Passwords do not match');
        return;
      }

      if (passwordController.text.length < 6) {
        SnackbarHelper.showError('Password must be at least 6 characters');
        return;
      }

      isLoading.value = true;

      final response = await http.post(
        Uri.parse(ApiConstants.forgotPasswordReset),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': userEmail.value,
          'otp': getFullOTP(),
          'password': passwordController.text,
          'password_confirmation': confirmPasswordController.text,
        }),
      );

      if (response.statusCode == 200) {
        SnackbarHelper.showSuccess('Password reset successfully');


        Get.offAllNamed('/login');

        // Clear all data
        clearAll();
      } else {
        final error = json.decode(response.body);
        SnackbarHelper.showError(error['message'] ?? 'Failed to reset password');
      }
    } catch (e) {
      SnackbarHelper.showNetworkError();
    } finally {
      isLoading.value = false;
    }
  }

  // Helper methods
  void updateOTP(int index, String value) {
    otpValues[index] = value;
  }

  String getFullOTP() {
    return otpControllers.map((controller) => controller.text).join();
  }

  bool isOTPComplete() {
    return otpValues.every((value) => value.isNotEmpty);
  }

  void clearOTP() {
    for (var controller in otpControllers) {
      controller.clear();
    }
    otpValues.value = List.generate(6, (index) => '');
  }

  void clearAll() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    clearOTP();
    userEmail.value = '';
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    super.onClose();
  }
}