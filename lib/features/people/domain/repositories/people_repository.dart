import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/person.dart';

/// Abstract repository for people data
abstract class PeopleRepository {
  /// Fetch people with pagination
  Future<Either<Failure, List<Person>>> fetchPeople({required int page});

  /// Search people by name
  Future<Either<Failure, List<Person>>> searchPeople({required String query});

  /// Get person by ID
  Future<Either<Failure, Person>> getPersonById(String id);
}
