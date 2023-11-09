

class HomeEntity {
  HomeEntity({this.nextTime});
  Duration? nextTime;

  factory HomeEntity.fromJson(Map<String, dynamic> json) =>
      HomeEntity(
        nextTime: json["nextTime"],
      );

  Map<String, dynamic> toJson() => {
        "nextTime": nextTime,
  };
}