import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/password_controller.dart';
import 'create_new_password_view.dart';

class ForgotPasswordOTPView extends GetView<PasswordController> {
  const ForgotPasswordOTPView({super.key});

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
      body: Column(
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
          children: [
            const SizedBox(height: 8),
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFE7BB07),
                borderRadius: BorderRadius.circular(48),
                border: Border.all(
                  color: Color(0xFFFFFAE6),
                  width: 10,
                ),
              ),
              child: const Icon(
                Icons.email_outlined,
                size: 24,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'OTP Verification',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0D0D12),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Enter the OTP sent to your email to verify your identity. Once verified, you can proceed to reset your password.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF818898),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
                Obx(() =>  Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return Container(
                  width: 42,
                  height: 48,
                  decoration: BoxDecoration(
                    color: controller.otpValues[index].isNotEmpty
                        ? const Color(0xFFFFFFFF)
                        : const Color(0xFFFFFAE6),
                    border: Border.all(
                      color: controller.otpValues[index].isNotEmpty
                          ? const Color(0xFFDFE1E7)
                          : const Color(0xFF8C7104),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: TextField(
                      controller: controller.otpControllers[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      decoration: const InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        if (value.length > 1) {
                          String pastedText = value.replaceAll(RegExp(r'[^0-9]'), '');
                          if (pastedText.length >= 6) {
                            for (int i = 0; i < 6 && i < pastedText.length; i++) {
                              controller.otpControllers[i].text = pastedText[i];
                              controller.updateOTP(i, pastedText[i]);
                            }
                            FocusScope.of(context).unfocus();
                          } else {
                            for (int i = index; i < 6 && i - index < pastedText.length; i++) {
                              controller.otpControllers[i].text = pastedText[i - index];
                              controller.updateOTP(i, pastedText[i - index]);
                            }
                          }
                        } else {
                          controller.updateOTP(index, value);
                          if (value.length == 1 && index < 5) {
                            FocusScope.of(context).nextFocus();
                          } else if (value.isEmpty && index > 0) {
                            FocusScope.of(context).previousFocus();
                          }
                        }
                      },
                    ),
                  ),
                );
              }),
                )),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Haven\'t received the code? ',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF818898),
                  ),
                ),
                GestureDetector(
                  onTap: () => controller.resendOTP(),
                  child: Text(
                    'Resend',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFB49206),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 52,
                child: Obx(() {
                  final bool isOtpComplete = controller.isOTPComplete();
                  return ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () async {

                      // ✅ Testing Purpose - Direct Create New page navigation
                      Get.to(() => const CreateNewPasswordView());

                     // bool verified = await controller.verifyOTP();
                      //if (verified) {
                       // Get.to(() => const CreateNewPasswordView());
                     // }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isOtpComplete
                          ? const Color(0xFFFECD08) // OTP পূর্ণ হলে গোল্ডেন
                          : const Color(0xFFB5B5B5), // না হলে ধূসর
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Verify',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isOtpComplete ? Colors.black87 : const Color(0xFF3A3A3A),
                      ),
                    ),
                  );
                }
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