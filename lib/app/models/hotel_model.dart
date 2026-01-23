import 'package:flutter/material.dart';

class Hotel {
  final String id;
  final String name;
  final String? subtitle;
  final String image;
  final List<String> images;
  final double rating;
  final int reviews;
  final String location;
  final String description;
  final String address;
  final double price;
  bool isFavorite;
  final double? originalPrice;
  final int nights;
  final int discount;
  final List<String> highlights;
  final List<Service> services;
  final List<RoomDetail> roomDetails;

  Hotel({
    required this.id,
    required this.name,
    this.subtitle,
    required this.image,
    required this.images,
    required this.rating,
    required this.location,
    required this.reviews,
    required this.description,
    required this.address,
    required this.price,
    this.isFavorite = false,
    this.originalPrice,
    this.nights = 1,
    this.discount = 0,
    this.highlights = const [],
    this.services = const [],
    this.roomDetails = const [],
  });

  // From JSON (For Real API)

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      subtitle: json['subtitle']?.toString(),
      image: json['image']?.toString() ?? '',
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      rating: _toDouble(json['rating']) ?? 0.0,
      reviews: _toInt(json['reviews']) ?? 0,
      description: json['description']?.toString() ?? '',
      location: json['location']?.toString() ?? json['address']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      price: _toDouble(json['price']) ?? 0.0,
      originalPrice: json['originalPrice'] != null
          ? _toDouble(json['originalPrice'])
          : null,
      nights: _toInt(json['nights']) ?? 1,
      discount: _toInt(json['discount']) ?? 0,
      highlights: (json['highlights'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      services: ((json['Services'] ?? json['services']) as List<dynamic>?)
          ?.map((e) => Service.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      roomDetails: (json['roomDetails'] as List<dynamic>?)
          ?.map((e) => RoomDetail.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  // To JSON (For Send to API)

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subtitle': subtitle,
      'location': location,
      'image': image,
      'images': images,
      'rating': rating,
      'reviews': reviews,
      'description': description,
      'address': address,
      'price': price,
      'originalPrice': originalPrice,
      'nights': nights,
      'discount': discount,
      'highlights': highlights,
      'Services': services.map((e) => e.toJson()).toList(),
      'roomDetails': roomDetails.map((e) => e.toJson()).toList(),
    };
  }

  // Helper methods

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      final cleaned = value.replaceAll(RegExp(r'[^0-9.]'), '');
      return double.tryParse(cleaned);
    }
    return null;
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
      return int.tryParse(cleaned);
    }
    return null;
  }

  // Helper getters

  String get ratingText {
    if (rating >= 4.8) return 'Excellent';
    if (rating >= 4.0) return 'Very Good';
    return 'Good';
  }

  String get formattedPrice => '\$${price.toStringAsFixed(0)}';
  String get discountText => discount > 0 ? '$discount%' : '';
  double get discountedPrice => originalPrice ?? price * (1 - discount / 100);
}

class Service {
  final String name;
  final IconData icon;

  Service({
    required this.name,
    required this.icon,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      name: json['name'] as String? ?? '',
      icon: Service.iconFromString(json['icon'] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'icon': Service.iconToString(icon),
    };
  }

  static IconData iconFromString(String? iconName) {
    switch (iconName) {
      case 'ac_unit': return Icons.ac_unit;
      case 'business': return Icons.business;
      case 'dry_cleaning': return Icons.dry_cleaning;
      case 'iron': return Icons.iron;
      case 'local_cafe': return Icons.local_cafe;
      case 'wifi': return Icons.wifi;
      case 'pool': return Icons.pool;
      case 'spa': return Icons.spa;
      case 'restaurant': return Icons.restaurant;
      default: return Icons.check_circle;
    }
  }

  static String iconToString(IconData icon) {
    if (icon == Icons.ac_unit) return 'ac_unit';
    if (icon == Icons.business) return 'business';
    if (icon == Icons.dry_cleaning) return 'dry_cleaning';
    if (icon == Icons.iron) return 'iron';
    if (icon == Icons.local_cafe) return 'local_cafe';
    if (icon == Icons.wifi) return 'wifi';
    if (icon == Icons.pool) return 'pool';
    if (icon == Icons.spa) return 'spa';
    if (icon == Icons.restaurant) return 'restaurant';
    return 'check_circle';
  }
}

class RoomDetail {
  final String label;
  final String value;
  final bool isPrice;

  RoomDetail({
    required this.label,
    required this.value,
    this.isPrice = false,
  });

  factory RoomDetail.fromJson(Map<String, dynamic> json) {
    return RoomDetail(
      label: json['label'] as String? ?? '',
      value: json['value'] as String? ?? '',
      isPrice: json['isPrice'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'value': value,
      'isPrice': isPrice,
    };
  }
}

class Room {
  final String id;
  final String name;
  final String image;
  final String rating;
  final String ratingText;
  final String reviews;
  final double refundPrice;
  final double breakfastPrice;
  final int leftCount;
  final List<RoomFeature> features;
  final double price;

  Room({
    required this.id,
    required this.name,
    required this.image,
    required this.rating,
    required this.ratingText,
    required this.reviews,
    required this.refundPrice,
    required this.breakfastPrice,
    required this.leftCount,
    required this.features,
    required this.price,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      image: json['image'] as String? ?? '',
      rating: json['rating']?.toString() ?? '0.0',
      ratingText: json['ratingText'] as String? ?? '',
      reviews: json['reviews'] as String? ?? '',
      refundPrice: (json['refundPrice'] as num?)?.toDouble() ?? 0.0,
      breakfastPrice: (json['breakfastPrice'] as num?)?.toDouble() ?? 0.0,
      leftCount: json['leftCount'] as int? ?? 0,
      features: (json['features'] as List<dynamic>?)
          ?.map((e) => RoomFeature.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'rating': rating,
      'ratingText': ratingText,
      'reviews': reviews,
      'refundPrice': refundPrice,
      'breakfastPrice': breakfastPrice,
      'leftCount': leftCount,
      'features': features.map((e) => e.toJson()).toList(),
      'price': price,
    };
  }
}

class RoomFeature {
  final IconData icon;
  final String text;

  RoomFeature({
    required this.icon,
    required this.text,
  });

  factory RoomFeature.fromJson(Map<String, dynamic> json) {
    return RoomFeature(
      icon: Service.iconFromString(json['icon'] as String?),
      text: json['text'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'icon': Service.iconToString(icon),
      'text': text,
    };
  }
}