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
  // Reactive variables — API থেকে আপডেট হবে
  final userName = 'Loading...'.obs;
  final userType = 'User'.obs;
  final userAddress = 'Fetching location...'.obs;
  final rewardPoints = '0 Points'.obs;
  final profileImageUrl = ''.obs;
  final isLoading = true.obs;

// Dynamic Reward Badges — API থেকে আসবে
  final rewardBadges = <RewardBadge>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  // এটা রিয়েল API কল হবে
  Future<void> fetchUserProfile() async {
    try {
      isLoading.value = true;

      // ------------------ TEMPORARY DEMO DATA  ------------------
      await Future.delayed(const Duration(seconds: 1));

      userName.value = 'Josimuddin';
      userType.value = 'Premium User';
      userAddress.value = 'Address: Aqua Tower\n43 Mohakhali C/A,Dhaka 1212';
      rewardPoints.value = '15,216 Points';
      profileImageUrl.value = 'https://via.placeholder.com/150';

// ---------- Dynamic Badges (এখানে API থেকে আসবে) ----------
      rewardBadges.assignAll([
        RewardBadge(
          label: 'Gold',
          color: const Color(0xFFFFD700),
          icon: Image.asset('assets/images/gold.png', width: 24, height: 24,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.monetization_on, size: 24, color: Color(0xFFFFD700));
            },
          ),
        ),
        RewardBadge(
          label: 'Platinum',
          color: const Color(0xFF00BCD4),
          icon: Image.asset('assets/images/platinum.png', width: 24, height: 24,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.star, size: 24, color: Color(0xFF00BCD4));
            },
          ),
        ),
        RewardBadge(
          label: 'Diamond',
          color: const Color(0xFF2196F3),
          icon: Image.asset('assets/images/diamond.png', width: 24, height: 24,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.diamond, size: 24, color: Color(0xFF2196F3));
            },
          ),
        ),
      ]);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load profile. Please try again.');
      userName.value = 'Guest User';
      profileImageUrl.value = '';
    } finally {
      isLoading.value = false;
    }
  }


// Helper methods for color & icon (যদি API শুধু label পাঠায়)
  Color _getColorForLabel(String label) {
    switch (label) {
      case 'Gold':
        return const Color(0xFFFFD700);
      case 'Platinum':
        return const Color(0xFF00BCD4);
      case 'Diamond':
        return const Color(0xFF2196F3);
      default:
        return Colors.grey;
    }
  }

  IconData _getIconForLabel(String label) {
    switch (label) {
      case 'Gold':
        return Icons.monetization_on;
      case 'Platinum':
        return Icons.center_focus_strong;
      case 'Diamond':
        return Icons.diamond;
      default:
        return Icons.auto_awesome;
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

                Get.back(); // ডায়ালগ বন্ধ
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
    MenuItem(icon:Image.asset('assets/images/search.png'),label: 'Track My Bookings', color: Color(0xFFFECD08), onTap: trackBookings),
    MenuItem(icon: Image.asset('assets/images/favorite.png'), label: 'Saved', color: Color(0xFFFECD08), onTap: openSaved),
    MenuItem(icon: Image.asset('assets/images/chat_bot.png'), label: 'AI Chatbot', color: Color(0xFFFECD08), onTap: openAIChatbot),
    MenuItem(icon:Image.asset('assets/images/history.png'), label: 'My History', color: Color(0xFFFECD08), onTap: openHistory),
    MenuItem(icon: Image.asset('assets/images/info.png'), label: 'Legal Info', color: Color(0xFFFECD08), onTap: openLegalInfo),
  ];
// বাকি মেথডগুলো
  void trackBookings() => Get.snackbar('Track Bookings', 'Opening bookings');
  void openSaved() {Get.toNamed(Routes.SAVED);}
  void openAIChatbot() {Get.toNamed(Routes.CHATBOT);}
  void openHistory() => Get.snackbar('History', 'Opening history');
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
  void updateProfileImage(String url) => profileImageUrl.value = url;
}