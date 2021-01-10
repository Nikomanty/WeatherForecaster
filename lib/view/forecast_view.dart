import 'package:flutter/material.dart';

class ForecastView extends StatefulWidget {
  @override
  _ForecastViewState createState() => _ForecastViewState();
}

class _ForecastViewState extends State<ForecastView> {
  final String _defaultCity = "Oulu";
  String _city;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _city != null ? _city : _defaultCity,
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: _createWeatherAppBackground(),
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            addSearchBar(),
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            _createCurrentWeatherWidget(),
            _addItemDivider(),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _sunriseSunsetWidget(_city, "sunrise"),
                  _sunriseSunsetWidget(_city, "sunset"),
                ],
              ),
            ),
            _addItemDivider(),
            Text(
              "5 day / 3 Hour Forecast",
              style: TextStyle(fontSize: 20.0, color: Colors.white),
            ),
            SafeArea(child: _fiveDayThreeHourForecast(_city)),
          ],
        ),
      ),
    );
  }

  // //Futures
  //
  // Future<Map> getWeather(String city) async {
  //   String apiUrl =
  //       "http://api.openweathermap.org/data/2.5/weather?q=$city&appid=8ae4bfcdd85127081911f63765a8f29d&units=metric";
  //   http.Response response = await http.get(apiUrl);
  //   return json.decode(response.body);
  // }
  //
  // Future<Map> hourWeather(String city) async {
  //   String apiUrl =
  //       "http://api.openweathermap.org/data/2.5/forecast?q=$city&appid=8ae4bfcdd85127081911f63765a8f29d&units=metric";
  //   http.Response response = await http.get(apiUrl);
  //   return json.decode(response.body);
  // }
  //
  // Future searchCity(BuildContext context) async {
  //   Map result =
  //       await Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) {
  //     return new Search();
  //   }));
  //
  //   if (result != null && result.containsKey("city")) {
  //     _city = result['city'].toString();
  //   } else {
  //     print("Nothing");
  //   }
  // }

  Widget addSearchBar() {
    return Container(
      height: 50,
      child: Center(child: Text("Search")),
    );
  }

  Widget _createCurrentWeatherWidget() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _addCurrentWeatherIconWidget(_city),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _addCurrentWeatherInfoWidget(_city, "main", "temp", "ºC"),
                  _addCurrentWeatherInfoWidget(_city, "main", "humidity", "%"),
                  _addCurrentWeatherInfoWidget(_city, "wind", "speed", "m/s"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _addCurrentWeatherIconWidget(String city) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FutureBuilder(
              // future: getWeather(city == null ? "Oulu" : city),
              builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
            if (snapshot.hasData) {
              Map content = snapshot.data;

              return new Image.asset(
                "images/clear.png",
                height: 150.0,
                width: 150.0,
              );
            } else {
              return new Image.asset(
                "images/clear.png",
                height: 150.0,
                width: 150.0,
              );
            }
          }),
        ],
      ),
    );
  }

  //Widget for current weather
  Widget _addCurrentWeatherInfoWidget(
      String city, String jsonObject, String jsonField, String suffix) {
    return new FutureBuilder(
        // future: getWeather(city == null ? _defaultCity : city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
      if (snapshot.hasData) {
        Map content = snapshot.data;
        return new Container(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
                child: new Text(
                  "123",
                  style: new TextStyle(fontSize: 25.0, color: Colors.white),
                ),
              ),
            ],
          ),
        );
      } else {
        return new CircularProgressIndicator();
      }
    });
  }

  //Widget for sunset - sunrise weather
  Widget _sunriseSunsetWidget(String city, String riseOrSet) {
    return Expanded(
      child: FutureBuilder(
          // future: getWeather(city == null ? util.defaultCity : city),
          builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
        if (snapshot.hasData) {
          Map content = snapshot.data;

          return new Column(
            children: <Widget>[
              new Image.asset(
                riseOrSet == "sunrise" ? "assets/images/sunrise.png" : "assets/images/sunset.png",
                height: 50.0,
                width: 50.0,
              ),
              new Text(
                "date",
                style: new TextStyle(color: Colors.white),
              ),
            ],
          );
        } else {
          return new CircularProgressIndicator();
        }
      }),
    );
  }

  //Widget for 5day / 3 Hour weather
  Widget _fiveDayThreeHourForecast(String city) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: FutureBuilder(
          // future: hourWeather(city == null ? util.defaultCity : city),
          builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
        if (snapshot.hasData) {
          Map content = snapshot.data;
          List _days = content['list'];

          return new Container(
            height: 180.0,
            child: ListView.builder(
                itemCount: _days.length - 1,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, position) {
                  final int index = position + 1;

                  var temp = _days[index]['main']['temp'];
                  var wind = _days[index]['wind']['speed'];
                  var icon = _days[index]['weather'][0]['main'];

                  return new Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text(
                          "date",
                          style: new TextStyle(color: Colors.white),
                        ),
                        new Text(
                          "time",
                          style: new TextStyle(color: Colors.white),
                        ),
                        new Padding(padding: EdgeInsets.only(top: 10.0)),
                        new Image.asset(
                          "assets/images/${icon.toString()}.png",
                          height: 40.0,
                          width: 40.0,
                        ),
                        new Text(
                          "${temp.toStringAsFixed(1)} ºC",
                          style: new TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                        new Text(
                          "${wind.toStringAsFixed(1)} m/s",
                          style: new TextStyle(color: Colors.white, fontSize: 15.0),
                        ),
                      ],
                    ),
                  );
                }),
          );
        } else {
          return new CircularProgressIndicator();
        }
      }),
    );
  }

  Widget _addItemDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
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
          Colors.blue[500],
          Colors.blue[300],
        ],
      ),
    );
  }
}
