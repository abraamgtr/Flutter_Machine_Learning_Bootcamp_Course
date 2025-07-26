import 'package:code_muse/features/feature_homepage/domain/entities/code_generation_entity.dart';

/// Repository interface for code generation operations
///
/// This interface defines the contract for code generation data operations
/// in the domain layer. It abstracts away the data source implementation
/// details and provides a clean API for the use cases.
abstract class CodeGenerationRepository {
  /// Generates code based on the given entity
  ///
  /// [entity] - The code generation request entity
  ///
  /// Returns a [CodeGenerationResult] containing the generated code and metadata
  ///
  /// Throws:
  /// - [NetworkException] when there are network connectivity issues
  /// - [ServerException] when the API returns an error response
  /// - [AuthenticationException] when the API key is invalid
  /// - [ValidationException] when the request parameters are invalid
  /// - [RateLimitException] when the API rate limit is exceeded
  Future<CodeGenerationResult> generateCode(CodeGenerationEntity entity);

  /// Tests the connection to the code generation service
  ///
  /// Returns true if the service is accessible and authentication is valid
  ///
  /// This method is useful for:
  /// - Checking API connectivity during app startup
  /// - Validating API key configuration
  /// - Displaying service status to users
  Future<bool> testConnection();

  /// Validates a code generation entity before processing
  ///
  /// [entity] - The entity to validate
  ///
  /// Returns true if the entity is valid for code generation
  ///
  /// This method performs business logic validation including:
  /// - Prompt content validation
  /// - Parameter range validation
  /// - Model availability validation
  bool validateEntity(CodeGenerationEntity entity);
}
