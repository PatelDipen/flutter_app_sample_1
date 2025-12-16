import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/user_model.dart';

/// Remote data source for authentication
abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String username, required String password});

  Future<UserModel> getCurrentUser(String token);
}

/// Implementation of auth remote data source
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserModel> login({
    required String username,
    required String password,
  }) async {
    final response = await dio.post(
      ApiConstants.authLoginEndpoint,
      data: {'username': username, 'password': password},
    );

    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<UserModel> getCurrentUser(String token) async {
    final response = await dio.get(
      ApiConstants.authMeEndpoint,
      options: Options(
        headers: {
          ApiConstants.authorizationHeader:
              '${ApiConstants.bearerPrefix} $token',
        },
      ),
    );

    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }
}
