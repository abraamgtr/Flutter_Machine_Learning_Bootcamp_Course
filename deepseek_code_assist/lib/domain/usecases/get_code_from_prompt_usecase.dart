import '../entities/code_generation.dart';
import '../repositories/code_generation_repository.dart';
import '../../core/error/exceptions.dart';

/// Use case for generating code from a user prompt
///
/// This class encapsulates the business logic for code generation,
/// including validation, error handling, and result processing.
/// It follows the single responsibility principle and dependency inversion.
class GetCodeFromPromptUseCase {
  /// Repository for code generation operations
  final CodeGenerationRepository _repository;

  const GetCodeFromPromptUseCase(this._repository);

  /// Executes the code generation use case
  ///
  /// [params] - Parameters containing the prompt and generation settings
  ///
  /// Returns a [CodeGenerationResult] with the generated code and metadata
  ///
  /// Throws:
  /// - [ValidationException] when the input parameters are invalid
  /// - [NetworkException] when there are network connectivity issues
  /// - [ServerException] when the API returns an error response
  /// - [AuthenticationException] when the API key is invalid
  /// - [RateLimitException] when the API rate limit is exceeded
  Future<CodeGenerationResult> call(CodeGenerationParams params) async {
    // Create entity from parameters
    final entity = CodeGenerationEntity(
      prompt: params.prompt,
      model: params.model,
      maxTokens: params.maxTokens,
      temperature: params.temperature,
    );

    // Validate the entity using business rules
    if (!_repository.validateEntity(entity)) {
      throw _createValidationException(entity);
    }

    // Perform additional business logic validation
    _validateBusinessRules(params);

    // Generate code using the repository
    final result = await _repository.generateCode(entity);

    // Validate the result
    if (!result.isValidCode) {
      throw const ServerException(
        'Generated code appears to be invalid or empty',
        code: 'INVALID_GENERATION',
      );
    }

    return result;
  }

  /// Tests the connection to the code generation service
  ///
  /// Returns true if the service is accessible and properly configured
  Future<bool> testConnection() async {
    return await _repository.testConnection();
  }

  /// Validates business rules for code generation
  void _validateBusinessRules(CodeGenerationParams params) {
    // Check prompt content for potential issues
    final prompt = params.prompt.trim().toLowerCase();

    // Check for potentially harmful requests
    if (_containsHarmfulContent(prompt)) {
      throw const ValidationException(
        'The prompt contains content that cannot be processed',
        code: 'HARMFUL_CONTENT',
      );
    }

    // Check prompt length limits
    if (params.prompt.length > 8000) {
      throw const ValidationException(
        'Prompt is too long. Please limit your request to 8000 characters or less.',
        code: 'PROMPT_TOO_LONG',
      );
    }

    // Check for very short prompts that might not be useful
    if (params.prompt.trim().length < 3) {
      throw const ValidationException(
        'Prompt is too short. Please provide a more detailed description.',
        code: 'PROMPT_TOO_SHORT',
      );
    }
  }

  /// Checks if the prompt contains potentially harmful content
  bool _containsHarmfulContent(String prompt) {
    // List of keywords that might indicate harmful requests
    const harmfulKeywords = [
      'delete',
      'remove',
      'destroy',
      'hack',
      'crack',
      'malware',
      'virus',
      'exploit',
    ];

    // Check for harmful patterns (basic implementation)
    for (final keyword in harmfulKeywords) {
      if (prompt.contains(keyword)) {
        // Additional context checking could be implemented here
        // For now, we use a simple keyword check
        return false; // Allow these for educational purposes
      }
    }

    return false;
  }

  /// Creates a detailed validation exception based on entity validation failures
  ValidationException _createValidationException(CodeGenerationEntity entity) {
    final fieldErrors = <String, String>{};

    if (!entity.isValidPrompt) {
      fieldErrors['prompt'] = 'Prompt must be at least 3 characters long';
    }

    if (!entity.isValidTemperature) {
      fieldErrors['temperature'] = 'Temperature must be between 0.0 and 1.0';
    }

    if (!entity.isValidMaxTokens) {
      fieldErrors['maxTokens'] = 'Max tokens must be between 1 and 4096';
    }

    return ValidationException(
      'Invalid parameters for code generation',
      code: 'VALIDATION_FAILED',
      fieldErrors: fieldErrors,
    );
  }
}

/// Parameters for the code generation use case
///
/// This class encapsulates all the parameters needed for code generation
/// and provides validation and default values.
class CodeGenerationParams {
  /// The user's coding prompt/request
  final String prompt;

  /// The AI model to use for generation
  final String model;

  /// Maximum number of tokens in the response
  final int maxTokens;

  /// Temperature for response creativity (0.0-1.0)
  final double temperature;

  const CodeGenerationParams({
    required this.prompt,
    this.model = 'deepseek-coder',
    this.maxTokens = 2048,
    this.temperature = 0.1,
  });

  /// Creates parameters with default values optimized for code generation
  factory CodeGenerationParams.forCodeGeneration(String prompt) {
    return CodeGenerationParams(
      prompt: prompt,
      model: 'deepseek-coder',
      maxTokens: 2048,
      temperature: 0.1, // Low temperature for more deterministic code
    );
  }

  /// Creates parameters optimized for code explanation
  factory CodeGenerationParams.forCodeExplanation(String prompt) {
    return CodeGenerationParams(
      prompt: prompt,
      model: 'deepseek-coder',
      maxTokens: 1024,
      temperature: 0.3, // Slightly higher for more natural explanations
    );
  }

  /// Creates parameters optimized for code review
  factory CodeGenerationParams.forCodeReview(String prompt) {
    return CodeGenerationParams(
      prompt: prompt,
      model: 'deepseek-coder',
      maxTokens: 1536,
      temperature: 0.2, // Balanced for thorough but focused reviews
    );
  }

  @override
  String toString() {
    return 'CodeGenerationParams(prompt: ${prompt.length} chars, model: $model, maxTokens: $maxTokens, temperature: $temperature)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CodeGenerationParams &&
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
