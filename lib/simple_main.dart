import 'package:flutter/material.dart';

// Simple Country model
class Country {
  final String name;
  final String capital;
  final String flag;
  final String region;
  final int population;
  final String code;

  Country({
    required this.name,
    required this.capital,
    required this.flag,
    required this.region,
    required this.population,
    required this.code,
  });
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Country Explorer',
      home: const SimpleCountryScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SimpleCountryScreen extends StatelessWidget {
  const SimpleCountryScreen({super.key});

  // Local hardcoded data
  final List<Country> countries = const [
    Country(
      name: 'United States',
      capital: 'Washington D.C.',
      flag: 'https://flagcdn.com/w320/us.png',
      region: 'Americas',
      population: 331002651,
      code: 'US',
    ),
    Country(
      name: 'France',
      capital: 'Paris',
      flag: 'https://flagcdn.com/w320/fr.png',
      region: 'Europe',
      population: 65273511,
      code: 'FR',
    ),
    Country(
      name: 'Japan',
      capital: 'Tokyo',
      flag: 'https://flagcdn.com/w320/jp.png',
      region: 'Asia',
      population: 125836021,
      code: 'JP',
    ),
    Country(
      name: 'Brazil',
      capital: 'Brasília',
      flag: 'https://flagcdn.com/w320/br.png',
      region: 'Americas',
      population: 212559417,
      code: 'BR',
    ),
    Country(
      name: 'Egypt',
      capital: 'Cairo',
      flag: 'https://flagcdn.com/w320/eg.png',
      region: 'Africa',
      population: 102334404,
      code: 'EG',
    ),
    Country(
      name: 'Australia',
      capital: 'Canberra',
      flag: 'https://flagcdn.com/w320/au.png',
      region: 'Oceania',
      population: 25499884,
      code: 'AU',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Country Explorer - SIMPLE'),
      ),
      body: GridView.builder(
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
          return Card(
            elevation: 2,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      appBar: AppBar(title: Text(country.name)),
                      body: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(country.flag, width: 200),
                            const SizedBox(height: 20),
                            Text('Capital: ${country.capital}'),
                            Text('Population: ${country.population}'),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    Text(
                      country.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Capital: ${country.capital}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}