import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grow/features/Home/presentation/manage/cubit/cubits_cubit.dart';
import 'package:grow/features/Home/presentation/views/widgets/weather_body_cubit.dart';

class WeatherBody extends StatelessWidget {
  const WeatherBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherCubit, CubitsState>(
      builder: (context, state) {
        if (state is WeatherLoading) {
          return Center(child: const CircularProgressIndicator());
        } else if (state is WeatherLoaded) {
          return WeatherBodyCubit(weather: state.weatherModel!);
        } else if (state is WeatherError) {
          return const Text('error');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
