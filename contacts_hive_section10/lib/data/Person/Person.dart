import 'package:hive/hive.dart';

part 'Person.g.dart';

@HiveType(typeId: 0)
class Person {
  @HiveField(0)
  String? name;
  @HiveField(1)
  String? nickName;

  Person({required this.name, required this.nickName});

  factory Person.fromJson(Map<String, String>? json) =>
      Person(name: json?["name"] ?? "", nickName: json?["nickName"] ?? "");

  Map<String, String> toJson() => {
        "name": this.name ?? "test",
        "nickName": this.nickName ?? "test",
      };
}
