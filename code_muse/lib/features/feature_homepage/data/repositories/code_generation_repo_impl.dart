import 'package:code_muse/core/error/exceptions.dart';
import 'package:code_muse/features/feature_homepage/data/datasources/remote/code_generation_remote_service.dart';
import 'package:code_muse/features/feature_homepage/domain/entities/code_generation_entity.dart';
import 'package:code_muse/features/feature_homepage/domain/repositories/code_generation_repo.dart';

import '../models/code_generation_request.dart';

/// Implementation of [CodeGenerationRepository] that connects domain layer to data sources
///
/// This class bridges the gap between the domain layer (business logic) and
/// the data layer (external APIs, databases, etc.). It converts between
/// domain entities and data models while handling errors appropriately.
class CodeGenerationRepositoryImpl implements CodeGenerationRepository {
  /// Remote data source for API operations
  final CodeGenerationRemoteDataSource _remoteDataSource;

  const CodeGenerationRepositoryImpl(this._remoteDataSource);

  @override
  Future<CodeGenerationResult> generateCode(CodeGenerationEntity entity) async {
    try {
      // Convert domain entity to data model
      final request = _entityToRequest(entity);

      // Make API call through data source
      final response = await _remoteDataSource.generateCode(request);

      // Convert response to domain entity
      return _responseToResult(response);
    } catch (e) {
      // Re-throw known exceptions
      if (e is AppException) {
        rethrow;
      }

      // Wrap unknown exceptions
      throw ServerException(
        'Unexpected error during code generation: $e',
        code: 'REPOSITORY_ERROR',
      );
    }
  }

  @override
  Future<bool> testConnection() async {
    try {
      return await _remoteDataSource.testConnection();
    } catch (e) {
      // Connection test should not throw exceptions
      // Instead, return false to indicate failure
      return false;
    }
  }

  @override
  bool validateEntity(CodeGenerationEntity entity) {
    // Delegate to entity's own validation logic
    return entity.isValid;
  }

  /// Converts a domain entity to a data model request
  CodeGenerationRequest _entityToRequest(CodeGenerationEntity entity) {
    return CodeGenerationRequest(
      prompt: entity.cleanedPrompt,
      model: entity.model,
      maxTokens: entity.maxTokens,
      temperature: entity.temperature,
    );
  }

  /// Converts a data model response to a domain entity result
  CodeGenerationResult _responseToResult(response) {
    // Extract token usage information
    final tokenUsage = TokenUsage(
      prompt: response.usage.promptTokens,
      completion: response.usage.completionTokens,
      total: response.usage.totalTokens,
    );

    // Create domain result entity
    return CodeGenerationResult(
      code: response.generatedCode,
      model: response.model,
      tokenUsage: tokenUsage,
      timestamp: DateTime.now(),
      id: response.id,
    );
  }
}
