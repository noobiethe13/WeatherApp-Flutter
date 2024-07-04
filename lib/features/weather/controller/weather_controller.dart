import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:weatherapp/services/weather_service.dart';

import '../../../models/weather_model.dart';

class WeatherController{
  final WeatherService _weatherService = WeatherService();

  //function to get weather data
  Future<WeatherModel?> getWeatherData(String cityName) async {
    try {
      WeatherModel weatherModel = await _weatherService.getWeather(cityName);
      return weatherModel;
    } catch (e) {
      _showToast('Error fetching weather data');
      print(e.toString());
      return null;
    }
  }

  //function display toasts for errors
  void _showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}