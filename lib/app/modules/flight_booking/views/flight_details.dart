import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/flight_booking_controller.dart';

class FlightDetailsView extends GetView<FlightBookingController> {
  const FlightDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFECD08),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Text(
          'Review Flight Details',
          style: GoogleFonts.inter(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(() {
        final flight = controller.selectedFlight.value;
        if (flight == null) {
          return const Center(child: Text('No flight selected'));
        }

        final isRoundTrip = controller.selectedTripType.value == 'Round Way';

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // Airline Logo/Name
                    _buildAirlineHeader(flight),

                    const SizedBox(height: 24),

                    // Flight Route - Outbound
                    _buildFlightRoute(
                      fromCode: flight.fromCode,
                      toCode: flight.toCode,
                      fromDate: flight.departureTime,
                      toDate: flight.arrivalTime,
                      fromCity: flight.from,
                      toCity: flight.to,
                      duration: flight.duration,
                      stops: flight.stops,
                    ),

                    // Return Flight (if round trip)
                    if (isRoundTrip) ...[
                      const SizedBox(height: 16),
                      _buildFlightRoute(
                        fromCode: flight.toCode,
                        toCode: flight.fromCode,
                        fromDate: flight.arrivalTime.add(const Duration(days: 7)),
                        toDate: flight.arrivalTime.add(const Duration(days: 7, hours: 12)),
                        fromCity: flight.to,
                        toCity: flight.from,
                        duration: flight.duration,
                        stops: flight.stops,
                        isReturn: true,
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Price Section
                    _buildPriceSection(flight),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),

            // Bottom Button
            _buildBottomButton(flight),
          ],
        );
      }),
    );
  }

  Widget _buildAirlineHeader(flight) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // You can replace this with actual airline logo
          Text(
            'AIRFRANCE',
            style: GoogleFonts.roboto(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF002157),
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(width: 8),
          // Plane icon as logo placeholder
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFE31E24),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.flight,
              color: Colors.white,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlightRoute({
    required String fromCode,
    required String toCode,
    required DateTime fromDate,
    required DateTime toDate,
    required String fromCity,
    required String toCity,
    required String duration,
    required int stops,
    bool isReturn = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // From
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fromCode,
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(fromDate),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  fromCity,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Duration & Arrow
          Column(
            children: [
              Text(
                duration,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFFECD08),
                ),
              ),
              const SizedBox(height: 4),
              Icon(
                isReturn ? Icons.arrow_back : Icons.arrow_forward,
                color: const Color(0xFFFECD08),
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                stops == 0 ? 'Non-stop' : '$stops stop${stops > 1 ? 's' : ''}',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: const Color(0xFFFECD08),
                ),
              ),
            ],
          ),

          // To
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  toCode,
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(toDate),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  toCity,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection(flight) {
    final basePrice = flight.price;
    final taxPrice = basePrice * 0.12;
    final totalPassengers = controller.totalPassengers;
    final baseFareTotal = basePrice * totalPassengers;
    final taxTotal = taxPrice * totalPassengers;
    final total = baseFareTotal + taxTotal;

    final showDetails = true.obs;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Price Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$ ${basePrice.toStringAsFixed(0)}',
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                Obx(() => GestureDetector(
                  onTap: () => showDetails.value = !showDetails.value,
                  child: Row(
                    children: [
                      Text(
                        'Fare Details',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        showDetails.value
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        size: 20,
                        color: Colors.grey[600],
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),

          // Expandable Fare Details
          Obx(() => AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: showDetails.value
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Column(
              children: [
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Base Fare
                      _buildFareRow(
                        '1 x Base fare (ADULT)',
                        baseFareTotal,
                      ),
                      const SizedBox(height: 12),
                      _buildFareRow(
                        '1 x Tax (ADULT)',
                        taxTotal,
                      ),
                      const SizedBox(height: 12),
                      _buildFareRow(
                        'AIT & VAT',
                        0,
                      ),
                      const SizedBox(height: 12),
                      _buildFareRow(
                        'Other charges',
                        0,
                      ),

                      const SizedBox(height: 20),

                      // Flight Details Bullets
                      _buildBulletList([
                        flight.airline,
                        flight.flightNumber,
                        '${flight.cabinClass} (${controller.totalPassengers})',
                        'Baggage (per PAX): Adult-20KGS',
                      ]),

                      const SizedBox(height: 20),

                      // Total
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            '\$${total.toStringAsFixed(0)}',
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFFECD08),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            secondChild: const SizedBox.shrink(),
          )),
        ],
      ),
    );
  }

  Widget _buildFareRow(String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: Colors.grey[700],
          ),
        ),
        Text(
          'USD \$${amount.toStringAsFixed(0)}',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildBulletList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '• ',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              Expanded(
                child: Text(
                  item,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomButton(flight) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: controller.bookFlight,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFECD08),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              'Provide Details',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final month = months[date.month - 1];
    return '$day $month, ${date.year}';
  }
}