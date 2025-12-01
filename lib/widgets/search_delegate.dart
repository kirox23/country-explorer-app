import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/country_provider.dart';
import '../models/country.dart';

class CountrySearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    final countryProvider = Provider.of<CountryProvider>(context);

    // Filter countries based on query
    final List<Country> filtered = countryProvider.countries
        .where((country) =>
    country.name.toLowerCase().contains(query.toLowerCase()) ||
        country.capital.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (query.isEmpty) {
      return const Center(
        child: Text(
          'Type to search countries',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No results for "$query"',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final country = filtered[index];
        return ListTile(
          leading: Image.network(
            country.flag,
            width: 40,
            height: 30,
            fit: BoxFit.cover,
          ),
          title: Text(country.name),
          subtitle: Text(country.capital),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // Close search and navigate to detail screen
            close(context, country.code);
          },
        );
      },
    );
  }
}