class Weather {
  final String city;
  final double temperature;
  final String mainCondition;

  Weather({
    required this.city,
    required this.temperature,
    required this.mainCondition,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json['name'],
      temperature: double.parse(json['main']['temp'].toString()),
      mainCondition: json['weather'][0]['main'],
    );
  }
}
