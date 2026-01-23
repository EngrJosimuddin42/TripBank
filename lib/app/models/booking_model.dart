class BookingSummary {
  final String type;
  final String title;
  final String subtitle;
  final String dates;
  final String imageUrl;
  final String bookingId;
  String status;
  final String totalAmount;
  final Map<String, dynamic> ticketData;
  final DateTime bookingDate;

  BookingSummary({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.dates,
    required this.imageUrl,
    required this.bookingId,
    required this.status,
    required this.totalAmount,
    required this.ticketData,
    DateTime? bookingDate,
  }) : bookingDate = bookingDate ?? DateTime.now();

  // Convert to JSON for storage

  Map<String, dynamic> toJson() => {
    'type': type,
    'title': title,
    'subtitle': subtitle,
    'dates': dates,
    'imageUrl': imageUrl,
    'bookingId': bookingId,
    'status': status,
    'totalAmount': totalAmount,
    'ticketData': ticketData,
    'bookingDate': bookingDate.toIso8601String(),
  };

  // Create from JSON

  factory BookingSummary.fromJson(Map<String, dynamic> json) => BookingSummary(
    type: json['type'] ?? '',
    title: json['title'] ?? '',
    subtitle: json['subtitle'] ?? '',
    dates: json['dates'] ?? '',
    imageUrl: json['imageUrl'] ?? '',
    bookingId: json['bookingId'] ?? '',
    status: json['status'] ?? 'Confirmed',
    totalAmount: json['totalAmount'] ?? '\$0',
    ticketData: json['ticketData'] ?? {},
    bookingDate: json['bookingDate'] != null
        ? DateTime.parse(json['bookingDate'])
        : DateTime.now(),
  );
}
