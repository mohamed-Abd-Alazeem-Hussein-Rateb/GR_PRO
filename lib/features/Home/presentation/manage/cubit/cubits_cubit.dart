import 'package:bloc/bloc.dart';
import 'package:grow/features/Home/data/modle/weather_modle.dart';
import 'package:grow/features/Home/data/service.dart';
import 'package:meta/meta.dart';

part 'cubits_state.dart';

class WeatherCubit extends Cubit<CubitsState> {
  WeatherCubit(this.weatherservice) : super(CubitsInitial());
  final WeatherService weatherservice;

  Future<void> getWeather() async {
    emit(WeatherLoading());
    try {
      final weather = await weatherservice.getWeatherByLocation();
      if (weather != null) {
         print("✅ بيانات الطقس المستلمة: ${weather.toString()}");
        emit(WeatherLoaded(weather));
      } else {
        // Handle the case where weather is null
        emit(WeatherError('Weather data is not available'));
      }
    } catch (e) {
      emit(WeatherError(e.toString()));
    }
  }
}
