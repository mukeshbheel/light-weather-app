import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:light_weather_app/models/weather_model.dart';
import 'package:light_weather_app/services/weather_service.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  final WeatherService _weatherService = WeatherService(apiKey: 'cc55e809e04874a1b39736b293cb7b21');
  Weather? _weather;

  final TextEditingController _placeController = TextEditingController();

  _fetchWeather()async {
    //get the current city
    String cityName = await _weatherService.getCurrentCity();

    //get weather for city
    try{
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }

    //any error
    catch(e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  fetchWeatherForSearch(String placeName) async{
    try{
      final weather = await _weatherService.getWeather(placeName);
      setState(() {
        _weather = weather;
      });
    }

    //any error
    catch(e){
      if (kDebugMode) {
        print(e);
      }
    }

  }

  String getWeatherAnimation(String? mainCondition){
    if(mainCondition == null) return 'assets/sunny.json';

    switch(mainCondition.toLowerCase()){
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(242, 239, 239, 1),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(height: 50,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                        controller: _placeController,
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16
                        ),
                        onTapOutside: (e)=> FocusScope.of(context).unfocus(),
                        onSubmitted: (s){
                          if(_placeController.text.trim().isNotEmpty) {
                            fetchWeatherForSearch(_placeController.text.trim());
                          }
                        },
                        decoration: const InputDecoration(
                          hintText: 'Search for a place',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                            fontSize: 16
                          ),
                        ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    if(_placeController.text.trim().isNotEmpty) {
                      fetchWeatherForSearch(_placeController.text.trim());
                    }
                  },
                  child: SizedBox(
                    child: Lottie.asset('assets/searchIcon.json', width: 100),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    _placeController.clear();
                    _fetchWeather();
                  },
                  child: SizedBox(
                    child: Lottie.asset('assets/clearIcon.json', width: 30),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 100,),


          // SizedBox(
          //   width: 300,
          //   child: TextField(
          //     controller: _placeController,
          //     decoration: InputDecoration(
          //       hintText: 'Search for a place'
          //     ),
          //   ),
          // ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Lottie.asset('assets/locationIcon.json', width: 30),
                      Text((_weather?.city ?? 'loading city..').toUpperCase(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                          fontSize: 20
                        ),
                      ),
                    ],
                  ),

                  //animation
                  Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

                  Column(
                    children: [

                      Text(_weather?.temperature != null ? '${_weather?.temperature.toDouble().round()}°C' : 'loading temperature..',
                        style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                            fontSize: 25
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Text(_weather?.mainCondition ?? '',
                        style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                            fontSize: 16
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
