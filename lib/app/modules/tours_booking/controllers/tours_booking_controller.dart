import 'package:get/get.dart';
import '../../../constants/app_strings.dart';
import '../../../models/tour_model.dart';
import '../../../services/favorites_service.dart';
import '../../../utils/booking_helper.dart';
import '../../../widgets/snackbar_helper.dart';
import '../../my_bookings/controllers/my_bookings_controller.dart';

class ToursBookingController extends GetxController {

  // Dependencies / Services
  final FavoritesService _favoritesService = Get.find<FavoritesService>();

  // Observable variables (Rx)
  final RxList<Tour> allTours = <Tour>[].obs;
  final RxList<Tour> filteredTours = <Tour>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;
  final RxInt adultsCount = 1.obs;
  final RxInt childrenCount = 0.obs;
  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final Rxn<Tour> selectedTour = Rxn<Tour>();
  final Rxn<Tour> bookedTour = Rxn<Tour>();
  final RxString selectedPaymentMethod = ''.obs;
  final RxInt guestCount = 1.obs;
  final RxString bookingReference = ''.obs;
  final RxDouble taxRate = 0.10.obs;

  // FAVORITES METHODS
  bool isTourFavorite(String tourId) {
    return _favoritesService.isFavorite('tour', tourId);
  }

  Future<void> toggleTourFavorite(String tourId) async {
    final tour = allTours.firstWhereOrNull((t) => t.id == tourId);
    if (tour == null) return;

    final tourData = {
      'id': tour.id,
      'name': tour.title,
      'title': tour.title,
      'location': tour.location,
      'image': tour.imageUrl,
      'imageUrl': tour.imageUrl,
      'rating': tour.rating,
      'reviewsCount': tour.reviewsCount,
      'price': tour.price,
      'category': tour.category,
      'duration': tour.duration,
      'maxPeople': tour.maxPeople,
      'description': tour.description,
      'buttonText': tour.buttonText,
      'startTime': tour.startTime,
      'destination': tour.destination,
      'visitingPlaces': tour.visitingPlaces,
      'taxRate': tour.taxRate,
      'keyHighlights': tour.keyHighlights,
      'included': tour.included,
      'notIncluded': tour.notIncluded,
      'whatToBring': tour.whatToBring,
      'itinerary': tour.itinerary.map((day) => {
        'day': day.day,
        'title': day.title,
        'activities': day.activities,
      }).toList(),
      'meetingPoint': tour.meetingPoint != null ? {
        'address': tour.meetingPoint!.address,
        'description': tour.meetingPoint!.description,
        'mapImageUrl': tour.meetingPoint!.mapImageUrl,
      } : null,
    };

    await _favoritesService.toggleFavorite('tour', tourData);
  }
  // Related Tour Method
  List<Tour> getRelatedTours({
    required String currentTourId,
    Tour? currentTour,
    int limit = 10,
  }) {
    final Tour? baseTour = currentTour ?? selectedTour.value;
    if (baseTour == null) return [];

    return allTours.where((tour) {
      if (tour.id == currentTourId) return false;
      final sameCategory = tour.category.toLowerCase() == baseTour.category.toLowerCase();
      final sameLocation = tour.location.toLowerCase() == baseTour.location.toLowerCase();
      return sameCategory || sameLocation;
    }).take(limit).toList();
  }

  //Lifecycle methods
  @override
  void onInit() {
    super.onInit();
    loadTours();
    debounce(searchQuery, (_) => filterTours(),
        time: const Duration(milliseconds: 500));

    if (Get.arguments != null && Get.arguments is Tour) {
      selectedTour.value = Get.arguments as Tour;
    }
  }

