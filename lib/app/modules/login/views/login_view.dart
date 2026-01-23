import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../routes/app_pages.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFF9FAFB),
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9FAFB),
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: const Color(0xFFF9FAFB),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome Back!',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0D0D12),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Log in to access your account and continue where you left off. Enter your credentials to get started.',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF818898),
                      height: 1.5.h,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email Address',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF0D0D12),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Obx(
                          () => Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: controller.hasError.value
                                ? const Color(0xFFDF1C41)
                                : const Color(0xFFDFE1E7),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: controller.emailController,
                          onChanged: (value) {
                            controller.clearError();
                            controller.checkFormValidity();
                          },
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF0D0D12),
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter your email address',
                            hintStyle: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF818898),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Obx(
                          () => controller.hasError.value
                          ? Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 12,
                              color: Color(0xFFDF1C41),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Please check the format and try again',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFFDF1C41),
                              ),
                            ),
                          ],
                        ),
                      )
                          : const SizedBox(),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Password',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF0D0D12),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Obx(
                          () => Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFFDFE1E7),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: controller.passwordController,
                          obscureText: !controller.isPasswordVisible.value,
                          onChanged: (value) => controller.checkFormValidity(),
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF0D0D12),
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter your password',
                            hintStyle: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF818898),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () =>
                                  controller.togglePasswordVisibility(),
                              icon: SizedBox(
                                width: 18,
                                height: 14,
                                child: Icon(
                                  controller.isPasswordVisible.value
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: const Color(0xFF818898),
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () =>
                            Get.toNamed(Routes.FORGOT_PASSWORD_EMAIL),
                        child: Text(
                          'Forgot Password?',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFB49206),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: Obx(
                            () => ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : () {
                            Get.offAllNamed('/home');

                            //if (!controller.validateEmail()) {
                            //  return;
                           // }
                           // if (!controller.validatePassword()) {
                            //  return;
                           // }
                           // controller.login();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: controller.isFormValid.value
                                ? const Color(0xFFFECD08)
                                : const Color(0xFFB5B5B5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: controller.isLoading.value
                              ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                              : Text(
                            'Login',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: controller.isFormValid.value
                                  ? const Color(0xFF0D0D12)
                                  : const Color(0xFF3A3A3A),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(color: Color(0xFFDFE1E7)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Or continue with',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF818898),
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Divider(color: Color(0xFFDFE1E7)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialButton(
                          imagePath: 'assets/images/google.png',
                          onTap: controller.loginWithGoogle,
                        ),
                        const SizedBox(width: 16),
                        _buildSocialButton(
                          imagePath: 'assets/images/apple.png',
                          onTap: controller.loginWithApple,
                        ),
                      ],
                    ),
                    const SizedBox(height: 150),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don`t have an account? ',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF818898),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Get.toNamed(Routes.REGISTER),
                          child: Text(
                            'Register',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFB49206),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isActive
                  ? const Color(0xFFE7BB07)
                  : const Color(0xFF818898),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 3,
            width: 130,
            color: isActive ? const Color(0xFFE7BB07) : Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.white,
        ),
        child: ClipRRect(
          child: Image.asset(
            imagePath,
            width: 48,
            height: 48,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              print('Image load error: $imagePath');
              return Icon(
                _getIconForPath(imagePath),
                size: 48,
                color: const Color(0xFF818898),
              );
            },
          ),
        ),
      ),
    );
  }

  IconData _getIconForPath(String path) {
    if (path.contains('google')) return Icons.g_mobiledata;
    if (path.contains('apple')) return Icons.apple;
    return Icons.login;
  }
}