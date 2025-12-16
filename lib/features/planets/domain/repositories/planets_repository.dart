import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/planet.dart';

abstract class PlanetsRepository {
  Future<Either<Failure, List<Planet>>> fetchPlanets({required int page});
  Future<Either<Failure, List<Planet>>> searchPlanets({required String query});
  Future<Either<Failure, Planet>> getPlanetById(String id);
}
