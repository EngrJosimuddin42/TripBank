import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/custom_date_picker.dart';
import '../controllers/flight_booking_controller.dart';

class PassengerDetailsView extends GetView<FlightBookingController> {
  PassengerDetailsView({super.key});

  final TextEditingController _dobController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
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
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                  ),
                  Expanded(
                    child: Text(
                      'Confirm Passenger Details',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF3A3A3A),
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Contact Details Section
                  _buildContactDetailsSection(),

                  // Passenger Details Header + Adult Card
                  _buildPassengerDetailsSection(),


                  const SizedBox(height: 24),

                  // Next Button (এখন scroll হবে)
                  _buildScrollableNextButton(),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Contact Details Section
  Widget _buildContactDetailsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: const Color(0xFFE7BB07),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Image.asset('assets/images/bxs_contact.png'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contact Details',
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600,color: Color(0xFF3A3A3A)),
                    ),
                    Text(
                      'to receive your E-tickets & updates',
                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400,color: Color(0xFF3A3A3A)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          _buildRequiredTextField(label: 'Mobile No.', hint: '+88   01799999999'),
          const SizedBox(height: 16),
          _buildRequiredTextField(label: 'Email', hint: 'josimcse@gmail.com'),
          const SizedBox(height: 16),
          _buildRequiredTextField(label: 'NIN Number', hint: '654854685548165851'),
          const SizedBox(height: 16),
          _buildRequiredTextField(label: 'Passport Number', hint: '564854165465465'),
        ],
      ),
    );
  }

  // Passenger Details Header + Adult Card
  Widget _buildPassengerDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Passenger Details',
                      style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w500,color: Color(0xFF3A3A3A)),
                    ),
                    Text(
                      'Please Provide the details of passenger',
                      style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400,color: Color(0xFF818898)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        // Adult Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE7BB07),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Image.asset('assets/images/Passenger.png'),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Adult',
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600,color: Color(0xFF3A3A3A)),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                'Title',
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildTitleButton('MR.', true),
                  const SizedBox(width: 12),
                  _buildTitleButton('MS.', false),
                  const SizedBox(width: 12),
                  _buildTitleButton('MRS.', false),
                ],
              ),
              const SizedBox(height: 20),

              // First Name
              _buildRequiredTextField(label: 'First Name (Given Name)', hint: 'Josim'),
              const SizedBox(height: 16),

              // Last Name
              _buildRequiredTextField(label: 'Last Name (Surname)', hint: 'Uddin'),
              const SizedBox(height: 16),

              // Date of Birth
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date of Birth',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF818898),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _selectDOB,
                    child: AbsorbPointer(
                      child: TextField(
                        controller: _dobController,
                        readOnly: true,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF3A3A3A),
                        ),
                        decoration: InputDecoration(
                          hintText: ('MM-DD-YYYY'),
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF3A3A3A).withOpacity(0.6),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFE6EAF4),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Icon(
                              Icons.calendar_today,
                              color: Colors.grey,
                              size: 18,
                            ),
                          ),
                          suffixIconConstraints: const BoxConstraints(
                            minWidth: 30,
                            minHeight: 30,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: const BorderSide(color: Color(0xFFE6EAF4)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: const BorderSide(color: Color(0xFFE6EAF4)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: const BorderSide(color: Color(0xFFE6EAF4), width: 2),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
  // Title Buttons (MR. / MS. / MRS.)
  Widget _buildTitleButton(String title, bool isSelected) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 40,
        width: 50,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE7BB07) : const Color(0xFFFFFAE6),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: const Color(0xFF8F949A), width: 1.5),
        ),
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  // Required Text Field with Red *
  Widget _buildRequiredTextField({
    required String label,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xFF818898)),
            children: const [
              TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF3A3A3A),
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF3A3A3A).withOpacity(0.6),
            ),
            filled: true,
            fillColor: const Color(0xFFE6EAF4),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 6,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Color(0xFFE6EAF4)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Color(0xFFE6EAF4)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Color(0xFFE6EAF4), width: 2),
            ),
          ),
        ),
      ],
    );
  }

  // CustomDatePicker ব্যবহার করে DOB সিলেক্ট
  void _selectDOB() async {
    final DateTime? picked = await showDialog<DateTime>(
      context: Get.context!,
      builder: (BuildContext dialogContext) {
        return CustomDatePicker(
          initialDate: DateTime(1990),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          onDateSelected: (date) {
            _dobController.text =
            '${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}-${date.year}';
          },
        );
      },
    );
  }

  // Next Button (Fixed at bottom)
  Widget _buildScrollableNextButton() {
    return Center(
      child: SizedBox(
        width: 343,
        height: 52,
        child: ElevatedButton(
          onPressed: controller.continueToPayment,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFECD08),
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: Text(
            'Next',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF3A3A3A),
            ),
          ),
        ),
      ),
    );
  }
}