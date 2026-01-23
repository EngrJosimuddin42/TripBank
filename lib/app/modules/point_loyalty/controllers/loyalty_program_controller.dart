import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'dart:math';

class LoyaltyProgramController extends GetxController {

  var selectedTab = 0.obs;

  // Member Stats
  final memberTier = 'Platinum'.obs;
  final totalPoints = 15216.obs;
  final cashbackPercentage = 84.obs;
  final daysActive = 24.obs;
  final totalCoupons = 12.obs;

  // Platinum Card Specific
  final memberSince = 'December 2024'.obs;
  final nextTier = 'Diamond'.obs;
  final progressPercentage = 84.obs;
  final pointsNeeded = 2784.obs;
  final targetDate = 'March 2025'.obs;

  // BuyGiftCardView local state
  final selectedAmount = Rx<int?>(null);
  final useBonusPoints = false.obs;

  // Gift Cards
  final totalGiftCardBalance = 225.0.obs;
  final activeCardsCount = 2.obs;
  final giftCards = <GiftCard>[].obs;
  final recentlySentCards = <SentCard>[].obs;

  // Referrals
  final totalReferrals = 12.obs;
  final pointsEarned = 12000.obs;
  final successRate = 75.obs;
  final referralCode = 'd1yaa2025'.obs;
  final referralLink = 'https://travelbook.com/join/d1yaa2025'.obs;
  final pastReferrals = <Referral>[].obs;

  // Gift Card Form Data
  final recipientName = ''.obs;
  final recipientEmail = ''.obs;
  final giftAmount = 0.0.obs;
  final personalMessage = ''.obs;
  final deliveryDate = Rx<DateTime?>(null);

