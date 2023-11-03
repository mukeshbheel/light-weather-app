import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:light_weather_app/models/weather_model.dart';
import 'package:light_weather_app/pages/all_animations_page.dart';
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
      final weather = await _weatherService.getWeather(cityName, context);
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
      final weather = await _weatherService.getWeather(placeName, context);
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
    if(mainCondition.toLowerCase().contains('rain') && mainCondition.toLowerCase().contains('thunder')){
      return 'assets/rainthunder.json';
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
    if(mainCondition.toLowerCase().contains('blizzard')){
      return 'assets/snow.json';
    }
    if(mainCondition.toLowerCase().contains('ice pellets')){
      return 'assets/snow.json';
    }
    if(mainCondition.toLowerCase().contains('drizzle')){
      return 'assets/drizzle.json';
    }
    if(mainCondition.toLowerCase().contains('fog')){
      return 'assets/fog.json';
    }
    if(mainCondition.toLowerCase().contains('sleet')){
      return 'assets/sleet.json';
    }


    switch(mainCondition.toLowerCase()){
      case 'sunny':
        return 'assets/sunny.json';
      case 'overcast':
        return 'assets/cloud.json';
      case 'clear':
        return 'assets/clear.json';
      case 'mist':
        return 'assets/mist.json';
      default:
        return 'assets/clear.json';
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
          const Gap(50),
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
          const Gap(100,),


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
                      Text((_weather?.city ?? '').toUpperCase(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                          fontSize: 20
                        ),
                      ),
                      const Gap(10),
                      Text('${(_weather?.region ?? '')}${(_weather?.country != null ? ', ${_weather?.country}' : '')}${(_weather?.localtime != null ? ', ${_weather?.localtime}' : '')}',
                        style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                            fontSize: 14
                        ),
                      ),
                    ],
                  ),
                  const Gap(10),

                  //animation
                  if(_weather?.mainCondition != null)
                  SizedBox(height: 250 ,child: Lottie.asset(getWeatherAnimation(_weather?.mainCondition), fit: BoxFit.fitHeight)),
                  // SizedBox(height: 250 ,child: FittedBox(child: Lottie.asset('assets/sunny.json', fit: BoxFit.fill))),

                  const Gap(10),

                  Column(
                    children: [

                      InkWell(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AllAnimations(showNight: _weather?.isDay != null && _weather!.isDay ? false : true,)),
                          );
                        },
                        child: Text(_weather?.temperature != null ? '${_weather?.temperature.toDouble().round()}°C' : '',
                          style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                              fontSize: 25
                          ),
                        ),
                      ),
                      const Gap(10),
                      Text(_weather?.mainCondition ?? '',
                        style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                            fontSize: 16
                        ),
                      ),
                      const Gap(10),
                      Text('( Tap on temperature for bonus page )',
                        style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                            fontSize: 10
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
