part of 'cubits_cubit.dart';

@immutable
sealed class CubitsState {}

final class CubitsInitial extends CubitsState {}

final class WeatherLoading extends CubitsState {}

final class WeatherLoaded extends CubitsState {
  final WeatherModel? weatherModel;
  WeatherLoaded(this.weatherModel);
}

final class WeatherError extends CubitsState {
  final String error;
  WeatherError( this.error);
}
