class PersonEntity {
  PersonEntity({this.email, this.fullName, this.age, this.image});
  String? email;
  String? fullName;
  String? age;
  String? image;

  factory PersonEntity.fromJson(Map<String, dynamic>? json) {
    return PersonEntity(
        email: json?["email"] ?? "test@email.com",
        fullName: json?["fullName"] ?? "Test Name",
        age: json?["age"] ?? "22",
        image: json?["image"] ?? "");
  }

  Map<String, String> toJson() => {
        "email": this.email ?? "",
        "fullName": this.fullName ?? "Test Name",
        "age": this.age ?? "22",
        "image": this.image ?? "",
      };
}
