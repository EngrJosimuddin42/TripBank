import 'package:flutter/material.dart' hide DrawerController;
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../controllers/drawer_controller.dart';
import 'package:flutter/services.dart';

class DrawerView extends GetView<DrawerController> {
  const DrawerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // স্ট্যাটাস বার হলুদ করো
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xFFFEDE5A),
      statusBarIconBrightness: Brightness.dark,
    ));

    return Container(
      color: const Color(0xFFFFFAE6),
      child: SafeArea(
        top: false,  // স্ট্যাটাস বারের উপর দিয়ে হেডার যাবে
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(24, 30, 24, 10),
                color: const Color(0xFFFEDE5A),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.black,
                        size: 28,
                      ),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ],
                ),
              ),

              // প্রোফাইল ইনফো (প্রিমিয়াম + অ্যাড্রেস)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 34),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => Text(
                      controller.userName.value,
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    )),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/premium quality.png',
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(width: 8),
                        Obx(() => Text(
                          controller.userType.value,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF9D9D9D),
                          ),
                        )),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Obx(() => Text(
                      controller.userAddress.value,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2A2A2A),
                      ),
                    )),
                  ],
                ),
              ),

              _buildEditProfileButton(),
              const SizedBox(height: 10),
              _buildMenuList(),
              const SizedBox(height: 150),
              _buildLogoutButton(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => Text(
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
              mainAxisAlignment: MainAxisAlignment.start,
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
          Obx(() => Text(
            controller.userAddress.value,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2A2A2A),
            ),
          ),
          ),
        ],
      ),
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
              const SizedBox(width: 120),
              Icon(Icons.arrow_forward_ios, size: 20,  color: Color(0xFF2A2A2A)),
            ],
          ),
        ),
      ),
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