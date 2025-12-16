import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/person.dart';
import '../../domain/repositories/people_repository.dart';
import '../datasources/people_remote_datasource.dart';

class PeopleRepositoryImpl implements PeopleRepository {
  final PeopleRemoteDataSource remoteDataSource;

  PeopleRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Person>>> fetchPeople({required int page}) async {
    try {
      final response = await remoteDataSource.fetchPeople(page: page);
      final people = response.results.map((model) => model.toEntity()).toList();
      return Right(people);
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
  Future<Either<Failure, List<Person>>> searchPeople({
    required String query,
  }) async {
    try {
      final response = await remoteDataSource.searchPeople(query: query);
      final people = response.results.map((model) => model.toEntity()).toList();
      return Right(people);
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
  Future<Either<Failure, Person>> getPersonById(String id) async {
    try {
      final model = await remoteDataSource.getPersonById(id);
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
