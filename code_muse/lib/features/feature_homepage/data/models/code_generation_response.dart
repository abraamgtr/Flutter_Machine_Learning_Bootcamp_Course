/// Model class for DeepSeek API code generation response
///
/// This class represents the structure of data received from the DeepSeek API
/// after a code generation request. It includes the generated code,
/// metadata, and usage statistics.
class CodeGenerationResponse {
  /// Unique identifier for this response
  final String id;

  /// Type of object (typically 'chat.completion')
  final String object;

  /// Timestamp when the response was created
  final int created;

  /// The model used for generation
  final String model;

  /// List of choice objects containing the generated content
  final List<Choice> choices;

  /// Usage statistics for the request
  final Usage usage;

  const CodeGenerationResponse({
    required this.id,
    required this.object,
    required this.created,
    required this.model,
    required this.choices,
    required this.usage,
  });

  /// Create a CodeGenerationResponse from JSON data
  factory CodeGenerationResponse.fromJson(Map<String, dynamic> json) {
    return CodeGenerationResponse(
      id: json['id'] as String,
      object: json['object'] as String,
      created: json['created'] as int,
      model: json['model'] as String,
      choices:
          (json['choices'] as List<dynamic>)
              .map((choice) => Choice.fromJson(choice as Map<String, dynamic>))
              .toList(),
      usage: Usage.fromJson(json['usage'] as Map<String, dynamic>),
    );
  }

  /// Convert the response to JSON format
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'object': object,
      'created': created,
      'model': model,
      'choices': choices.map((choice) => choice.toJson()).toList(),
      'usage': usage.toJson(),
    };
  }

  /// Get the generated code content (from the first choice)
  String get generatedCode {
    if (choices.isNotEmpty) {
      return choices.first.message.content;
    }
    return '';
  }

  @override
  String toString() {
    return 'CodeGenerationResponse(id: $id, model: $model, choices: ${choices.length}, usage: $usage)';
  }
}

/// Represents a choice in the API response
class Choice {
  /// Index of this choice
  final int index;

  /// The message containing the generated content
  final Message message;

  /// Reason why the generation finished
  final String finishReason;

  const Choice({
    required this.index,
    required this.message,
    required this.finishReason,
  });

  /// Create a Choice from JSON data
  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      index: json['index'] as int,
      message: Message.fromJson(json['message'] as Map<String, dynamic>),
      finishReason: json['finish_reason'] as String,
    );
  }

  /// Convert the choice to JSON format
  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'message': message.toJson(),
      'finish_reason': finishReason,
    };
  }

  @override
  String toString() {
    return 'Choice(index: $index, finishReason: $finishReason)';
  }
}

/// Represents a message in the API response
class Message {
  /// Role of the message sender (typically 'assistant')
  final String role;

  /// The actual generated content
  final String content;

  const Message({required this.role, required this.content});

  /// Create a Message from JSON data
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      role: json['role'] as String,
      content: json['content'] as String,
    );
  }

  /// Convert the message to JSON format
  Map<String, dynamic> toJson() {
    return {'role': role, 'content': content};
  }

  @override
  String toString() {
    return 'Message(role: $role, content: ${content.length} chars)';
  }
}

/// Represents usage statistics for the API request
class Usage {
  /// Number of tokens in the prompt
  final int promptTokens;

  /// Number of tokens in the completion
  final int completionTokens;

  /// Total number of tokens used
  final int totalTokens;

  const Usage({
    required this.promptTokens,
    required this.completionTokens,
    required this.totalTokens,
  });

  /// Create Usage from JSON data
  factory Usage.fromJson(Map<String, dynamic> json) {
    return Usage(
      promptTokens: json['prompt_tokens'] as int,
      completionTokens: json['completion_tokens'] as int,
      totalTokens: json['total_tokens'] as int,
    );
  }

  /// Convert usage to JSON format
  Map<String, dynamic> toJson() {
    return {
      'prompt_tokens': promptTokens,
      'completion_tokens': completionTokens,
      'total_tokens': totalTokens,
    };
  }

  @override
  String toString() {
    return 'Usage(prompt: $promptTokens, completion: $completionTokens, total: $totalTokens)';
  }
}
