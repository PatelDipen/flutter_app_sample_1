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
    super.message = 'Server error occurred',
    super.statusCode,
  ]);
}

/// Exception thrown when the request is unauthorized (401)
class UnauthorizedException extends AppException {
  const UnauthorizedException([
    super.message = 'Unauthorized',
    super.statusCode,
  ]);
}

/// Exception thrown when the resource is not found (404)
class NotFoundException extends AppException {
  const NotFoundException([
    super.message = 'Resource not found',
    super.statusCode,
  ]);
}

/// Exception thrown when there is a bad request (400)
class BadRequestException extends AppException {
  const BadRequestException([super.message = 'Bad request', super.statusCode]);
}

/// Exception thrown when there is no internet connection
class NetworkException extends AppException {
  const NetworkException([super.message = 'No internet connection']);
}

/// Exception thrown when the request times out
class TimeoutException extends AppException {
  const TimeoutException([super.message = 'Request timeout']);
}

/// Exception thrown when there is a cache error
class CacheException extends AppException {
  const CacheException([super.message = 'Cache error occurred']);
}

/// Exception thrown when there is a parsing error
class ParseException extends AppException {
  const ParseException([super.message = 'Failed to parse data']);
}

/// Generic API exception
class ApiException extends AppException {
  const ApiException(super.message, [super.statusCode]);
}
