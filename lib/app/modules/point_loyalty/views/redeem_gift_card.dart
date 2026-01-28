import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../controllers/loyalty_program_controller.dart';

class RedeemGiftCardView extends GetView<LoyaltyProgramController> {
  const RedeemGiftCardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFFEDE5A),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                    ),
                    Expanded(
                      child: Text(
                        'Redeem Gift Card',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
            ),
          ),
        ),

      body: SingleChildScrollView(
        child: Column(

          children: [
            const SizedBox(height: 16),
            // Header Section
            Container(
              height: 180,
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage ('assets/images/gift_card.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  const Icon(Icons.card_giftcard, size: 32,color: Colors.white),
                  const SizedBox(height: 12),
                  Text(
                    'Tripbank Giftcards',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'The official gift for travelers',
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Tabs Section
            Container(
              margin: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCardTab('Buy Card', 0, () => Get.toNamed(Routes.buyGiftCard)),
                    const SizedBox(width: 12),
                    _buildCardTab('Send Card', 1, () => Get.toNamed(Routes.sendGiftCard)),
                    const SizedBox(width: 12),
                    _buildCardTab('Redeem', 2, () => Get.toNamed(Routes.redeemGiftCard)),
                    const SizedBox(width: 12),
                    _buildCardTab('My Cards', 3, () => Get.toNamed(Routes.myGiftCards)),
                  ],
                ),
              ),
            ),

            // Redeem Card Section
            Container(
              width: 376,
              height: 170,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF05DF72), Color(0xFF00C950)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/images/download.png'),
                  const SizedBox(height: 16),
                  Text(
                    'Redeem Gift Card',
                    style: GoogleFonts.poppins(
                      color: Color(0xFF3A3A3A),
                      fontSize: 20,
                      fontWeight: FontWeight.w500,

                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter your gift card code below',
                    style: GoogleFonts.poppins(
                        color: Color(0xFF3A3A3A),
                      fontSize: 14,
                        fontWeight: FontWeight.w400
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Gift Card Code Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gift Card Code',
                  style: GoogleFonts.arimo(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF4A5565),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 376,
                  child: TextField(
                    onChanged: (value) => controller.redeemCode.value = value,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                    ),
                    decoration: InputDecoration(
                      hintText: 'TB-2025-XXXXXX',
                      hintStyle: GoogleFonts.inter(
                        color: Colors.grey[400],
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      filled: true,
                      fillColor: Color(0xFFF9FAFB),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xFFE5E7EB), width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xFF10B981), width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

         // Redeem Button
            SizedBox(
              width: 376,
              child: ElevatedButton(
                onPressed: () => controller.redeemGiftCard(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE7BB07),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check, color: Colors.black, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Redeem Now',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // How to Redeem
            Container(
              width: 376,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Color(0xFFFBBF24),
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How to Redeem',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildRedeemStep('Enter your unique gift card code above'),
                  _buildRedeemStep('The balance will be added to your account instantly'),
                  _buildRedeemStep('Use it for flights, hotels, or car rentals'),
                ],
              ),
            ),
            ],
          ),
        ),
      );
  }

  Widget _buildCardTab(String title, int index, VoidCallback onTap) {
    return Obx(() {
      final isSelected = controller.selectedTab.value == index;
      return GestureDetector(
        onTap: () {
          controller.selectedTab.value = index;
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFE7BB07) : Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: isSelected ? null : Border.all(color: Colors.grey[200]!),
          ),
          child: Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? Colors.white : Colors.black87,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildRedeemStep(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFFFBBF24),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

}