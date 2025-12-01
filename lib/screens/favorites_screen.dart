import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/country_provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/country_card.dart';
import 'country_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final countryProvider = Provider.of<CountryProvider>(context);

    // Get favorite countries by filtering from all countries
    final favoriteCountries = countryProvider.countries
        .where((country) => favoritesProvider.isFavorite(country.code))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Countries'),
        actions: [
          if (favoriteCountries.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Clear All Favorites'),
                    content: const Text(
                        'Are you sure you want to remove all favorite countries?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          favoritesProvider.clearFavorites();
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Clear All',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
              tooltip: 'Clear all favorites',
            ),
        ],
      ),
      body: favoriteCountries.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No favorite countries yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Tap the heart icon on countries to add them here',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      )
          : GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        itemCount: favoriteCountries.length,
        itemBuilder: (context, index) {
          final country = favoriteCountries[index];
          return CountryCard(
            country: country,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CountryDetailScreen(
                    countryCode: country.code,
                    country: country,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}