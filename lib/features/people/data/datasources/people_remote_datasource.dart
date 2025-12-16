import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/person_model.dart';

abstract class PeopleRemoteDataSource {
  Future<PeopleResponse> fetchPeople({required int page});
  Future<PeopleResponse> searchPeople({required String query});
  Future<PersonModel> getPersonById(String id);
}

class PeopleRemoteDataSourceImpl implements PeopleRemoteDataSource {
  final Dio dio;

  PeopleRemoteDataSourceImpl({required this.dio});

  @override
  Future<PeopleResponse> fetchPeople({required int page}) async {
    final response = await dio.get(
      ApiConstants.peopleEndpoint,
      queryParameters: {'page': page},
    );

    return PeopleResponse.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<PeopleResponse> searchPeople({required String query}) async {
    final response = await dio.get(
      ApiConstants.peopleEndpoint,
      queryParameters: {'search': query},
    );

    return PeopleResponse.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<PersonModel> getPersonById(String id) async {
    final response = await dio.get('${ApiConstants.peopleEndpoint}/$id');

    return PersonModel.fromJson(response.data as Map<String, dynamic>);
  }
}
