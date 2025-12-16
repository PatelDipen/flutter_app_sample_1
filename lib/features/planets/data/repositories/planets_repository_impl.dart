import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/planet.dart';
import '../../domain/repositories/planets_repository.dart';
import '../datasources/planets_remote_datasource.dart';

class PlanetsRepositoryImpl implements PlanetsRepository {
  final PlanetsRemoteDataSource remoteDataSource;

  PlanetsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Planet>>> fetchPlanets({
    required int page,
  }) async {
    try {
      final response = await remoteDataSource.fetchPlanets(page: page);
      final planets = response.results
          .map((model) => model.toEntity())
          .toList();
      return Right(planets);
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
  Future<Either<Failure, List<Planet>>> searchPlanets({
    required String query,
  }) async {
    try {
      final response = await remoteDataSource.searchPlanets(query: query);
      final planets = response.results
          .map((model) => model.toEntity())
          .toList();
      return Right(planets);
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
  Future<Either<Failure, Planet>> getPlanetById(String id) async {
    try {
      final model = await remoteDataSource.getPlanetById(id);
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
