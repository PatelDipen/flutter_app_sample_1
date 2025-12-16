import 'package:dartz/dartz.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

/// Implementation of auth repository
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final SecureStorageService secureStorage;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.secureStorage,
  });

  @override
  Future<Either<Failure, User>> login({
    required String username,
    required String password,
  }) async {
    try {
      final userModel = await remoteDataSource.login(
        username: username,
        password: password,
      );

      // Save token to secure storage
      if (userModel.token != null) {
        await secureStorage.write(
          key: ApiConstants.authTokenKey,
          value: userModel.token!,
        );
      }

      return Right(userModel.toEntity());
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message, e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on TimeoutException catch (e) {
      return Left(TimeoutFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on AppException catch (e) {
      return Left(ApiFailure(e.message, e.statusCode));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final token = await secureStorage.read(key: ApiConstants.authTokenKey);

      if (token == null) {
        return const Left(UnauthorizedFailure('No token found'));
      }

      final userModel = await remoteDataSource.getCurrentUser(token);
      return Right(userModel.toEntity());
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message, e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AppException catch (e) {
      return Left(ApiFailure(e.message, e.statusCode));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await secureStorage.delete(key: ApiConstants.authTokenKey);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      final token = await secureStorage.read(key: ApiConstants.authTokenKey);
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
