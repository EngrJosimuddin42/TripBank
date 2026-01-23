import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../models/booking_model.dart';
import '../../../services/storage_service.dart';

class MyBookingsController extends GetxController {
  final RxList<BookingSummary> bookings = <BookingSummary>[].obs;
  final StorageService _storage = Get.find<StorageService>();

  final selectedFilter = 'All'.obs;
  final filterOptions = ['All', 'Flight', 'Hotel', 'Car', 'Bus'].obs;

  final selectedStatus = 'All'.obs;
  final statusOptions = ['All', 'Confirmed', 'Canceled', 'Completed', 'Pending'].obs;

  @override
  void onInit() {
    super.onInit();
    _loadBookings();

    // ✅ FIX: Add dummy data if storage is empty AND save it
    if (bookings.isEmpty) {
      _addDummyData();
      _saveBookings();
    }
  }

  // স্টোরেজ থেকে ডাটা লোড করার আসল মেথড
  void _loadBookings() {
    try {
      final List<dynamic> rawData = _storage.getBookings();

      if (rawData.isNotEmpty) {
        final loadedBookings = rawData.map((e) {
          return BookingSummary.fromJson(Map<String, dynamic>.from(e));
        }).toList();

        bookings.assignAll(loadedBookings);
        debugPrint("✅ MyBookings: ${bookings.length} items loaded from storage");
      } else {
        debugPrint("⚠️ MyBookings: Storage is empty");
      }
    } catch (e) {
      debugPrint("❌ Error loading bookings: $e");
    }
  }

  // ডাটা সেভ করার মেথড
  void _saveBookings() {
    try {
      final dataToSave = bookings.map((b) => b.toJson()).toList();
      _storage.saveBookings(dataToSave);
      debugPrint("💾 Saved ${bookings.length} bookings to storage");
    } catch (e) {
      debugPrint("❌ Error saving bookings: $e");
    }
  }

