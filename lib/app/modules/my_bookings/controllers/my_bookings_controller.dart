import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../models/booking_model.dart';
import '../../../services/storage_service.dart';

class MyBookingsController extends GetxController {
  final RxList<BookingSummary> bookings = <BookingSummary>[].obs;
  final StorageService _storage = Get.find<StorageService>();

  final selectedTab = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadBookings();

    // Add dummy data if storage is empty
    if (bookings.isEmpty) {
      _addDummyData();
      _saveBookings();
    }
  }

  // Load bookings from storage
  void _loadBookings() {
    try {
      final List<dynamic> rawData = _storage.getBookings();

      if (rawData.isNotEmpty) {
        final loadedBookings = rawData.map((e) {
          return BookingSummary.fromJson(Map<String, dynamic>.from(e));
        }).toList();

        bookings.assignAll(loadedBookings);
        debugPrint(" MyBookings: ${bookings.length} items loaded from storage");
      } else {
        debugPrint(" MyBookings: Storage is empty");
      }
    } catch (e) {
      debugPrint(" Error loading bookings: $e");
    }
  }

  // Save bookings to storage
  void _saveBookings() {
    try {
      final dataToSave = bookings.map((b) => b.toJson()).toList();
      _storage.saveBookings(dataToSave);
      debugPrint("Saved ${bookings.length} bookings to storage");
    } catch (e) {
      debugPrint(" Error saving bookings: $e");
    }
  }

  // Add dummy data
  void _addDummyData() {
    bookings.addAll([
      // Today's booking with tag
      BookingSummary(
        bookingId: 'TB-294830',
        type: 'Flight',
        title: 'Dubai Business Trip',
        subtitle: 'Dubai, UAE',
        dates: '12-17 Dec 2025 • 5 days',
        totalAmount: '\$1,250',
        status: 'Confirmed',
        imageUrl: 'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?w=400',
        bookingDate: DateTime.now(),
        ticketData: {
          'services': ['Flight', 'Hotel', 'Tour'],
          'travelers': 2,
          'tag': 'Next Adventure',
        },
      ),

      // Upcoming bookings
      BookingSummary(
        bookingId: 'TB-294831',
        type: 'Hotel',
        title: 'Tokyo Cherry Tour',
        subtitle: 'Tokyo, Japan',
        dates: '5-8 Jan 2026 • 4 days',
        totalAmount: '\$850',
        status: 'Confirmed',
        imageUrl: 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400',
        bookingDate: DateTime.now().subtract(const Duration(days: 5)),
        ticketData: {
          'services': ['Hotel'],
          'travelers': 3,
        },
      ),

      BookingSummary(
        bookingId: 'TB-294832',
        type: 'Car',
        title: 'Airport Pickup Car Rental',
        subtitle: 'New York, USA',
        dates: 'Pickup 17 Dec • 3 days',
        totalAmount: '\$450',
        status: 'Confirmed',
        imageUrl: 'https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?w=400',
        bookingDate: DateTime.now().subtract(const Duration(days: 7)),
        ticketData: {
          'services': ['Car'],
          'travelers': 3,
        },
      ),

      BookingSummary(
        bookingId: 'TB-294833',
        type: 'Tour',
        title: 'Bali Island Adventure',
        subtitle: 'Bali, Indonesia',
        dates: '20-25 Feb 2026 • 6 days',
        totalAmount: '\$1,850',
        status: 'Confirmed',
        imageUrl: 'https://images.unsplash.com/photo-1537996194471-e657df975ab4?w=400',
        bookingDate: DateTime.now().subtract(const Duration(days: 10)),
        ticketData: {
          'services': ['Tour'],
          'travelers': 5,
        },
      ),

      // Canceled booking
      BookingSummary(
        bookingId: 'TB-284920',
        type: 'Flight',
        title: 'Paris Flight Booking',
        subtitle: 'Paris, France',
        dates: '20-25 Nov 2025 • 6 days',
        totalAmount: '\$2,100',
        status: 'Canceled',
        imageUrl: 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=400',
        bookingDate: DateTime.now().subtract(const Duration(days: 75)),
        ticketData: {
          'services': ['Flight'],
          'travelers': 2,
          'canceledOn': '15 Nov 2025',
          'refundAmount': '\$2,100',
        },
      ),
    ]);
  }

  // Add new booking
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

  // Filtered bookings based on tab
  List<BookingSummary> get filteredBookings {
    switch (selectedTab.value) {
      case 0: // All
        return bookings;
      case 1: // Today
        final today = DateTime.now();
        return bookings.where((b) {
          return b.bookingDate.year == today.year &&
              b.bookingDate.month == today.month &&
              b.bookingDate.day == today.day;
        }).toList();
      case 2: // Upcoming
        return bookings.where((b) => b.status == 'Confirmed').toList();
      case 3: // Canceled
        return bookings.where((b) => b.status == 'Canceled').toList();
      default:
        return bookings;
    }
  }

  // Change tab
  void changeTab(int index) => selectedTab.value = index;

  // Get booking by ID
  BookingSummary? getBookingById(String bookingId) {
    return bookings.firstWhereOrNull((b) => b.bookingId == bookingId);
  }

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
        content: const Text('Are you sure you want to cancel this trip?'),
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
        'Your trip has been canceled successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    }
  }

  // Delete booking
  Future<void> deleteBooking(String bookingId) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete Booking'),
        content: const Text('Are you sure you want to delete this booking?'),
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
        'Booking removed successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // View booking details - Navigate to booking details page
  void viewBookingDetails(BookingSummary booking) {
    Get.toNamed('/my-bookings-details', arguments: {'booking': booking});
  }

  // View specific ticket based on service type
  void viewServiceTicket(BookingSummary booking, String serviceType) {
    switch (serviceType) {
      case 'Flight':
        Get.toNamed('/ticket', arguments: {'booking': booking});
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
        Get.snackbar(
          'View Ticket',
          'Opening $serviceType ticket...',
          snackPosition: SnackPosition.BOTTOM,
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

  // Get total spending
  double get totalSpending {
    return bookings.fold(0.0, (sum, booking) {
      final amount = double.tryParse(
          booking.totalAmount.replaceAll(RegExp(r'[^\d.]'), '')
      ) ?? 0;
      return sum + amount;
    });
  }

  // Get confirmed bookings count
  int get confirmedCount => bookings.where((b) => b.status == 'Confirmed').length;

  // Get canceled bookings count
  int get canceledCount => bookings.where((b) => b.status == 'Canceled').length;
}