import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BASE_URL = 'https://api.weatherapi.com/v1/current.json';
  // static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService({required this.apiKey});

  Future<Weather> getWeather(String cityName, BuildContext context) async {
    // final response = await http.get(Uri.parse('$BASE_URL?q=$cityName&units=metric&appid=$apiKey'));

    showDialog<void>(
      barrierColor: Colors.transparent,
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  // key: key,
                shadowColor: Colors.transparent,
                  backgroundColor: Colors.white,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        Lottie.asset('assets/loader.json', width: 100),
                        SizedBox(height: 10,),
                        Text("Please Wait....",style: TextStyle(color: Colors.black),)
                      ]),
                    )
                  ]));
        });
    final response = await http.get(Uri.parse('$BASE_URL?key=$apiKey&q=$cityName&aqi=no'));
    Future.delayed(Duration(seconds: 1,),(){
      Navigator.pop(context);
    });


    if(response.statusCode == 200){
      debugPrint(response.body);
      return Weather.fromJson(jsonDecode(response.body));
    }else{
      throw Exception('Failed to load weather data');
    }
  }

  Future<String> getCurrentCity() async {
    //get permission from user
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
    }

    //fetch the current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );

    //convert the location in list of placemark objects
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    //extract the city name from the first placemark
    String? city = placemarks[0].locality;

    return city ?? '';
  }

  getTime(String localtime){
    DateTime datetime = DateTime.parse('2023-11-03 02:59');
    String formattedTime = DateFormat.jm().format(datetime);
    return formattedTime;
  }


}