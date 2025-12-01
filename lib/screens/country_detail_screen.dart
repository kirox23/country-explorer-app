import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/country.dart';
import '../services/country_service.dart';
import '../providers/favorites_provider.dart';

class CountryDetailScreen extends StatefulWidget {
  final String countryCode;
  final Country? country;

  const CountryDetailScreen({
    super.key,
    required this.countryCode,
    this.country,
  });

  @override
  State<CountryDetailScreen> createState() => _CountryDetailScreenState();
}

class _CountryDetailScreenState extends State<CountryDetailScreen> {
  late Future<Country> _countryFuture;
  final CountryService _countryService = CountryService();

  @override
  void initState() {
    super.initState();
    if (widget.country != null) {
      _countryFuture = Future.value(widget.country!);
    } else {
      _countryFuture = _countryService.getCountryByCode(widget.countryCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Country Details'),
        actions: [
          Consumer<FavoritesProvider>(
            builder: (context, favoritesProvider, child) {
              return FutureBuilder<Country>(
                future: _countryFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final country = snapshot.data!;
                    return IconButton(
                      icon: Icon(
                        favoritesProvider.isFavorite(country.code)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: favoritesProvider.isFavorite(country.code)
                            ? Colors.red
                            : Colors.white,
                      ),
                      onPressed: () {
                        favoritesProvider.toggleFavorite(country.code);
                      },
                    );
                  }
                  return const SizedBox();
                },
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<Country>(
        future: _countryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text(
                    'Error loading country details',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Code: ${widget.countryCode}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _countryFuture = _countryService.getCountryByCode(widget.countryCode);
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No country data found'));
          }

          final country = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 200,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(country.flag),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        country.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Consumer<FavoritesProvider>(
                      builder: (context, favoritesProvider, child) {
                        return Icon(
                          favoritesProvider.isFavorite(country.code)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: favoritesProvider.isFavorite(country.code)
                              ? Colors.red
                              : Colors.grey,
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildDetailRow('Capital', country.capital),
                        _buildDetailRow('Region', country.region),
                        _buildDetailRow(
                          'Population',
                          country.population.toString(),
                        ),
                        _buildDetailRow('Country Code', country.code),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}