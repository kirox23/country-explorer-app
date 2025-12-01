import '../models/country.dart';

class LocalCountryService {
  Future<List<Country>> getAllCountries() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
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
      // Add more countries as needed...
    ];
  }

  Future<Country> getCountryByCode(String code) async {
    final countries = await getAllCountries();
    return countries.firstWhere(
          (c) => c.code == code,
      orElse: () => countries.first,
    );
  }
}