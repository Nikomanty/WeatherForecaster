import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:weather_forecaster/model/current_weather_model.dart';
import 'package:weather_forecaster/model/network.dart';
import 'package:weather_forecaster/model/forecast_weather_model.dart';
import 'package:weather_forecaster/util/forecast_util.dart';

class ForecastView extends StatefulWidget {
  @override
  _ForecastViewState createState() => _ForecastViewState();
}

class _ForecastViewState extends State<ForecastView> {
  Future<CurrentWeatherModel> currentWeatherObject;
  Future<ForecastWeatherModel> weatherForecastObjects;
  String _city = "Oulu";

  @override
  void initState() {
    super.initState();
    currentWeatherObject = getCurrentWeather();
    weatherForecastObjects = Network().getWeatherForecast(cityName: _city);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: _createWeatherAppBackground(),
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            _addCitySearchField(),
            currentWeatherWidget(context),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "5 day / 3 Hour Forecast",
                style: TextStyle(fontSize: 20.0, color: Colors.white),
              ),
            ),
            _fiveDayThreeHourForecast(),
          ],
        ),
      ),
    );
  }

  Widget _addCitySearchField() {
    return Container(
      height: 40,
      child: TextField(
        decoration: InputDecoration(
          fillColor: Colors.white.withOpacity(0.5),
          filled: true,
          hintText: "Enter city name...",
          prefixIcon: Icon(
            Icons.search,
            color: Colors.black,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: EdgeInsets.all(5),
        ),
        onSubmitted: (value) {
          setState(() {
            _city = value;
            currentWeatherObject = getCurrentWeather();
            weatherForecastObjects = getForecastWeather();
          });
        },
      ),
    );
  }

  Widget currentWeatherWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FutureBuilder(
          future: currentWeatherObject,
          builder: (BuildContext context, AsyncSnapshot<CurrentWeatherModel> snapshot) {
            if (snapshot.hasData) {
              CurrentWeatherModel content = snapshot.data;
              return Container(
                decoration: _weatherAppItemBackground(),
                child: Column(
                  children: [
                    _addCityNameWidget(content),
                    _createCurrentWeatherWidget(context, content),
                    _addItemDivider(),
                    Container(
                      margin: EdgeInsets.only(bottom: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _sunriseSunsetWidget("sunrise", content),
                          _sunriseSunsetWidget("sunset", content),
                        ],
                      ),
                    ),
                    // _addItemDivider(),
                  ],
                ),
              );
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }

  Widget _addCityNameWidget(CurrentWeatherModel content) {
    var time = Util.getFormattedDate(
        new DateTime.fromMillisecondsSinceEpoch(content.dt * 1000), Util.longDateAndTimeFormat);
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Center(
        child: Column(
          children: [
            Text(
              "$_city, ${content.sys.country}",
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
            Text(
              "$time",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createCurrentWeatherWidget(BuildContext context, CurrentWeatherModel content) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _addCurrentWeatherIconWidget(context, content),
          _addCurrentWeatherInfoWidget(context, content),
        ],
      ),
    );
  }

  Widget _addCurrentWeatherIconWidget(BuildContext context, CurrentWeatherModel content) {
    String imageName = content != null ? content.weather[0].main : "Clear";
    return Container(
      child: Image.asset(
        "images/$imageName.png",
        height: 120.0,
        width: 120.0,
      ),
    );
  }

  //Widget for current weather
  Widget _addCurrentWeatherInfoWidget(BuildContext context, CurrentWeatherModel content) {
    return Container(
      margin: EdgeInsets.only(left: 15),
      width: 170,
      child: Container(
        child: new Column(
          children: <Widget>[
            _addCurrentWeatherInfoItem(content.main.temp.round(), "Temperature", "°C"),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Divider(
                height: 1,
                color: Colors.white,
                thickness: 1,
              ),
            ),
            _addCurrentWeatherInfoItem(content.main.feelsLike.round(), "Feels like", "°C"),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Divider(
                height: 1,
                color: Colors.white,
                thickness: 1,
              ),
            ),
            _addCurrentWeatherInfoItem(content.main.humidity, "Humidity", "%"),
          ],
        ),
      ),
    );
  }

  Widget _addCurrentWeatherInfoItem(int value, String prefix, String suffix) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$prefix: ",
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
          Text(
            "$value $suffix",
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
        ],
      ),
    );
  }

  //Widget for sunset - sunrise weather
  Widget _sunriseSunsetWidget(String riseOrSet, CurrentWeatherModel content) {
    var time = riseOrSet == "sunrise" ? content.sys.sunrise : content.sys.sunset;
    var convertedTime = Util.getFormattedDate(
        new DateTime.fromMillisecondsSinceEpoch(time * 1000), Util.onlyTimeFormat);
    return Expanded(
      child: Column(
        children: <Widget>[
          new Image.asset(
            riseOrSet == "sunrise" ? "images/Sunrise.png" : "images/Sunset.png",
            height: 40.0,
            width: 50.0,
          ),
          new Text(
            convertedTime,
            style: new TextStyle(color: Colors.white, fontSize: 20),
          ),
        ],
      ),
    );
  }

  //Widget for 5day / 3 Hour weather
  Widget _fiveDayThreeHourForecast() {
    return FutureBuilder(
        future: weatherForecastObjects,
        builder: (BuildContext context, AsyncSnapshot<ForecastWeatherModel> snapshot) {
          if (snapshot.hasData) {
            ForecastWeatherModel content = snapshot.data;
            List _days = content.list;

            return Container(
              height: 180.0,
              child: ListView.builder(
                  itemCount: _days.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, position) {
                    var temp = content.list[position].main.temp.round();
                    var feelsLike = content.list[position].main.feelsLike.round();
                    var icon = content.list[position].weather[0].main;
                    var time = Util.getFormattedDate(
                        DateTime.fromMillisecondsSinceEpoch(content.list[position].dt * 1000),
                        Util.shortDateAndTimeFormat);

                    return new Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                      child: Container(
                        width: 80,
                        decoration: _weatherAppItemBackground(),
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Text(
                              time,
                              style: new TextStyle(fontSize: 18, color: Colors.white),
                            ),
                            new Padding(padding: EdgeInsets.only(top: 10.0)),
                            new Image.asset(
                              "images/$icon.png",
                              height: 40.0,
                              width: 40.0,
                            ),
                            new Text(
                              "$temp ºC",
                              style: new TextStyle(color: Colors.white, fontSize: 20.0),
                            ),
                            new Text(
                              "$feelsLike °C",
                              style: new TextStyle(color: Colors.white, fontSize: 15.0),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            );
          } else {
            return new CircularProgressIndicator();
          }
        });
  }

  Widget _addItemDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Divider(
        height: 5,
        color: Colors.white,
      ),
    );
  }

  BoxDecoration _createWeatherAppBackground() {
    return BoxDecoration(
      gradient: new LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.1, 0.4, 0.7, 0.9],
        colors: [
          Colors.blue[900],
          Colors.blue[800],
          Colors.blue[700],
          Colors.blue[600],
        ],
      ),
    );
  }

  BoxDecoration _weatherAppItemBackground() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.white),
      gradient: new LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.1, 0.4, 0.7, 0.9],
        colors: [
          Colors.blue[600],
          Colors.blue[700],
          Colors.blue[800],
          Colors.blue[900],
        ],
      ),
    );
  }

  Future<CurrentWeatherModel> getCurrentWeather() =>
      new Network().getCurrentWeather(cityName: _city);

  Future<ForecastWeatherModel> getForecastWeather() =>
      new Network().getWeatherForecast(cityName: _city);
}
