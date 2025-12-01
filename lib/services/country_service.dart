import '../models/country.dart';
import './api_service.dart'; // Your friend's API
import './local_country_service.dart'; // Local backup

class CountryService {
  final ApiService _apiService = ApiService();
  final LocalCountryService _localService = LocalCountryService();

  Future<List<Country>> getAllCountries() async {
    print('🔄 Trying apicountries.com API...');

    try {
      // Try your friend's API first
      final countries = await _apiService.fetchCountries();

      if (countries.isNotEmpty) {
        print('✅ Successfully loaded ${countries.length} countries from apicountries.com');
        return countries;
      } else {
        print('⚠️ apicountries.com returned empty, using backup');
        return _localService.getAllCountries();
      }
    } catch (e) {
      print('❌ apicountries.com failed: $e');
      print('🔄 Falling back to local data...');

      // Fallback to local data
      return _localService.getAllCountries();
    }
  }

  Future<Country> getCountryByCode(String code) async {
    try {
      return await _apiService.getCountryByCode(code);
    } catch (e) {
      print('Error fetching country $code: $e');
      return _localService.getCountryByCode(code);
    }
  }
}