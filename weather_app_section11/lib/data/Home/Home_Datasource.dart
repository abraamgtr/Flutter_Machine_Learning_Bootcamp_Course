import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app_section11/data/Home/Home_DTO.dart';

enum WeekDayName {
  Monday,
  Tuesday,
  Wednesday,
  Thursday,
  Friday,
  Saturday,
  Sunday,
}

abstract class HomeRemoteDataSource {
  Future<List<HomeDTO>?> getWeather();
}

class HomeDataSource extends HomeRemoteDataSource {
  HomeDataSource();
  @override
  Future<List<HomeDTO>?> getWeather() async {
    var client = http.Client();
    List<HomeDTO> forecastList = [];
    try {
      var response = await client.get(Uri.parse(
          "http://api.openweathermap.org/data/2.5/forecast?id=524901&q=London&cnt=3&appid=2d54d2641139a2870234e83cc30066e1&&units=metric"));
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      decodedResponse["list"].forEach((weatherData) {
        forecastList.add(HomeDTO.fromJson(weatherData));
        print(weatherData);
      });
      print("Weather Data = $decodedResponse");
      print(forecastList.first.dt?.weekday);
      return forecastList;
    } catch (e) {
      print("INFO: ERROR => ${e.toString()}");
      return null;
    } finally {
      client.close();
    }
  }
}
