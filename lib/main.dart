import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grow/features/Home/data/service.dart';
import 'package:grow/features/Home/presentation/manage/cubit/cubits_cubit.dart';
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
    return BlocProvider(
      create: (context) => WeatherCubit(WeatherService())..getWeather(), // ✅ تعديل هنا
      child: MaterialApp(
        builder: DevicePreview.appBuilder,
        debugShowCheckedModeBanner: false,
        home: SplachView(),
      ),
    );
  }
}
