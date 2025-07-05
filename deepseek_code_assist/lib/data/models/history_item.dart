/// Model class for storing code generation history
///
/// This class represents a single entry in the user's code generation history.
/// It stores both the user's prompt and the AI's response for later reference.
class HistoryItem {
  /// Unique identifier for this history item
  final String id;

  /// The user's original prompt/request
  final String prompt;

  /// The AI-generated code response
  final String generatedCode;

  /// Timestamp when this item was created
  final DateTime timestamp;

  /// The model used for generation
  final String model;

  /// Token usage information
  final int tokenUsage;

  const HistoryItem({
    required this.id,
    required this.prompt,
    required this.generatedCode,
    required this.timestamp,
    required this.model,
    required this.tokenUsage,
  });

  /// Create a HistoryItem from JSON data (for local storage)
  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      id: json['id'] as String,
      prompt: json['prompt'] as String,
      generatedCode: json['generatedCode'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      model: json['model'] as String,
      tokenUsage: json['tokenUsage'] as int,
    );
  }

  /// Convert the history item to JSON format (for local storage)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prompt': prompt,
      'generatedCode': generatedCode,
      'timestamp': timestamp.toIso8601String(),
      'model': model,
      'tokenUsage': tokenUsage,
    };
  }

  /// Create a HistoryItem from API request and response
  factory HistoryItem.fromApiData({
    required String prompt,
    required String generatedCode,
    required String model,
    required int tokenUsage,
  }) {
    return HistoryItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      prompt: prompt,
      generatedCode: generatedCode,
      timestamp: DateTime.now(),
      model: model,
      tokenUsage: tokenUsage,
    );
  }

  /// Get a formatted date string for display
  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 7) {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  /// Get a truncated version of the prompt for display
  String get shortPrompt {
    if (prompt.length <= 100) return prompt;
    return '${prompt.substring(0, 97)}...';
  }

  /// Get a truncated version of the generated code for display
  String get shortCode {
    if (generatedCode.length <= 200) return generatedCode;
    return '${generatedCode.substring(0, 197)}...';
  }

  /// Create a copy of this item with updated parameters
  HistoryItem copyWith({
    String? id,
    String? prompt,
    String? generatedCode,
    DateTime? timestamp,
    String? model,
    int? tokenUsage,
  }) {
    return HistoryItem(
      id: id ?? this.id,
      prompt: prompt ?? this.prompt,
      generatedCode: generatedCode ?? this.generatedCode,
      timestamp: timestamp ?? this.timestamp,
      model: model ?? this.model,
      tokenUsage: tokenUsage ?? this.tokenUsage,
    );
  }

  @override
  String toString() {
    return 'HistoryItem(id: $id, timestamp: $timestamp, model: $model, tokenUsage: $tokenUsage)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HistoryItem &&
        other.id == id &&
        other.prompt == prompt &&
        other.generatedCode == generatedCode &&
        other.timestamp == timestamp &&
        other.model == model &&
        other.tokenUsage == tokenUsage;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        prompt.hashCode ^
        generatedCode.hashCode ^
        timestamp.hashCode ^
        model.hashCode ^
        tokenUsage.hashCode;
  }
}
