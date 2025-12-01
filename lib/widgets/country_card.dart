import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/country.dart';
import '../providers/favorites_provider.dart';

class CountryCard extends StatelessWidget {
  final Country country;
  final VoidCallback onTap;

  const CountryCard({
    super.key,
    required this.country,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesProvider>(
      builder: (context, favoritesProvider, child) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Flag
                      Container(
                        height: 80,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          image: DecorationImage(
                            image: NetworkImage(country.flag),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Country Name
                      Text(
                        country.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // Capital
                      Text(
                        'Capital: ${country.capital}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Heart icon
                Positioned(
                  top: 4,
                  right: 4,
                  child: IconButton(
                    icon: Icon(
                      favoritesProvider.isFavorite(country.code)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: favoritesProvider.isFavorite(country.code)
                          ? Colors.red
                          : Colors.grey,
                    ),
                    onPressed: () {
                      favoritesProvider.toggleFavorite(country.code);
                    },
                    padding: EdgeInsets.zero,
                    iconSize: 24,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}