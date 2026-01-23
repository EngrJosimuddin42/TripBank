import 'package:flutter/material.dart';
import 'app_strings.dart';

class AppConfig {
  // Price Range
  static const double minPrice = 0;
  static const double maxPrice = 5000;
  static const int priceDivisions = 50;

  // Travel Time
  static const double minTravelTime = 0;
  static const double maxTravelTime = 30;
  static const int travelTimeDivisions = 30;

  // Airlines List
  static List<String> get defaultAirlines => [
    'All',
    'British Air Lines',
    'Fly Emirates',
    'Camair co',
    'Asky Airlines',
  ];

  // Stops Options
  static List<String> get stopsOptions => ['0', '1', '2+'];

  // Time Slots
  static List<Map<String, dynamic>> get timeSlots => [
    {
      'time': '00:00 - 05:59',
      'label': AppStrings.earlyMorning,
      'icon': Icons.nightlight,
      'startHour': 0,
      'endHour': 5,
    },
    {
      'time': '06:00 - 11:59',
      'label': AppStrings.morning,
      'icon': Icons.wb_sunny,
      'startHour': 6,
      'endHour': 11,
    },
    {
      'time': '12:00 - 17:59',
      'label': AppStrings.afternoon,
      'icon': Icons.wb_sunny_outlined,
      'startHour': 12,
      'endHour': 17,
    },
    {
      'time': '18:00 - 23:59',
      'label': AppStrings.evening,
      'icon': Icons.nights_stay,
      'startHour': 18,
      'endHour': 23,
    },
  ];

  // Flight Classes
  static List<Map<String, dynamic>> get flightClasses => [
    {'name': 'Economy', 'count': 35, 'basePrice': 320.0},
    {'name': 'Premium economy', 'count': 6, 'basePrice': 4325.0},
    {'name': 'Business class', 'count': 17, 'basePrice': 5027.0},
    {'name': 'First class', 'count': 0, 'basePrice': 5027.0},
  ];

  // Facilities
  static List<Map<String, dynamic>> get facilities => [
    {'name': 'Seat choice included', 'price': 2358.0},
    {'name': 'Hand baggage included', 'price': 3208.0},
    {'name': 'No cancel fee', 'price': 3654.0},
    {'name': 'Cancel fee', 'price': 3654.0},
  ];
}