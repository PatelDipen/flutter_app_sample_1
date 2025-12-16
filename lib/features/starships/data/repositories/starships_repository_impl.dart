import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/starship.dart';
import '../../domain/repositories/starships_repository.dart';
import '../datasources/starships_remote_datasource.dart';

class StarshipsRepositoryImpl implements StarshipsRepository {
  final StarshipsRemoteDataSource remoteDataSource;

  StarshipsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Starship>>> fetchStarships({
    required int page,
  }) async {
    try {
      final response = await remoteDataSource.fetchStarships(page: page);
      final starships = response.results
          .map((model) => model.toEntity())
          .toList();
      return Right(starships);
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
  Future<Either<Failure, List<Starship>>> searchStarships({
    required String query,
  }) async {
    try {
      final response = await remoteDataSource.searchStarships(query: query);
      final starships = response.results
          .map((model) => model.toEntity())
          .toList();
      return Right(starships);
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
  Future<Either<Failure, Starship>> getStarshipById(String id) async {
    try {
      final model = await remoteDataSource.getStarshipById(id);
      return Right(model.toEntity());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message, e.statusCode));
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
}
