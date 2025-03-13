import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:grow/features/dashboard/presentation/views/dashboard_view.dart';
import 'package:grow/features/splach/presentation/views/splach_view.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true, // تأكد من تفعيل المعاينة
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: DevicePreview.appBuilder, // ربط التطبيق بـ DevicePreview
      debugShowCheckedModeBanner: false, // إخفاء شريط الـ debug
      home:SplachView(),
    );
  }
}


