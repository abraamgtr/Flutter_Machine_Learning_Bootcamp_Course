class Usage {
  Usage({
    this.prompt_tokens,
    this.completion_tokens,
    this.total_tokens,
  });

  final int? prompt_tokens;
  final int? completion_tokens;
  final int? total_tokens;

  factory Usage.fromJson(Map<String, dynamic>? json) {
    return Usage(
      prompt_tokens: json?['prompt_tokens'],
      completion_tokens: json?['completion_tokens'],
      total_tokens: json?['total_tokens'],
    );
  }

  Map<String, dynamic>? toJson() => {
        "prompt_tokens": this.prompt_tokens,
        "completion_tokens": this.completion_tokens,
        "total_tokens": this.total_tokens,
      };
}
