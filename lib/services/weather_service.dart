import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../model/weather_model.dart';

class WeatherService {
  final String _apiKey = dotenv.env['openWeatherApiKey']!;
  final String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Weather> fetchWeather(String city) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl?q=$city&appid=$_apiKey&units=metric&lang=kr'));

      if (response.statusCode == 200) {
        print('Weather data fetched successfully');
        return Weather.fromJson(jsonDecode(response.body));
      } else {
        print('Failed to load weather data: ${response.statusCode}');
        throw Exception('Failed to load weather');
      }
    } catch (e) {
      print('Error fetching weather data: $e');
      throw Exception('Error fetching weather data');
    }
  }
  Future<Weather> fetchWeatherByCoordinates(double latitude, double longitude) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$_apiKey&units=metric'));
    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
