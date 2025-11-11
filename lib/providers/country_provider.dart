import 'package:flutter/foundation.dart';
import '../models/country.dart';
import '../services/country_service.dart';
import '../services/mock_country_service.dart'; // Add this import

class CountryProvider with ChangeNotifier {
  // Use real service first, fallback to mock
  final CountryService _countryService = CountryService();
  final MockCountryService _mockService = MockCountryService();

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
      print('Loading countries from real API...');
      _countries = await _countryService.getAllCountries();
      _filteredCountries = _countries;
      _error = '';
      print('Successfully loaded ${_countries.length} countries');
    } catch (e) {
      print('Real API failed: $e');
      print('Trying mock data...');

      // Fallback to mock data
      try {
        _countries = await _mockService.getAllCountries();
        _filteredCountries = _countries;
        _error = '';
        print('Successfully loaded ${_countries.length} mock countries');
      } catch (mockError) {
        _error = 'Failed to load countries. Using mock data also failed: $mockError';
        _countries = [];
        _filteredCountries = [];
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterCountries(String query) {
    if (query.isEmpty) {
      _filteredCountries = _countries;
    } else {
      _filteredCountries = _countries.where((country) =>
          country.name.toLowerCase().contains(query.toLowerCase())
      ).toList();
    }
    notifyListeners();
  }
}