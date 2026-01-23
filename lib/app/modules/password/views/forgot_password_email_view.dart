import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/password_controller.dart';
import 'forgot_password_otp_view.dart';

class ForgotPasswordEmailView extends GetView<PasswordController> {
  const ForgotPasswordEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(PasswordController());

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 16),
        child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: AppBar(
            backgroundColor: const Color(0xFFF9FAFB),
            elevation: 0,
            leadingWidth: 68,
            leading: Center(
              child: Container(
                width: 44,
                height: 44,
                margin: const EdgeInsets.only(left: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color(0xFFE5E7EB),
                    width: 1,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  shape: CircleBorder(),
                  child: InkWell(
                    customBorder: CircleBorder(),
                    onTap: () => Get.back(),
                    child: Center(
                      child: Icon(
                        Icons.arrow_back,
                        color: Color(0xFF0D0D12),
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            title: Text(
              'Forgot Password',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0D0D12),
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body:Column(
          children: [
          const SizedBox(height: 28),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              'Enter Your Email',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0D0D12),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Please enter the email address associated with\n your account. We\'ll send you a link to reset your\n password and regain access.',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF818898),
                height: 1.55,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Email Address',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF0D0D12),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              height: 48,
              width: 327,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFDFE1E7)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF0D0D12),
                ),
                decoration: InputDecoration(
                  hintText: 'johndoe@example.com',
                  hintStyle: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF0D0D12),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () async {
                  Get.to(() => const ForgotPasswordOTPView());

                 // if (controller.emailController.text.isEmpty) {
                   // SnackbarHelper.showError('Please enter email');
                  //  return;
                 // }
                  //await controller.sendOTP(controller.emailController.text);
                 // if (controller.userEmail.value.isNotEmpty) {
                   // Get.to(() => const ForgotPasswordOTPView());
                  //}
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFECD08),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Continue',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3A3A3A),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      ),
        ),
      ],
    ),
    );
  }
}