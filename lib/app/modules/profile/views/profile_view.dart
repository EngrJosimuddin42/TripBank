import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../routes/app_pages.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDFDFD),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 74),
            _buildProfileHeader(),
            const SizedBox(height: 20),
            _buildEditProfileButton(),
            const SizedBox(height: 20),
            _buildRewardsCard(),
            const SizedBox(height: 20),
            _buildMenuList(),
            const SizedBox(height: 20),
            _buildLogoutButton(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 108,
              height: 108,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey[300]!, width: 2),
              ),
              child: ClipOval(
                child: Obx(() {
                  final imageUrl = controller.profileImageUrl.value;

                  if (imageUrl.isEmpty) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.person,
                        size: 54,
                        color: Colors.grey,
                      ),
                    );
                  }
                  return Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey[300],
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                                : null,
                            color: Color(0xFFFFC107),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.person,
                          size: 54,
                          color: Colors.grey,
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Color(0xFFFECD08),
                  shape: BoxShape.circle,
                ),
                child: Image.asset('assets/images/edit.png',color: Color(0xFF3A3A3A))
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(
              () => Text(
            controller.userName.value,
            style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black
            ),
          ),
        ),
        const SizedBox(height: 4),
        Obx(
              () =>Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/premium quality.png',
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 4),
              Text(
                controller.userType.value,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF9D9D9D),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Obx(
              () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/location_p.png',
                width: 16,
                height: 16,
                color: const Color(0xFF141B34),
              ),
              const SizedBox(width: 4),
              Text(
                controller.userAddress.value,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2A2A2A),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEditProfileButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 6),
      child: InkWell(
        onTap: controller.editProfile,
        borderRadius: BorderRadius.circular(10),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                SizedBox(
                  width: 30,
                  height: 30,
                  child: Center(
                    child: Image.asset(
                      'assets/images/edit.png',
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                const Text(
                  'Edit profile',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 185),
                Icon(Icons.arrow_forward_ios, size: 20,  color: Color(0xFF2A2A2A)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRewardsCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: () {
          Get.toNamed(Routes.LOYALTY_PROGRAM);
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color:const Color(0xFFFFFAE6),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFFECD08)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'TripBank Rewards',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF3A3A3A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Obx(() => Row(
                      children: [
                        const Icon(Icons.star, size: 20, color: Color(0xFFFECD08)),
                        const SizedBox(width: 6),
                        Text(
                          controller.rewardPoints.value,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF3A3A3A),
                          ),
                        ),
                      ],
                    )),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.LOYALTY_PROGRAM);
                      },
                      child:Text(
                        'Details',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: Color(0xFFB49206),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Obx(() => Row(
                children: controller.rewardBadges
                    .map((badge) => _buildRewardBadge(badge.label, badge.color, badge.icon ))
                    .toList(),
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRewardBadge(String label, Color color, Widget icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: icon,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: Color(0xFF818898),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildMenuList() {
    return Column(
      children: controller.menuItems
          .map((item) => _buildMenuItem(
        icon: item.icon,
        label: item.label,
        color: item.color,
        onTap: item.onTap,
      ))
          .toList(),
    );
  }

  Widget _buildMenuItem({
    required Widget icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                SizedBox(
                  width: 30,
                  height: 30,
                  child: Center(
                      child: icon
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2A2A2A),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Icon(Icons.arrow_forward_ios, size: 20,  color: Color(0xFF2A2A2A)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: controller.logout,
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFEAEA),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFFF9696)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.logout,
                  size: 20,
                  color: Color(0xFFEB212B),
                ),
              ),
              const SizedBox(width: 14),
              Text(
                'Log Out',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2A2A2A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}