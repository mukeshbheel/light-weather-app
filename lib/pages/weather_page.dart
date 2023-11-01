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

  final WeatherService _weatherService = WeatherService(apiKey: 'c5a18daed22e4415bd050640230111');
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
    if(mainCondition.toLowerCase().contains('cloud')){
      return 'assets/cloud.json';
    }
    if(mainCondition.toLowerCase().contains('rain')){
      return 'assets/rain.json';
    }
    if(mainCondition.toLowerCase().contains('thunder')){
      return 'assets/thunder.json';
    }
    if(mainCondition.toLowerCase().contains('snow')){
      return 'assets/snow.json';
    }


    switch(mainCondition.toLowerCase()){
      case 'clouds':
      case 'partly cloudy':
      case 'overcast':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
      case 'freezing fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'patchy rain nearby':
      case 'drizzle':
      case 'patchy light drizzle':
      case 'light drizzle':
      case 'shower rain':
      case 'patchy snow nearby':
      case 'blowing snow':
      case 'patchy freezing drizzle nearby':
        return 'assets/rain.json';
      case 'thunderstorm':
      case 'thundery outbreaks in nearby':
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
      backgroundColor:  Color.fromRGBO(242, 239, 239, (_weather != null && _weather!.isDay) ? 1: 0),
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
                        style: TextStyle(
                            color: _weather != null && _weather!.isDay ? Colors.black : Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16
                        ),
                        onTapOutside: (e)=> FocusScope.of(context).unfocus(),
                        onSubmitted: (s){
                          if(_placeController.text.trim().isNotEmpty) {
                            fetchWeatherForSearch(_placeController.text.trim());
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Search for a place',
                          hintStyle: TextStyle(
                            color: _weather != null && _weather!.isDay ? Colors.grey : Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: _weather != null && _weather!.isDay ? Colors.black : Colors.white
                            )
                          ),
                          disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: _weather != null && _weather!.isDay ? Colors.black : Colors.white
                              )
                          ),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: _weather != null && _weather!.isDay ? Colors.black : Colors.white
                              )
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: _weather != null && _weather!.isDay ? Colors.black : Colors.white
                              )
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
                    child:_weather != null && _weather!.isDay ? Lottie.asset('assets/searchIcon.json', width: 100,) : Lottie.asset('assets/nightSearchIcon.json', width: 100,),
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
                      _weather != null && _weather!.isDay ? Lottie.asset('assets/locationIcon.json', width: 30) : Lottie.asset('assets/nightLocationIcon.json', width: 30),
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
