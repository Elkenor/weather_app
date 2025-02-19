import 'package:flutter/material.dart';
import 'services/weather_service.dart';
import 'models/weather.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();
  Weather? _weather;
  bool _isLoading = false;

  void _fetchWeather() async {
    setState(() {
      _isLoading = true;
    });
    try {
      Weather weather = await WeatherService().fetchWeather(_cityController.text);
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to fetch weather data'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'Enter city name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchWeather,
              child: Text('Get Weather'),
            ),
            SizedBox(height: 16),
            _isLoading
                ? CircularProgressIndicator()
                : _weather != null
                ? Column(
              children: [
                Text(
                  'Temperature: ${_weather!.temperature}°C',
                  style: TextStyle(fontSize: 24),
                ),
                Text(
                  'Description: ${_weather!.description}',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            )
                : Container(),
          ],
        ),
      ),
    );
  }
}
