// 정보 확인용
import 'package:flutter/material.dart';
import '../services/location_service.dart';
import '../services/weather_service.dart';
import '../model/location_model.dart';
import '../model/weather_model.dart';

class MyInfo extends StatefulWidget {
  @override
  _MyInfoState createState() => _MyInfoState();
}

class _MyInfoState extends State<MyInfo> {
  final LocationService _locationService = LocationService();
  final WeatherService _weatherService = WeatherService();
  LocationModel? _location;
  Weather? _weather;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLocationAndWeather();
  }

  void _fetchLocationAndWeather() async {
    try {
      LocationModel? location = await _locationService.getCurrentLocation();
      if (location != null) {
        Weather weather = await _weatherService.fetchWeatherByCoordinates(
            location.latitude, location.longitude);
        setState(() {
          _location = location;
          _weather = weather;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching location or weather data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Info'),
        backgroundColor: Colors.blue,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _location == null || _weather == null
          ? Center(child: Text('Could not fetch location or weather data.'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Location Information',
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Latitude: ${_location!.latitude}'),
            Text('Longitude: ${_location!.longitude}'),
            SizedBox(height: 20),
            Text('Weather Information',
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Temperature: ${_weather!.temperature}°C'),
            Text('Feels Like: ${_weather!.feelsLike}°C'),
            Text('Humidity: ${_weather!.humidity}%'),
            Text('Condition: ${_weather!.description}'),
          ],
        ),
      ),
    );
  }
}
