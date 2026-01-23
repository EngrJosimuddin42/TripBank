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

class DrawerController extends GetxController {
  final userName = 'Loading...'.obs;
  final userType = 'User'.obs;
  final userAddress = 'Fetching location...'.obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDrawer();
  }


  Future<void> fetchDrawer() async {
    try {
      isLoading.value = true;

      // TEMPORARY DEMO DATA

      await Future.delayed(const Duration(seconds: 1));

      userName.value = 'Josimuddin';
      userType.value = 'Premium User';
      userAddress.value = 'My Address: Aqua Tower 43, Mohakhali C/A,Dhaka 1212';
      isLoading.value = false;

    } catch (e) {
      isLoading.value = false;
      SnackbarHelper.showError('Failed to load profile data');
      print('Error fetching drawer data: $e');
    }
  }

  // Methods

  void editProfile() {
    final nameController = TextEditingController(text: userName.value);
    final addressController = TextEditingController(text: userAddress.value);

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        content: Column(
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
              controller: addressController,
              decoration: InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: const Icon(Icons.location_on_outlined),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              final newName = nameController.text.trim();
              final newAddress = addressController.text.trim();

              if (newName.isNotEmpty && newAddress.isNotEmpty) {
                userName.value = newName;
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
    MenuItem(icon: Image.asset('assets/images/group.png'), label: 'My Bookings', color: Color(0xFFFECD08), onTap: openBookings),
    MenuItem(icon: Image.asset('assets/images/favorite.png'), label: 'Saved', color: Color(0xFFFECD08), onTap: openSaved),
    MenuItem(icon: Image.asset('assets/images/chat_bot.png'), label: 'AI Chatbot', color: Color(0xFFFECD08), onTap: openAIChatbot),
    MenuItem(icon:Image.asset('assets/images/history.png'), label: 'My History', color: Color(0xFFFECD08), onTap: openHistory),
    MenuItem(icon: Image.asset('assets/images/info.png'), label: 'Legal Info', color: Color(0xFFFECD08), onTap: openLegalInfo),
  ];

  void openBookings() {Get.toNamed(Routes.MY_BOOKINGS);}
  void openSaved() {Get.toNamed(Routes.SAVED);}
  void openAIChatbot() { Get.toNamed(Routes.CHATBOT);}
  void openHistory() { Get.toNamed(Routes.MY_TRIPS);}
  void openLegalInfo() => Get.snackbar('Legal', 'Opening legal information');

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
          Get.offAllNamed(Routes.LOGIN);
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
  void updateUserAddress(String address) => userAddress.value = address;
}