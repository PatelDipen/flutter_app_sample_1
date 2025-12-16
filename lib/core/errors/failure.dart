import 'package:equatable/equatable.dart';

/// Base failure class for error handling using functional programming
abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure(this.message, [this.statusCode]);

  @override
  List<Object?> get props => [message, statusCode];

  @override
  String toString() => message;
}

/// Failure for server errors (5xx)
class ServerFailure extends Failure {
  const ServerFailure([
    String message = 'Server error occurred',
    int? statusCode,
  ]) : super(message, statusCode);
}

/// Failure for unauthorized access (401)
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([
    String message = 'Unauthorized access',
    int? statusCode,
  ]) : super(message, statusCode);
}

/// Failure when resource is not found (404)
class NotFoundFailure extends Failure {
  const NotFoundFailure([
    String message = 'Resource not found',
    int? statusCode,
  ]) : super(message, statusCode);
}

/// Failure for bad requests (400)
class BadRequestFailure extends Failure {
  const BadRequestFailure([String message = 'Bad request', int? statusCode])
    : super(message, statusCode);
}

/// Failure for network connectivity issues
class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'No internet connection'])
    : super(message);
}

/// Failure for request timeout
class TimeoutFailure extends Failure {
  const TimeoutFailure([String message = 'Request timeout']) : super(message);
}

/// Failure for cache operations
class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache error occurred'])
    : super(message);
}

/// Failure for data parsing
class ParseFailure extends Failure {
  const ParseFailure([String message = 'Failed to parse data'])
    : super(message);
}

/// Generic API failure
class ApiFailure extends Failure {
  const ApiFailure(String message, [int? statusCode])
    : super(message, statusCode);
}

/// Unknown/Unexpected failure
class UnknownFailure extends Failure {
  const UnknownFailure([String message = 'An unknown error occurred'])
    : super(message);
}
