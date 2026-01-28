import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LocationData {
  final String city;
  final String terminal;
  final String country;
  final String code;

  LocationData({
    required this.city,
    required this.terminal,
    required this.country,
    required this.code,
  });
}

class LocationSearchDialog extends StatefulWidget {
  final String title;
  const LocationSearchDialog({super.key, required this.title});

  @override
  State<LocationSearchDialog> createState() => _LocationSearchDialogState();
}

class _LocationSearchDialogState extends State<LocationSearchDialog> {
  final _searchController = TextEditingController();
  final _locations = <LocationData>[].obs;
  final _isLoading = false.obs;
  final _searchQuery = ''.obs;

  //  SINGLE SOURCE OF TRUTH
  static final List<LocationData> _allLocations = [
    // Nigeria
    LocationData(city: 'Abuja', code: 'ABV', terminal: 'Abuja Bus Terminal', country: 'Nigeria'),
    LocationData(city: 'Lagos', code: 'LOS', terminal: 'Ikeja Bus Park', country: 'Nigeria'),
    LocationData(city: 'Ibadan', code: 'IBA', terminal: 'Ibadan Bus Terminal', country: 'Nigeria'),
    LocationData(city: 'Port Harcourt', code: 'PHC', terminal: 'Port Harcourt Central Station', country: 'Nigeria'),
    LocationData(city: 'Kano', code: 'KAN', terminal: 'Kano Interstate Terminal', country: 'Nigeria'),

    // Europe
    LocationData(city: 'Paris', code: 'CDG', terminal: 'Paris Central Station', country: 'France'),
    LocationData(city: 'Berlin', code: 'BER', terminal: 'Berlin Central Bus Station', country: 'Germany'),
    LocationData(city: 'Rome', code: 'ROM', terminal: 'Roma Tiburtina', country: 'Italy'),
    LocationData(city: 'Madrid', code: 'MAD', terminal: 'Estación Sur de Autobuses', country: 'Spain'),
    LocationData(city: 'Amsterdam', code: 'AMS', terminal: 'Amsterdam Sloterdijk', country: 'Netherlands'),
    LocationData(city: 'Istanbul', code: 'IST', terminal: 'City Square Terminal', country: 'Turkey'),

    // Asia
    LocationData(city: 'Dubai', code: 'DXB', terminal: 'Al Ghubaiba Bus Station', country: 'UAE'),
    LocationData(city: 'Singapore', code: 'SIN', terminal: 'Queen Street Terminal', country: 'Singapore'),
    LocationData(city: 'Tokyo', code: 'TYO', terminal: 'Shinjuku Bus Terminal', country: 'Japan'),
    LocationData(city: 'Bangkok', code: 'BKK', terminal: 'Mo Chit Bus Terminal', country: 'Thailand'),
    LocationData(city: 'Kuala Lumpur', code: 'KUL', terminal: 'TBS Bus Terminal', country: 'Malaysia'),
    LocationData(city: 'Mumbai', code: 'BOM', terminal: 'Mumbai Central Bus Stand', country: 'India'),
    LocationData(city: 'Delhi', code: 'DEL', terminal: 'ISBT Kashmere Gate', country: 'India'),
    LocationData(city: 'Dhaka', code: 'DAC', terminal: 'Mohakhali Bus Terminal', country: 'Bangladesh'),
    LocationData(city: 'Chittagong', code: 'CGP', terminal: 'Chittagong Bus Stand', country: 'Bangladesh'),
    LocationData(city: 'Sylhet', code: 'ZYL', terminal: 'Sylhet Central Bus Station', country: 'Bangladesh'),

    // North America
    LocationData(city: 'New York', code: 'NYC', terminal: 'Port Authority Bus Terminal', country: 'USA'),
    LocationData(city: 'Los Angeles', code: 'LAX', terminal: 'Union Station', country: 'USA'),
    LocationData(city: 'Chicago', code: 'CHI', terminal: 'Chicago Union Station', country: 'USA'),
    LocationData(city: 'Toronto', code: 'YYZ', terminal: 'Toronto Coach Terminal', country: 'Canada'),
    LocationData(city: 'Vancouver', code: 'YVR', terminal: 'Pacific Central Station', country: 'Canada'),

    // Middle East
    LocationData(city: 'Riyadh', code: 'RUH', terminal: 'Riyadh Bus Station', country: 'Saudi Arabia'),
    LocationData(city: 'Doha', code: 'DOH', terminal: 'Doha Bus Terminal', country: 'Qatar'),
    LocationData(city: 'Cairo', code: 'CAI', terminal: 'Cairo Gateway Terminal', country: 'Egypt'),

    // Africa
    LocationData(city: 'Johannesburg', code: 'JNB', terminal: 'Park Station', country: 'South Africa'),
    LocationData(city: 'Nairobi', code: 'NBO', terminal: 'Nairobi Railway Station', country: 'Kenya'),
    LocationData(city: 'Accra', code: 'ACC', terminal: 'Accra Central Station', country: 'Ghana'),
  ];

  @override
  void initState() {
    super.initState();
    _loadPopularLocations();
  }

  void _loadPopularLocations() {
    _locations.value = _allLocations;
  }

  void _searchLocations(String query) async {
    _searchQuery.value = query;

    if (query.trim().isEmpty) {
      _loadPopularLocations();
      return;
    }

    _isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 300));

    final queryLower = query.toLowerCase();
    final filtered = _allLocations.where((loc) =>
    loc.city.toLowerCase().contains(queryLower) ||
        loc.code.toLowerCase().contains(queryLower) ||
        loc.country.toLowerCase().contains(queryLower) ||
        loc.terminal.toLowerCase().contains(queryLower)
    ).toList();

    _locations.value = filtered;
    _isLoading.value = false;
  }

  Widget _buildLocationTile(LocationData location) {
    return InkWell(
      onTap: () => Get.back(result: location),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFAE6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFECD08)),
              ),
              child: const Icon(
                Icons.directions_bus,
                color: Color(0xFFD4A017),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        location.city,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFECD08),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          location.code,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    location.terminal,
                    style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    location.country,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFD4A017),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    widget.title,
                    style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)
                ),
                IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close)
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _searchController,
              onChanged: _searchLocations,
              decoration: InputDecoration(
                hintText: 'Search city or location...',
                hintStyle: GoogleFonts.inter(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Color(0xFFD4A017)),
                filled: true,
                fillColor: const Color(0xFFFFFAE6),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none
                ),
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: Obx(() {
                if (_isLoading.value) {
                  return const Center(
                      child: CircularProgressIndicator(color: Color(0xFFFECD08))
                  );
                }

                if (_locations.isEmpty) {
                  return Center(
                      child: Text(
                          "No locations found",
                          style: GoogleFonts.inter()
                      )
                  );
                }

                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _locations.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final loc = _locations[index];
                    return _buildLocationTile(loc);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}