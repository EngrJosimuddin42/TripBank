import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/custom_date_picker.dart';
import '../controllers/loyalty_program_controller.dart';

class SendGiftCardView extends GetView<LoyaltyProgramController> {
  const SendGiftCardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
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
                      'Send Gift card',
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
                  image: AssetImage('assets/images/gift_card.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                      Icons.card_giftcard, size: 32, color: Colors.white),
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
                    _buildCardTab(
                        'Buy Card', 0, () => Get.toNamed(Routes.BUY_GIFT_CARD)),
                    const SizedBox(width: 12),
                    _buildCardTab('Send Card', 1, () =>
                        Get.toNamed(Routes.SEND_GIFT_CARD)),
                    const SizedBox(width: 12),
                    _buildCardTab('Redeem', 2, () =>
                        Get.toNamed(Routes.REDEEM_GIFT_CARD)),
                    const SizedBox(width: 12),
                    _buildCardTab(
                        'My Cards', 3, () => Get.toNamed(Routes.MY_GIFT_CARDS)),
                  ],
                ),
              ),
            ),


            // Send a Gift Card Section
            Container(
              height: 150,
              width: 374,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFA855F7), Color(0xFF9333EA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/images/icon_2.png'),
                  const SizedBox(height: 12),
                  Text(
                    'Send a Gift Card',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Make someone\'s day with travel credits',
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),


            // Form
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recipient Name',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    onChanged: (value) =>
                    controller.recipientName.value = value,
                    decoration: InputDecoration(
                      hintText: 'Enter name',
                      hintStyle: GoogleFonts.inter(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                      filled: true,
                      fillColor: Color(0xFFF9FAFB),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xFFE5E7EB),
                            width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xFFFECD08),
                            width: 2),
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    'Recipient Email',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    onChanged: (value) =>
                    controller.recipientEmail.value = value,
                    decoration: InputDecoration(
                      hintText: 'Enter email address',
                      hintStyle: GoogleFonts.inter(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                      filled: true,
                      fillColor: Color(0xFFF9FAFB),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xFFE5E7EB),
                            width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xFFFECD08),
                            width: 2),
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),

                  Text(
                    'Amount',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    onChanged: (value) =>
                    controller.giftAmount.value = double.tryParse(value) ?? 0,
                    decoration: InputDecoration(
                      hintText: '\$ 25',
                      hintStyle: GoogleFonts.inter(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                      filled: true,
                      fillColor: Color(0xFFF9FAFB),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xFFE5E7EB),
                            width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xFFFECD08),
                            width: 2),
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),

                  Text(
                    'Personal Message',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    onChanged: (value) =>
                    controller.personalMessage.value = value,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Write a personal message...',
                      hintStyle: GoogleFonts.inter(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                      filled: true,
                      fillColor: Color(0xFFF9FAFB),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xFFE5E7EB),
                            width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xFFFECD08),
                            width: 2),
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    'Delivery Date',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(() => TextField(
                    controller: TextEditingController(
                      text: controller.deliveryDate.value != null
                          ? '${controller.deliveryDate.value!.day.toString().padLeft(2, '0')}/${controller.deliveryDate.value!.month.toString().padLeft(2, '0')}/${controller.deliveryDate.value!.year}'
                          : '',
                    ),
                    decoration: InputDecoration(
                      hintText: 'dd/mm/yyyy',
                      hintStyle: GoogleFonts.inter(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                      filled: true,
                      fillColor: Color(0xFFF9FAFB),
                      suffixIcon: Icon(Icons.calendar_today, size: 20, color: Colors.grey[600]),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xFFE5E7EB), width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xFFFECD08), width: 2),
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                    readOnly: true,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => CustomDatePicker(
                          initialDate: controller.deliveryDate.value ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                          onDateSelected: (selectedDate) {
                            controller.deliveryDate.value = selectedDate;
                          },
                        ),
                      );
                    },
                  )),

                ],
              ),
            ),
            const SizedBox(height: 24),

            // Send Gift Card Button
            SizedBox(
              width: 374,
              child: ElevatedButton(
                onPressed: () => controller.sendGiftCard(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE7BB07),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.send, color: Colors.black, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Send Gift Card',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Recently Sent
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Recently Sent',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            Obx(() => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: controller.recentlySentCards.map((card) {
                  return _buildRecentItem(
                    card.name,
                    card.email,
                    '\$${card.amount.toStringAsFixed(0)}',
                    '${card.date.year}-${card.date.month.toString().padLeft(2, '0')}-${card.date.day.toString().padLeft(2, '0')}',
                    card.status,
                    card.status == 'Completed' ? const Color(0xFF10B981) : const Color(0xFFFBBF24),
                  );
                }).toList(),
              ),
            )),

            const SizedBox(height: 32),
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

  Widget _buildRecentItem(String name, String email, String amount, String date, String status, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name and Status Badge Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Email
          Text(
            email,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 10),

          // Amount and Date Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                amount,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                date,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}