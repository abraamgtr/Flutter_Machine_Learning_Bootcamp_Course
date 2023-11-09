class NotificationEntity {
  NotificationEntity({this.pillTime, this.type});
  DateTime? pillTime;
  String? type;

  factory NotificationEntity.fromJson(Map<String, dynamic> json) =>
      NotificationEntity(
        pillTime: json["pillTime"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "pillTime": pillTime,
        "type": type,
  };
}
