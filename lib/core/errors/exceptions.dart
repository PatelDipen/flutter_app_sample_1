/// Base exception class for the application
abstract class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

/// Exception thrown when there is a server error (5xx)
class ServerException extends AppException {
  const ServerException([
    String message = 'Server error occurred',
    int? statusCode,
  ]) : super(message, statusCode);
}

/// Exception thrown when the request is unauthorized (401)
class UnauthorizedException extends AppException {
  const UnauthorizedException([
    String message = 'Unauthorized',
    int? statusCode,
  ]) : super(message, statusCode);
}

/// Exception thrown when the resource is not found (404)
class NotFoundException extends AppException {
  const NotFoundException([
    String message = 'Resource not found',
    int? statusCode,
  ]) : super(message, statusCode);
}

/// Exception thrown when there is a bad request (400)
class BadRequestException extends AppException {
  const BadRequestException([String message = 'Bad request', int? statusCode])
    : super(message, statusCode);
}

/// Exception thrown when there is no internet connection
class NetworkException extends AppException {
  const NetworkException([String message = 'No internet connection'])
    : super(message);
}

/// Exception thrown when the request times out
class TimeoutException extends AppException {
  const TimeoutException([String message = 'Request timeout']) : super(message);
}

/// Exception thrown when there is a cache error
class CacheException extends AppException {
  const CacheException([String message = 'Cache error occurred'])
    : super(message);
}

/// Exception thrown when there is a parsing error
class ParseException extends AppException {
  const ParseException([String message = 'Failed to parse data'])
    : super(message);
}

/// Generic API exception
class ApiException extends AppException {
  const ApiException(String message, [int? statusCode])
    : super(message, statusCode);
}
