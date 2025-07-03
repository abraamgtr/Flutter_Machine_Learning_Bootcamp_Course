class Choices {
  Choices({this.content, this.index, this.role, this.finish_reason});

  final String? content;
  final int? index;
  final String? role;
  final String? finish_reason;

  factory Choices.fromJson(Map<String, dynamic>? json) {
    return Choices(
      content: json?['message']["content"].toString(),
      index: json?['index'],
      role: json?['message']['role'].toString(),
      finish_reason: json?['finish_reason'].toString(),
    );
  }

  Map<String, dynamic>? toJson() => {
        "content": this.content,
        "index": this.index,
        "role": this.role,
        "finish_reason": this.finish_reason,
      };
}
