import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/country.dart';

class CountryService {
  // Try different API endpoints
  static const String baseUrlV3 = 'https://restcountries.com/v3.1';
  static const String baseUrlV2 = 'https://restcountries.com/v2';

  Future<List<Country>> getAllCountries() async {
    try {
      print('Fetching countries from API...');

      // Try v3 endpoint first
      final response = await http.get(
        Uri.parse('$baseUrlV3/all'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      print('API Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('Successfully fetched ${data.length} countries');

        if (data.isEmpty) {
          throw Exception('No countries found in response');
        }

        return data.map((json) => Country.fromJson(json)).toList();
      } else {
        // If v3 fails, try v2 as backup
        print('Trying v2 endpoint...');
        final responseV2 = await http.get(
          Uri.parse('$baseUrlV2/all'),
          headers: {
            'Content-Type': 'application/json',
          },
        ).timeout(const Duration(seconds: 30));

        if (responseV2.statusCode == 200) {
          final List<dynamic> data = json.decode(responseV2.body);
          print('Successfully fetched ${data.length} countries from v2');
          return data.map((json) => Country.fromJson(json)).toList();
        } else {
          throw Exception('Failed to load countries: ${response.statusCode}');
        }
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: $e');
    } on FormatException catch (e) {
      throw Exception('Data format error: $e');
    } catch (e) {
      throw Exception('Error fetching countries: $e');
    }
  }

  Future<Country> getCountryByCode(String code) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrlV3/alpha/$code'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          return Country.fromJson(data.first);
        } else {
          throw Exception('Country not found');
        }
      } else {
        throw Exception('Failed to load country details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching country: $e');
    }
  }
}