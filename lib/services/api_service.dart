import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/country.dart';

class ApiService {
  static const String _baseUrl = 'https://www.apicountries.com';

  Future<List<Country>> fetchCountries() async {
    try {
      print('🌐 Calling API: $_baseUrl/countries');

      final url = Uri.parse('$_baseUrl/countries');
      final response = await http.get(url).timeout(const Duration(seconds: 30));

      print('📡 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print('✅ Successfully parsed ${data.length} countries from apicountries.com');

        if (data.isEmpty) {
          throw Exception('API returned empty list');
        }

        // Convert JSON to Country objects
        final List<Country> countries = [];
        for (var item in data) {
          try {
            final country = Country.fromJson(item as Map<String, dynamic>);

            // Only add if we have valid data
            if (country.name != 'Unknown' && country.code != 'XX') {
              countries.add(country);
            }
          } catch (e) {
            print('⚠️ Skipping invalid country data: $e');
          }
        }

        print('🎉 Loaded ${countries.length} valid countries');

        // Sort alphabetically
        countries.sort((a, b) => a.name.compareTo(b.name));

        return countries;
      } else {
        print('❌ API Error ${response.statusCode}: ${response.body}');
        throw Exception('Failed to load countries. Code: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Network error: $e');
      throw Exception('Error fetching countries: $e');
    }
  }

  Future<Country> getCountryByCode(String code) async {
    try {
      print('🌐 Fetching country details: $code');

      final url = Uri.parse('$_baseUrl/countries/$code');
      final response = await http.get(url).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);
        return Country.fromJson(data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to load country details');
      }
    } catch (e) {
      throw Exception('Error fetching country: $e');
    }
  }
}