  //LOAD TOURS (Dummy Data)
  void loadTours() async {
    isLoading.value = true;

    await Future.delayed(const Duration(milliseconds: 1200));

    final demoTours = [
      Tour(
        id: 'tour_001',
        title: 'Paris City Highlights & Eiffel Tower',
        location: 'Paris, France',
        imageUrl: 'https://thumbs.dreamstime.com/b/golden-hour-paris-eiffel-tower-sunset-stunning-view-city-skyline-358975913.jpg',
        category: 'City Highlights',
        duration: '6 Hours',
        maxPeople: 15,
        price: 129.0,
        rating: 4.2,
        reviewsCount: 342,
        description: 'Explore the iconic landmarks of Paris including the Eiffel Tower, Louvre Museum, and Notre-Dame Cathedral on this comprehensive city tour.',
        buttonText: AppStrings.viewDetails,
        startTime: '09:00 AM',
        destination: 'Eiffel Tower, Louvre, Notre-Dame',
        visitingPlaces: ['Eiffel Tower', 'Louvre Museum', 'Notre-Dame Cathedral'],
        taxRate: 0.12,
        keyHighlights: [
          'Skip-the-line access to the Eiffel Tower 2nd floor',
          'Professional English-speaking local guide',
          'Scenic 1-hour cruise on the River Seine',
          'Small group tour for a personalized experience'
        ],
        included: [
          'Entry tickets to Eiffel Tower',
          'River Cruise ticket',
          'Professional tour guide',
          'Bottled water'
        ],
        notIncluded: [
          'Hotel pickup and drop-off',
          'Food and drinks',
          'Gratuities (optional)'
        ],
        whatToBring: [
          'Comfortable walking shoes',
          'Passport or ID card',
          'Camera',
          'Sunscreen'
        ],
        itinerary: [
          ItineraryDay(
            day: 'Day 1',
            title: 'Meeting at Eiffel Tower',
            activities: ['Meet guide at North Pillar', 'Security check & elevator ride'],
          ),
          ItineraryDay(
            day: 'Day 2',
            title: 'Louvre External Tour',
            activities: ['History of the glass pyramid', 'Photo session at Cour Napoléon'],
          ),
          ItineraryDay(
            day: 'Day 3',
            title: 'River Seine Cruise',
            activities: ['Panoramic view of Paris', 'Audio commentary included'],
          ),
        ],
        meetingPoint: MeetingPoint(
          address: 'Champ de Mars, 5 Avenue Anatole France, 75007 Paris, France',
          description: 'Please meet your guide at the base of the Eiffel Tower, near the North Pillar.',
          mapImageUrl: 'https://images.unsplash.com/photo-1524231757912-21f4fe3a7200?w=600',
        ),
      ),
      Tour(
        id: 'tour_002',
        title: 'Safari Adventure Experience',
        location: 'Uluwatu, Indonesia',
        imageUrl: 'https://images.unsplash.com/photo-1516426122078-c23e76319801?w=800&h=600&fit=crop',
        category: 'Adventure',
        duration: '3 Days',
        maxPeople: 12,
        price: 450.0,
        rating: 4.9,
        reviewsCount: 342,
        description: 'Experience the thrill of a safari adventure through the beautiful landscapes of Uluwatu.',
        buttonText: AppStrings.bookTour,
        startTime: '06:00 AM',
        destination: 'Uluwatu National Park',
        taxRate: 0.08,
        keyHighlights: [
          'Watch the sunset at Uluwatu Temple',
          'Traditional Kecak Fire Dance performance',
          'Surfing lessons at Padang Padang Beach',
          'Luxury safari tent accommodation'
        ],
        included: [
          'Accommodation (2 nights)',
          'All breakfasts and dinners',
          'Private 4x4 transport',
          'Dance show tickets'
        ],
        notIncluded: [
          'Airfare to Bali',
          'Personal insurance',
          'Alcoholic beverages'
        ],
        whatToBring: [
          'Swimwear',
          'Insect repellent',
          'Power bank',
          'Hiking boots'
        ],
        itinerary: [
          ItineraryDay(
            day: 'Day 1',
            title: 'Coastal Arrival',
            activities: ['Airport pickup', 'Check-in to Safari Camp', 'Welcome dinner'],
          ),
          ItineraryDay(
            day: 'Day 2',
            title: 'Temple & Dance',
            activities: ['Morning surf session', 'Visit Uluwatu Temple', 'Watch Kecak Dance'],
          ),
          ItineraryDay(
            day: 'Day 3',
            title: 'Nature Trek',
            activities: ['Guided forest hike', 'Traditional Balinese lunch', 'Departure'],
          ),
        ],
        meetingPoint: MeetingPoint(
          address: 'Ngurah Rai International Airport, Bali',
          description: 'Our representative will be waiting at the arrival gate with a name board.',
          mapImageUrl: 'https://images.unsplash.com/photo-1539367628448-4bc5c9d171c8?w=600',
        ),
      ),
      Tour(
        id: 'tour_003',
        title: 'Bali Temple & Beach Discovery',
        location: 'Bali, Indonesia',
        imageUrl: 'https://images.unsplash.com/photo-1537953773345-d172ccf13cf1?w=800&h=600&fit=crop',
        category: 'Beach',
        duration: '8 Hours',
        maxPeople: 12,
        price: 95.0,
        rating: 4.3,
        reviewsCount: 342,
        description: 'Discover the spiritual temples and pristine beaches of Bali. Visit Tanah Lot, Uluwatu Temple, and more.',
        buttonText: AppStrings.viewDetails,
        startTime: '08:00 AM',
        visitingPlaces: ['Tanah Lot Temple', 'Uluwatu Temple', 'Seminyak Beach'],
        keyHighlights: [
          'Visit the iconic Tanah Lot Temple at high tide',
          'Explore the cliff-side Uluwatu Temple',
          'Relax at the famous Seminyak Beach',
          'Traditional Balinese lunch included'
        ],
        included: [
          'Air-conditioned transportation',
          'Entrance fees to all temples',
          'Professional English-speaking guide',
          'Mineral water'
        ],
        notIncluded: [
          'Kecak Dance performance tickets',
          'Personal expenses',
          'Tips for the guide'
        ],
        whatToBring: [
          'Sarong (for temple entry)',
          'Sunglasses and Hat',
          'Sunscreen',
          'Comfortable sandals'
        ],
        itinerary: [
          ItineraryDay(
            day: 'Day 1',
            title: 'Hotel Pickup',
            activities: ['Pickup from Seminyak/Kuta area', 'Briefing by the guide'],
          ),
          ItineraryDay(
            day: 'Day 2',
            title: 'Tanah Lot Temple',
            activities: ['Explore the offshore temple', 'Walking around the coastal cliffs'],
          ),
          ItineraryDay(
            day: 'Day 3',
            title: 'Lunch & Seminyak Beach',
            activities: ['Authentic Balinese lunch', 'Relaxing time at the beach'],
          ),
          ItineraryDay(
            day: 'Day 4',
            title: 'Uluwatu Temple',
            activities: ['Visiting the cliff-top temple', 'Watching the sunset'],
          ),
        ],
        meetingPoint: MeetingPoint(
          address: 'Seminyak Square Main Entrance, Bali',
          description: 'Look for our guide wearing a yellow t-shirt near the main fountain.',
          mapImageUrl: 'https://images.unsplash.com/photo-1518548419970-286c1f59ad70?w=600',
        ),
      ),
      Tour(
        id: 'tour_004',
        title: 'Paris City Highlights & Eiffel Tower',
        location: 'Paris, France',
        imageUrl: 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=800&h=600&fit=crop',
        category: 'Culture',
        duration: 'Full Day',
        maxPeople: 15,
        price: 120.0,
        rating: 4.8,
        reviewsCount: 342,
        description: 'Explore the iconic landmarks of Paris including the Eiffel Tower, Louvre Museum, and Notre-Dame Cathedral.',
        buttonText: AppStrings.viewDetails,
        startTime: '10:00 AM',
        keyHighlights: [
          'Visit the summit of the Eiffel Tower',
          'Explore the masterpieces of the Louvre',
          'Admire the architecture of Notre-Dame',
          'Guided walk through the Latin Quarter'
        ],
        included: [
          'All entry tickets',
          'Certified local historian guide',
          'Headsets to hear the guide clearly',
          'Public transport pass for the day'
        ],
        notIncluded: [
          'Lunch and beverages',
          'Souvenir photos',
          'Hotel drop-off'
        ],
        whatToBring: [
          'Valid Passport or ID',
          'Comfortable walking shoes',
          'Raincoat or Umbrella',
          'Power bank'
        ],
        itinerary: [
          ItineraryDay(
            day: 'Day 1',
            title: 'Meeting at Louvre Museum',
            activities: ['Meet guide at the Pyramid', 'Priority entry and 2-hour guided tour'],
          ),
          ItineraryDay(
            day: 'Day 2',
            title: 'Lunch Break & Notre-Dame',
            activities: ['Free time for lunch near Seine', 'Guided exterior tour of the Cathedral'],
          ),
          ItineraryDay(
            day: 'Day 3',
            title: 'Eiffel Tower Experience',
            activities: ['Travel to the tower', 'Summit access for sunset views'],
          ),
        ],
        meetingPoint: MeetingPoint(
          address: 'Louvre Pyramid, 75001 Paris, France',
          description: 'The guide will be standing near the main glass pyramid holding a sign with the tour logo.',
          mapImageUrl: 'https://images.unsplash.com/photo-1550106631-0164c000300d?w=600',
        ),
      ),
      Tour(
        id: 'tour_005',
        title: 'Ubud Rice Terrace & Culture Tour',
        location: 'Ubud, Bali',
        imageUrl: 'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=800&h=600&fit=crop',
        category: 'Culture',
        duration: 'Full Day',
        maxPeople: 8,
        price: 120.0,
        rating: 3.9,
        reviewsCount: 342,
        description: 'Explore the famous rice terraces and local culture.',
        buttonText: AppStrings.viewDetails,
        startTime: '07:00 AM',
        destination: 'Tegalalang Rice Terraces',
        keyHighlights: [
          'Walk through the scenic Tegalalang Rice Terraces',
          'Visit the sacred Ubud Monkey Forest',
          'Traditional Balinese art market shopping',
          'Holy water purification at Tirta Empul Temple'
        ],
        included: [
          'Private air-conditioned SUV',
          'Ubud Monkey Forest entrance fee',
          'Local Balinese lunch',
          'Parking and petrol'
        ],
        notIncluded: [
          'Personal shopping expenses',
          'Alcoholic drinks',
          'Jungle Swing tickets'
        ],
        whatToBring: [
          'Comfortable walking shoes',
          'Modest clothing (for temples)',
          'Insect repellent',
          'Extra cash (for souvenirs)'
        ],
        itinerary: [
          ItineraryDay(
            day: 'Day 1',
            title: 'Hotel Pickup',
            activities: ['Direct transfer to Ubud', 'Scenic drive through local villages'],
          ),
          ItineraryDay(
            day: 'Day 2',
            title: 'Tegalalang Rice Terrace',
            activities: ['Guided trek through the terraces', 'Coffee tasting experience'],
          ),
          ItineraryDay(
            day: 'Day 3',
            title: 'Sacred Monkey Forest',
            activities: ['Observing monkeys in their habitat', 'Visiting the forest temple'],
          ),
          ItineraryDay(
            day: 'Day 4',
            title: 'Ubud Palace & Market',
            activities: ['Exploring royal architecture', 'Shopping for local handicrafts'],
          ),
        ],
        meetingPoint: MeetingPoint(
          address: 'Ubud Art Market Main Gate, Bali',
          description: 'Our guide will meet you at the main gate of the Ubud Art Market, holding a sign with your name.',
          mapImageUrl: 'https://images.unsplash.com/photo-1598948123440-9a8abc390294?w=600',
        ),
      ),
      Tour(
        id: 'tour_006',
        title: 'Nusa Penida Island Hopping',
        location: 'Nusa Penida, Bali',
        imageUrl: 'https://images.unsplash.com/photo-1606857521015-7f9fcf423740?w=800&h=600&fit=crop',
        category: 'Island',
        duration: '1 Day',
        maxPeople: 10,
        price: 180.0,
        rating: 4.8,
        reviewsCount: 342,
        description: 'Visit the most beautiful spots of Nusa Penida.',
        buttonText: AppStrings.bookTour,
        startTime: '06:30 AM',
        visitingPlaces: ['Kelingking Beach', 'Angel\'s Billabong', 'Crystal Bay'],
        keyHighlights: [
          'Photo session at the famous Kelingking T-Rex Cliff',
          'Swim in the natural infinity pool at Angel`s Billabong',
          'Snorkeling at Crystal Bay with colorful marine life',
          'Fast boat round-trip transfers from Sanur'
        ],
        included: [
          'Round-trip fast boat tickets',
          'Private car on the island with driver',
          'Snorkeling gear and boat',
          'Indonesian buffet lunch'
        ],
        notIncluded: [
          'Personal insurance',
          'Swimsuit and towel',
          'Extra snacks and drinks'
        ],
        whatToBring: [
          'Change of clothes',
          'Sunscreen and Hat',
          'Waterproof bag for phone',
          'Towel'
        ],
        itinerary: [
          ItineraryDay(
            day: 'Day 1',
            title: 'Meeting & Boarding',
            activities: ['Meet at Sanur Harbour', 'Fast boat departure to Nusa Penida'],
          ),
          ItineraryDay(
              day: 'Day 2',
              title: 'West Island Tour',
              activities: ['Visit Kelingking Beach', 'Exploring Broken Beach & Angel`s Billabong'],
          ),
          ItineraryDay(
            day: 'Day 3',
            title: 'Lunch & Snorkeling',
            activities: ['Buffet lunch at local restaurant', 'Snorkeling at Crystal Bay'],
          ),
          ItineraryDay(
            day: 'Day 4',
            title: 'Return to Mainland',
            activities: ['Board boat back to Sanur', 'Drop-off at hotel'],
          ),
        ],
        meetingPoint: MeetingPoint(
          address: 'Sanur Harbour, Jalan Hang Tuah, Bali',
          description: 'Meet our coordinator at the "Matahari Terbit" entrance near the ticket counter.',
          mapImageUrl: 'https://images.unsplash.com/photo-1559128010-7c1ad6e1b6a5?w=600',
        ),
      ),
      Tour(
        id: 'tour_007',
        title: 'Paris Romantic Seine River Cruise',
        location: 'Paris, France',
        imageUrl: 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=800&h=600&fit=crop',
        category: 'River Cruise',
        duration: '2 Hours',
        maxPeople: 20,
        price: 85.0,
        rating: 4.7,
        reviewsCount: 189,
        description: 'Enjoy a romantic evening cruise along the Seine River with breathtaking views of Paris landmarks including the Eiffel Tower and Notre-Dame. Perfect for couples and families.',
        buttonText: AppStrings.bookTour,
        startTime: '07:00 PM',
        destination: 'Seine River',
        visitingPlaces: ['Eiffel Tower (from river)', 'Notre-Dame Cathedral (from river)', 'Louvre Pyramid (from river)'],
        taxRate: 0.10,
        keyHighlights: [
          'Romantic sunset views of illuminated Paris monuments',
          'Audio guide in multiple languages',
          'Comfortable seating with blankets (evening cruises)',
          'On-board bar available (drinks not included)'
        ],
        included: [
          '1-hour Seine River cruise',
          'Audio commentary in 8 languages',
          'Free onboard Wi-Fi',
          'Blankets for evening cruises'
        ],
        notIncluded: [
          'Food and drinks',
          'Hotel pickup/drop-off',
          'Gratuities'
        ],
        whatToBring: [
          'Warm clothing (for evening cruises)',
          'Camera or smartphone',
          'Light jacket or scarf',
          'Cash or card for onboard bar'
        ],
        itinerary: [
          ItineraryDay(
            day: 'Day 1',
            title: 'Boarding & Departure',
            activities: ['Board at Pont de l\'Alma', 'Start cruise along the Seine'],
          ),
          ItineraryDay(
            day: 'Day 2',
            title: 'Paris Highlights from River',
            activities: ['Pass by Eiffel Tower', 'View Notre-Dame & Louvre from water'],
          ),
          ItineraryDay(
            day: 'Day 3',
            title: 'Return to Dock',
            activities: ['Complete loop', 'Disembark at same point'],
          ),
        ],
        meetingPoint: MeetingPoint(
          address: 'Pont de l\'Alma, Right Bank, 75008 Paris, France',
          description: 'Meet at the Bateaux Parisiens ticket office near Pont de l\'Alma. Look for the blue and white boats.',
          mapImageUrl: 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=600',
        ),
      ),

      Tour(
        id: 'tour_008',
        title: 'Versailles Palace Day Trip from Paris',
        location: 'Paris, France',
        imageUrl: 'https://images.unsplash.com/photo-1561501878-aabd62634533?w=800&h=600&fit=crop',
        category: 'Historical',
        duration: '8 Hours',
        maxPeople: 15,
        price: 110.0,
        rating: 4.6,
        reviewsCount: 245,
        description: 'Discover the opulent Versailles Palace and its magnificent gardens on this full-day guided tour from Paris. Skip-the-line access included.',
        buttonText: AppStrings.bookTour,
        startTime: '08:30 AM',
        destination: 'Palace of Versailles',
        visitingPlaces: ['Hall of Mirrors', 'King\'s Apartments', 'Gardens of Versailles', 'Marie Antoinette\'s Estate'],
        taxRate: 0.10,
        keyHighlights: [
          'Skip-the-line entry to Versailles Palace',
          'Expert English-speaking guide',
          'Round-trip transportation from Paris',
          'Free time to explore the gardens'
        ],
        included: [
          'Round-trip train tickets from Paris',
          'Skip-the-line entrance to Palace & Gardens',
          'Professional guided tour (2 hours)',
          'Headsets for clear audio'
        ],
        notIncluded: [
          'Lunch and personal expenses',
          'Hotel pickup/drop-off',
          'Gratuities (optional)'
        ],
        whatToBring: [
          'Comfortable walking shoes',
          'Water bottle',
          'Sunscreen and hat (summer)',
          'Valid ID/passport'
        ],
        itinerary: [
          ItineraryDay(
            day: 'Day 1',
            title: 'Departure from Paris',
            activities: ['Meet at central Paris point', 'Train to Versailles'],
          ),
          ItineraryDay(
            day: 'Day 2',
            title: 'Versailles Palace Tour',
            activities: ['Guided tour of Palace & Hall of Mirrors', 'Visit King & Queen apartments'],
          ),
          ItineraryDay(
            day: 'Day 3',
            title: 'Gardens & Return',
            activities: ['Explore gardens & fountains', 'Return train to Paris'],
          ),
        ],
        meetingPoint: MeetingPoint(
          address: 'Paris Montparnasse Station, 75015 Paris, France',
          description: 'Meet your guide at the main entrance of Montparnasse Station, near platform 5-24. Look for the guide holding a sign with the tour name.',
          mapImageUrl: 'https://images.unsplash.com/photo-1561501878-aabd62634533?w=600',
        ),
      ),
    ];

    allTours.assignAll(demoTours);
    filteredTours.assignAll(demoTours);
    isLoading.value = false;
  }

