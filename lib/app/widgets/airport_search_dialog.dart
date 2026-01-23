import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/flight_model.dart';

class AirportSearchDialog extends StatefulWidget {
  const AirportSearchDialog({super.key});

  @override
  State<AirportSearchDialog> createState() => _AirportSearchDialogState();
}
class _AirportSearchDialogState extends State<AirportSearchDialog> {
  final _searchController = TextEditingController();
  final _airports = <Airport>[].obs;
  final _isLoading = false.obs;
  final _searchQuery = ''.obs;

  @override
  void initState() {
    super.initState();

    _loadPopularAirports();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  void _loadPopularAirports() {
    _airports.value = [
      Airport(
        id: '1',
        code: 'ABV',
        name: 'Nnamdi Azikiwe International Airport',
        city: 'Abuja',
        country: 'Nigeria',
      ),
      Airport(
        id: '2',
        code: 'LOS',
        name: 'Murtala Muhammed International Airport',
        city: 'Lagos',
        country: 'Nigeria',
      ),
      Airport(
        id: '3',
        code: 'LHR',
        name: 'Heathrow Airport',
        city: 'London',
        country: 'United Kingdom',
      ),
      Airport(
        id: '4',
        code: 'DXB',
        name: 'Dubai International Airport',
        city: 'Dubai',
        country: 'United Arab Emirates',
      ),
      Airport(
        id: '5',
        code: 'JFK',
        name: 'John F. Kennedy International Airport',
        city: 'New York',
        country: 'United States',
      ),
    ];
  }

  // Search airports via API

  Future<void> _searchAirports(String query) async {
    if (query.trim().isEmpty) {
      _loadPopularAirports();
      return;
    }

    if (query.length < 2) return;

    _searchQuery.value = query;
    _isLoading.value = true;

    try {

      //  DUMMY:

      await Future.delayed(const Duration(milliseconds: 500));

      final allAirports = [
        ..._airports,
        Airport(
          id: '6',
          code: 'CDG',
          name: 'Charles de Gaulle Airport',
          city: 'Paris',
          country: 'France',
        ),
        Airport(
          id: '7',
          code: 'IST',
          name: 'Istanbul Airport',
          city: 'Istanbul',
          country: 'Turkey',
        ),
        Airport(
          id: '8',
          code: 'SIN',
          name: 'Singapore Changi Airport',
          city: 'Singapore',
          country: 'Singapore',
        ),
      ];

      _airports.value = allAirports
          .where((airport) =>
      airport.city.toLowerCase().contains(query.toLowerCase()) ||
          airport.code.toLowerCase().contains(query.toLowerCase()) ||
          airport.name.toLowerCase().contains(query.toLowerCase()) ||
          airport.country.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to search airports: $e',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Header

            Row(
              children: [
                Expanded(
                  child: Text(
                    'Select Airport',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Search Field

            TextField(
              controller: _searchController,
              onChanged: _searchAirports,
              decoration: InputDecoration(
                hintText: 'Search by city, airport name or code',
                hintStyle: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
                prefixIcon: const Icon(Icons.search, color: Color(0xFFD4A017)),
                suffixIcon:_searchController.text.isNotEmpty
                    ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    _loadPopularAirports();
                  },
                  icon: const Icon(Icons.clear, size: 20),
                )
                    : const SizedBox.shrink(),
                filled: true,
                fillColor: const Color(0xFFFFFAE6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFFECD08)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFFECD08)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFFECD08), width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            const SizedBox(height: 16),

            // Section Title

            Text(
              _searchQuery.value.isEmpty ? 'Popular Airports' : 'Search Results',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),

            // Results List

            Expanded(
              child: Builder(
                builder: (context) {
                  if (_isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFFECD08),
                      ),
                    );
                  }

                  if (_airports.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.flight_takeoff,
                            size: 64,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No airports found',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try a different search term',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    physics: const ClampingScrollPhysics(),
                    itemCount: _airports.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final airport = _airports[index];
                      return _buildAirportTile(airport);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAirportTile(Airport airport) {
    return InkWell(
      onTap: () => Get.back(result: airport),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [

            // Airport Icon

            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFAE6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFECD08)),
              ),
              child: const Icon(
                Icons.flight,
                color: Color(0xFFD4A017),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),

            // Airport Details

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        airport.city,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFECD08),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          airport.code,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    airport.name,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.grey[700],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    airport.country,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFFD4A017),
                    ),
                  ),
                ],
              ),
            ),

            // Arrow Icon

            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

