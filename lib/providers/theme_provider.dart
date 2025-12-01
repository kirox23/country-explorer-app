import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  static const String _themeKey = 'theme_mode';

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString(_themeKey);

      if (savedTheme == 'dark') {
        _themeMode = ThemeMode.dark;
      } else if (savedTheme == 'light') {
        _themeMode = ThemeMode.light;
      } else {
        _themeMode = ThemeMode.system;
      }
      notifyListeners();
    } catch (e) {
      print('Error loading theme: $e');
    }
  }

  Future<void> _saveTheme(String theme) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeKey, theme);
    } catch (e) {
      print('Error saving theme: $e');
    }
  }

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    _saveTheme(isDark ? 'dark' : 'light');
    notifyListeners();
  }

  void setTheme(ThemeMode mode) {
    _themeMode = mode;
    _saveTheme(mode == ThemeMode.dark ? 'dark' : 'light');
    notifyListeners();
  }
}