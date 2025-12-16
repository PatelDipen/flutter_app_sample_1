import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/api_constants.dart';
import '../errors/exceptions.dart';

/// Dio client for SWAPI API
final swapiDioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.swapiBaseUrl,
      connectTimeout: const Duration(milliseconds: ApiConstants.defaultTimeout),
      receiveTimeout: const Duration(milliseconds: ApiConstants.defaultTimeout),
      headers: {ApiConstants.contentTypeHeader: ApiConstants.applicationJson},
    ),
  );

  // Add interceptors
  dio.interceptors.add(LoggingInterceptor());
  dio.interceptors.add(ErrorInterceptor());

  return dio;
});

/// Dio client for DummyJSON API (with auth support)
final dummyJsonDioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.dummyJsonBaseUrl,
      connectTimeout: const Duration(milliseconds: ApiConstants.defaultTimeout),
      receiveTimeout: const Duration(milliseconds: ApiConstants.defaultTimeout),
      headers: {ApiConstants.contentTypeHeader: ApiConstants.applicationJson},
    ),
  );

  // Add interceptors
  dio.interceptors.add(LoggingInterceptor());
  dio.interceptors.add(AuthInterceptor(ref));
  dio.interceptors.add(ErrorInterceptor());

  return dio;
});

/// Logging interceptor for debugging
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('📤 REQUEST[${options.method}] => PATH: ${options.path}');
    print('Headers: ${options.headers}');
    print('Query Parameters: ${options.queryParameters}');
    if (options.data != null) {
      print('Body: ${options.data}');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
      '📥 RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );
    print('Data: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print(
      '❌ ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );
    print('Message: ${err.message}');
    print('Error: ${err.error}');
    super.onError(err, handler);
  }
}

/// Authentication interceptor to add token to requests
class AuthInterceptor extends Interceptor {
  final Ref ref;

  AuthInterceptor(this.ref);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // TODO: Get token from secure storage via provider
    // For now, we'll implement this when we create the auth feature
    // final token = await ref.read(authTokenProvider.future);
    // if (token != null) {
    //   options.headers[ApiConstants.authorizationHeader] =
    //       '${ApiConstants.bearerPrefix} $token';
    // }

    super.onRequest(options, handler);
  }
}

/// Error interceptor to handle and convert errors
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final exception = _handleError(err);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: exception,
        type: err.type,
        response: err.response,
      ),
    );
  }

  AppException _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException('Request timeout. Please try again.');

      case DioExceptionType.badResponse:
        return _handleStatusCodeError(
          error.response?.statusCode,
          error.response?.data,
        );

      case DioExceptionType.cancel:
        return const ApiException('Request cancelled');

      case DioExceptionType.connectionError:
        if (error.error is SocketException) {
          return const NetworkException('No internet connection');
        }
        return const NetworkException('Connection error');

      case DioExceptionType.badCertificate:
        return const ApiException('Bad certificate');

      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return const NetworkException('No internet connection');
        }
        return ApiException('Unknown error: ${error.message}');
    }
  }

  AppException _handleStatusCodeError(int? statusCode, dynamic responseData) {
    String message = 'An error occurred';

    // Try to extract message from response
    if (responseData != null) {
      if (responseData is Map<String, dynamic>) {
        message =
            responseData['message'] ??
            responseData['error'] ??
            responseData['detail'] ??
            message;
      } else if (responseData is String) {
        message = responseData;
      }
    }

    switch (statusCode) {
      case 400:
        return BadRequestException(message, statusCode);
      case 401:
        return UnauthorizedException(message, statusCode);
      case 403:
        return UnauthorizedException('Access forbidden', statusCode);
      case 404:
        return NotFoundException(message, statusCode);
      case 500:
      case 502:
      case 503:
        return ServerException(message, statusCode);
      default:
        return ApiException(message, statusCode);
    }
  }
}
