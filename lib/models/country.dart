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
    return Country(
      name: json['name']['common'] ?? 'Unknown',
      capital: (json['capital'] as List?)?.first ?? 'No Capital',
      flag: json['flags']['png'] ?? '',
      region: json['region'] ?? 'Unknown',
      population: json['population'] ?? 0,
      code: json['cca2'] ?? '',
    );
  }
}