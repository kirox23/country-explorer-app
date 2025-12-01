class Country {
  final String name;
  final String capital;
  final String flag;
  final String region;
  final int population;
  final String code;

  Country({
    required this.name,
    required this.capital,
    required this.flag,
    required this.region,
    required this.population,
    required this.code,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    // Get country code (try different field names)
    String getCode() {
      if (json['code'] != null) return json['code'].toString().toUpperCase();
      if (json['cca2'] != null) return json['cca2'].toString().toUpperCase();
      if (json['alpha2Code'] != null) return json['alpha2Code'].toString().toUpperCase();
      if (json['iso2'] != null) return json['iso2'].toString().toUpperCase();
      return 'XX';
    }

    final code = getCode();

    // Generate flag URL from code
    final flag = code != 'XX'
        ? 'https://flagcdn.com/w320/${code.toLowerCase()}.png'
        : 'https://flagcdn.com/w320/un.png'; // UN flag as fallback

    // Get name
    String getName() {
      if (json['name'] is String) return json['name'];
      if (json['name'] is Map) {
        return json['name']['common'] ??
            json['name']['official'] ??
            'Unknown';
      }
      return 'Unknown';
    }

    // Get capital
    String getCapital() {
      if (json['capital'] is String) return json['capital'];
      if (json['capital'] is List && (json['capital'] as List).isNotEmpty) {
        return (json['capital'] as List).first.toString();
      }
      return 'No Capital';
    }

    // Get region
    final region = json['region']?.toString() ??
        json['continent']?.toString() ??
        'Unknown';

    // Get population
    int getPopulation() {
      if (json['population'] is int) return json['population'];
      if (json['population'] is String) {
        return int.tryParse(json['population']) ?? 0;
      }
      return 0;
    }

    return Country(
      name: getName(),
      capital: getCapital(),
      flag: flag,
      region: region,
      population: getPopulation(),
      code: code,
    );
  }
}