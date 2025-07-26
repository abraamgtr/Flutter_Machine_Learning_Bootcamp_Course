/// Domain entity representing a code generation request
///
/// This entity encapsulates the business logic and rules for code generation
/// requests in the domain layer, independent of external frameworks.
class CodeGenerationEntity {
  /// The user's coding prompt/request
  final String prompt;

  /// The AI model to use for generation
  final String model;

  /// Maximum number of tokens in the response
  final int maxTokens;

  /// Temperature for response creativity (0.0-1.0)
  final double temperature;

  const CodeGenerationEntity({
    required this.prompt,
    this.model = 'deepseek-coder',
    this.maxTokens = 2048,
    this.temperature = 0.5,
  });

  /// Validates if the prompt is suitable for code generation
  bool get isValidPrompt {
    final trimmedPrompt = prompt.trim();
    return trimmedPrompt.isNotEmpty && trimmedPrompt.length >= 3;
  }

  /// Checks if the temperature is within valid range
  bool get isValidTemperature {
    return temperature >= 0.0 && temperature <= 1.0;
  }

  /// Checks if the max tokens is within reasonable limits
  bool get isValidMaxTokens {
    return maxTokens > 0 && maxTokens <= 4096;
  }

  /// Validates all parameters
  bool get isValid {
    return isValidPrompt && isValidTemperature && isValidMaxTokens;
  }

  /// Gets a cleaned version of the prompt
  String get cleanedPrompt => prompt.trim();

  @override
  String toString() {
    return 'CodeGenerationEntity(prompt: ${prompt.length} chars, model: $model, maxTokens: $maxTokens, temperature: $temperature)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CodeGenerationEntity &&
        other.prompt == prompt &&
        other.model == model &&
        other.maxTokens == maxTokens &&
        other.temperature == temperature;
  }

  @override
  int get hashCode {
    return prompt.hashCode ^
        model.hashCode ^
        maxTokens.hashCode ^
        temperature.hashCode;
  }
}

/// Domain entity representing a code generation result
///
/// This entity contains the generated code and metadata from the AI service.
class CodeGenerationResult {
  /// The generated code content
  final String code;

  /// The model used for generation
  final String model;

  /// Token usage statistics
  final TokenUsage tokenUsage;

  /// Timestamp when the code was generated
  final DateTime timestamp;

  /// Unique identifier for this result
  final String id;

  const CodeGenerationResult({
    required this.code,
    required this.model,
    required this.tokenUsage,
    required this.timestamp,
    required this.id,
  });

  /// Checks if the generated code appears to be valid
  bool get isValidCode {
    final trimmedCode = code.trim();
    return trimmedCode.isNotEmpty && trimmedCode.length > 5;
  }

  /// Gets a summary of the generated code
  String get codeSummary {
    if (code.length <= 100) return code;
    return '${code.substring(0, 97)}...';
  }

  /// Gets the estimated number of lines in the code
  int get estimatedLines {
    return code.split('\n').length;
  }

  @override
  String toString() {
    return 'CodeGenerationResult(id: $id, model: $model, lines: $estimatedLines, tokens: ${tokenUsage.total})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CodeGenerationResult &&
        other.code == code &&
        other.model == model &&
        other.tokenUsage == tokenUsage &&
        other.timestamp == timestamp &&
        other.id == id;
  }

  @override
  int get hashCode {
    return code.hashCode ^
        model.hashCode ^
        tokenUsage.hashCode ^
        timestamp.hashCode ^
        id.hashCode;
  }
}

/// Domain entity representing token usage statistics
///
/// This provides insights into the cost and efficiency of API requests.
class TokenUsage {
  /// Number of tokens in the prompt
  final int prompt;

  /// Number of tokens in the completion
  final int completion;

  /// Total number of tokens used
  final int total;

  const TokenUsage({
    required this.prompt,
    required this.completion,
    required this.total,
  });

  /// Calculates the efficiency ratio (completion tokens / total tokens)
  double get efficiencyRatio {
    if (total == 0) return 0.0;
    return completion / total;
  }

  /// Checks if the token usage is within reasonable limits
  bool get isReasonable {
    return total > 0 && total <= 4096 && prompt >= 0 && completion >= 0;
  }

  @override
  String toString() {
    return 'TokenUsage(prompt: $prompt, completion: $completion, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TokenUsage &&
        other.prompt == prompt &&
        other.completion == completion &&
        other.total == total;
  }

  @override
  int get hashCode {
    return prompt.hashCode ^ completion.hashCode ^ total.hashCode;
  }
}
