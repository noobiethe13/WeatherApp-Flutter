import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../models/weather_model.dart';
import '../../../services/weather_service.dart';

class HomeController {
  final WeatherService _weatherService = WeatherService();

  //function to retrieve user's current location
  Future<String?> getCityName(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      // Check if location services are enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showToast('Location services are disabled. Please enable them in your device settings.');
        return null;
      }

      // Check location permission
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showToast('Location permissions are denied. Please allow access to your location.');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showToast('Location permissions are permanently denied. Please enable them in your app settings.');
        return null;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Get place mark from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      // Extract city name
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return place.locality;
      } else {
        _showToast('Unable to determine your city. Please enter it manually.');
        return null;
      }
    } catch (e) {
      _showToast('Error accessing location: ${e.toString()}');
      return null;
    }
  }

  //function to get weather data
  Future<WeatherModel?> getWeatherData(String cityName) async {
    try {
      WeatherModel weatherModel = await _weatherService.getWeather(cityName);
      return weatherModel;
    } catch (e) {
      _showToast('Error fetching weather data');
      print("ERROR: $e.toString()");
      return null;
    }
  }

  //show toasts for errors
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