  // নতুন বুকিং যোগ করা
  void addBooking(BookingSummary booking) {
    bookings.insert(0, booking);
    _saveBookings();
    bookings.refresh();

    Get.snackbar(
      'Booking Saved',
      '${booking.type} booking saved successfully',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // ফিল্টার করা লিস্ট যেটা View-তে ব্যবহার করবেন
  List<BookingSummary> get filteredBookings {
    return bookings.where((b) {
      bool typeMatch = selectedFilter.value == 'All' || b.type == selectedFilter.value;
      bool statusMatch = selectedStatus.value == 'All' || b.status == selectedStatus.value;
      return typeMatch && statusMatch;
    }).toList();
  }

  void _addDummyData() {
    final dummy = BookingSummary(
      type: 'Hotel',
      title: 'Grand Palace Resort',
      subtitle: 'Cox\'s Bazar, Bangladesh',
      dates: '20-22 Jan 2026',
      imageUrl: 'https://placehold.jp/300x200.png',
      bookingId: 'BK12345678',
      status: 'Confirmed',
      totalAmount: '\$250',
      ticketData: {},
    );
    bookings.add(dummy);
    debugPrint("➕ Added dummy booking");
  }

  // Get booking by ID
  BookingSummary? getBookingById(String bookingId) {
    return bookings.firstWhereOrNull((b) => b.bookingId == bookingId);
  }

  // Get bookings by type
  List<BookingSummary> getBookingsByType(String type) {
    return bookings.where((b) => b.type == type).toList();
  }

  // Get confirmed bookings count
  int get confirmedCount => bookings.where((b) => b.status == 'Confirmed').length;

  // Get canceled bookings count
  int get canceledCount => bookings.where((b) => b.status == 'Canceled').length;

  // Cancel booking
  Future<void> cancelBooking(String bookingId) async {
    final index = bookings.indexWhere((b) => b.bookingId == bookingId);
    if (index == -1) {
      Get.snackbar('Error', 'Booking not found');
      return;
    }

    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Cancel Booking'),
        content: Text('Are you sure you want to cancel booking #${bookingId.substring(bookingId.length - 8)}?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      bookings[index].status = 'Canceled';
      bookings.refresh();
      _saveBookings();

      Get.snackbar(
        'Booking Canceled',
        'Your booking has been canceled successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    }
  }

  // Download ticket
  Future<void> downloadTicket(String bookingId) async {
    final booking = getBookingById(bookingId);
    if (booking == null) {
      Get.snackbar('Error', 'Booking not found');
      return;
    }

    Get.snackbar(
      'Downloading',
      'Your ${booking.type} ticket is being downloaded...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green[100],
      colorText: Colors.green[900],
      duration: const Duration(seconds: 2),
    );

    await Future.delayed(const Duration(seconds: 1));

    Get.snackbar(
      'Download Complete',
      'Ticket saved to Downloads',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green[100],
      colorText: Colors.green[900],
    );
  }

  // View ticket details
  void viewTicketDetails(String bookingId) {
    final booking = getBookingById(bookingId);
    if (booking == null) {
      Get.snackbar('Error', 'Booking not found');
      return;
    }

    switch (booking.type) {
      case 'Flight':
        Get.toNamed('/flight-ticket', arguments: {'booking': booking});
        break;
      case 'Hotel':
        Get.toNamed('/hotel-ticket', arguments: {'booking': booking});
        break;
      case 'Car':
        Get.toNamed('/car-ticket', arguments: {'booking': booking});
        break;
      case 'Tour':
        Get.toNamed('/tour-ticket', arguments: {'booking': booking});
        break;
      default:
        Get.snackbar('Error', 'Unknown booking type');
    }
  }

  // Share ticket
  Future<void> shareTicket(String bookingId) async {
    final booking = getBookingById(bookingId);
    if (booking == null) {
      Get.snackbar('Error', 'Booking not found');
      return;
    }

    Get.snackbar(
      'Share Ticket',
      'Sharing ${booking.type} ticket...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Delete booking from history
  Future<void> deleteBooking(String bookingId) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete Booking'),
        content: const Text('Are you sure you want to delete this booking from history?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Yes, Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      bookings.removeWhere((b) => b.bookingId == bookingId);
      _saveBookings();

      Get.snackbar(
        'Deleted',
        'Booking removed from history',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Update type filter
  void updateFilter(String filter) {
    selectedFilter.value = filter;
  }

  // Update status filter
  void updateStatusFilter(String status) {
    selectedStatus.value = status;
  }

  // Sort by date (newest first)
  void sortByDateNewest() {
    bookings.sort((a, b) => b.bookingDate.compareTo(a.bookingDate));
    bookings.refresh();
  }

  // Sort by date (oldest first)
  void sortByDateOldest() {
    bookings.sort((a, b) => a.bookingDate.compareTo(b.bookingDate));
    bookings.refresh();
  }

  // Sort by amount (highest first)
  void sortByAmountHighest() {
    bookings.sort((a, b) {
      final amountA = double.tryParse(a.totalAmount.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
      final amountB = double.tryParse(b.totalAmount.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
      return amountB.compareTo(amountA);
    });
    bookings.refresh();
  }

  // Clear all bookings
  Future<void> clearAllBookings() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Clear All Bookings'),
        content: const Text('Are you sure you want to clear all booking history?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      bookings.clear();
      _saveBookings();

      Get.snackbar(
        'Cleared',
        'All bookings have been cleared',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Get total spending
  double get totalSpending {
    return bookings.fold(0.0, (sum, booking) {
      final amount = double.tryParse(
          booking.totalAmount.replaceAll(RegExp(r'[^\d.]'), '')
      ) ?? 0;
      return sum + amount;
    });
  }

  // Get spending by type
  Map<String, double> get spendingByType {
    final Map<String, double> spending = {};

    for (var booking in bookings) {
      final amount = double.tryParse(
          booking.totalAmount.replaceAll(RegExp(r'[^\d.]'), '')
      ) ?? 0;

      spending[booking.type] = (spending[booking.type] ?? 0) + amount;
    }

    return spending;
  }

  // Get bookings count by type
  Map<String, int> get bookingsCountByType {
    final Map<String, int> counts = {};

    for (var booking in bookings) {
      counts[booking.type] = (counts[booking.type] ?? 0) + 1;
    }

    return counts;
  }
}