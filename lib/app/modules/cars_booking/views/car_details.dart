import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/car_details_controller.dart';

class CarDetailsView extends GetView<CarDetailsController> {
  const CarDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: _buildAppBar(),
      body: Obx(() {
        final car = controller.selectedCar.value;
        if (car == null) return const Center(child: CircularProgressIndicator());

        final breakdown = controller.getPriceBreakdown();

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "${car.brand} ${car.model}",
                        style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Container(
                        height: 180,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: car.imageUrl.isNotEmpty
                              ? Image.network(
                            car.imageUrl,
                            fit: BoxFit.contain,
                            errorBuilder: (c, e, s) => _buildFallbackAssetImage(),
                          )
                              : _buildFallbackAssetImage(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    _buildFareHeader(breakdown['total']!),
                    const SizedBox(height: 20),
                    const Divider(),

                    Obx(() => Visibility(
                      visible: controller.isFareDetailsExpanded.value,
                      child: _buildFareBreakdown(breakdown),
                    )),

                    const SizedBox(height: 10),

                    if (car.extras.isNotEmpty)
                      ...car.extras.map((extra) => _buildFeatureCheck(
                        extra,
                        hasInfo: extra.toLowerCase().contains("cancellation"),
                      )),

                    const SizedBox(height: 30),
                    _buildTotalSection(breakdown['total']!),
                  ],
                ),
              ),
            ),

            _buildPaymentButton(),
            const SizedBox(height: 40),
          ],
        );
      }),
    );
  }


  Widget _buildFallbackAssetImage() {
    return Image.asset(
      'assets/images/car_image.jpg',
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => const Icon(
        Icons.directions_car,
        size: 100,
        color: Colors.grey,
      ),
    );
  }

  // UI Components

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(103),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFEDE5A),
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Row(
              children: [
                IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black)),
                Text('Car Details', style: GoogleFonts.roboto(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFareHeader(double total) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("\$ ${total.toStringAsFixed(0)}", style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w700)),
        GestureDetector(
          onTap: () => controller.isFareDetailsExpanded.toggle(),
          child: Row(
            children: [
              Text("Fare Details", style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[600])),
              Icon(controller.isFareDetailsExpanded.value ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, size: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFareBreakdown(Map<String, double> breakdown) {
    return Column(
      children: [
        _buildPriceRow(
            "${breakdown['days']!.toInt()} x Base fare (\$${breakdown['pricePerDay']!.toStringAsFixed(0)}/day)",
            "USD \$${breakdown['baseFare']!.toStringAsFixed(0)}"
        ),
        _buildPriceRow("Tax (15%)", "USD \$${breakdown['tax']!.toStringAsFixed(0)}"),
        const Divider(),
        _buildPriceRow("AIT & VAT", "USD \$${breakdown['aitVat']!.toStringAsFixed(0)}"),
        _buildPriceRow("Other charges", "USD \$${breakdown['otherCharges']!.toStringAsFixed(0)}"),
        const Divider(),
      ],
    );
  }

  Widget _buildTotalSection(double total) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Total", style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700)),
        Text(
          "\$${total.toStringAsFixed(0)}",
          style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: const Color(0xFFC7A100)),
        ),
      ],
    );
  }

  Widget _buildPaymentButton() {
    return SizedBox(
      width: 343,
      height: 60,
      child: ElevatedButton(
        onPressed: () => controller.proceedToPayment(),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFECD08),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
        ),
        child: Text('Make Payment', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF6B5603))),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[600])),
          Text(value, style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildFeatureCheck(String text, {bool hasInfo = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.check, color: Colors.green, size: 20),
          const SizedBox(width: 10),
          Text(text, style: GoogleFonts.inter(fontSize: 13, color: Colors.blueGrey[800])),
          if (hasInfo) ...[
            const SizedBox(width: 4),
            Icon(Icons.info_outline, size: 16, color: Colors.grey[400]),
          ]
        ],
      ),
    );
  }
}