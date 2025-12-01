import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider with ChangeNotifier {
  List<String> _favoriteCountryCodes = [];

  List<String> get favoriteCountryCodes => _favoriteCountryCodes;

  FavoritesProvider() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _favoriteCountryCodes = prefs.getStringList('favorite_countries') ?? [];
      notifyListeners();
    } catch (e) {
      print('Error loading favorites: $e');
    }
  }

  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('favorite_countries', _favoriteCountryCodes);
    } catch (e) {
      print('Error saving favorites: $e');
    }
  }

  bool isFavorite(String countryCode) {
    return _favoriteCountryCodes.contains(countryCode);
  }

  Future<void> toggleFavorite(String countryCode) async {
    if (isFavorite(countryCode)) {
      _favoriteCountryCodes.remove(countryCode);
    } else {
      _favoriteCountryCodes.add(countryCode);
    }
    await _saveFavorites();
    notifyListeners();
  }

  Future<void> clearFavorites() async {
    _favoriteCountryCodes.clear();
    await _saveFavorites();
    notifyListeners();
  }
}