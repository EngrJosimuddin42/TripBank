import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tripbank/app/modules/register/controllers/register_controller.dart';

import '../../../widgets/snackbar_helper.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            Text(
              'Join Us Today!',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF0D0D12),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Create your account in a few simple steps and unlock access to exclusive features.',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF818898),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 64),

            // First Name & Last Name
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'First Name',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF0D0D12),
                        ),
                      ),
                      const SizedBox(height: 6),
                      _buildTextField(
                        controller: controller.firstNameController,
                        hintText: 'First Name',
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Last Name',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF0D0D12),
                        ),
                      ),
                      const SizedBox(height: 6),
                      _buildTextField(
                        controller: controller.lastNameController,
                        hintText: 'Last Name',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Email
            Text(
              'Email',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF0D0D12),
              ),
            ),
            const SizedBox(height: 6),
            _buildTextField(
              controller: controller.emailController,
              hintText: 'Your email',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            // Phone
            Text(
              'Phone',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF0D0D12),
              ),
            ),
            const SizedBox(height: 6),
            Focus(
              child: Builder(
                builder: (context) {
                  final bool hasFocus = Focus.of(context).hasFocus;

                  return Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: hasFocus ? const Color(0xFFFFFAE6) : Colors.white,
                      border: Border.all(
                        color: hasFocus ? const Color(0xFFFECD08) : const Color(0xFFDFE1E7),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
              child: Row(
                children: [
                  // Country Code Picker
                  GestureDetector(
                    onTap: () => controller.showCountryPicker(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Obx(() => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            controller.selectedCountry.value.code,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF3A3A3A),
                            ),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            size: 20,
                            color: Color(0xFF3A3A3A),
                          ),
                        ],
                      )),
                    ),
                  ),

                  // Divider
                  Container(
                    width: 1,
                    height: 48,
                    color: const Color(0xFFE5E7EB),
                  ),

                  // Phone Number Field
                  Expanded(
                    child: TextField(
                      controller: controller.phoneController,
                      keyboardType: TextInputType.phone,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF3A3A3A),
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter phone number",
                        hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF3A3A3A)
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                ],
              ),
            );
    },
  ),
  ),
            const SizedBox(height: 16),

            // NID Number (Optional)
            Text(
              'NIN Number (Optional)',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF0D0D12),
              ),
            ),
            const SizedBox(height: 6),
            _buildTextField(
              controller: controller.nidController,
              hintText: 'NIN Number',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // Passport (Optional)
            Text(
              'Passport (Optional)',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF0D0D12),
              ),
            ),
            const SizedBox(height: 6),
            _buildTextField(
              controller: controller.passportController,
              hintText: 'Your passport',
            ),
            const SizedBox(height: 16),

            // Date of Birth
            Text(
              'Date of Birth',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF0D0D12),
              ),
            ),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: () => controller.pickDate(context),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFDFE1E7)),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() => Text(
                      controller.selectedDate.value.isEmpty
                          ? 'Birthday Date'
                          : controller.selectedDate.value,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: controller.selectedDate.value.isEmpty
                            ? const Color(0xFF818898)
                            : Colors.black,
                      ),
                    )),
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 20,
                      color: Color(0xFF818898),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Select Gender
            Text(
              'Select Gender',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF0D0D12),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                _buildRadioButton('Male'),
                const SizedBox(width: 24),
                _buildRadioButton('Female'),
              ],
            ),
            const SizedBox(height: 16),

            // Password
            Text(
              'Password',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF0D0D12),
              ),
            ),
            const SizedBox(height: 6),
            _buildPasswordField(
              controller: controller.passwordController,
              hintText: 'Your password',
              isVisible: controller.isPasswordVisible,
            ),
            const SizedBox(height: 16),

            // Confirm Password
            Text(
              'Confirm Password',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF0D0D12),
              ),
            ),
            const SizedBox(height: 6),
            _buildPasswordField(
              controller: controller.confirmPasswordController,
              hintText: 'Your password',
              isVisible: controller.isConfirmPasswordVisible,
            ),
            const SizedBox(height: 28),

            // Terms & Conditions + Privacy Policy
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'By registering you agree to',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF818898),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Terms & Conditions',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFB49206),
                        ),
                      ),
                    ),
                    Text(
                      ' and ',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF818898),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Privacy Policy',
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
            const SizedBox(height: 24),

            // Register Button
            Center(
              child: SizedBox(
                width: 327,
                height: 52,
                child: Obx(() {
                  final bool isValid = controller.isFormValid.value;
                  final bool isLoading = controller.isLoading.value;

                  return ElevatedButton(
                    // ✅ Testing Purpose - Direct success dialog
                    onPressed: () async {
                      controller.showSuccessDialog();
                     // if (isLoading) return;

                    //  if (isValid) {
                      //  await controller.registerUser();
                     // } else {
                       // SnackbarHelper.showWarning(
                        //  'Please fill all required fields correctly',
                        //  title: 'Incomplete Form',
                       // );
                     // }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: isValid
                          ? const Color(0xFFFECD08)  // Active
                          : const Color(0xFFB5B5B5), // Disabled
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      elevation: 0
                    ),
                    child:isLoading
                        ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                    )
                        : Text(
                      'Register',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                          color: isValid
                            ? Colors.black  // Active
                            : const Color(0xFF3A3A3A) // Disabled
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 42),

            // Login Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account? ',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF818898),
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Text(
                    'Login',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFB49206),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
  }) {
    return Focus(
      child: Builder(
        builder: (context) {
          final bool hasFocus = Focus.of(context).hasFocus;

          return Container(
            height: 48,
            decoration: BoxDecoration(
              color: hasFocus ? const Color(0xFFFFFAE6) : Colors.white,
              border: Border.all(
                color: hasFocus ? const Color(0xFFFECD08) : const Color(0xFFDFE1E7),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF3A3A3A),
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF3A3A3A)
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required RxBool isVisible,
  }) {
    return Focus(
        child: Builder(
            builder: (context) {
              final bool hasFocus = Focus
                  .of(context)
                  .hasFocus;

              return Container(
                height: 48,
                decoration: BoxDecoration(
                  color: hasFocus ? const Color(0xFFFFFAE6) : Colors.white,
                  border: Border.all(
                    color: hasFocus ? const Color(0xFFFECD08) : const Color(
                        0xFFDFE1E7),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Obx(() =>
                    TextField(
                        controller: controller,
                        obscureText: !isVisible.value,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: hintText,
                          hintStyle: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: hasFocus
                                ? const Color(0xFF3A3A3A)
                                : const Color(0xFF818898),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16),
                          suffixIcon: IconButton(
                            onPressed: () => isVisible.toggle(),
                            icon: SizedBox(
                              width: 18,
                              height: 14,
                              child: Icon(
                                isVisible.value
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: const Color(0xFF818898),
                                size: 18,
                              ),
                            ),
                          ),
                        )
                    ),
                ),
              );
            }
        )
    );
  }

  Widget _buildRadioButton(String value) {
    return Obx(() {
      final isSelected = controller.selectedGender.value == value;
      return GestureDetector(
        onTap: () => controller.selectedGender.value = value,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFB49206)
                      : const Color(0xFF3A3A3A),
                  width: 1,
                ),
              ),
              child: isSelected
                  ? Center(
                child: Container(
                  width: 7.5,
                  height: 7.5,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFB49206),
                  ),
                ),
              )
                  : null,
            ),
            const SizedBox(width: 8),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ],
        ),
      );
    });
  }
}