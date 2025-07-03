class PersonEntity {
  PersonEntity({this.email});
  String? email;

  factory PersonEntity.fromJson(Map<String, String>? json) {
    return PersonEntity(email: json?["email"] ?? "test@email.com");
  }

  Map<String, String> toJson() => {
        "email": this.email ?? "",
      };
}
