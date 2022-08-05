import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../models/weather_models.dart';

const String _apiKey = "1d1c851523aa10948cdea3bf1ab1922d";

class WeatherService {
  Future<WeatherModel> fetchWeatherInformation(String cityName) async {
    final Uri url = Uri(
      scheme: "https",
      host: "api.openweathermap.org",
      path: "data/2.5/weather",
      queryParameters: {"q": cityName, 'appid': _apiKey, "units": "metric"},
    );
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      return WeatherModel.fromJson(response.body);
    } else {
      throw Exception('Failed to load weather information');
    }
  }

  Future<WeatherModel> fetchWeatherInformationGeolocation(Position pos) async {
    final Uri url = Uri(
      scheme: "https",
      host: "api.openweathermap.org",
      path: "data/2.5/weather",
      queryParameters: {
        "lat": pos.latitude.toString(),
        "lon": pos.longitude.toString(),
        'appid': _apiKey,
        "units": "metric"
      },
    );
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      return WeatherModel.fromJson(response.body);
    } else {
      throw Exception('Failed to load weather information');
    }
  }
}