  // Subtotal (before tax)
  double calculateTotalAmount() {
    if (selectedTour.value == null) return 0.0;
    final adultPrice = selectedTour.value!.price * adultsCount.value;
    final childPrice = (selectedTour.value!.price * 0.5) * childrenCount.value;
    return adultPrice + childPrice;
  }

  // Tax calculation
  double calculateTax() {
    final subtotal = calculateTotalAmount();
    final rate = selectedTour.value?.taxRate ?? taxRate.value;
    return subtotal * rate;
  }

  // Grand total (subtotal + tax)
  double calculateGrandTotal() {
    return calculateTotalAmount() + calculateTax();
  }

  // BOOKING FLOW
  void proceedToPayment() {
    if (selectedDate.value == null) {
      SnackbarHelper.showWarning(
        AppStrings.selectDateError,
        title: AppStrings.error,
      );
      return;
    }
    Get.toNamed('/payment-tour');
  }

  void bookTour(Tour tour) {
    selectedTour.value = tour;
    resetPaymentSelection();
    Get.toNamed('/payment-tour');
  }

  void confirmBooking() {
    if (selectedTour.value == null) {
      SnackbarHelper.showWarning(
          'No tour selected',
          title: 'No Tour Selected'
      );
      return;
    }

    bookingReference.value = 'TB-${DateTime.now().millisecondsSinceEpoch}';
    bookedTour.value = selectedTour.value;
    _saveTourBookingToMyBookings();
  }

