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
        title: Text('My Info', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.blue,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.lightBlue,))
          : _location == null || _weather == null
          ? Center(child: Text('Could not fetch location or weather data.'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('나의 위치',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text('위도: ${_location!.latitude}'),
              Text('경도: ${_location!.longitude}'),
              SizedBox(height: 20),
              Text('지금 날씨',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text('온도: ${_weather!.temperature}°C'),
              Text('체감온도: ${_weather!.feelsLike}°C'),
              Text('습도: ${_weather!.humidity}%'),
              Text('날씨: ${_weather!.description}'),
            ],
          ),
        ),
      ),
    );
  }
}
