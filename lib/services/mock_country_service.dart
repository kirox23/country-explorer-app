import '../models/country.dart';

class MockCountryService {
  Future<List<Country>> getAllCountries() async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));

    // Return mock data
    return [
      Country(
        name: 'United States',
        capital: 'Washington D.C.',
        flag: 'https://flagcdn.com/w320/us.png',
        region: 'Americas',
        population: 329484123,
        code: 'US',
      ),
      Country(
        name: 'France',
        capital: 'Paris',
        flag: 'https://flagcdn.com/w320/fr.png',
        region: 'Europe',
        population: 67391582,
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
        population: 212559409,
        code: 'BR',
      ),
      Country(
        name: 'Egypt',
        capital: 'Cairo',
        flag: 'https://flagcdn.com/w320/eg.png',
        region: 'Africa',
        population: 102334403,
        code: 'EG',
      ),
      Country(
        name: 'Australia',
        capital: 'Canberra',
        flag: 'https://flagcdn.com/w320/au.png',
        region: 'Oceania',
        population: 25687041,
        code: 'AU',
      ),
    ];
  }

  Future<Country> getCountryByCode(String code) async {
    final countries = await getAllCountries();
    final country = countries.firstWhere(
          (country) => country.code == code,
      orElse: () => countries.first,
    );
    return country;
  }
}