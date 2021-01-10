import 'package:flutter/material.dart';
import 'package:weather_forecaster/views/forecast_view.dart';

void main() {
  runApp(MaterialApp(
    home: ForecastView(),
    theme: ThemeData(
      backgroundColor: Colors.blueGrey,
      primaryColor: Colors.blue,
      accentColor: Colors.blueAccent,
    ),
  ));
}