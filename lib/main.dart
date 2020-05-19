import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:simple_weather/api/api.dart';
import 'package:simple_weather/app/app.dart';
import 'package:simple_weather/service/service.dart';

void main() {
  final httpClient = http.Client();
  final weatherApiClient = MetaWeatherApiClient(httpClient: httpClient);
  final weatherService = WeatherService(weatherApiClient: weatherApiClient);
  runApp(WeatherApp(weatherService: weatherService));
}
