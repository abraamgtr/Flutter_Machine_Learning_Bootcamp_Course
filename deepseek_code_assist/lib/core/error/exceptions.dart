/// Base exception class for all custom exceptions in the app
///
/// This provides a consistent interface for all exceptions and enables
/// better error handling throughout the application.
abstract class AppException implements Exception {
  /// A human-readable message describing the error
  final String message;

  /// Optional error code for programmatic error handling
  final String? code;

  const AppException(this.message, {this.code});

  @override
  String toString() =>
      'AppException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Exception thrown when there are network connectivity issues
///
/// This includes scenarios like no internet connection, timeouts,
/// or general network failures.
class NetworkException extends AppException {
  const NetworkException(super.message, {super.code});

  @override
  String toString() =>
      'NetworkException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Exception thrown when the server returns an error response
///
/// This includes HTTP error codes like 400, 500, etc., and
/// any server-side errors from the DeepSeek API.
class ServerException extends AppException {
  /// HTTP status code (if applicable)
  final int? statusCode;

  const ServerException(super.message, {super.code, this.statusCode});

  @override
  String toString() =>
      'ServerException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}${code != null ? ' (Code: $code)' : ''}';
}

/// Exception thrown when there are authentication/authorization issues
///
/// This typically occurs when the API key is invalid, expired,
/// or missing proper permissions.
class AuthenticationException extends AppException {
  const AuthenticationException(super.message, {super.code});

  @override
  String toString() =>
      'AuthenticationException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Exception thrown when the request data is invalid
///
/// This occurs when the request parameters don't meet the API requirements
/// or contain invalid data.
class ValidationException extends AppException {
  /// Map of field-specific validation errors
  final Map<String, String>? fieldErrors;

  const ValidationException(super.message, {super.code, this.fieldErrors});

  @override
  String toString() {
    String base =
        'ValidationException: $message${code != null ? ' (Code: $code)' : ''}';
    if (fieldErrors != null && fieldErrors!.isNotEmpty) {
      base += '\nField errors: $fieldErrors';
    }
    return base;
  }
}

/// Exception thrown when the API rate limit is exceeded
///
/// This occurs when too many requests are made in a short time period
/// and the API responds with a rate limiting error.
class RateLimitException extends AppException {
  /// Time until the rate limit resets (in seconds)
  final int? retryAfterSeconds;

  const RateLimitException(super.message, {super.code, this.retryAfterSeconds});

  @override
  String toString() =>
      'RateLimitException: $message${retryAfterSeconds != null ? ' (Retry after: ${retryAfterSeconds}s)' : ''}${code != null ? ' (Code: $code)' : ''}';
}

/// Exception thrown when local storage operations fail
///
/// This includes failures in reading from or writing to shared preferences
/// or other local storage mechanisms.
class CacheException extends AppException {
  const CacheException(super.message, {super.code});

  @override
  String toString() =>
      'CacheException: $message${code != null ? ' (Code: $code)' : ''}';
}
