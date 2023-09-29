class PersonDTO {
  PersonDTO({this.email});
  String? email;

  factory PersonDTO.fromJson(Map<String, String>? json) {
    return PersonDTO(email: json?["email"] ?? "test@email.com");
  }

  Map<String, String> toJson() => {
        "email": this.email ?? "",
      };
}
