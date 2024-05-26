// screen2가 비어있길래 날씨정보 표시하는거 테스트로 해봤어요..

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../services/weather_service.dart';
import '../model/weather_model.dart';

class Screen2 extends StatefulWidget {
  const Screen2({super.key});

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  Future<Weather>? futureWeather;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    try {
      await dotenv.load();
      print('Environment variables loaded');
      setState(() {
        futureWeather = WeatherService().fetchWeather('Seoul');
      });
    } catch (e) {
      print('Failed to load environment variables: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Information'),
      ),
      body: Center(
        child: futureWeather == null
            ? const CircularProgressIndicator()
            : FutureBuilder<Weather>(
          future: futureWeather,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Description: ${snapshot.data!.description}',
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    'Temperature: ${snapshot.data!.temperature}°C',
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              );
            } else {
              return const Text('No data');
            }
          },
        ),
      ),
    );
  }
}
