import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tripbank/app/widgets/custom_date_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../constants/api_constants.dart';
import '../../../services/storage_service.dart';
import '../../../widgets/snackbar_helper.dart';

class Country {
  final String name;
  final String code;
  final String flag;
  final int minLength;
  final int maxLength;

  Country({
    required this.name,
    required this.code,
    required this.flag,
    required this.minLength,
    required this.maxLength,
  });
}

// Countries list
final List<Country> countries = [
  Country(name: 'United States', code: '+1', flag: '🇺🇸', minLength: 10, maxLength: 10),
  Country(name: 'Bangladesh', code: '+880', flag: '🇧🇩', minLength: 10, maxLength: 10),
  Country(name: 'India', code: '+91', flag: '🇮🇳', minLength: 10, maxLength: 10),
  Country(name: 'Pakistan', code: '+92', flag: '🇵🇰', minLength: 10, maxLength: 10),
  Country(name: 'United Kingdom', code: '+44', flag: '🇬🇧', minLength: 9, maxLength: 10),
  Country(name: 'Canada', code: '+1', flag: '🇨🇦', minLength: 10, maxLength: 10),
  Country(name: 'Australia', code: '+61', flag: '🇦🇺', minLength: 9, maxLength: 9),
];

class RegisterController extends GetxController {
  // Text Controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final nidController = TextEditingController();
  final passportController = TextEditingController();
  final dobController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Reactive States
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final selectedGender = 'Male'.obs;
  final selectedCountry = countries[1].obs; // Default: Bangladesh
  final selectedDate = ''.obs;

  // States
  final isLoading = false.obs;
  final isFormValid = false.obs;
  final errorMessage = ''.obs;
  final storage = Get.find<StorageService>();

  @override
  void onInit() {
    super.onInit();

    // প্রতিটি ফিল্ড চেঞ্জ হলেই ভ্যালিডেশন চালাবে
    firstNameController.addListener(_validateForm);
    lastNameController.addListener(_validateForm);
    emailController.addListener(_validateForm);
    phoneController.addListener(_validateForm);
    nidController.addListener(_validateForm);
    passportController.addListener(_validateForm);
    dobController.addListener(_validateForm);
    passwordController.addListener(_validateForm);
    confirmPasswordController.addListener(_validateForm);

    // কান্ট্রি চেঞ্জ হলে ফোন লেন্থ রি-চেক
    selectedCountry.listen((_) => _validateForm());
  }

  void _validateForm() {
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim().replaceAll(RegExp(r'\D'), '');
    final nid = nidController.text.trim();
    final passport = passportController.text.trim();
    final dob = dobController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    // ইমেইল ভ্যালিডেশন
    final emailValid = email.isNotEmpty && RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);

    // পাসওয়ার্ড ম্যাচ
    final passwordMatch = password == confirmPassword && password.isNotEmpty;

    // NID অথবা Passport এর মধ্যে যেকোনো একটা থাকতে হবে
    final idValid = nid.isNotEmpty || passport.isNotEmpty;

    // ফোন নম্বর লেন্থ চেক (সিলেক্টেড কান্ট্রি অনুযায়ী)
    final country = selectedCountry.value;
    final phoneValid = phone.isNotEmpty &&
        phone.length >= country.minLength &&
        phone.length <= country.maxLength;

    // সব কন্ডিশন চেক
    final valid = firstName.isNotEmpty &&
        lastName.isNotEmpty &&
        email.isNotEmpty &&
        emailValid &&
        phoneValid &&
        dob.isNotEmpty &&
        password.isNotEmpty &&
        passwordMatch &&
        idValid;

    isFormValid.value = valid;
  }


// API Call
  Future<void> registerUser() async {
    if (!isFormValid.value) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final fullPhone = '${selectedCountry.value.code}${phoneController.text.trim().replaceAll(RegExp(r'\D'), '')}';

      final Map<String, dynamic> body = {
        "first_name": firstNameController.text.trim(),
        "last_name": lastNameController.text.trim(),
        "email": emailController.text.trim(),
        "phone": fullPhone,
        "dob": dobController.text.trim(),
        "password": passwordController.text,
        "gender": selectedGender.value,
        if (nidController.text.trim().isNotEmpty) "nid": nidController.text.trim(),
        if (passportController.text.trim().isNotEmpty) "passport": passportController.text.trim(),
      };

      final response = await http.post(
        Uri.parse(ApiConstants.register),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // টোকেন থাকলে সেভ করুন
        final token = responseData['token'] ?? responseData['access_token'];
        if (token != null) {
          await storage.saveToken(token);
        }

        // ইউজার ডাটা থাকলে সেভ করুন
        if (responseData['user'] != null) {
          await storage.saveUser(responseData['user']);
        }

        showSuccessDialog();
      } else {
        final msg = responseData['message'] ??
            responseData['error'] ??
            'Registration failed';
        errorMessage.value = msg;

        SnackbarHelper.showError(msg);
      }
    } catch (e) {
      SnackbarHelper.showNetworkError();
    } finally {
      isLoading.value = false;
    }
  }
  // Date Picker
  Future<void> pickDate(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => CustomDatePicker(
        initialDate: DateTime(1990),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
        onDateSelected: (picked) {
          final formattedDate =
              '${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}';
          dobController.text = formattedDate;
          selectedDate.value = formattedDate;
          _validateForm();
        },
      ),
    );
  }

  // Country Picker
  void showCountryPicker(BuildContext context) {
    Get.bottomSheet(
      backgroundColor: const Color(0xFFF6F8FA),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      Container(
        height: MediaQuery.of(context).size.height * 0.6,
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Country',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close, color: Colors.black),
                  ),
                ],
              ),
            ),
            const Divider(color: Color(0xFFDFE1E7)),
            Expanded(
              child: ListView.builder(
                itemCount: countries.length,
                itemBuilder: (context, index) {
                  final country = countries[index];
                  final isSelected = selectedCountry.value == country;

                  return ListTile(
                    leading: Text(
                      country.flag,
                      style: const TextStyle(fontSize: 28),
                    ),
                    title: Text(
                      country.name,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          country.code,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: const Color(0xFF818898),
                          ),
                        ),
                        if (isSelected) ...[
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.check,
                            color: Color(0xFFB49206),
                            size: 20,
                          ),
                        ],
                      ],
                    ),
                    onTap: () {
                      selectedCountry.value = country;
                      Get.back();
                      _validateForm();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Success Dialog
  void showSuccessDialog() {
    Get.dialog(
      barrierDismissible: false,
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: const Color(0xFFFFFFFF),
        child: SizedBox(
          width: 300,
          height: 400,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFFED739).withValues(alpha: 0.6),
                        const Color(0xFFFED739).withValues(alpha: 0.3),
                      ],
                      stops: const [0.0, 0.3],
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFED739),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 27,
                        color: Colors.white,
                        weight: 3.33,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Registration Successful!',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0D0D12),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Thank you for signing up. We`re excited \nto have you with us. You can now log in \nand start exploring all the features we \nhave to offer.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF818898),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: 256,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () async {
                      Get.back();
                      if (await storage.isLoggedIn()) {
                        Get.offAllNamed('/home');
                      } else {
                        Get.offAllNamed('/login');
                      }
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    nidController.dispose();
    passportController.dispose();
    dobController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
