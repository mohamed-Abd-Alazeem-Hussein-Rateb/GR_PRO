import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart'; // ✅ إضافة Firebase
import 'package:grow/features/Home/data/service.dart';
import 'package:grow/features/Home/presentation/manage/cubit/cubits_cubit.dart';
import 'package:grow/features/splach/presentation/views/splach_view.dart';
import 'firebase_options.dart'; // ✅ استيراد الإعدادات التي تم إنشاؤها تلقائيًا

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ التأكد من تهيئة Flutter قبل تشغيل Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // ✅ تهيئة Firebase بناءً على المنصة
  );

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
    return BlocProvider(
      create: (context) => WeatherCubit(WeatherService())..getWeather(), // ✅ Cubit للطقس
      child: MaterialApp(
        builder: DevicePreview.appBuilder,
        debugShowCheckedModeBanner: false,
        home: SplachView(),
      ),
    );
  }
}