  void _saveTourBookingToMyBookings() {
    final tour = selectedTour.value;
    if (tour == null) return;

    final total = calculateGrandTotal();

    final dynamicImageUrl = tour.imageUrl.isNotEmpty
        ? tour.imageUrl
        : 'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=400';


    // USE BookingHelper
    final bookingToSave = BookingHelper.createTourBooking(
      tourName: tour.title,
      destination: tour.location,
      country: _extractCountryFromLocation(tour.location),
      startDate: selectedDate.value ?? DateTime.now(),
      endDate: _calculateEndDate(),
      totalPrice: total,
      travelers: adultsCount.value + childrenCount.value,
      imageUrl: dynamicImageUrl,
      tourDetails: {
        'tourId': tour.id,
        'category': tour.category,
        'duration': tour.duration,
        'maxPeople': tour.maxPeople,
        'price': tour.price,
        'rating': tour.rating,
        'reviewsCount': tour.reviewsCount,
        'description': tour.description,
        'startTime': tour.startTime,
        'destination': tour.destination,

        // Booking details
        'adults': adultsCount.value,
        'children': childrenCount.value,
        'selectedDate': selectedDate.value?.toIso8601String(),
        'subtotal': calculateTotalAmount(),
        'tax': calculateTax(),
        'taxRate': tour.taxRate,
        'paymentMethod': selectedPaymentMethod.value,
        'bookingReference': bookingReference.value,

        // Tour specifics
        'visitingPlaces': tour.visitingPlaces,
        'keyHighlights': tour.keyHighlights,
        'included': tour.included,
        'notIncluded': tour.notIncluded,
        'whatToBring': tour.whatToBring,

        'itinerary': tour.itinerary.map((day) => {
          'day': day.day,
          'title': day.title,
          'activities': day.activities,
        }).toList(),

        if (tour.meetingPoint != null)
          'meetingPoint': {
            'address': tour.meetingPoint!.address,
            'description': tour.meetingPoint!.description,
            'mapImageUrl': tour.meetingPoint!.mapImageUrl,
          },
      },
    );

    Get.find<MyBookingsController>().addBooking(bookingToSave);

    SnackbarHelper.showSuccess(
      'Your tour has been booked successfully!',
      title: 'Booking Confirmed',
    );
  }

// Helper method to extract country from location
  String _extractCountryFromLocation(String location) {
    // Location format: "City, Country"
    final parts = location.split(',');
    if (parts.length > 1) {
      return parts.last.trim();
    }

    // Fallback mapping
    final locationCountryMap = {
      'Paris': 'France',
      'Bali': 'Indonesia',
      'Uluwatu': 'Indonesia',
      'Ubud': 'Indonesia',
      'Nusa Penida': 'Indonesia',
    };

    for (var key in locationCountryMap.keys) {
      if (location.contains(key)) {
        return locationCountryMap[key]!;
      }
    }

    return 'International';
  }

// Helper method to calculate end date based on tour duration
  DateTime _calculateEndDate() {
    if (selectedDate.value == null) return DateTime.now();

    final tour = selectedTour.value;
    if (tour == null) return selectedDate.value!;

    // Parse duration string (e.g., "3 Days", "8 Hours", "Full Day")
    final duration = tour.duration.toLowerCase();

    if (duration.contains('day')) {
      final daysMatch = RegExp(r'(\d+)').firstMatch(duration);
      if (daysMatch != null) {
        final days = int.parse(daysMatch.group(1)!);
        return selectedDate.value!.add(Duration(days: days));
      }
    }

    if (duration.contains('full day')) {
      return selectedDate.value!.add(Duration(days: 1));
    }

    if (duration.contains('hour')) {
      final hoursMatch = RegExp(r'(\d+)').firstMatch(duration);
      if (hoursMatch != null) {
        final hours = int.parse(hoursMatch.group(1)!);
        return selectedDate.value!.add(Duration(hours: hours));
      }
    }

    // Default: same day
    return selectedDate.value!;
  }

  void resetBooking() {
    selectedPaymentMethod.value = '';
    adultsCount.value = 1;
    childrenCount.value = 0;
    selectedTour.value = null;
    bookedTour.value = null;
    bookingReference.value = '';
  }

  // RESET METHODS
  void resetPaymentSelection() {
    selectedPaymentMethod.value = '';
  }

  // SEARCH & FILTER
  void filterTours() {
    if (searchQuery.value.trim().isEmpty) {
      filteredTours.assignAll(allTours);
    } else {
      final query = searchQuery.value.toLowerCase().trim();
      final result = allTours.where((tour) {
        return tour.title.toLowerCase().contains(query) ||
            tour.location.toLowerCase().contains(query) ||
            tour.category.toLowerCase().contains(query);
      }).toList();

      filteredTours.assignAll(result);
    }
  }

  // NAVIGATION
  void onTourTap(Tour tour) {
    selectedTour.value = tour;
    Get.toNamed('/tour-details');
  }
}