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
      _countries = await _countryService.getAllCountries();
      _filteredCountries = _countries;
      _error = '';
    } catch (e) {
      _error = e.toString();
      _countries = [];
      _filteredCountries = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchCountries(String query) {
    if (query.isEmpty) {
      _filteredCountries = _countries;
    } else {
      _filteredCountries = _countries.where((country) {
        return country.name.toLowerCase().contains(query.toLowerCase()) ||
            country.capital.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  // Optional: Add sorting for BON-04
  void sortCountries(String sortBy) {
    switch (sortBy) {
      case 'name':
        _filteredCountries.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'population':
        _filteredCountries.sort((a, b) => b.population.compareTo(a.population));
        break;
      case 'region':
        _filteredCountries.sort((a, b) => a.region.compareTo(b.region));
        break;
    }
    notifyListeners();
  }
}