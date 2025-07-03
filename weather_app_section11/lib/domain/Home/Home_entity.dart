class HomeEntity {
  HomeEntity(
      {this.humidity, this.temp, this.windSpeed, this.icon, this.dt, this.day});

  final int? humidity;
  final double? temp;
  final double? windSpeed;
  final String? icon;
  final DateTime? dt;
  final String? day;

  factory HomeEntity.fromJson(Map<String, dynamic>? json) => HomeEntity(
        humidity: json?["humidity"] ?? 0.0,
        temp: json?["temp"] ?? 0.0,
        windSpeed: json?["windSpeed"] ?? 0.0,
        icon: json?["icon"].toString() ?? "",
        dt: json?["dt"] ?? DateTime.now(),
        day: json?["day"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "humidity": this.humidity,
        "temp": this.temp,
        "windSpeed": this.windSpeed,
        "icon": this.icon,
        "dt": this.dt,
        "day": this.day,
      };
}
