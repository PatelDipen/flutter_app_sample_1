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
    super.message = 'Server error occurred',
    super.statusCode,
  ]);
}

/// Failure for unauthorized access (401)
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([
    super.message = 'Unauthorized access',
    super.statusCode,
  ]);
}

/// Failure when resource is not found (404)
class NotFoundFailure extends Failure {
  const NotFoundFailure([
    super.message = 'Resource not found',
    super.statusCode,
  ]);
}

/// Failure for bad requests (400)
class BadRequestFailure extends Failure {
  const BadRequestFailure([super.message = 'Bad request', super.statusCode]);
}

/// Failure for network connectivity issues
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

/// Failure for request timeout
class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'Request timeout']);
}

/// Failure for cache operations
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error occurred']);
}

/// Failure for data parsing
class ParseFailure extends Failure {
  const ParseFailure([super.message = 'Failed to parse data']);
}

/// Generic API failure
class ApiFailure extends Failure {
  const ApiFailure(super.message, [super.statusCode]);
}

/// Unknown/Unexpected failure
class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'An unknown error occurred']);
}
