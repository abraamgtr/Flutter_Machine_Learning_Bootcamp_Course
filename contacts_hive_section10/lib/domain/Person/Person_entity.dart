class PersonEntity {
  String? name;
  String? nickName;

  PersonEntity({required this.name, required this.nickName});

  factory PersonEntity.fromJson(Map<String, String>? json) => PersonEntity(
      name: json?["name"] ?? "", nickName: json?["nickName"] ?? "");

  Map<String, String> toJson() => {
        "name": this.name ?? "test",
        "nickName": this.nickName ?? "test",
      };
}
