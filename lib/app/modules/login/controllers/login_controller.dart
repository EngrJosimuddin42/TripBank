import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart' as auth;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../../repositories/auth_repository.dart';
import '../../../services/auth_service.dart';
import '../../../widgets/snackbar_helper.dart';

class LoginController extends GetxController {
  // Dependencies
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final AuthService _authService = Get.find<AuthService>();

  // Text Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Observable States
  final RxBool isPasswordVisible = false.obs;
  final RxBool hasError = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool isFormValid = false.obs;

  void togglePasswordVisibility() => isPasswordVisible.value = !isPasswordVisible.value;

  void clearError() => hasError.value = false;

  // Check if form is valid
  void checkFormValidity() {
    isFormValid.value = emailController.text.trim().isNotEmpty &&
        passwordController.text.trim().isNotEmpty;
  }

  // Email Validation
  bool validateEmail() {
    final email = emailController.text.trim();
    if (email.isEmpty || !GetUtils.isEmail(email)) {
      hasError.value = true;
      return false;
    }
    hasError.value = false;
    return true;
  }

  // Password Validation
  bool validatePassword() {
    if (passwordController.text.trim().length < 6) {
      SnackbarHelper.showError('Password must be at least 6 characters');
      return false;
    }
    return true;
  }

  // ✅ CORRECT LOGIN - Uses Repository
  Future<void> login() async {
    if (!validateEmail() || !validatePassword()) return;

    try {
      isLoading.value = true;

      // Use AuthRepository instead of direct HTTP
      final result = await _authRepository.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Save to AuthService
      await _authService.login(result['token'], result['user']);

      SnackbarHelper.showSuccess('Welcome back!');
      Get.offAllNamed('/home');
      clearAll();
    } catch (e) {
      SnackbarHelper.showError(_getErrorMessage(e));
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ CORRECT GOOGLE LOGIN
  Future<void> loginWithGoogle() async {
    try {
      isLoading.value = true;

      final auth.GoogleSignIn googleSignIn = auth.GoogleSignIn();
      final auth.GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        isLoading.value = false;
        return;
      }

      final auth.GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      // Use AuthRepository's socialLogin method
      final result = await _authRepository.socialLogin(
        provider: 'google',
        token: googleAuth.idToken ?? '',
      );

      // Save to AuthService
      await _authService.login(result['token'], result['user']);

      SnackbarHelper.showSuccess('Welcome!');
      Get.offAllNamed('/home');
      clearAll();
    } catch (e) {
      SnackbarHelper.showError('Google Login Failed: ${_getErrorMessage(e)}');
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ CORRECT APPLE LOGIN
  Future<void> loginWithApple() async {
    try {
      isLoading.value = true;

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName
        ],
      );

      // Use AuthRepository's socialLogin method
      final result = await _authRepository.socialLogin(
        provider: 'apple',
        token: credential.authorizationCode,
      );

      // Save to AuthService
      await _authService.login(result['token'], result['user']);

      SnackbarHelper.showSuccess('Welcome!');
      Get.offAllNamed('/home');
      clearAll();
    } catch (e) {
      SnackbarHelper.showError('Apple Login Failed: ${_getErrorMessage(e)}');
    } finally {
      isLoading.value = false;
    }
  }

  // Extract error message
  String _getErrorMessage(dynamic error) {
    if (error.toString().contains('Login failed:')) {
      return error.toString().replaceAll('Exception: Login failed: ', '');
    }
    return error.toString().replaceAll('Exception: ', '');
  }

  void clearAll() {
    emailController.clear();
    passwordController.clear();
    hasError.value = false;
    isFormValid.value = false;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}