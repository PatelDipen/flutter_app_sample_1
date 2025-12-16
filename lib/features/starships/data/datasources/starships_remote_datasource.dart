import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/starship_model.dart';

abstract class StarshipsRemoteDataSource {
  Future<StarshipsResponse> fetchStarships({required int page});
  Future<StarshipsResponse> searchStarships({required String query});
  Future<StarshipModel> getStarshipById(String id);
}

class StarshipsRemoteDataSourceImpl implements StarshipsRemoteDataSource {
  final Dio dio;

  StarshipsRemoteDataSourceImpl({required this.dio});

  @override
  Future<StarshipsResponse> fetchStarships({required int page}) async {
    final response = await dio.get(
      ApiConstants.starshipsEndpoint,
      queryParameters: {'page': page},
    );
    return StarshipsResponse.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<StarshipsResponse> searchStarships({required String query}) async {
    final response = await dio.get(
      ApiConstants.starshipsEndpoint,
      queryParameters: {'search': query},
    );
    return StarshipsResponse.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<StarshipModel> getStarshipById(String id) async {
    final response = await dio.get('${ApiConstants.starshipsEndpoint}/$id');
    return StarshipModel.fromJson(response.data as Map<String, dynamic>);
  }
}