  // Redeem
  final redeemCode = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadMockData();
    fetchMembershipData();
  }

  final customAmountController = TextEditingController();

  void selectPresetAmount(int amount) {
    selectedAmount.value = amount;
    customAmountController.clear();
  }
  void proceedToCheckout() {
    double finalAmount = 0;

    if (customAmountController.text.isNotEmpty) {
      finalAmount = double.tryParse(customAmountController.text) ?? 0;
    } else if (selectedAmount.value != null) {
      finalAmount = selectedAmount.value!.toDouble();
    }

    if (finalAmount <= 0) {
      Get.snackbar('Error', 'Please select or enter an amount');
      return;
    }

    // Navigate to payment or confirmation
    print('Proceeding with amount: $finalAmount');
  }

  void _loadMockData() {

    // Load Gift Cards
    giftCards.assignAll([
      GiftCard(
        id: '1',
        title: 'Travel Dreams',
        balance: 150.0,
        code: 'TB-2025-ABC123',
        from: 'John Smith',
        expiryDate: DateTime(2026, 12, 31),
        color: '0xFF2196F3',
      ),
      GiftCard(
        id: '2',
        title: 'Adventure Awaits',
        balance: 75.0,
        code: 'TB-2025-XYZ789',
        from: 'Self Purchase',
        expiryDate: DateTime(2026, 6, 30),
        color: '0xFFFF9800',
      ),
    ]);

    // Load Recently Sent Cards
    recentlySentCards.assignAll([
      SentCard(
        name: 'Sarah Johnson',
        email: 'sarah@example.com',
        amount: 100.0,
        date: DateTime(2025, 12, 30),
        status: 'Completed',
      ),
      SentCard(
        name: 'Mike Davis',
        email: 'mike@example.com',
        amount: 50.0,
        date: DateTime(2025, 11, 22),
        status: 'Pending',
      ),
    ]);

    // Load Past Referrals
    pastReferrals.assignAll([
      Referral(
        name: 'Emma Wilson',
        email: 'emma@example.com',
        date: DateTime(2025, 11, 20),
        bookings: 3,
        points: 1000,
        isCompleted: true,
      ),
      Referral(
        name: 'James Brown',
        email: 'james@example.com',
        date: DateTime(2025, 11, 18),
        bookings: 2,
        points: 1000,
        isCompleted: true,
      ),
      Referral(
        name: 'Lisa Chen',
        email: 'lisa@example.com',
        date: DateTime(2025, 11, 25),
        bookings: 0,
        points: 0,
        isCompleted: false,
      ),
      Referral(
        name: 'Robert Taylor',
        email: 'robert@example.com',
        date: DateTime(2025, 11, 15),
        bookings: 5,
        points: 1000,
        isCompleted: true,
      ),
    ]);

    // Update totals based on mock data
    totalGiftCardBalance.value = giftCards.fold(0.0, (sum, card) => sum + card.balance);
    activeCardsCount.value = giftCards.length;
    totalReferrals.value = pastReferrals.length;
    pointsEarned.value = pastReferrals.fold(0, (sum, ref) => sum + ref.points);
    successRate.value = pastReferrals.isEmpty
        ? 0
        : (pastReferrals.where((r) => r.isCompleted).length * 100 ~/ pastReferrals.length);
  }

  // Real API call
  Future<void> fetchMembershipData() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      print(' Membership data refreshed');
    } catch (e) {
      print(' Error fetching membership data: $e');
      Get.snackbar(
        'Error',
        'Failed to load membership data',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> sendGiftCard() async {
    if (recipientName.value.isEmpty || recipientEmail.value.isEmpty || giftAmount.value <= 0) {
      Get.snackbar('Error', 'Please fill all required fields');
      return;
    }

    await Future.delayed(const Duration(seconds: 1));

    final sentCard = SentCard(
      name: recipientName.value,
      email: recipientEmail.value,
      amount: giftAmount.value,
      date: deliveryDate.value ?? DateTime.now(),
      status: 'Pending',
    );

    recentlySentCards.insert(0, sentCard);

    Get.snackbar(
      'Success',
      'Gift card sent successfully!',
      backgroundColor: Get.theme.colorScheme.primary,
      colorText: Get.theme.colorScheme.onPrimary,
    );

    _clearSendForm();
  }

  void _clearSendForm() {
    recipientName.value = '';
    recipientEmail.value = '';
    giftAmount.value = 0.0;
    personalMessage.value = '';
    deliveryDate.value = null;
  }

  Future<void> redeemGiftCard() async {
    if (redeemCode.value.isEmpty) {
      Get.snackbar('Error', 'Please enter gift card code');
      return;
    }

    await Future.delayed(const Duration(seconds: 1));

    final random = Random();
    final amount = (random.nextInt(100) + 25).toDouble();

    totalGiftCardBalance.value += amount;
    activeCardsCount.value++;


    Get.snackbar(
      'Success',
      '\$$amount added to your balance!',
      backgroundColor: Get.theme.colorScheme.primary,
      colorText: Get.theme.colorScheme.onPrimary,
    );

    redeemCode.value = '';
  }

  void copyReferralCode() {
    Get.snackbar('Copied', 'Referral code copied to clipboard', duration: const Duration(seconds: 2));
  }

  void copyReferralLink() {
    Get.snackbar('Copied', 'Referral link copied to clipboard', duration: const Duration(seconds: 2));
  }

  void shareReferralCode() {

    Get.snackbar('Share', 'Opening share dialog...');
  }

  @override
  void onClose() {
    super.onClose();
  }
}

// Models remain unchanged
class GiftCard {
  final String id;
  final String title;
  final double balance;
  final String code;
  final String from;
  final DateTime expiryDate;
  final String color;

  GiftCard({
    required this.id,
    required this.title,
    required this.balance,
    required this.code,
    required this.from,
    required this.expiryDate,
    required this.color,
  });
}

class SentCard {
  final String name;
  final String email;
  final double amount;
  final DateTime date;
  final String status;

  SentCard({
    required this.name,
    required this.email,
    required this.amount,
    required this.date,
    required this.status,
  });
}

class Referral {
  final String name;
  final String email;
  final DateTime date;
  final int bookings;
  final int points;
  final bool isCompleted;

  Referral({
    required this.name,
    required this.email,
    required this.date,
    required this.bookings,
    required this.points,
    required this.isCompleted,
  });
}