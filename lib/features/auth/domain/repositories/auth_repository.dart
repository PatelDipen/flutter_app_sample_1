import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/user.dart';

/// Abstract repository interface for authentication
abstract class AuthRepository {
  /// Login with username and password
  Future<Either<Failure, User>> login({
    required String username,
    required String password,
  });

  /// Get current authenticated user
  Future<Either<Failure, User>> getCurrentUser();

  /// Logout current user
  Future<Either<Failure, void>> logout();

  /// Check if user is authenticated
  Future<bool> isAuthenticated();
}
