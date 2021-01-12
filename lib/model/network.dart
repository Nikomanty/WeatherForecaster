import 'dart:convert';

import 'package:http/http.dart';
import 'package:weather_forecaster/model/current_weather_model.dart';
import 'package:weather_forecaster/model/forecast_weather_model.dart';
import 'package:weather_forecaster/util/forecast_util.dart';

class Network {

  Future<CurrentWeatherModel> getCurrentWeather({String cityName}) async {
    var jsonUrl =
        "http://api.openweathermap.org/data/2.5/weather?q=$cityName&units=metric&appid=${Util.appId}";
    final response = await get(Uri.encodeFull(jsonUrl));
    if(response.statusCode == 200) {
      return CurrentWeatherModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Error getting forecast");
    }
  }

  Future<ForecastWeatherModel> getWeatherForecast({String cityName}) async {
    var jsonUrl =
        "http://api.openweathermap.org/data/2.5/forecast?q=$cityName&units=metric&appid=${Util.appId}";
    final response = await get(Uri.encodeFull(jsonUrl));
    if(response.statusCode == 200) {
      return ForecastWeatherModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Error getting forecast");
    }

  }

}
