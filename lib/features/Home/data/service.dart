import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:grow/features/Home/data/modle/weather_modle.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  Future<WeatherModel?> getWeatherByLocation() async {
    try {
      // 1️⃣ التحقق من أذونات الموقع
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print("⚠️ خدمة الموقع غير مفعلة!");
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print("⚠️ تم رفض إذن الموقع!");
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print("🚨 الإذن مرفوض بشكل دائم!");
        return null;
      }

      // 2️⃣ الحصول على الموقع الحالي باستخدام settings
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high, // دقة عالية
        ),
      );

      double latitude = position.latitude;
      double longitude = position.longitude;

      print("📍 الموقع: ($latitude, $longitude)");

      // 3️⃣ طلب بيانات الطقس بناءً على الإحداثيات
      final response = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=9fc868456ce31966cb9564283db15c34&units=metric',
        ),
      );
       print("✅ بيانات الطقس المستلمة: ${response.body}");
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print("✅ بيانات الطقس: $data");
        return WeatherModel.fromJson(data);
      } else {
        print("❌ خطأ في الطلب: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("❌ استثناء: $e");
      return null;
    }
  }
}
