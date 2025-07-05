import '../models/code_generation_request.dart';
import '../models/code_generation_response.dart';

/// Abstract class defining the contract for remote code generation data source
///
/// This interface follows the dependency inversion principle of clean architecture,
/// allowing the domain layer to depend on abstractions rather than concrete implementations.
abstract class CodeGenerationRemoteDataSource {
  /// Generates code based on the given prompt using the DeepSeek API
  ///
  /// [request] - The code generation request containing the prompt and parameters
  ///
  /// Returns a [CodeGenerationResponse] containing the generated code and metadata
  ///
  /// Throws:
  /// - [NetworkException] when there are network connectivity issues
  /// - [ServerException] when the API returns an error response
  /// - [AuthenticationException] when the API key is invalid
  Future<CodeGenerationResponse> generateCode(CodeGenerationRequest request);

  /// Tests the connection to the DeepSeek API
  ///
  /// Returns true if the API is accessible and the authentication is valid
  ///
  /// Throws:
  /// - [NetworkException] when there are network connectivity issues
  /// - [AuthenticationException] when the API key is invalid
  Future<bool> testConnection();
}
