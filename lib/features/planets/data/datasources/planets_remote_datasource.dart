import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/planet_model.dart';

abstract class PlanetsRemoteDataSource {
  Future<PlanetsResponse> fetchPlanets({required int page});
  Future<PlanetsResponse> searchPlanets({required String query});
  Future<PlanetModel> getPlanetById(String id);
}

class PlanetsRemoteDataSourceImpl implements PlanetsRemoteDataSource {
  final Dio dio;

  PlanetsRemoteDataSourceImpl({required this.dio});

  @override
  Future<PlanetsResponse> fetchPlanets({required int page}) async {
    final response = await dio.get(
      ApiConstants.planetsEndpoint,
      queryParameters: {'page': page},
    );
    return PlanetsResponse.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<PlanetsResponse> searchPlanets({required String query}) async {
    final response = await dio.get(
      ApiConstants.planetsEndpoint,
      queryParameters: {'search': query},
    );
    return PlanetsResponse.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<PlanetModel> getPlanetById(String id) async {
    final response = await dio.get('${ApiConstants.planetsEndpoint}/$id');
    return PlanetModel.fromJson(response.data as Map<String, dynamic>);
  }
}
