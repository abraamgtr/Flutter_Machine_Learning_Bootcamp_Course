

class HomeDTO {
  HomeDTO({this.nextTime});
  String? nextTime;

  factory HomeDTO.fromJson(Map<String, dynamic> json) =>
      HomeDTO(
        nextTime: json["nextTime"],
      );

  Map<String, dynamic> toJson() => {
        "nextTime": nextTime,
  };
}