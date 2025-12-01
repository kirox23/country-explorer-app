import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/country_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/country_card.dart';
import 'country_detail_screen.dart';
import 'favorites_screen.dart';

class CountryListScreen extends StatefulWidget {
  const CountryListScreen({super.key});

  @override
  State<CountryListScreen> createState() => _CountryListScreenState();
}

class _CountryListScreenState extends State<CountryListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CountryProvider>(context, listen: false).loadCountries();
    });
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    Provider.of<CountryProvider>(context, listen: false)
        .searchCountries(_searchController.text);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Country Explorer'),
        actions: [
          // Theme toggle
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return IconButton(
                icon: Icon(
                  themeProvider.isDarkMode
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
                onPressed: () {
                  themeProvider.toggleTheme(!themeProvider.isDarkMode);
                },
                tooltip: 'Toggle theme',
              );
            },
          ),
          // Favorites button with badge
          Consumer<FavoritesProvider>(
            builder: (context, favoritesProvider, child) {
              final favoriteCount = favoritesProvider.favoriteCountryCodes.length;
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.favorite),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FavoritesScreen(),
                        ),
                      );
                    },
                  ),
                  if (favoriteCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          favoriteCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search countries...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[800]
                    : Colors.white.withOpacity(0.9),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: (value) {
                Provider.of<CountryProvider>(context, listen: false)
                    .searchCountries(value);
              },
            ),
          ),
        ),
      ),
      body: Consumer<CountryProvider>(
        builder: (context, countryProvider, child) {
          if (countryProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (countryProvider.error.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${countryProvider.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: countryProvider.loadCountries,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final countries = countryProvider.countries;

          if (_searchController.text.isNotEmpty && countries.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'No countries found for "${_searchController.text}"',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      _searchController.clear();
                      countryProvider.searchCountries('');
                    },
                    child: const Text('Clear Search'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => countryProvider.loadCountries(),
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: countries.length,
              itemBuilder: (context, index) {
                final country = countries[index];
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
        },
      ),
    );
  }
}