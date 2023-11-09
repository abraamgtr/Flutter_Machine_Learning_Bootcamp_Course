class NotificationDTO {
  NotificationDTO({this.pillTime, this.type});
  DateTime? pillTime;
  String? type;

  factory NotificationDTO.fromJson(Map<String, dynamic> json) =>
      NotificationDTO(
        pillTime: json["pillTime"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "pillTime": pillTime,
        "type": type,
  };
}
