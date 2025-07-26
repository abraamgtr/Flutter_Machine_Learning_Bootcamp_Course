/// Model class for DeepSeek API code generation request
///
/// This class represents the structure of data sent to the DeepSeek API
/// for code generation requests. It includes the user's prompt and
/// configuration parameters for the AI model.
class CodeGenerationRequest {
  /// The user's coding prompt/request
  final String prompt;

  /// The AI model to use (defaults to deepseek-coder)
  final String model;

  /// Maximum number of tokens in the response
  final int maxTokens;

  /// Temperature for response creativity (0.0-1.0)
  final double temperature;

  /// Whether to stream the response
  final bool stream;

  const CodeGenerationRequest({
    required this.prompt,
    this.model = 'deepseek-coder',
    this.maxTokens = 2048,
    this.temperature = 0.1,
    this.stream = false,
  });

  /// Convert the request to JSON format for API submission
  Map<String, dynamic> toJson() {
    return {
      'model': model,
      'messages': [
        {'role': 'user', 'content': prompt},
      ],
      'max_tokens': maxTokens,
      'temperature': temperature,
      'stream': stream,
    };
  }

  /// Create a copy of this request with updated parameters
  CodeGenerationRequest copyWith({
    String? prompt,
    String? model,
    int? maxTokens,
    double? temperature,
    bool? stream,
  }) {
    return CodeGenerationRequest(
      prompt: prompt ?? this.prompt,
      model: model ?? this.model,
      maxTokens: maxTokens ?? this.maxTokens,
      temperature: temperature ?? this.temperature,
      stream: stream ?? this.stream,
    );
  }

  @override
  String toString() {
    return 'CodeGenerationRequest(prompt: $prompt, model: $model, maxTokens: $maxTokens, temperature: $temperature, stream: $stream)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CodeGenerationRequest &&
        other.prompt == prompt &&
        other.model == model &&
        other.maxTokens == maxTokens &&
        other.temperature == temperature &&
        other.stream == stream;
  }

  @override
  int get hashCode {
    return prompt.hashCode ^
        model.hashCode ^
        maxTokens.hashCode ^
        temperature.hashCode ^
        stream.hashCode;
  }
}
