import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../modules/explore/controllers/explore_controller.dart';

class CardBuilders {

  // Hotel Card Builder

  static Widget buildHotelCard(Map destination) {
    final controller = Get.find<ExploreController>();
    final hotel = controller.createHotelFromMap(destination);
    final isTrending = destination['isTrending'] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Row(
        children: [
      Stack(
      children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              hotel.image,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.hotel, size: 50),
            ),
          ),

        //  Trending Badge

        if (isTrending)
          Positioned(
            top: 8,
            left: 8,
            child: _buildTag(
              'Trending',
              bgColor: const Color(0xFFFECD08),
              textColor: const Color(0xFF6B5603),
            ),
          ),
      ],
      ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        hotel.name,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _buildBookButton(padding: 8, data: destination),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    Text(
                        ' ${hotel.rating}',
                      style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 4),
                      Text(
                        '(${hotel.reviews})',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                  ],
                ),

                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: Colors.grey,
                      size: 16,
                    ),
                    Expanded(
                      child: Text(
                        ' ${hotel.address}',
                        style: const TextStyle(color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: hotel.formattedPrice,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                       TextSpan(
                        text: ' /${hotel.nights} Night',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Flight Card Builder

  static Widget buildFlightCard(Map destination) {
    final controller = Get.find<ExploreController>();
    final flight = controller.createFlightFromMap(destination);
    final isTrending = destination['isTrending'] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFFFFFF).withValues(alpha: 0.1),
          width: 1.5,
        ),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        children: [
          if (isTrending)
            Align(
              alignment: Alignment.topRight,
              child: _buildTag(
                'Trending',
                bgColor: const Color(0xFFFECD08),
                textColor: const Color(0xFF6B5603),
              ),
            ),
          const SizedBox(height: 8),

          // Header

          Row(
            children: [
              flight.airlineLogo.isNotEmpty
                  ? Image.network(flight.airlineLogo, width: 40, height: 40)
                  : Image.asset('assets/images/flight_2.png', width: 40),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      flight.airline,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Direct • ${flight.cabinClass}',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${flight.price.toStringAsFixed(0)}',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '/person',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Route

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      flight.fromCode,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      controller.formatTime(flight.departureTime),
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(height: 1, color: Colors.grey[300]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Image.asset(
                        'assets/images/flight_1.png',
                        width: 24,
                        height: 24,
                      ),
                    ),
                    Expanded(
                      child: Container(height: 1, color: Colors.grey[300]),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      flight.toCode,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      controller.formatTime(flight.arrivalTime),
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(height: 1, color: Colors.grey[200]),
          const SizedBox(height: 16),

          // Footer

          Row(
            children: [
              Icon(
                Icons.access_time_outlined,
                size: 18,
                color: Colors.grey[500],
              ),
              const SizedBox(width: 6),
              Text(
                flight.duration,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
              const Spacer(),
              _buildBookButton(padding: 8, data: destination),
            ],
          ),
        ],
      ),
    );
  }

  // Tour Card Builder

  static Widget buildTourCard(Map destination) {
    final controller = Get.find<ExploreController>();
    final tour = controller.createTourFromMap(destination);
    final isTrending = destination['isTrending'] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(
                  tour.imageUrl,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 140,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: _buildTag(
                  isTrending ? 'Trending' : tour.category,
                  bgColor: const Color(0xFFFECD08),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: _buildRatingTag(tour.rating),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tour.title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: const Color(0xFF1D2939),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_outlined,
                      size: 16,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      tour.duration,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.people_outline,
                      size: 16,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Max ${tour.maxPeople} people',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '\$${tour.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          TextSpan(
                            text: '/person',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildBookButton(padding: 8, data: destination),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // Car Card Builder

  static Widget buildCarCard(Map destination) {
    final controller = Get.find<ExploreController>();
    final car = controller.createCarFromMap(destination);
    final isTrending = destination['isTrending'] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              car.imageUrl,
              width: 90,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 90,
                height: 80,
                color: Colors.grey[200],
                child: const Icon(Icons.directions_car),
              ),
            ),
          ),

          //  Trending Badge

          if (isTrending)
            Positioned(
              top: 4,
              left: 4,
              child: _buildTag(
                'Trending',
                bgColor: const Color(0xFFFECD08),
                textColor: const Color(0xFF6B5603),
              ),
            ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "${car.brand} ${car.model}",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.bookmark_border, color: Colors.amber),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 14),
                    Text(
                      ' ${car.rating}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      car.types,
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.person, size: 14, color: Colors.grey),
                    Text(
                      ' ${car.seats} ',
                      style: const TextStyle(fontSize: 11),
                    ),
                    const Icon(Icons.shopping_bag, size: 14, color: Colors.grey),
                    Text(
                      ' ${car.bags} ',
                      style: const TextStyle(fontSize: 11),
                    ),
                    const Icon(Icons.directions_car, size: 14, color: Colors.grey),
                    Text(
                      ' ${car.doors}',
                      style: const TextStyle(fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '\$${car.pricePerDay.toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const TextSpan(
                            text: '/day',
                            style: TextStyle(color: Colors.grey, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    _buildBookButton(padding: 8, data: destination),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Grid Card for Featured (Trending)

  static Widget buildTrendingGridCard(Map destination) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  destination['image'],
                  height: 110,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 110,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported, color: Colors.grey),
                  ),
                ),
              ),
          Positioned(
            top: 8,
            left: 8,
            child: _buildTag(
              'Trending',
              bgColor: const Color(0xFFFECD08),
              textColor: const Color(0xFF6B5603),
            ),
          ),
        ],
      ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  destination['name'] ?? 'Unknown',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    const Icon(Icons.star, size: 12, color: Colors.amber),
                    Text(
                      ' ${destination['rating']}',
                      style: const TextStyle(fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${destination['price']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    _buildBookButton(padding: 8, data: destination),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widgets

  static Widget _buildBookButton({String label = 'Book Now', double padding = 8,
    required Map data}) {
    final controller = Get.find<ExploreController>();
    return InkWell(
      onTap: () => controller.navigateToDetails(data),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: padding),
        decoration: BoxDecoration(
          color: const Color(0xFFFECD08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        ),
      ),
    );
  }

  static Widget _buildTag(String text, {Color? bgColor, Color? textColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor ?? const Color(0xFFFECD08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          fontSize: 10,
          color: textColor ?? const Color(0xFF6B5603),
        ),
      ),
    );
  }

  static Widget _buildRatingTag(dynamic rating) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, color: Colors.amber, size: 14),
          Text(
            ' $rating',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Main dispatcher

  static Widget buildDestinationCard(Map destination) {
    String type = destination['type'] ?? 'hotel';

    switch (type) {
      case 'flight':
        return buildFlightCard(destination);
      case 'tour':
        return buildTourCard(destination);
      case 'car':
        return buildCarCard(destination);
      default:
        return buildHotelCard(destination);
    }
  }
}