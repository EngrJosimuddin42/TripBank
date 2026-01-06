import 'package:get/get.dart';

class ExploreController extends GetxController {
  var selectedTab = 0.obs;
  var searchQuery = ''.obs;

  final featuredDestinations = [
    {
      'name': 'Singapore Airlines',
      'location': 'Singapore',
      'rating': 4.8,
      'reviews': 234,
      'price': '\$850',
      'discount': '-25%',
      'isFavorite': false,
      'image': '',
    },
    {
      'name': 'Dubai',
      'location': 'UAE',
      'rating': 4.9,
      'reviews': 512,
      'price': '\$920',
      'discount': '-20%',
      'isFavorite': true,
      'image': '',
    },
    {
      'name': 'NYC',
      'location': 'New York',
      'rating': 4.7,
      'reviews': 890,
      'price': '\$1200',
      'discount': '-15%',
      'isFavorite': false,
      'image': '',
    },
    {
      'name': 'Louvre Museum',
      'location': 'Paris',
      'rating': 4.9,
      'reviews': 678,
      'price': '\$450',
      'discount': '-30%',
      'isFavorite': false,
      'image': '',
    },
  ].obs;

  final allDestinations = [
    {
      'name': 'Safari Adventure Experience',
      'location': 'Kenya',
      'rating': 4.6,
      'reviews': 123,
      'price': '\$650',
      'discount': '-18%',
      'isFavorite': false,
      'image': '',
    },
    {
      'name': 'Louvre Museum',
      'location': 'Paris',
      'rating': 4.8,
      'reviews': 456,
      'price': '\$400',
      'discount': '-22%',
      'isFavorite': true,
      'image': '',
    },
  ].obs;

  void selectTab(int index) {
    selectedTab.value = index;
  }

  void toggleFavorite(int index, bool isFeatured) {
    if (isFeatured) {
      featuredDestinations[index]['isFavorite'] =
      !(featuredDestinations[index]['isFavorite'] as bool);
      featuredDestinations.refresh();
    } else {
      allDestinations[index]['isFavorite'] =
      !(allDestinations[index]['isFavorite'] as bool);
      allDestinations.refresh();
    }
  }

  void searchDestinations(String query) {
    searchQuery.value = query;
  }
}
