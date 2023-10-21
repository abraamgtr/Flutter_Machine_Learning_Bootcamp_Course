import 'package:weather_app_section11/data/Home/Home_Datasource.dart';

class HomeDTO {
  HomeDTO(
      {this.humidity, this.temp, this.windSpeed, this.icon, this.dt, this.day});

  final int? humidity;
  final double? temp;
  final double? windSpeed;
  final String? icon;
  final DateTime? dt;
  final String? day;

  String convertToWeekDay(int day) {
    switch (day) {
      case 1:
        return WeekDayName.Monday.name;
      case 2:
        return WeekDayName.Tuesday.name;
      case 3:
        return WeekDayName.Wednesday.name;
      case 4:
        return WeekDayName.Thursday.name;
      case 5:
        return WeekDayName.Friday.name;
      case 6:
        return WeekDayName.Saturday.name;
      case 7:
        return WeekDayName.Sunday.name;
      default:
        return WeekDayName.Monday.name;
    }
  }

  factory HomeDTO.fromJson(Map<String, dynamic>? json) {
    print(json);
    return HomeDTO(
      humidity: json?["main"]["humidity"] ?? 0,
      temp: json?["main"]["temp"] ?? 0.0,
      windSpeed: json?["wind"]["speed"] ?? 0.0,
      icon: json?["weather"][0]["icon"].toString() ?? "",
      dt: DateTime.parse(json?["dt"].toString() ?? "") ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    print(convertToWeekDay(this.dt?.weekday ?? 0));
    return {
      "humidity": this.humidity,
      "temp": this.temp,
      "windSpeed": this.windSpeed,
      "icon": this.icon,
      "dt": this.dt,
      "day": convertToWeekDay(this.dt?.weekday ?? 0)
    };
  }
}
