import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather_app/models/weather_models.dart';
import 'package:flutter_weather_app/services/weather_service.dart';
import 'package:flutter_weather_app/states/weather_state.dart';
import 'package:geolocator/geolocator.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit() : super(WeatherLoading());

  Future<void> fetchWeather(String cityName) async {
    WeatherService weatherService = WeatherService();
    emit(WeatherLoading());
    try {
      WeatherModel weatherModel =
          await weatherService.fetchWeatherInformation(cityName);
      emit(WeatherLoaded(weatherModel: weatherModel));
    } catch (e) {
      emit(WeatherError(errorMessage: e.toString()));
    }
  }

  Future<void> fetchWeatherByLongLat(Position pos) async {
    WeatherService weatherService = WeatherService();
    emit(WeatherLoading());
    try {
      WeatherModel weatherModel =
          await weatherService.fetchWeatherInformationGeolocation(pos);
      emit(WeatherLoaded(weatherModel: weatherModel));
    } catch (e) {
      emit(WeatherError(errorMessage: e.toString()));
    }
  }
}
