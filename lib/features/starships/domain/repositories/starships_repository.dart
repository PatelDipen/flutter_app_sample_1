import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/starship.dart';

abstract class StarshipsRepository {
  Future<Either<Failure, List<Starship>>> fetchStarships({required int page});
  Future<Either<Failure, List<Starship>>> searchStarships({required String query});
  Future<Either<Failure, Starship>> getStarshipById(String id);
}
