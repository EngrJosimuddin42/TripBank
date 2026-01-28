import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_strings.dart';
import '../../../models/flight_model.dart';
import '../../../widgets/horizontal_arrow.dart';
import '../controllers/flight_details_controller.dart';

class FlightDetailsView extends GetView<FlightDetailsController> {
  const FlightDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(103),
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
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                  ),
                  Text(
                    'Flight Details',
                    style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        final flight = controller.selectedFlight.value;
        if (flight == null) {
          return const Center(child: Text('No flight selected'));
        }

        final totalPassengers = controller.totalPassengers.value;
        final isRoundTrip = controller.isRoundTrip.value;

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.medium),

                    _buildAirlineHeader(flight),

                    const SizedBox(height: AppSpacing.large),

                    // Departure Flight
                    _buildFlightRoute(
                      fromCode: flight.fromCode,
                      toCode: flight.toCode,
                      fromDate: flight.departureTime,
                      toDate: flight.arrivalTime,
                      fromCity: flight.from,
                      toCity: flight.to,
                      duration: flight.duration,
                      stops: flight.stops,
                      isReturn: false,
                    ),

                    // Return Flight
                    if (isRoundTrip && flight.returnDepartureTime != null) ...[
                      const SizedBox(height: AppSpacing.small),
                      _buildFlightRoute(
                        fromCode: flight.toCode,
                        toCode: flight.fromCode,
                        fromDate: flight.returnDepartureTime!,
                        toDate: flight.returnArrivalTime ?? flight.arrivalTime.add(const Duration(days: 7)),
                        fromCity: flight.to,
                        toCity: flight.from,
                        duration: flight.returnDuration ?? flight.duration,
                        stops: flight.returnStops ?? flight.stops,
                        isReturn: true,
                      ),
                    ],

                    const SizedBox(height: AppSpacing.large),

                    _buildPriceSection(flight, totalPassengers),

                    const SizedBox(height: AppSpacing.xlarge),
                  ],
                ),
              ),
            ),

            _buildBottomButton(flight, isRoundTrip),
          ],
        );
      }),
    );
  }

  Widget _buildAirlineHeader(Flight flight) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: flight.airlineLogo.startsWith('http')
            ? Image.network(
          flight.airlineLogo,
          height: 60,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Image.asset(
            'assets/images/air_france.png',
            height: 60,
            fit: BoxFit.contain,
          ),
        )
            : Image.asset(
          flight.airlineLogo,
          height: 60,
          fit: BoxFit.contain,
        ),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fromCode,
                  style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black),
                ),
                const SizedBox(height: 4),
                Text(
                  controller.formatDate(fromDate),
                  style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600]),
                ),
                Text(
                  fromCity,
                  style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                duration,
                style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFFFECD08)),
              ),
              const SizedBox(height: 4),
              const HorizontalArrow(width: 140),
              const SizedBox(height: 4),
              Text(
                stops == 0 ? AppStrings.nonStop : '$stops ${stops > 1 ? AppStrings.stops : AppStrings.stop}',
                style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFFFECD08)),
              ),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  toCode,
                  style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black),
                ),
                const SizedBox(height: 4),
                Text(
                  controller.formatDate(toDate),
                  style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600]),
                ),
                Text(
                  toCity,
                  style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600]),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection(Flight flight, int totalPassengers) {
    final breakdown = controller.getPriceBreakdown();
    final baseFare = breakdown['baseFare']!;
    final taxAmount = breakdown['taxes']!;
    final vatAmount = breakdown['vat']!;
    final otherCharges = breakdown['otherCharges']!;
    final grandTotal = breakdown['total']!;

    final showDetails = true.obs;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${flight.currencySymbol}${grandTotal.toStringAsFixed(0)}',
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(
                  '$totalPassengers ${totalPassengers > 1 ? AppStrings.travelers : AppStrings.traveler}',
                  style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[700]),
                ),
                Obx(() => GestureDetector(
                  onTap: () => showDetails.value = !showDetails.value,
                  child: Row(
                    children: [
                      Text(AppStrings.fareDetails, style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[600])),
                      Icon(
                        showDetails.value ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        size: 20,
                        color: Colors.grey[600],
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
          Obx(() => AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: showDetails.value ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Base Fare
                  _buildFareRow(
                    '$totalPassengers x ${AppStrings.baseFare} (ADULT)${controller.isRoundTrip.value ? " x 2" : ""}',
                    baseFare,
                    flight.currencySymbol,
                  ),
                  const SizedBox(height: 16),

                  // Taxes
                  _buildFareRow(
                    '$totalPassengers x ${AppStrings.taxesFees} (ADULT)${controller.isRoundTrip.value ? " x 2" : ""}',
                    taxAmount,
                    flight.currencySymbol,
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 16),

                  // AIT & VAT
                  _buildFareRow(
                    AppStrings.aitVat,
                    vatAmount,
                    flight.currencySymbol,
                  ),
                  const SizedBox(height: 16),

                  // Other Charges
                  _buildFareRow(
                    AppStrings.otherCharges,
                    otherCharges,
                    flight.currencySymbol,
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 20),

                  _buildBulletList([
                    flight.airline,
                    flight.flightNumber,
                    '${controller.selectedClass.value} ($totalPassengers)',
                    flight.baggageAllowance,
                    if (flight.fareRules != null) flight.fareRules!,
                  ]),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppStrings.total, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700)),
                      Text(
                        '${flight.currencySymbol}${grandTotal.toStringAsFixed(0)}',
                        style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: const Color(0xFFFECD08)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            secondChild: const SizedBox.shrink(),
          )),
        ],
      ),
    );
  }

  Widget _buildFareRow(String label, double amount, String currencySymbol) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[700]),
        ),
        Text(
          '$currencySymbol${amount.toStringAsFixed(0)}',
          style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[700]),
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
              Text('• ', style: GoogleFonts.inter(fontSize: 14, color: Colors.black)),
              Expanded(
                child: Text(
                  item,
                  style: GoogleFonts.inter(fontSize: 14, color: Colors.black),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomButton(Flight flight, bool isRoundTrip) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              controller.bookFlight();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFECD08),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              isRoundTrip ? AppStrings.selectRoundTrip : AppStrings.provideDetails,
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
}