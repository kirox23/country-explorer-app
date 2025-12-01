import 'package:flutter/foundation.dart';
import '../models/country.dart';
import '../services/country_service.dart';

class CountryProvider with ChangeNotifier {
  final CountryService _countryService = CountryService();

  List<Country> _countries = [];
  List<Country> _filteredCountries = [];
  bool _isLoading = false;
  String _error = '';

  List<Country> get countries => _filteredCountries;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> loadCountries() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      print('🔄 Loading countries...');
      _countries = await _countryService.getAllCountries();
      _filteredCountries = _countries;
      print('✅ Successfully loaded ${_countries.length} countries');
    } catch (e) {
      print('❌ Error: $e');
      _error = 'Failed to load countries. Please check your internet connection.';
      _countries = [];
      _filteredCountries = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ADD THIS SEARCH METHOD:
  void searchCountries(String query) {
    if (query.isEmpty) {
      _filteredCountries = _countries;
    } else {
      _filteredCountries = _countries.where((country) {
        return country.name.toLowerCase().contains(query.toLowerCase()) ||
            (country.capital?.toLowerCase() ?? '').contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }
}