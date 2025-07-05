import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../core/error/exceptions.dart';
import '../models/code_generation_request.dart';
import '../models/code_generation_response.dart';
import 'code_generation_remote_datasource.dart';

/// Concrete implementation of [CodeGenerationRemoteDataSource] using Dio
///
/// This class handles all HTTP communication with the DeepSeek API,
/// including authentication, request formatting, and response parsing.
class CodeGenerationRemoteDataSourceImpl
    implements CodeGenerationRemoteDataSource {
  /// HTTP client for making API requests
  final Dio _dio;

  /// Base URL for the DeepSeek API
  static const String _baseUrl = 'https://api.deepseek.com';

  /// API endpoint for chat completions
  static const String _chatEndpoint = '/chat/completions';

  CodeGenerationRemoteDataSourceImpl({Dio? dio}) : _dio = dio ?? Dio() {
    _setupDio();
  }

  /// Configure Dio with default settings and interceptors
  void _setupDio() {
    // Get API key from environment
    final apiKey = dotenv.env['DEEPSEEK_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw const AuthenticationException(
        'DeepSeek API key not found. Please ensure DEEPSEEK_API_KEY is set in your .env file.',
        code: 'MISSING_API_KEY',
      );
    }

    // Configure base options
    _dio.options = BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
        'Accept': 'application/json',
      },
    );

    // Add logging interceptor for debugging (in development only)
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        logPrint: (object) {
          // Only log in debug mode
          assert(() {
            print('[DeepSeek API] $object');
            return true;
          }());
        },
      ),
    );

    // Add retry interceptor for transient failures
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          // Retry logic for specific error codes
          if (error.response?.statusCode == 429 ||
              error.response?.statusCode == 502 ||
              error.response?.statusCode == 503 ||
              error.response?.statusCode == 504) {
            final retryCount = error.requestOptions.extra['retryCount'] ?? 0;
            if (retryCount < 3) {
              // Wait before retrying (exponential backoff)
              await Future.delayed(Duration(seconds: (retryCount + 1) * 2));

              // Update retry count
              error.requestOptions.extra['retryCount'] = retryCount + 1;

              // Retry the request
              try {
                final response = await _dio.fetch(error.requestOptions);
                handler.resolve(response);
                return;
              } catch (e) {
                // If retry fails, continue with original error handling
              }
            }
          }

          handler.next(error);
        },
      ),
    );
  }

  @override
  Future<CodeGenerationResponse> generateCode(
    CodeGenerationRequest request,
  ) async {
    try {
      // Make the API request
      final response = await _dio.post(_chatEndpoint, data: request.toJson());

      // Parse and return the response
      return CodeGenerationResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(
        'Unexpected error occurred while generating code: $e',
        code: 'UNKNOWN_ERROR',
      );
    }
  }

  @override
  Future<bool> testConnection() async {
    try {
      // Create a simple test request with reasonable token limit
      final testRequest = const CodeGenerationRequest(
        prompt: 'print("Hello, World!")',
        maxTokens: 50, // Just enough for a simple response
      );

      // Make the API call
      await generateCode(testRequest);

      return true;
    } catch (e) {
      // If any exception occurs, the connection test failed
      return false;
    }
  }

  /// Convert Dio exceptions to our custom exception types
  AppException _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException(
          'Request timed out. Please check your internet connection and try again.',
          code: 'TIMEOUT',
        );

      case DioExceptionType.badResponse:
        return _handleHttpError(e);

      case DioExceptionType.cancel:
        return const NetworkException(
          'Request was cancelled.',
          code: 'CANCELLED',
        );

      case DioExceptionType.connectionError:
        return const NetworkException(
          'Connection failed. Please check your internet connection.',
          code: 'CONNECTION_ERROR',
        );

      case DioExceptionType.badCertificate:
        return const NetworkException(
          'SSL certificate verification failed.',
          code: 'SSL_ERROR',
        );

      case DioExceptionType.unknown:
      default:
        if (e.error is SocketException) {
          return const NetworkException(
            'No internet connection. Please check your network settings.',
            code: 'NO_INTERNET',
          );
        }
        return NetworkException(
          'Network error occurred: ${e.message}',
          code: 'NETWORK_ERROR',
        );
    }
  }

  /// Handle HTTP error responses
  AppException _handleHttpError(DioException e) {
    final statusCode = e.response?.statusCode;
    final data = e.response?.data;

    // Extract error message from response
    String errorMessage = 'An error occurred';
    if (data is Map<String, dynamic>) {
      errorMessage =
          data['error']?['message'] ??
          data['message'] ??
          data['detail'] ??
          errorMessage;
    }

    switch (statusCode) {
      case 400:
        return ValidationException(
          'Invalid request: $errorMessage',
          code: 'BAD_REQUEST',
        );

      case 401:
        return const AuthenticationException(
          'Invalid API key. Please check your DeepSeek API key.',
          code: 'UNAUTHORIZED',
        );

      case 403:
        return const AuthenticationException(
          'Access forbidden. Please check your API key permissions.',
          code: 'FORBIDDEN',
        );

      case 404:
        return const ServerException(
          'API endpoint not found. Please check the service availability.',
          code: 'NOT_FOUND',
        );

      case 429:
        // Extract retry-after header if available
        int? retryAfter;
        final retryAfterHeader = e.response?.headers['retry-after']?.first;
        if (retryAfterHeader != null) {
          retryAfter = int.tryParse(retryAfterHeader);
        }

        return RateLimitException(
          'Rate limit exceeded. Please wait before making another request.',
          code: 'RATE_LIMITED',
          retryAfterSeconds: retryAfter,
        );

      case 500:
      case 502:
      case 503:
      case 504:
        return ServerException(
          'Server error: $errorMessage. Please try again later.',
          code: 'SERVER_ERROR',
          statusCode: statusCode,
        );

      default:
        return ServerException(
          'HTTP error ($statusCode): $errorMessage',
          code: 'HTTP_ERROR',
          statusCode: statusCode,
        );
    }
  }
}
