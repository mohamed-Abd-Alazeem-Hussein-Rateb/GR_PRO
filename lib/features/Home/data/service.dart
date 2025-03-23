import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:grow/features/Home/data/modle/weather_modle.dart';

class WeatherService {
  final Dio _dio = Dio();

  Future<WeatherModel?> getWeatherByLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print("\u26A0\uFE0F خدمة الموقع غير مفعلة!");
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print("\u26A0\uFE0F تم رفض إذن الموقع!");
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print("\uD83D\uDEA8 الإذن مرفوض بشكل دائم!");
        return null;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      double latitude = position.latitude;
      double longitude = position.longitude;

      print("\uD83D\uDCCD الموقع: ($latitude, $longitude)");

      final response = await _dio.get(
        'https://api.openweathermap.org/data/2.5/weather',
        queryParameters: {
          'lat': latitude,
          'lon': longitude,
          'appid': '9fc868456ce31966cb9564283db15c34',
          'units': 'metric',
        },
      );

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(response.data);
      } else {
        print("❌ خطأ في الاستجابة: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("❌ استثناء: $e");
      return null;
    }
  }
}
