class Weather {
  final String city;
  final String region;
  final String country;
  final String localtime;
  final double temperature;
  final String mainCondition;
  final bool isDay;

  Weather({
    required this.city,
    required this.region,
    required this.country,
    required this.localtime,
    required this.temperature,
    required this.mainCondition,
    required this.isDay,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json['location']['name'],
      region: json['location']['region'],
      country: json['location']['country'],
      localtime: json['location']['localtime'],
      temperature: double.parse(json['current']['temp_c'].toString()),
      mainCondition: json['current']['condition']['text'],
      isDay: json['current']['is_day'] == 1,
    );
  }
}
