import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/country_provider.dart';
import '../widgets/country_card.dart';
import '../widgets/search_delegate.dart';
import 'country_detail_screen.dart';

class CountryListScreen extends StatefulWidget {
  const CountryListScreen({super.key});

  @override
  State<CountryListScreen> createState() => _CountryListScreenState();
}

class _CountryListScreenState extends State<CountryListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CountryProvider>(context, listen: false).loadCountries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Country Explorer'),
        actions: [
          // Search button
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CountrySearchDelegate(),
              ).then((countryCode) {
                if (countryCode != null && countryCode.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CountryDetailScreen(
                        countryCode: countryCode,
                      ),
                    ),
                  );
                }
              });
            },
          ),
        ],
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
              itemCount: countryProvider.countries.length,
              itemBuilder: (context, index) {
                final country = countryProvider.countries[index];
                return CountryCard(
                  country: country,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CountryDetailScreen(
                          countryCode: country.code,
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