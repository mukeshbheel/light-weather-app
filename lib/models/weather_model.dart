class Weather {
  final String city;
  final double temperature;
  final String mainCondition;
  final bool isDay;

  Weather({
    required this.city,
    required this.temperature,
    required this.mainCondition,
    required this.isDay,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json['location']['name'],
      temperature: double.parse(json['current']['temp_c'].toString()),
      mainCondition: json['current']['condition']['text'],
      isDay: json['current']['is_day'] == 1,
    );
  }
}
