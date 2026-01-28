import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/snackbar_helper.dart';

class MenuItem {
  final Widget icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  MenuItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}

class RewardBadge {
  final String label;
  final Color color;
  final Widget icon;

  RewardBadge({
    required this.label,
    required this.color,
    required this.icon,
  });
}

class ProfileController extends GetxController {
  // Reactive variables
  final userName = 'Loading...'.obs;
  final userType = 'User'.obs;
  final userAddress = 'Fetching location...'.obs;
  final rewardPoints = '0 Points'.obs;
  final profileImageUrl = ''.obs;
  final isLoading = true.obs;

  //  TourTicketView
  final userEmail = ''.obs;
  final userPhone = ''.obs;

  // Dynamic Reward Badges
  final rewardBadges = <RewardBadge>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }


  Future<void> fetchUserProfile() async {
    try {
      isLoading.value = true;


      //  TEMPORARY DEMO DATA
      await Future.delayed(const Duration(seconds: 1));
      userName.value = 'Josimuddin';
      userType.value = 'Premium User';
      userAddress.value = 'Address: Aqua Tower\n43 Mohakhali C/A,Dhaka 1212';
      rewardPoints.value = '15,216 Points';
      profileImageUrl.value = 'https://via.placeholder.com/150';
      userEmail.value = 'josimuddin@example.com';
      userPhone.value = '+880 1712-345678';

      // Dynamic Badges
      rewardBadges.assignAll([
        RewardBadge(
          label: 'Gold',
          color: const Color(0xFFFFD700),
          icon: Image.asset(
            'assets/images/gold.png',
            width: 24,
            height: 24,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.monetization_on, size: 24, color: Color(0xFFFFD700));
            },
          ),
        ),
        RewardBadge(
          label: 'Platinum',
          color: const Color(0xFF00BCD4),
          icon: Image.asset(
            'assets/images/platinum.png',
            width: 24,
            height: 24,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.star, size: 24, color: Color(0xFF00BCD4));
            },
          ),
        ),
        RewardBadge(
          label: 'Diamond',
          color: const Color(0xFF2196F3),
          icon: Image.asset(
            'assets/images/diamond.png',
            width: 24,
            height: 24,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.diamond, size: 24, color: Color(0xFF2196F3));
            },
          ),
        ),
      ]);
    } catch (e) {
      SnackbarHelper.showError(
          'Failed to load profile. Please try again.',
          title: 'Loading Failed'
      );
      userName.value = 'Guest User';
      userEmail.value = 'guest@example.com';
      userPhone.value = 'Not available';
      profileImageUrl.value = '';
    } finally {
      isLoading.value = false;
    }
  }


  // Methods
  void editProfile() {
    final nameController = TextEditingController(text: userName.value);
    final addressController = TextEditingController(text: userAddress.value);
    final emailController = TextEditingController(text: userEmail.value);
    final phoneController = TextEditingController(text: userPhone.value);

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.phone_outlined),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.location_on_outlined),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              final newName = nameController.text.trim();
              final newEmail = emailController.text.trim();
              final newPhone = phoneController.text.trim();
              final newAddress = addressController.text.trim();

              if (newName.isNotEmpty && newEmail.isNotEmpty && newPhone.isNotEmpty && newAddress.isNotEmpty) {
                userName.value = newName;
                userEmail.value = newEmail;
                userPhone.value = newPhone;
                userAddress.value = newAddress;

                Get.back();
                SnackbarHelper.showSuccess('Profile updated successfully!');
              } else {
                SnackbarHelper.showError('Please fill all fields');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFECD08),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  // Menu Items
  List<MenuItem> get menuItems => [
    MenuItem(
        icon: Image.asset('assets/images/favorite.png'),
        label: 'Saved',
        color: Color(0xFFFECD08),
        onTap: openSaved),
    MenuItem(
        icon: Image.asset('assets/images/chat_bot.png'),
        label: 'AI Chatbot',
        color: Color(0xFFFECD08),
        onTap: openAIChatbot),
    MenuItem(
        icon: Image.asset('assets/images/history.png'),
        label: 'My History',
        color: Color(0xFFFECD08),
        onTap: openHistory),
    MenuItem(
        icon: Image.asset('assets/images/info.png'),
        label: 'Legal Info',
        color: Color(0xFFFECD08),
        onTap: openLegalInfo),
  ];


  void openBookings() {
    Get.toNamed(Routes.myBookings);
  }

  void openSaved() {
    Get.toNamed(Routes.saved);
  }

  void openAIChatbot() {
    Get.toNamed(Routes.chatbot);
  }

  void openHistory() {
    Get.toNamed(Routes.myBookings);
  }

  void openLegalInfo() =>
      SnackbarHelper.showInfo(
          'Redirecting to our Terms of Service and Privacy Policy...',
          title: 'Legal Information'
      );

  void logout() {
    Get.defaultDialog(
      barrierDismissible: false,
      title: 'Log Out',
      titleStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xFFEB212B),
      ),
      content: const Text(
        'Are you sure you want to log out?',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15, height: 1.5, color: Colors.black87),
      ),
      radius: 16,
      cancel: OutlinedButton(
        onPressed: () => Get.back(),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.grey[800],
          side: const BorderSide(color: Colors.grey, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        child: const Text('No'),
      ),
      confirm: ElevatedButton(
        onPressed: () {
          Get.back();
          Get.offAllNamed(Routes.login);
          SnackbarHelper.showSuccess('You have been logged out successfully');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFEB212B),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        child: const Text('Yes, Log Out'),
      ),
    );
  }

  // Optional update methods
  void updateUserName(String name) => userName.value = name;
  void updateUserEmail(String email) => userEmail.value = email;
  void updateUserPhone(String phone) => userPhone.value = phone;
  void updateUserAddress(String address) => userAddress.value = address;
  void updateProfileImage(String url) => profileImageUrl.value = url;
}